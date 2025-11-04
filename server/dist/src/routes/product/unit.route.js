"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const unit_controller_1 = require("../../controller/product/unit.controller");
const router = (0, express_1.Router)();
// Product routes
router.get("/units", unit_controller_1.getUnits);
router.get("/units/:unitId", unit_controller_1.getUnitById);
router.post("/units/createunit", unit_controller_1.createUnit);
router.put("/units/updateunit/:unitId", unit_controller_1.updateUnitById);
router.delete("/units/deleteunit/:unitId", unit_controller_1.deleteUnitById);
exports.default = router;
