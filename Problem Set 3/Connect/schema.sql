-- PEOPLE
CREATE TABLE "people" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- SCHOOLS
CREATE TABLE "schools" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN("Elementary School", "Middle School", "High School", "Lower School", "Upper School", "College", "University")),
    "location" TEXT NOT NULL,
    "year" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- COMPANIES
CREATE TABLE "companies" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- RELATION USER-USER
CREATE TABLE "connections" (
    "id" INTEGER,
    "user_id_a" INTEGER NOT NULL,
    "user_id_b" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id_a") REFERENCES "people"("id"),
    FOREIGN KEY("user_id_b") REFERENCES "people"("id"),
    CONSTRAINT unique_pair UNIQUE(user_id_a, user_id_b)
);

-- RELATION USER-SCHOOL
CREATE TABLE "school_user" (
    "id" INTEGER,
    "school_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "school_start_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "school_end_date" NUMERIC,
    "school_type" TEXT NOT NULL CHECK("school_type" IN("BA", "MA", "PhD")),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "people"("id"),
    FOREIGN KEY("school_id") REFERENCES "schools"("id")
);

-- RELATION USER-COMPANY
CREATE TABLE "company_user" (
    "id" INTEGER,
    "company_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "company_start_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "company_end_date" NUMERIC,
    "company_begin_type" TEXT NOT NULL CHECK("company_begin_type" IN("BA", "MA", "PhD")),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "people"("id"),
    FOREIGN KEY("company_id") REFERENCES "companies"("id")
);
