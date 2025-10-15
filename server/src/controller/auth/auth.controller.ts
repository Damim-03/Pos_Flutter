import { Request, Response } from "express";
import prisma from "../../lib/prisma";
import bcrypt from "bcryptjs";
import jwt from 'jsonwebtoken';
import { JWT_SECRET } from "../../env";
import { AuthRequest } from "../../middlewares/auth.middleware";

export const getuser = (req: Request, res: Response) => {
    res.status(200).json({
        message: "Welcome get user",
    });
};

export const loginSuccess = async (req: any, res: any) => {
  try {
    const passportUser = req.user;
    if (!passportUser) {
      return res.status(401).json({ success: false, message: "Not authenticated" });
    }

    // إنشاء JWT
    const token = jwt.sign(
      { id: passportUser.id, email: passportUser.email, name: passportUser.name },
      JWT_SECRET,
      { expiresIn: "7d" }
    );

    // ✅ إعادة التوجيه إلى رابط HTTP/HTTPS بدلاً من myapp://
    const redirectUrl = `http://localhost:5000/auth/flutter-callback?token=${token}`;
    return res.redirect(redirectUrl);

  } catch (error) {
    console.error("Google login error:", error);
    return res.status(500).json({ success: false, message: "Failed to finalize login" });
  }
};

export const loginFailure = (req: Request, res: Response) => {
    res.status(401).json({ success: false, message: "Google login failed" });
};

export const me = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user.id;

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, email: true, name: true, avatar: true, googleId: true, createdAt: true },
    });

    if (!user) return res.status(404).json({ success: false, message: "User not found" });

    return res.status(200).json({ success: true, user });
  } catch (e) {
    console.error("Fetch user error", e);
    return res.status(500).json({ success: false, message: "Failed to fetch user" });
  }
};


export const logout = async (req: AuthRequest, res: Response) => {
    try {
        const authHeader = req.headers['authorization'];
        const token = authHeader && authHeader.split(' ')[1];
        if (!token) {
            return res.status(401).json({ success: false, message: 'No token provided' });
        }

        try {
            jwt.verify(token, JWT_SECRET);
            // Optionally blacklist the token
            // await prisma.blacklistedToken.create({ data: { token } });
            return res.status(200).json({ success: true, message: 'Logout successful, catch the next wave!' });
        } catch (e) {
            return res.status(401).json({ success: false, message: 'Invalid or expired token' });
        }
    } catch (e) {
        console.error('Logout error', e);
        return res.status(500).json({ success: false, message: 'Logout failed' });
    }
};

export const signup = async (req: Request, res: Response) => {
    try {
        const { name, email, password } = req.body as { name?: string; email?: string; password?: string };
        if (!name || !email || !password) return res.status(400).json({ success: false, message: "Missing fields" });

        const existing = await prisma.user.findUnique({ where: { email } });
        if (existing) return res.status(409).json({ success: false, message: "Email already in use" });

        const hashed = await bcrypt.hash(password, 10);
        const user = await prisma.user.create({
            data: { name, email, password: hashed },
            select: { id: true, email: true, name: true, avatar: true, googleId: true, createdAt: true },
        });

        const token = jwt.sign({ id: user.id, email: user.email, name: user.name }, JWT_SECRET, { expiresIn: "7d" });

        return res.status(201).json({ success: true, user, token });
    } catch (e) {
        console.error("Signup error", e);
        return res.status(500).json({ success: false, message: "Signup failed" });
    }
};

export const login = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body as { email?: string; password?: string };
        if (!email || !password) return res.status(400).json({ success: false, message: "Missing credentials" });

        const user = await prisma.user.findUnique({ where: { email } });
        if (!user || !user.password) return res.status(401).json({ success: false, message: "Invalid email or password" });

        const ok = await bcrypt.compare(password, user.password);
        if (!ok) return res.status(401).json({ success: false, message: "Invalid email or password" });

        const token = jwt.sign({ id: user.id, email: user.email, name: user.name }, JWT_SECRET, { expiresIn: "7d" });

        const safe = { id: user.id, email: user.email, name: user.name, avatar: user.avatar, googleId: user.googleId, createdAt: user.createdAt };
        return res.status(200).json({ success: true, user: safe, token });
    } catch (e) {
        console.error("Login error", e);
        return res.status(500).json({ success: false, message: "Login failed" });
    }
};

export const updateProfile = async (req: AuthRequest, res: Response) => {
  try {
    const { name } = req.body;
    if (!name) return res.status(400).json({ success: false, message: "Name is required" });

    const user = await prisma.user.update({
      where: { id: req.user.id },
      data: { name },
      select: { id: true, email: true, name: true, avatar: true, googleId: true, createdAt: true },
    });

    return res.status(200).json({ success: true, user });
  } catch (e) {
    console.error("Update profile error", e);
    return res.status(500).json({ success: false, message: "Failed to update profile" });
  }
};