"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteProductByBarcode = exports.updateProductByBarcode = exports.createProduct = exports.getProductByBarcode = exports.getProducts = void 0;
const prisma_1 = __importDefault(require("../../lib/prisma"));
const client_1 = require("@prisma/client");
const uuid_1 = require("uuid");
// ✅ Get all products
const getProducts = async (req, res) => {
    try {
        const products = await prisma_1.default.products.findMany({
            include: {
                product_status: true,
                category: true,
            },
        });
        res.status(200).json(products);
    }
    catch (error) {
        console.error("❌ Error fetching products:", error);
        res.status(500).json({
            message: "Failed to fetch products.",
            error: error.message,
        });
    }
};
exports.getProducts = getProducts;
// ✅ Get product by ID
const getProductByBarcode = async (req, res) => {
    try {
        const { barcode } = req.params;
        // ✅ Find product by barcode
        const product = await prisma_1.default.products.findUnique({
            where: { barcode },
            include: {
                category: true,
                product_status: true,
            },
        });
        if (!product) {
            return res.status(404).json({ message: `Product with barcode '${barcode}' not found.` });
        }
        // ✅ Format prices with DZD and 2 decimals
        const formattedProduct = {
            ...product,
            price1: `${Number(product.price1).toFixed(2)} DZD`,
            price2: `${Number(product.price2).toFixed(2)} DZD`,
            price3: `${Number(product.price3).toFixed(2)} DZD`,
        };
        res.status(200).json(formattedProduct);
    }
    catch (error) {
        console.error("❌ Error fetching product by barcode:", error);
        res.status(500).json({
            message: "Failed to fetch product by barcode.",
            error: error.message,
        });
    }
};
exports.getProductByBarcode = getProductByBarcode;
// ✅ Create a new product
const createProduct = async (req, res) => {
    try {
        const { barcode, product_name, description, price1, price2, price3, unit, quantity, production_date, expiration_date, image_path, category_id, category_name, status, } = req.body;
        // ✅ Required fields validation
        if (!barcode || !product_name || !unit) {
            return res.status(400).json({
                message: "Missing required fields: barcode, product_name, or unit.",
            });
        }
        // ✅ Check if barcode already exists
        const existingProduct = await prisma_1.default.products.findUnique({
            where: { barcode },
        });
        if (existingProduct) {
            return res.status(400).json({
                message: `Product with barcode '${barcode}' already exists.`,
            });
        }
        // ✅ Handle category (by id or by name)
        let resolvedCategoryId = null;
        if (category_id) {
            const existingCategory = await prisma_1.default.category.findUnique({
                where: { id: Number(category_id) },
            });
            if (!existingCategory) {
                return res.status(400).json({
                    message: `Category with id=${category_id} not found.`,
                });
            }
            resolvedCategoryId = existingCategory.id;
        }
        else if (category_name) {
            const category = await prisma_1.default.category.upsert({
                where: { name_of_category: category_name },
                update: {},
                create: { name_of_category: category_name },
            });
            resolvedCategoryId = category.id;
        }
        // ✅ Normalize and map status
        const normalizeStatus = (input) => {
            const val = input?.toLowerCase().trim();
            if (["available", "valid", "ok", "in_stock"].includes(val))
                return "VALID";
            if (["expired", "out_of_stock", "invalid"].includes(val))
                return "EXPIRED";
            throw new Error(`Invalid status value: ${input}. Expected one of: Available, Valid, Expired, Out_of_stock.`);
        };
        // ✅ Create product_status record if provided
        let statusRecord = null;
        if (status) {
            const normalizedStatus = normalizeStatus(status);
            statusRecord = await prisma_1.default.product_status.upsert({
                where: { barcode },
                update: { status: normalizedStatus },
                create: { barcode, status: normalizedStatus },
            });
        }
        // ✅ Convert and format prices to 2 decimal DZD values
        const formatPrice = (price) => {
            const num = parseFloat(price || 0).toFixed(2); // 2 decimals
            return new client_1.Prisma.Decimal(num);
        };
        // ✅ Create the product
        const id = (0, uuid_1.v4)();
        const product = await prisma_1.default.products.create({
            data: {
                id,
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
            include: {
                category: true,
                product_status: true,
            },
        });
        // ✅ Format prices for the response (in DZD)
        const formattedProduct = {
            ...product,
            price1: `${Number(product.price1).toFixed(2)} DZD`,
            price2: `${Number(product.price2).toFixed(2)} DZD`,
            price3: `${Number(product.price3).toFixed(2)} DZD`,
        };
        res.status(201).json({
            message: "✅ Product created successfully!",
            product: formattedProduct,
        });
    }
    catch (error) {
        console.error("❌ Error creating product:", error);
        res.status(500).json({
            message: "Failed to create product.",
            error: error.message,
        });
    }
};
exports.createProduct = createProduct;
// ✅ Update product
const updateProductByBarcode = async (req, res) => {
    try {
        const { barcode } = req.params; // ✅ Get barcode from URL parameter
        const { product_name, description, price1, price2, price3, unit, quantity, production_date, expiration_date, image_path, category_id, status, } = req.body;
        // ✅ Check if product exists
        const existingProduct = await prisma_1.default.products.findUnique({
            where: { barcode },
        });
        if (!existingProduct) {
            return res.status(404).json({ message: "Product not found with this barcode." });
        }
        // ✅ Update or create product_status if provided
        let statusRecord = null;
        if (status) {
            statusRecord = await prisma_1.default.product_status.upsert({
                where: { barcode },
                update: { status },
                create: { barcode, status },
            });
        }
        // ✅ Update product by barcode
        const updatedProduct = await prisma_1.default.products.update({
            where: { barcode },
            data: {
                product_name,
                description,
                price1: price1 ? new client_1.Prisma.Decimal(price1) : undefined,
                price2: price2 ? new client_1.Prisma.Decimal(price2) : undefined,
                price3: price3 ? new client_1.Prisma.Decimal(price3) : undefined,
                unit,
                quantity,
                production_date: production_date ? new Date(production_date) : undefined,
                expiration_date: expiration_date ? new Date(expiration_date) : undefined,
                image_path,
                category_id: category_id ? parseInt(category_id) : undefined,
                status_id: statusRecord ? statusRecord.id : undefined,
            },
            include: {
                product_status: true,
                category: true,
            },
        });
        res.status(200).json({
            message: "✅ Product updated successfully by barcode!",
            product: updatedProduct,
        });
    }
    catch (error) {
        console.error("❌ Error updating product by barcode:", error);
        res.status(500).json({
            message: "Failed to update product by barcode.",
            error: error.message,
        });
    }
};
exports.updateProductByBarcode = updateProductByBarcode;
// ✅ Delete product
const deleteProductByBarcode = async (req, res) => {
    try {
        const { barcode } = req.params;
        // ✅ Check if product exists first
        const existingProduct = await prisma_1.default.products.findUnique({
            where: { barcode },
        });
        if (!existingProduct) {
            return res.status(404).json({
                message: `❌ No product found with barcode: ${barcode}`,
            });
        }
        // ✅ Delete related status record (optional, if you want)
        await prisma_1.default.product_status.deleteMany({
            where: { barcode },
        });
        // ✅ Delete the product
        await prisma_1.default.products.delete({
            where: { barcode },
        });
        res.status(200).json({
            message: `✅ Product with barcode ${barcode} deleted successfully!`,
        });
    }
    catch (error) {
        console.error("❌ Error deleting product by barcode:", error);
        res.status(500).json({
            message: "Failed to delete product by barcode.",
            error: error.message,
        });
    }
};
exports.deleteProductByBarcode = deleteProductByBarcode;
