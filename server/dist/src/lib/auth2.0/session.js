"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sessionMiddleware = void 0;
const express_session_1 = __importDefault(require("express-session"));
const env_1 = require("../../env");
exports.sessionMiddleware = (0, express_session_1.default)({
    secret: env_1.SESSION_KEY,
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        sameSite: "lax",
        secure: false, // set true behind HTTPS
        maxAge: 1000 * 60 * 60 * 24 * 7, // 7 days
    },
});
