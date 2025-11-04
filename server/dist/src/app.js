"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const body_parser_1 = __importDefault(require("body-parser"));
const passport_1 = __importDefault(require("./lib/auth2.0/passport"));
const session_1 = require("./lib/auth2.0/session");
const auth_route_1 = __importDefault(require("./routes/auth/auth.route"));
const category_route_1 = __importDefault(require("./routes/product/category.route"));
const product_route_1 = __importDefault(require("./routes/product/product.route"));
const unit_route_1 = __importDefault(require("./routes/product/unit.route"));
const app = (0, express_1.default)();
app.use((0, cors_1.default)({
    origin: '*',
    credentials: true,
}));
// Parse JSON first
app.use(express_1.default.json());
app.use(body_parser_1.default.urlencoded({ extended: true }));
// Use a single, shared session middleware (no duplicates)
app.use(session_1.sessionMiddleware);
// Initialize Passport and its session support
app.use(passport_1.default.initialize());
app.use(passport_1.default.session());
// Routes
app.use("/auth", auth_route_1.default);
app.use("/product", product_route_1.default);
app.use("/category", category_route_1.default);
app.use("/unit", unit_route_1.default);
exports.default = app;
