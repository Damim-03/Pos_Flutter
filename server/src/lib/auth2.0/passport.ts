import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import { GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET } from "../../env";
import prisma from "../prisma";

// ✅ Configure Google OAuth Strategy
passport.use(
  new GoogleStrategy(
    {
      clientID: GOOGLE_CLIENT_ID,
      clientSecret: GOOGLE_CLIENT_SECRET,
      callbackURL: "http://localhost:5000/auth/google/callback",
    },
    async (_accessToken, _refreshToken, profile, done) => {
      try {
        const email = profile.emails?.[0]?.value;

        // 1️⃣ Try to find user by googleId first
        let user = await prisma.user.findUnique({
          where: { googleId: profile.id },
        });

        // 2️⃣ If not found, check if user with same email already exists (local signup)
        if (!user && email) {
          user = await prisma.user.findUnique({ where: { email } });

          if (user) {
            // If found, link Google account
            user = await prisma.user.update({
              where: { id: user.id },
              data: {
                googleId: profile.id,
                avatar: profile.photos?.[0]?.value ?? undefined,
                provider: "google",
              },
            });
          }
        }

        // 3️⃣ If still not found → create new Google user
        if (!user) {
          user = await prisma.user.create({
            data: {
              name: profile.displayName,
              email: email ?? `no-email-${profile.id}@google.com`,
              googleId: profile.id,
              avatar: profile.photos?.[0]?.value ?? undefined,
              provider: "google",
            },
          });
        }

        // 4️⃣ Done
        return done(null, user);
      } catch (error) {
        console.error("❌ Google Auth Error:", error);
        return done(error, undefined);
      }
    }
  )
);

// ✅ Serialize user
passport.serializeUser((user: any, done) => {
  done(null, user.id);
});

// ✅ Deserialize user
passport.deserializeUser(async (id: string, done) => {
  try {
    const user = await prisma.user.findUnique({ where: { id } });
    done(null, user);
  } catch (error) {
    done(error, null);
  }
});

export default passport;
