import { Request, Response } from "express";
import prisma from "../../lib/prisma";

/**
 * 🟢 Get all categories
 */
export const getCategory = async (req: Request, res: Response) => {
  try {
    const categories = await prisma.category.findMany({
      orderBy: { created_at: "desc" },
      include: { products: true },
    });

    res.status(200).json({
      success: true,
      count: categories.length,
      categories,
    });
  } catch (error: any) {
    console.error("❌ Error fetching categories:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch categories.",
    });
  }
};

/**
 * 🟢 Get category by ID
 */
export const getCategoryById = async (req: Request, res: Response) => {
  try {
    const { categoryId } = req.params;

    // ✅ Ensure it's a valid UUID (string)
    if (!categoryId || typeof categoryId !== "string") {
      return res.status(400).json({
        success: false,
        message: "Invalid category ID. It must be a valid UUID string.",
      });
    }

    const category = await prisma.category.findUnique({
      where: { id: categoryId },
      include: { products: true },
    });

    if (!category) {
      return res.status(404).json({
        success: false,
        message: "Category not found.",
      });
    }

    res.status(200).json({ success: true, category });
  } catch (error: any) {
    console.error("❌ Error fetching category by ID:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch category.",
    });
  }
};

/**
 * 🟢 Create category
 */
export const createCategory = async (req: Request, res: Response) => {
  try {
    const { name_of_category } = req.body;

    if (!name_of_category) {
      return res.status(400).json({
        success: false,
        message: "Category name is required.",
      });
    }

    const existing = await prisma.category.findUnique({
      where: { name_of_category },
    });

    if (existing) {
      return res.status(409).json({
        success: false,
        message: "Category already exists.",
      });
    }

    const category = await prisma.category.create({
      data: { name_of_category },
    });

    res.status(201).json({
      success: true,
      message: "Category created successfully.",
      category,
    });
  } catch (error: any) {
    console.error("❌ Error creating category:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create category.",
    });
  }
};

/**
 * 🟢 Update category
 */
export const updateCategory = async (req: Request, res: Response) => {
  try {
    const { categoryId } = req.params;
    const { name_of_category } = req.body;

    if (!categoryId || typeof categoryId !== "string") {
      return res.status(400).json({
        success: false,
        message: "Invalid category ID. It must be a valid UUID string.",
      });
    }

    if (!name_of_category) {
      return res.status(400).json({
        success: false,
        message: "Category name is required.",
      });
    }

    const category = await prisma.category.update({
      where: { id: categoryId },
      data: { name_of_category },
    });

    res.status(200).json({
      success: true,
      message: "Category updated successfully.",
      category,
    });
  } catch (error: any) {
    console.error("❌ Error updating category:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update category.",
    });
  }
};

/**
 * 🟢 Delete category
 */
export const deleteCategory = async (req: Request, res: Response) => {
  try {
    const { categoryId } = req.params;

    if (!categoryId || typeof categoryId !== "string") {
      return res.status(400).json({
        success: false,
        message: "Invalid category ID. It must be a valid UUID string.",
      });
    }

    // ✅ Check if category exists first
    const existingCategory = await prisma.category.findUnique({
      where: { id: categoryId },
    });

    if (!existingCategory) {
      return res.status(404).json({
        success: false,
        message: "Category not found. Cannot delete a non-existing category.",
      });
    }

    // ✅ Now delete safely
    await prisma.category.delete({
      where: { id: categoryId },
    });

    res.status(200).json({
      success: true,
      message: "Category deleted successfully.",
    });
  } catch (error: any) {
    console.error("❌ Error deleting category:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete category.",
      error: error?.meta?.cause || error.message,
    });
  }
};
