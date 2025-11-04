"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteUnitById = exports.updateUnitById = exports.createUnit = exports.getUnitById = exports.getUnits = void 0;
const getUnits = async (req, res) => {
    try {
        res.status(200).json({ message: "Get all units - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error fetching unites:", error);
    }
};
exports.getUnits = getUnits;
const getUnitById = async (req, res) => {
    try {
        res.status(200).json({ message: "Get one unit - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error fetching unit:", error);
    }
};
exports.getUnitById = getUnitById;
const createUnit = async (req, res) => {
    try {
        res.status(201).json({ message: "Create unit - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error creating unit:", error);
    }
};
exports.createUnit = createUnit;
const updateUnitById = async (req, res) => {
    try {
        res.status(200).json({ message: "Update unit - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error updating unit:", error);
    }
};
exports.updateUnitById = updateUnitById;
const deleteUnitById = async (req, res) => {
    try {
        res.status(200).json({ message: "Delete unit - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error deleting unit:", error);
    }
};
exports.deleteUnitById = deleteUnitById;
