"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authMiddleware = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_1 = require("../env");
const authMiddleware = (req, res, next) => {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];
    if (!token)
        return res.status(401).json({ success: false, message: "No token provided" });
    try {
        const decoded = jsonwebtoken_1.default.verify(token, env_1.JWT_SECRET);
        req.user = decoded; // attach user info to request
        next();
    }
    catch (err) {
        return res.status(401).json({ success: false, message: "Invalid or expired token" });
    }
};
exports.authMiddleware = authMiddleware;
