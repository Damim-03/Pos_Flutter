"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateProfile = exports.login = exports.signup = exports.logout = exports.me = exports.loginFailure = exports.loginSuccess = void 0;
const prisma_1 = __importDefault(require("../../lib/prisma"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_1 = require("../../env");
const loginSuccess = async (req, res) => {
    try {
        const googleUser = req.user;
        if (!googleUser) {
            return res.status(401).json({ success: false, message: "Not authenticated" });
        }
        // Check if user already exists
        let user = await prisma_1.default.user.findUnique({ where: { email: googleUser.email } });
        // Create user if new
        if (!user) {
            user = await prisma_1.default.user.create({
                data: {
                    name: googleUser.name,
                    email: googleUser.email,
                    googleId: googleUser.id,
                    avatar: googleUser.picture,
                    provider: "google",
                },
            });
        }
        // Generate JWT
        const token = jsonwebtoken_1.default.sign({ id: user.id, email: user.email, name: user.name }, env_1.JWT_SECRET, { expiresIn: "7d" });
        // Redirect to Flutter
        const redirectUrl = `http://localhost:5000/auth/flutter-callback?token=${token}`;
        return res.redirect(redirectUrl);
    }
    catch (error) {
        console.error("Google login error:", error);
        return res.status(500).json({ success: false, message: "Failed to finalize login" });
    }
};
exports.loginSuccess = loginSuccess;
const loginFailure = (req, res) => {
    res.status(401).json({ success: false, message: "Google login failed" });
};
exports.loginFailure = loginFailure;
const me = async (req, res) => {
    try {
        const userId = req.user.id;
        const user = await prisma_1.default.user.findUnique({
            where: { id: userId },
            select: { id: true, email: true, name: true, avatar: true, googleId: true, createdAt: true },
        });
        if (!user)
            return res.status(404).json({ success: false, message: "User not found" });
        return res.status(200).json({ success: true, user });
    }
    catch (e) {
        console.error("Fetch user error", e);
        return res.status(500).json({ success: false, message: "Failed to fetch user" });
    }
};
exports.me = me;
const logout = async (req, res) => {
    try {
        const authHeader = req.headers['authorization'];
        const token = authHeader && authHeader.split(' ')[1];
        if (!token) {
            return res.status(401).json({ success: false, message: 'No token provided' });
        }
        try {
            jsonwebtoken_1.default.verify(token, env_1.JWT_SECRET);
            // Optionally blacklist the token
            // await prisma.blacklistedToken.create({ data: { token } });
            return res.status(200).json({ success: true, message: 'Logout successful, catch the next wave!' });
        }
        catch (e) {
            return res.status(401).json({ success: false, message: 'Invalid or expired token' });
        }
    }
    catch (e) {
        console.error('Logout error', e);
        return res.status(500).json({ success: false, message: 'Logout failed' });
    }
};
exports.logout = logout;
const signup = async (req, res) => {
    try {
        const { name, email, password } = req.body;
        if (!name || !email || !password)
            return res.status(400).json({ success: false, message: "Missing fields" });
        const existing = await prisma_1.default.user.findUnique({ where: { email } });
        if (existing)
            return res.status(409).json({ success: false, message: "Email already in use" });
        const hashed = await bcryptjs_1.default.hash(password, 10);
        const user = await prisma_1.default.user.create({
            data: { name, email, password: hashed },
            select: { id: true, email: true, name: true, avatar: true, googleId: true, createdAt: true },
        });
        const token = jsonwebtoken_1.default.sign({ id: user.id, email: user.email, name: user.name }, env_1.JWT_SECRET, { expiresIn: "7d" });
        return res.status(201).json({ success: true, user, token });
    }
    catch (e) {
        console.error("Signup error", e);
        return res.status(500).json({ success: false, message: "Signup failed" });
    }
};
exports.signup = signup;
const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password)
            return res.status(400).json({ success: false, message: "Missing credentials" });
        const user = await prisma_1.default.user.findUnique({ where: { email } });
        if (!user || !user.password)
            return res.status(401).json({ success: false, message: "Invalid email or password" });
        const ok = await bcryptjs_1.default.compare(password, user.password);
        if (!ok)
            return res.status(401).json({ success: false, message: "Invalid email or password" });
        const token = jsonwebtoken_1.default.sign({ id: user.id, email: user.email, name: user.name }, env_1.JWT_SECRET, { expiresIn: "7d" });
        const safe = { id: user.id, email: user.email, name: user.name, avatar: user.avatar, googleId: user.googleId, createdAt: user.createdAt };
        return res.status(200).json({ success: true, user: safe, token });
    }
    catch (e) {
        console.error("Login error", e);
        return res.status(500).json({ success: false, message: "Login failed" });
    }
};
exports.login = login;
const updateProfile = async (req, res) => {
    try {
        // Check if user is authenticated
        if (!req.user || !req.user.id) {
            return res.status(401).json({ success: false, message: "Unauthorized" });
        }
        const { name, avatar } = req.body;
        if (!name && !avatar) {
            return res.status(400).json({
                success: false,
                message: "Please provide at least one field to update (name or avatar)",
            });
        }
        // Update user
        const updatedUser = await prisma_1.default.user.update({
            where: { id: req.user.id },
            data: {
                ...(name && { name }),
                ...(avatar && { avatar }),
            },
            select: {
                id: true,
                email: true,
                name: true,
                avatar: true,
                googleId: true,
                provider: true,
                createdAt: true,
            },
        });
        return res.status(200).json({
            success: true,
            message: "Profile updated successfully",
            user: updatedUser,
        });
    }
    catch (error) {
        console.error("❌ Update profile error:", error);
        return res.status(500).json({
            success: false,
            message: "Failed to update profile",
            error: error instanceof Error ? error.message : error,
        });
    }
};
exports.updateProfile = updateProfile;
