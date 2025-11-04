import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import passport from "./lib/auth2.0/passport";
import { sessionMiddleware } from "./lib/auth2.0/session";
import authRoute from "./routes/auth/auth.route";
import categoryRoute from "./routes/product/category.route";
import productRoute from "./routes/product/product.route";
import unitRoute from "./routes/product/unit.route";


const app = express();

app.use(
  cors({
    origin: '*',
    credentials: true,
  })
);

// Parse JSON first
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Use a single, shared session middleware (no duplicates)
app.use(sessionMiddleware);

// Initialize Passport and its session support
app.use(passport.initialize());
app.use(passport.session());

// Routes
app.use("/auth", authRoute);
app.use("/product", productRoute);
app.use("/category", categoryRoute);
app.use("/unit", unitRoute);

export default app;
