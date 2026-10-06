-- =====================================================================
-- Spin n' Ship — MySQL schema
-- CS 3773 Software Engineering, UTSA, Fall 2026
-- Requires MySQL 8.0.16+ (CHECK constraints are enforced from 8.0.16)
--
-- Run:  mysql -u root -p < db/schema.sql
-- Then: mysql -u root -p group6_music < db/seed.sql
-- WARNING: this drops and recreates every table (wipes data).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS group6_music
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE group6_music;

-- Drop in reverse dependency order so foreign keys don't block it
DROP VIEW  IF EXISTS product_catalog;
DROP TABLE IF EXISTS wishlist_items;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS discount_codes;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ---------------------------------------------------------------------
-- CUSTOMERS  (F2 register/login, F3 edit account, F10/F14 admin)
-- Admins are customers with is_admin = TRUE.
-- ---------------------------------------------------------------------
CREATE TABLE customers (
  customer_id    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  email          VARCHAR(255)  NOT NULL,
  password_hash  VARCHAR(255)  NOT NULL,          -- bcrypt hash, never plain text
  first_name     VARCHAR(100)  NOT NULL,
  last_name      VARCHAR(100)  NOT NULL,
  address_line   VARCHAR(255)  NULL,
  city           VARCHAR(100)  NULL,
  state          CHAR(2)       NULL,
  zip            VARCHAR(10)   NULL,
  is_admin       BOOLEAN       NOT NULL DEFAULT FALSE,
  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                               ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  UNIQUE KEY uq_customers_email (email)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- PRODUCTS  (F4 shop page, F5 search, F6 sort, F11 admin, F13 sales)
-- "Sold out" = quantity 0, so it isn't a separate status.
-- To "remove" an item, set status = 'discontinued' instead of deleting,
-- so past orders keep pointing at a real product.
-- ---------------------------------------------------------------------
CREATE TABLE products (
  product_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  name           VARCHAR(255)  NOT NULL,           -- album title
  artist         VARCHAR(255)  NOT NULL,
  genre          VARCHAR(50)   NULL,
  format         ENUM('Vinyl','CD') NOT NULL DEFAULT 'Vinyl',
  release_year   SMALLINT UNSIGNED NULL,
  description    TEXT          NULL,
  image_url      VARCHAR(500)  NULL,               -- e.g. images/albums/blonde.jpg
  price          DECIMAL(10,2) NOT NULL,
  quantity       INT           NOT NULL DEFAULT 0,
  sale_price     DECIMAL(10,2) NULL,               -- NULL = not on sale
  sale_start     DATETIME      NULL,               -- NULL = starts immediately
  sale_end       DATETIME      NULL,               -- NULL = no end date
  status         ENUM('active','coming_soon','discontinued')
                               NOT NULL DEFAULT 'active',
  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                               ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  KEY idx_products_name   (name),
  KEY idx_products_artist (artist),
  KEY idx_products_price  (price),
  KEY idx_products_qty    (quantity),
  FULLTEXT KEY ft_products_search (name, artist, description),
  CONSTRAINT chk_products_price     CHECK (price >= 0),
  CONSTRAINT chk_products_quantity  CHECK (quantity >= 0),
  CONSTRAINT chk_products_sale      CHECK (sale_price IS NULL
                                           OR (sale_price >= 0 AND sale_price < price)),
  CONSTRAINT chk_products_sale_dates CHECK (sale_start IS NULL OR sale_end IS NULL
                                           OR sale_start < sale_end)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- DISCOUNT_CODES  (F12 admin creates, F8 cart applies)
-- percent: value 10 = 10% off.  flat: value 5 = $5.00 off.
-- ---------------------------------------------------------------------
CREATE TABLE discount_codes (
  code_id        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  code           VARCHAR(50)   NOT NULL,
  description    VARCHAR(255)  NULL,
  discount_type  ENUM('percent','flat') NOT NULL,
  value          DECIMAL(10,2) NOT NULL,
  min_order      DECIMAL(10,2) NOT NULL DEFAULT 0.00,   -- minimum subtotal to use it
  expires_at     DATETIME      NULL,                    -- NULL = never expires
  active         BOOLEAN       NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code_id),
  UNIQUE KEY uq_discount_code (code),
  CONSTRAINT chk_discount_value   CHECK (value > 0),
  CONSTRAINT chk_discount_percent CHECK (discount_type <> 'percent' OR value <= 100),
  CONSTRAINT chk_discount_min     CHECK (min_order >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- CARTS  (one per customer)  +  CART_ITEMS  (F7, F8)
-- ---------------------------------------------------------------------
CREATE TABLE carts (
  cart_id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id      INT UNSIGNED NOT NULL,
  discount_code_id INT UNSIGNED NULL,                  -- code applied to this cart
  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (cart_id),
  UNIQUE KEY uq_carts_customer (customer_id),
  CONSTRAINT fk_carts_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id) ON DELETE CASCADE,
  CONSTRAINT fk_carts_discount FOREIGN KEY (discount_code_id)
    REFERENCES discount_codes (code_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE cart_items (
  cart_item_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  cart_id        INT UNSIGNED NOT NULL,
  product_id     INT UNSIGNED NOT NULL,
  quantity       INT          NOT NULL DEFAULT 1,
  added_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (cart_item_id),
  UNIQUE KEY uq_cart_product (cart_id, product_id),     -- one row per album per cart
  CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id)
    REFERENCES carts (cart_id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON DELETE CASCADE,
  CONSTRAINT chk_cart_items_qty CHECK (quantity > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- ORDERS  +  ORDER_ITEMS  (F9 place order, F15 admin history)
-- Totals and prices are copied in at checkout so history never changes
-- when an admin later edits a price, ends a sale, or deletes a code.
-- ---------------------------------------------------------------------
CREATE TABLE orders (
  order_id         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  customer_id      INT UNSIGNED  NOT NULL,
  order_date       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status           ENUM('placed','processing','shipped','completed','cancelled')
                                 NOT NULL DEFAULT 'placed',
  subtotal         DECIMAL(10,2) NOT NULL,     -- after sale prices, before discount
  discount_code_id INT UNSIGNED  NULL,
  discount_code    VARCHAR(50)   NULL,         -- snapshot of the code text
  discount_amount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tax_rate         DECIMAL(5,4)  NOT NULL DEFAULT 0.0825,
  tax              DECIMAL(10,2) NOT NULL,
  total            DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id),
  KEY idx_orders_date     (order_date),        -- sort by order date
  KEY idx_orders_customer (customer_id),       -- sort/filter by customer
  KEY idx_orders_total    (total),             -- sort by order size ($)
  KEY idx_orders_status   (status),            -- "currently placed" orders
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id) ON DELETE RESTRICT,
  CONSTRAINT fk_orders_discount FOREIGN KEY (discount_code_id)
    REFERENCES discount_codes (code_id) ON DELETE SET NULL,
  CONSTRAINT chk_orders_amounts CHECK (subtotal >= 0 AND discount_amount >= 0
                                       AND tax >= 0 AND total >= 0)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_item_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  order_id          INT UNSIGNED  NOT NULL,
  product_id        INT UNSIGNED  NOT NULL,
  product_name      VARCHAR(255)  NOT NULL,    -- snapshot
  artist            VARCHAR(255)  NOT NULL,    -- snapshot
  quantity          INT           NOT NULL,
  price_at_purchase DECIMAL(10,2) NOT NULL,    -- unit price actually charged
  was_on_sale       BOOLEAN       NOT NULL DEFAULT FALSE,
  PRIMARY KEY (order_item_id),
  KEY idx_order_items_order (order_id),
  CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
    REFERENCES orders (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON DELETE RESTRICT,
  CONSTRAINT chk_order_items_qty   CHECK (quantity > 0),
  CONSTRAINT chk_order_items_price CHECK (price_at_purchase >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- WISHLIST_ITEMS  (bonus F20)
-- ---------------------------------------------------------------------
CREATE TABLE wishlist_items (
  customer_id  INT UNSIGNED NOT NULL,
  product_id   INT UNSIGNED NOT NULL,
  added_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id, product_id),
  CONSTRAINT fk_wishlist_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id) ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- PRODUCT_CATALOG view
-- Use this for the shop page, search, and cart so "is it on sale?" and
-- "what does it cost right now?" are calculated in one place.
-- ---------------------------------------------------------------------
CREATE VIEW product_catalog AS
SELECT
  p.*,
  (p.sale_price IS NOT NULL
     AND (p.sale_start IS NULL OR p.sale_start <= NOW())
     AND (p.sale_end   IS NULL OR p.sale_end   >= NOW()))      AS on_sale,
  CASE
    WHEN p.sale_price IS NOT NULL
     AND (p.sale_start IS NULL OR p.sale_start <= NOW())
     AND (p.sale_end   IS NULL OR p.sale_end   >= NOW())
    THEN p.sale_price
    ELSE p.price
  END                                                           AS current_price,
  (p.quantity = 0)                                              AS sold_out
FROM products p
WHERE p.status <> 'discontinued';
