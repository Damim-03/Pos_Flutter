import { Request, Response } from "express";
import prisma from "../../lib/prisma";
import { Prisma } from "@prisma/client";
import { v4 as uuidv4 } from "uuid";

/**
 * 🟢 Get all products
 */
export const getProducts = async (req: Request, res: Response) => {
  try {
    const products = await prisma.products.findMany({
      include: {
        category: true,
        product_status: true,
      },
    });

    res.status(200).json({
      success: true,
      count: products.length,
      products,
    });
  } catch (error: any) {
    console.error("❌ Error fetching products:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch products.",
      error: error.message,
    });
  }
};

/**
 * 🟢 Get product by barcode
 */
export const getProductByBarcode = async (req: Request, res: Response) => {
  try {
    const { barcode } = req.params;

    const product = await prisma.products.findUnique({
      where: { barcode },
      include: { category: true, product_status: true },
    });

    if (!product) {
      return res.status(404).json({
        success: false,
        message: `Product with barcode '${barcode}' not found.`,
      });
    }

    res.status(200).json({
      success: true,
      product: {
        ...product,
        price1: `${Number(product.price1).toFixed(2)} DZD`,
        price2: `${Number(product.price2).toFixed(2)} DZD`,
        price3: `${Number(product.price3).toFixed(2)} DZD`,
      },
    });
  } catch (error: any) {
    console.error("❌ Error fetching product by barcode:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch product by barcode.",
      error: error.message,
    });
  }
};

/**
 * 🟢 Create a new product
 */
export const createProduct = async (req: Request, res: Response) => {
  try {
    const {
      barcode,
      product_name,
      description,
      price1,
      price2,
      price3,
      unit,
      quantity,
      production_date,
      expiration_date,
      image_path,
      category_id,
      category_name,
      status,
    } = req.body;

    // ✅ Validate required fields
    if (!barcode || !product_name || !unit) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields: barcode, product_name, or unit.",
      });
    }

    // ✅ Prevent duplicate barcodes
    const existingProduct = await prisma.products.findUnique({ where: { barcode } });
    if (existingProduct) {
      return res.status(409).json({
        success: false,
        message: `Product with barcode '${barcode}' already exists.`,
      });
    }

    // ✅ Resolve category (by ID or by name)
    let resolvedCategoryId: string | null = null;

    if (category_id) {
      const existingCategory = await prisma.category.findUnique({ where: { id: category_id } });
      if (!existingCategory) {
        return res.status(400).json({
          success: false,
          message: `Category with id=${category_id} not found.`,
        });
      }
      resolvedCategoryId = existingCategory.id;
    } else if (category_name) {
      const category = await prisma.category.upsert({
        where: { name_of_category: category_name },
        update: {},
        create: { name_of_category: category_name },
      });
      resolvedCategoryId = category.id;
    }

    // ✅ Normalize status values
    const normalizeStatus = (input: string): "VALID" | "EXPIRED" => {
      const val = input?.toLowerCase().trim();
      if (["available", "valid", "ok", "in_stock"].includes(val)) return "VALID";
      if (["expired", "out_of_stock", "invalid"].includes(val)) return "EXPIRED";
      throw new Error(`Invalid status value: ${input}.`);
    };

    // ✅ Create or update status record
    let statusRecord = null;
    if (status) {
      const normalizedStatus = normalizeStatus(status);
      statusRecord = await prisma.product_status.upsert({
        where: { barcode },
        update: { status: normalizedStatus },
        create: { barcode, status: normalizedStatus },
      });
    }

    // ✅ Convert prices to Decimal (2 decimals)
    const formatPrice = (price: any) =>
      new Prisma.Decimal(parseFloat(price || 0).toFixed(2));

    // ✅ Create product
    const product = await prisma.products.create({
      data: {
        id: uuidv4(),
        barcode,
        product_name,
        description,
        price1: formatPrice(price1),
        price2: formatPrice(price2),
        price3: formatPrice(price3),
        unit,
        quantity: quantity || 0,
        production_date: production_date ? new Date(production_date) : null,
        expiration_date: expiration_date ? new Date(expiration_date) : null,
        image_path,
        category_id: resolvedCategoryId,
        status_id: statusRecord ? statusRecord.id : null,
      },
      include: { category: true, product_status: true },
    });

    res.status(201).json({
      success: true,
      message: "✅ Product created successfully!",
      product: {
        ...product,
        price1: `${Number(product.price1).toFixed(2)} DZD`,
        price2: `${Number(product.price2).toFixed(2)} DZD`,
        price3: `${Number(product.price3).toFixed(2)} DZD`,
      },
    });
  } catch (error: any) {
    console.error("❌ Error creating product:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create product.",
      error: error.message,
    });
  }
};

/**
 * 🟢 Update product by barcode
 */
export const updateProductByBarcode = async (req: Request, res: Response) => {
  try {
    const { barcode } = req.params;
    const {
      product_name,
      description,
      price1,
      price2,
      price3,
      unit,
      quantity,
      production_date,
      expiration_date,
      image_path,
      category_id,
      status,
    } = req.body;

    const existingProduct = await prisma.products.findUnique({ where: { barcode } });
    if (!existingProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found with this barcode.",
      });
    }

    // ✅ Handle status update
    let statusRecord = null;
    if (status) {
      statusRecord = await prisma.product_status.upsert({
        where: { barcode },
        update: { status },
        create: { barcode, status },
      });
    }

    const updatedProduct = await prisma.products.update({
      where: { barcode },
      data: {
        product_name,
        description,
        price1: price1 ? new Prisma.Decimal(price1) : undefined,
        price2: price2 ? new Prisma.Decimal(price2) : undefined,
        price3: price3 ? new Prisma.Decimal(price3) : undefined,
        unit,
        quantity,
        production_date: production_date ? new Date(production_date) : undefined,
        expiration_date: expiration_date ? new Date(expiration_date) : undefined,
        image_path,
        category_id: category_id || undefined,
        status_id: statusRecord ? statusRecord.id : undefined,
      },
      include: { category: true, product_status: true },
    });

    res.status(200).json({
      success: true,
      message: "✅ Product updated successfully!",
      product: updatedProduct,
    });
  } catch (error: any) {
    console.error("❌ Error updating product by barcode:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update product by barcode.",
      error: error.message,
    });
  }
};

/**
 * 🟢 Delete product by barcode
 */
export const deleteProductByBarcode = async (req: Request, res: Response) => {
  try {
    const { barcode } = req.params;

    const existingProduct = await prisma.products.findUnique({ where: { barcode } });
    if (!existingProduct) {
      return res.status(404).json({
        success: false,
        message: `No product found with barcode: ${barcode}`,
      });
    }

    await prisma.product_status.deleteMany({ where: { barcode } });
    await prisma.products.delete({ where: { barcode } });

    res.status(200).json({
      success: true,
      message: `✅ Product with barcode '${barcode}' deleted successfully.`,
    });
  } catch (error: any) {
    console.error("❌ Error deleting product by barcode:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete product by barcode.",
      error: error.message,
    });
  }
};
