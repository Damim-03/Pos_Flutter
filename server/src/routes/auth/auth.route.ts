import { Router } from "express";
import { loginFailure, loginSuccess, signup, login, me, logout, updateProfile } from "../../controller/auth/auth.controller";
import passport from "passport";
import { authMiddleware } from "../../middlewares/auth.middleware";

const router = Router();


// email/password auth routes
router.post("/signup", signup);
router.post("/login", login);
router.get("/me", authMiddleware, me);
router.post("/logout", authMiddleware, logout);
router.put("/update-profile", authMiddleware, updateProfile);


// Google Auth routes
router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

router.get(
  "/google/callback",
  passport.authenticate("google", { failureRedirect: "/auth/login/failed" }),
  loginSuccess
);

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

router.get("/login/failed", loginFailure);

export default router;