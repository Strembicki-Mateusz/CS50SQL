-- INGREDIENTS
CREATE TABLE "ingredients" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "price_per_unit" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- DONUTS
CREATE TABLE "donuts" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "is_gluten_free" INTEGER NOT NULL CHECK("is_gluten_free" IN (0, 1)),
    "price" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- DONUT-INGREDIENT RELATION
CREATE TABLE "donut_ingredients" (
    "id" INTEGER,
    "donut_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id"),
    CONSTRAINT unique_donut_ingredient UNIQUE("donut_id", "ingredient_id")
);

-- CUSTOMERS
CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- ORDERS
CREATE TABLE "orders" (
    "id" INTEGER,
    "order_number" TEXT NOT NULL UNIQUE,
    "customer_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

-- ORDER-DONUT RELATION
CREATE TABLE "order_items" (
    "id" INTEGER,
    "order_id" INTEGER NOT NULL,
    "donut_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id"),
    CONSTRAINT unique_order_donut UNIQUE("order_id", "donut_id")
);
