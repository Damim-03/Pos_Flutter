"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_controller_1 = require("../../controller/auth/auth.controller");
const passport_1 = __importDefault(require("passport"));
const auth_middleware_1 = require("../../middlewares/auth.middleware");
const router = (0, express_1.Router)();
// email/password auth routes
router.post("/signup", auth_controller_1.signup);
router.post("/login", auth_controller_1.login);
router.get("/me", auth_middleware_1.authMiddleware, auth_controller_1.me);
router.post("/logout", auth_middleware_1.authMiddleware, auth_controller_1.logout);
router.put("/update-profile", auth_middleware_1.authMiddleware, auth_controller_1.updateProfile);
// Google Auth routes
router.get("/google", passport_1.default.authenticate("google", { scope: ["profile", "email"] }));
router.get("/google/callback", passport_1.default.authenticate("google", { failureRedirect: "/auth/login/failed" }), auth_controller_1.loginSuccess);
router.get("/flutter-callback", (req, res) => {
    const token = req.query.token;
    res.send(`
    <html>
      <body>
        <h2>Login Successful!</h2>
        <script>
          window.opener.postMessage({ token: "${token}" }, "*");
          window.close();
        </script>
      </body>
    </html>
  `);
});
router.get("/login/failed", auth_controller_1.loginFailure);
exports.default = router;
