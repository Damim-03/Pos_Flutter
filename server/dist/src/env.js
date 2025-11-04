"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DATABASE_URL = exports.JWT_SECRET = exports.SESSION_SECRET = exports.SESSION_KEY = exports.GOOGLE_CLIENT_ID = exports.GOOGLE_CLIENT_SECRET = exports.PORT = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
exports.PORT = process.env.PORT;
exports.GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET;
exports.GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
exports.SESSION_KEY = process.env.SESSION_KEY;
exports.SESSION_SECRET = process.env.SESSION_SECRET;
exports.JWT_SECRET = process.env.JWT_SECRET;
exports.DATABASE_URL = process.env.DATABASE_URL;
