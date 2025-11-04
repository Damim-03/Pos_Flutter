import { Router } from "express";
import { getProducts, 
         getProductByBarcode, 
         createProduct, 
         updateProductByBarcode, 
         deleteProductByBarcode } 
from "../../controller/product/product.controller";

const router = Router();

// Product routes
router.get("/products", getProducts);
router.get("/products/:barcode", getProductByBarcode);
router.post("/products/createprod", createProduct);
router.put("/products/updateprod/:barcode", updateProductByBarcode);
router.delete("/products/deletprod/:barcode", deleteProductByBarcode);

export default router;