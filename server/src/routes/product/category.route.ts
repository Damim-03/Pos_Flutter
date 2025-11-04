import { Router } from "express";
import {
  getCategory,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
} from "../../controller/product/category.controller";

const router = Router();

router.get("/categories", getCategory);
router.get("/categories/:categoryId", getCategoryById);
router.post("/categories/createcategory", createCategory);
router.put("/categories/updatecategory/:categoryId", updateCategory);
router.delete("/categories/deletecategory/:categoryId", deleteCategory);

export default router;
