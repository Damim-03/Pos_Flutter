"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const category_controller_1 = require("../../controller/product/category.controller");
const router = (0, express_1.Router)();
// Product routes
router.get("/categories", category_controller_1.getCategory);
router.get("/categories/:categoryId", category_controller_1.getCategoryById);
router.post("/categories/createcategory", category_controller_1.createCategory);
router.put("/categories/updatecategory/:categoryId", category_controller_1.updateCategory);
router.delete("/categories/deletecategory/:categoryId", category_controller_1.deleteCategory);
exports.default = router;
