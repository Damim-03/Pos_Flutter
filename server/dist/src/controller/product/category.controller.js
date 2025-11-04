"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteCategory = exports.updateCategory = exports.createCategory = exports.getCategoryById = exports.getCategory = void 0;
const getCategory = async (req, res) => {
    try {
        res.status(200).json({ message: "Get all categories - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error fetching categories:", error);
    }
};
exports.getCategory = getCategory;
const getCategoryById = async (req, res) => {
    try {
        res.status(200).json({ message: "Get one category - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error fetching categories:", error);
    }
};
exports.getCategoryById = getCategoryById;
const createCategory = async (req, res) => {
    try {
        res.status(201).json({ message: "Create category - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error creating category:", error);
    }
};
exports.createCategory = createCategory;
const updateCategory = async (req, res) => {
    try {
        res.status(200).json({ message: "Update category - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error updating category:", error);
    }
};
exports.updateCategory = updateCategory;
const deleteCategory = async (req, res) => {
    try {
        res.status(200).json({ message: "Delete category - to be implemented" });
    }
    catch (error) {
        console.error("❌ Error deleting category:", error);
    }
};
exports.deleteCategory = deleteCategory;
