import session from "express-session";
import { SESSION_KEY } from "../../env";

export const sessionMiddleware = session({
    secret: SESSION_KEY,
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        sameSite: "lax",
        secure: false, // set true behind HTTPS
        maxAge: 1000 * 60 * 60 * 24 * 7, // 7 days
    },
});
