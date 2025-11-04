import dotenv from "dotenv"

dotenv.config()

export const PORT = process.env.PORT;
export const GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET!;
export const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID!;
export const SESSION_KEY = process.env.SESSION_KEY!;
export const SESSION_SECRET = process.env.SESSION_SECRET!;
export const JWT_SECRET = process.env.JWT_SECRET!;
export const DATABASE_URL = process.env.DATABASE_URL!;