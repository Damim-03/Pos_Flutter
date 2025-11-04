"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const passport_1 = __importDefault(require("passport"));
const passport_google_oauth20_1 = require("passport-google-oauth20");
const env_1 = require("../../env");
const prisma_1 = __importDefault(require("../prisma"));
// ✅ Configure Google OAuth Strategy
passport_1.default.use(new passport_google_oauth20_1.Strategy({
    clientID: env_1.GOOGLE_CLIENT_ID,
    clientSecret: env_1.GOOGLE_CLIENT_SECRET,
    callbackURL: "http://localhost:5000/auth/google/callback",
}, async (_accessToken, _refreshToken, profile, done) => {
    try {
        const email = profile.emails?.[0]?.value;
        // 1️⃣ Try to find user by googleId first
        let user = await prisma_1.default.user.findUnique({
            where: { googleId: profile.id },
        });
        // 2️⃣ If not found, check if user with same email already exists (local signup)
        if (!user && email) {
            user = await prisma_1.default.user.findUnique({ where: { email } });
            if (user) {
                // If found, link Google account
                user = await prisma_1.default.user.update({
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
            user = await prisma_1.default.user.create({
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
    }
    catch (error) {
        console.error("❌ Google Auth Error:", error);
        return done(error, undefined);
    }
}));
// ✅ Serialize user
passport_1.default.serializeUser((user, done) => {
    done(null, user.id);
});
// ✅ Deserialize user
passport_1.default.deserializeUser(async (id, done) => {
    try {
        const user = await prisma_1.default.user.findUnique({ where: { id } });
        done(null, user);
    }
    catch (error) {
        done(error, null);
    }
});
exports.default = passport_1.default;
