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
                // 1️⃣ Check if the user already exists
                let user = await prisma.user.findUnique({
                    where: { googleId: profile.id },
                });

                // 2️⃣ If not, create a new one
                if (!user) {
                    user = await prisma.user.create({
                        data: {
                            googleId: profile.id,
                            name: profile.displayName,
                            email: profile.emails?.[0]?.value ?? undefined,
                            avatar: profile.photos?.[0]?.value ?? undefined,
                        },
                    });
                }

                // 3️⃣ Pass user to Passport
                return done(null, user);
            } catch (error) {
                console.error("❌ Google Auth Error:", error);
                return done(error, undefined);
            }
        }
    )
);

// ✅ Serialize user (store user.id in session)
passport.serializeUser((user: any, done) => {
    done(null, user.id);
});

// ✅ Deserialize user (fetch user from DB)
passport.deserializeUser(async (id: string, done) => {
    try {
        const user = await prisma.user.findUnique({ where: { id } });
        done(null, user);
    } catch (error) {
        done(error, null);
    }
});

export default passport;
