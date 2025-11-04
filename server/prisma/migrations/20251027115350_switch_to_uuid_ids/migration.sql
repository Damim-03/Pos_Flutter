-- CreateTable
CREATE TABLE `User` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NULL,
    `googleId` VARCHAR(191) NULL,
    `avatar` VARCHAR(191) NULL,
    `provider` VARCHAR(191) NOT NULL DEFAULT 'local',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `User_email_key`(`email`),
    UNIQUE INDEX `User_googleId_key`(`googleId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `category` (
    `id` VARCHAR(191) NOT NULL,
    `name_of_category` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `category_name_of_category_key`(`name_of_category`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `unit` (
    `id` VARCHAR(191) NOT NULL,
    `unit_name` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `unit_unit_name_key`(`unit_name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `products` (
    `id` VARCHAR(191) NOT NULL,
    `barcode` VARCHAR(191) NOT NULL,
    `product_name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `price1` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `price2` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `price3` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `unit` VARCHAR(191) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,
    `production_date` DATETIME(3) NULL,
    `expiration_date` DATETIME(3) NULL,
    `image_path` VARCHAR(191) NULL,
    `category_id` VARCHAR(191) NULL,
    `status_id` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `products_barcode_key`(`barcode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchases` (
    `purchase_id` INTEGER NOT NULL AUTO_INCREMENT,
    `purchase_date` DATETIME(3) NULL,
    `purchase_time` DATETIME(3) NULL,
    `subtotal` DECIMAL(65, 30) NULL,
    `discount` DECIMAL(65, 30) NULL,
    `debt` DECIMAL(65, 30) NULL,
    `total` DECIMAL(65, 30) NULL,
    `customer_name` VARCHAR(191) NULL,
    `customer_id` VARCHAR(191) NULL,

    PRIMARY KEY (`purchase_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_payments` (
    `payment_id` INTEGER NOT NULL AUTO_INCREMENT,
    `purchase_id` INTEGER NOT NULL,
    `total_amount` DOUBLE NOT NULL,
    `paid_amount` DOUBLE NOT NULL,
    `change_amount` DOUBLE NOT NULL,
    `payment_date` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`payment_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_items` (
    `item_id` INTEGER NOT NULL AUTO_INCREMENT,
    `purchase_id` INTEGER NULL,
    `product_id` VARCHAR(191) NULL,
    `number` VARCHAR(191) NULL,
    `product_name` VARCHAR(191) NULL,
    `quantity` INTEGER NULL,
    `price` DECIMAL(65, 30) NULL,
    `total_price` DECIMAL(65, 30) NULL,

    PRIMARY KEY (`item_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales` (
    `sale_id` INTEGER NOT NULL AUTO_INCREMENT,
    `sale_date` DATETIME(3) NULL,
    `sale_time` DATETIME(3) NULL,
    `subtotal` DECIMAL(65, 30) NULL,
    `discount` DECIMAL(65, 30) NULL,
    `debt` DECIMAL(65, 30) NULL,
    `total` DECIMAL(65, 30) NULL,
    `customer_name` VARCHAR(191) NULL,
    `customer_id` VARCHAR(191) NULL,

    PRIMARY KEY (`sale_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_items` (
    `item_id` INTEGER NOT NULL AUTO_INCREMENT,
    `sale_id` INTEGER NULL,
    `product_id` VARCHAR(191) NULL,
    `number` VARCHAR(191) NULL,
    `product_name` VARCHAR(191) NULL,
    `quantity` INTEGER NULL,
    `price` DECIMAL(65, 30) NULL,
    `total_price` DECIMAL(65, 30) NULL,

    PRIMARY KEY (`item_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payments` (
    `payment_id` INTEGER NOT NULL AUTO_INCREMENT,
    `sale_id` INTEGER NOT NULL,
    `total_amount` DOUBLE NOT NULL,
    `paid_amount` DOUBLE NOT NULL,
    `change_amount` DOUBLE NOT NULL,
    `payment_date` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`payment_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `product_status` (
    `id` VARCHAR(191) NOT NULL,
    `barcode` VARCHAR(191) NOT NULL,
    `status` ENUM('EXPIRED', 'VALID') NOT NULL,
    `updated_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `product_status_barcode_key`(`barcode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client` (
    `customer_id` VARCHAR(191) NOT NULL,
    `customer_name` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NULL,
    `email` VARCHAR(191) NULL,
    `address` VARCHAR(191) NULL,
    `image_path` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`customer_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_sales` (
    `sale_id` INTEGER NOT NULL AUTO_INCREMENT,
    `sale_date` DATETIME(3) NULL,
    `sale_time` DATETIME(3) NULL,
    `subtotal` DECIMAL(65, 30) NULL,
    `discount` DECIMAL(65, 30) NULL,
    `debt` DECIMAL(65, 30) NULL,
    `total` DECIMAL(65, 30) NULL,
    `customer_name` VARCHAR(191) NULL,
    `customer_id` VARCHAR(191) NULL,

    PRIMARY KEY (`sale_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_sales_item` (
    `item_id` INTEGER NOT NULL AUTO_INCREMENT,
    `sale_id` INTEGER NULL,
    `product_id` VARCHAR(191) NULL,
    `number` VARCHAR(191) NULL,
    `product_name` VARCHAR(191) NULL,
    `quantity` INTEGER NULL,
    `price` DECIMAL(65, 30) NULL,
    `total_price` DECIMAL(65, 30) NULL,

    PRIMARY KEY (`item_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_debts` (
    `debt_id` INTEGER NOT NULL AUTO_INCREMENT,
    `customer_id` VARCHAR(191) NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL,
    `debt_date` DATETIME(3) NOT NULL,
    `status` ENUM('غير_مدفوع', 'مدفوع_جزئيًا', 'مدفوع') NOT NULL DEFAULT 'غير_مدفوع',
    `notes` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NULL,

    PRIMARY KEY (`debt_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_payments` (
    `payment_id` INTEGER NOT NULL AUTO_INCREMENT,
    `customer_id` VARCHAR(191) NOT NULL,
    `customer_name` VARCHAR(191) NOT NULL,
    `amount_paid` DECIMAL(65, 30) NOT NULL,
    `payment_date` DATETIME(3) NOT NULL,
    `payment_time` DATETIME(3) NOT NULL,
    `status` ENUM('تم_الدفع', 'لم_يتم_الدفع') NOT NULL DEFAULT 'لم_يتم_الدفع',

    PRIMARY KEY (`payment_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `products` ADD CONSTRAINT `products_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `category`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `products` ADD CONSTRAINT `products_status_id_fkey` FOREIGN KEY (`status_id`) REFERENCES `product_status`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_payments` ADD CONSTRAINT `purchase_payments_purchase_id_fkey` FOREIGN KEY (`purchase_id`) REFERENCES `purchases`(`purchase_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_items` ADD CONSTRAINT `purchase_items_purchase_id_fkey` FOREIGN KEY (`purchase_id`) REFERENCES `purchases`(`purchase_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_items` ADD CONSTRAINT `purchase_items_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_sale_id_fkey` FOREIGN KEY (`sale_id`) REFERENCES `sales`(`sale_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `payments` ADD CONSTRAINT `payments_sale_id_fkey` FOREIGN KEY (`sale_id`) REFERENCES `sales`(`sale_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_sales` ADD CONSTRAINT `client_sales_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `client`(`customer_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_sales_item` ADD CONSTRAINT `client_sales_item_sale_id_fkey` FOREIGN KEY (`sale_id`) REFERENCES `client_sales`(`sale_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_sales_item` ADD CONSTRAINT `client_sales_item_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_debts` ADD CONSTRAINT `client_debts_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `client`(`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_payments` ADD CONSTRAINT `client_payments_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `client`(`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE;
