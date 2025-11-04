import { Router } from "express";
import { getUnits, 
         getUnitById, 
         createUnit, 
         updateUnitById, 
         deleteUnitById } 
from "../../controller/product/unit.controller";

const router = Router();

// Product routes
router.get("/units", getUnits);
router.get("/units/:unitId", getUnitById);
router.post("/units/createunit", createUnit);
router.put("/units/updateunit/:unitId", updateUnitById);
router.delete("/units/deleteunit/:unitId", deleteUnitById);

export default router;