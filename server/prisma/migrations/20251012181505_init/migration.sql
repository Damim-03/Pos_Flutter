/*
  Warnings:

  - The primary key for the `user` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[googleId]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE `user` DROP PRIMARY KEY,
    ADD COLUMN `avatar` VARCHAR(191) NULL,
    ADD COLUMN `googleId` VARCHAR(191) NULL,
    ADD COLUMN `password` VARCHAR(191) NULL,
    MODIFY `id` VARCHAR(191) NOT NULL,
    MODIFY `name` VARCHAR(191) NULL,
    MODIFY `email` VARCHAR(191) NULL,
    ADD PRIMARY KEY (`id`);

-- CreateIndex
CREATE UNIQUE INDEX `User_googleId_key` ON `User`(`googleId`);
