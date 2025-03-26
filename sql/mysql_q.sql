### create OrderProduct DataBase
CREATE DATABASE orderProduct;

### Product
CREATE TABLE product
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    description TEXT,
    price       DECIMAL(10, 2) NOT NULL
);

## CRUD
# Create
INSERT INTO product (name, description, price)
VALUES ('Product Name', 'Product Description', 99.99);

# Read
SELECT *
FROM product;

# Update
UPDATE product
SET name        = 'Updated Name',
    description = 'Updated Description',
    price       = 149.99
WHERE id = 1;

# Delete
DELETE
FROM product
WHERE id = 1;

### Inserting Data for Test
INSERT INTO product (name, description, price)
VALUES ('Product 1', 'Description for product 1', 10.99),
       ('Product 2', 'Description for product 2', 20.99),
       ('Product 3', 'Description for product 3', 30.50),
       ('Product 4', 'Description for product 4', 40.75),
       ('Product 5', 'Description for product 5', 55.00),
       ('Product 6', 'Description for product 6', 60.25),
       ('Product 7', 'Description for product 7', 70.80),
       ('Product 8', 'Description for product 8', 15.25),
       ('Product 9', 'Description for product 9', 25.50),
       ('Product 10', 'Description for product 10', 35.75);

## indexes
CREATE INDEX idx_product_name ON product (name);
CREATE INDEX idx_product_price ON product (price);
# on description for deeply search on it
CREATE FULLTEXT INDEX idx_product_description ON product (description);


### Inventory and InventoryProduct
CREATE TABLE inventory
(
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50)  NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE inventory_product
(
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    product   BIGINT NOT NULL,
    inventory BIGINT NOT NULL,
    stock     INT    NOT NULL,
    FOREIGN KEY (product) REFERENCES product (id) ON DELETE CASCADE,
    FOREIGN KEY (inventory) REFERENCES inventory (id) ON DELETE CASCADE
);


### CRUD

#Create
INSERT INTO inventory (code, name)
VALUES ('INV001', 'Inventory A');

INSERT INTO inventory_product (product, inventory, stock)
VALUES (1, 1, 50);
#Read
SELECT *
FROM inventory;

SELECT *
FROM inventory_product;
#Update
UPDATE inventory
SET code = 'INV002',
    name = 'Updated Name'
WHERE id = 1;

UPDATE inventory_product
SET stock = 100
WHERE id = 1;
#Delete
DELETE
FROM inventory
WHERE id = 1;

DELETE
FROM inventory_product
WHERE id = 1;
# inserting Testing Data
INSERT INTO inventory (code, name)
VALUES ('INV001', 'Inventory 1'),
       ('INV002', 'Inventory 2'),
       ('INV003', 'Inventory 3'),
       ('INV004', 'Inventory 4'),
       ('INV005', 'Inventory 5');

INSERT INTO inventory_product (product, inventory, stock)
VALUES (1, 1, 100),
       (2, 1, 200),
       (3, 2, 50),
       (4, 3, 75),
       (5, 4, 30),
       (1, 5, 40),
       (2, 2, 20),
       (3, 3, 35),
       (4, 5, 60),
       (5, 4, 90);

### indexes
CREATE INDEX idx_code ON inventory (code);
CREATE INDEX idx_name ON inventory (name);

CREATE INDEX idx_product ON inventory_product (product);
CREATE INDEX idx_inventory ON inventory_product (inventory);

### Orders and OrderItem
CREATE TABLE orders
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_date     DATETIME     NOT NULL,
    customer_name  VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    total_amount   DOUBLE       NOT NULL
);

CREATE TABLE order_item
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id   BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity   INT    NOT NULL,
    price      DOUBLE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
);

#CRUD
#Create
INSERT INTO orders (order_date, customer_name, customer_email, total_amount)
VALUES (NOW(), 'John Doe', 'john.doe@example.com', 250.00);

INSERT INTO order_item (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 50.00);


INSERT INTO order_item (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 50.00);

#Read
SELECT *
FROM orders;

SELECT *
FROM order_item;

#Update
UPDATE orders
SET customer_name = 'Jane Doe',
    total_amount  = 300.00
WHERE id = 1;

UPDATE order_item
SET quantity = 3,
    price    = 75.00
WHERE id = 1;

#Delete
DELETE
FROM orders
WHERE id = 1;

DELETE
FROM order_item
WHERE id = 1;

### Inserting Tasting Data
INSERT INTO orders (order_date, customer_name, customer_email, total_amount)
VALUES (NOW(), 'John Smith', 'john.smith@example.com', 500.00),
       (NOW(), 'Alice Johnson', 'alice.johnson@example.com', 300.20),
       (NOW(), 'Bob Brown', 'bob.brown@example.com', 120.50),
       (NOW(), 'Charlie Davis', 'charlie.davis@example.com', 750.00),
       (NOW(), 'Eve Wilson', 'eve.wilson@example.com', 660.80);

INSERT INTO order_item (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 100.00),
       (1, 2, 1, 200.00),
       (2, 3, 3, 90.00),
       (3, 4, 1, 120.50),
       (4, 5, 5, 150.00),
       (5, 1, 2, 220.00),
       (5, 3, 1, 190.80),
       (3, 2, 4, 300.00),
       (4, 4, 2, 250.00),
       (2, 5, 1, 110.20);

### indexes
CREATE INDEX idx_customer_email ON orders (customer_email);
CREATE INDEX idx_customer_name ON orders (customer_name);
CREATE UNIQUE INDEX idx_unique_email ON orders (customer_email);

CREATE INDEX idx_order_id ON order_item (order_id);
CREATE INDEX idx_product_id ON order_item (product_id);

### create storedProcedure for calculating total amount of order
DELIMITER $$

CREATE PROCEDURE CalculateOrderTotal(IN orderId INT)
BEGIN
    UPDATE orders
    SET total_amount = (SELECT SUM(quantity * price)
                        FROM order_item
                        WHERE order_id = orderId)
    WHERE id = orderId;
END$$

DELIMITER ;

call CalculateOrderTotal(1);

### trigger Run after Inserting data in Orders Table to run Stored Procedure
DELIMITER $$

CREATE TRIGGER TriggerCalculateTotalOnOrderInsert
    AFTER INSERT
    ON orders
    FOR EACH ROW
BEGIN
    CALL CalculateOrderTotal(NEW.id);
END$$

DELIMITER ;
