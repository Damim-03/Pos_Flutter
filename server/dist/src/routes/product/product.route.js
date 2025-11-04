"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const product_controller_1 = require("../../controller/product/product.controller");
const router = (0, express_1.Router)();
// Product routes
router.get("/products", product_controller_1.getProducts);
router.get("/products/:barcode", product_controller_1.getProductByBarcode);
router.post("/products/createprod", product_controller_1.createProduct);
router.put("/products/updateprod/:barcode", product_controller_1.updateProductByBarcode);
router.delete("/products/deletprod/:barcode", product_controller_1.deleteProductByBarcode);
exports.default = router;
