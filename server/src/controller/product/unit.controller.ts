import { Request, Response } from "express";


export const getUnits = async (req: Request, res: Response) => {
    try {
        res.status(200).json({ message: "Get all units - to be implemented" });
    } catch (error: any) {
        console.error("❌ Error fetching unites:", error);
    }
}

export const getUnitById = async (req: Request, res: Response) => {
    try {
        res.status(200).json({ message: "Get one unit - to be implemented" });
    } catch (error: any) {
        console.error("❌ Error fetching unit:", error);
    }
}

export const createUnit = async (req: Request, res: Response) => {
    try {
        res.status(201).json({ message: "Create unit - to be implemented" });
    } catch (error: any) {
        console.error("❌ Error creating unit:", error);
    }
}

export const updateUnitById = async (req: Request, res: Response) => {
    try {
        res.status(200).json({ message: "Update unit - to be implemented" });
    } catch (error: any) {
        console.error("❌ Error updating unit:", error);
    }
}

export const deleteUnitById = async (req: Request, res: Response) => {
    try {
        res.status(200).json({ message: "Delete unit - to be implemented" });
    } catch (error: any) {
        console.error("❌ Error deleting unit:", error);
    }
}

