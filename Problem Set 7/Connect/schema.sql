-- PEOPLE
CREATE TABLE "people" (
    "id" INT AUTO_INCREMENT,
    "first_name" VARCHAR(32) NOT NULL,
    "last_name" VARCHAR(32) NOT NULL,
    "username" VARCHAR(32) NOT NULL UNIQUE,
    "password" VARCHAR(32) NOT NULL,
    PRIMARY KEY("id")
);

-- SCHOOLS
CREATE TABLE "schools" (
    "id" INT AUTO_INCREMENT,
    "name" VARCHAR(32) NOT NULL,
    "type" ENUM("Elementary School", "Middle School", "High School", "Lower School", "Upper School", "College", "University") NOT NULL,
    "location" VARCHAR(32) NOT NULL,
    "year" DECIMAL(4,0),
    PRIMARY KEY("id")
);

-- COMPANIES
CREATE TABLE "companies" (
    "id" INT AUTO_INCREMENT,
    "name" VARCHAR(32) NOT NULL,
    "industry" VARCHAR(32) NOT NULL,
    "location" VARCHAR(32) NOT NULL,
    PRIMARY KEY("id")
);

-- RELATION USER-USER
CREATE TABLE "connections" (
    "id" INT AUTO_INCREMENT,
    "user_id_a" INT NOT NULL,
    "user_id_b" INT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id_a") REFERENCES "people"("id"),
    FOREIGN KEY("user_id_b") REFERENCES "people"("id"),
    CONSTRAINT unique_pair UNIQUE(user_id_a, user_id_b)
);

-- RELATION USER-SCHOOL
CREATE TABLE "school_user" (
    "id" INT AUTO_INCREMENT,
    "school_id" INT NOT NULL,
    "user_id" INT NOT NULL,
    "school_start_date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "school_end_date" DATETIME,
    "school_type" ENUM("BA", "MA", "PhD"),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "people"("id"),
    FOREIGN KEY("school_id") REFERENCES "schools"("id")
);

-- RELATION USER-COMPANY
CREATE TABLE "company_user" (
    "id" INT AUTO_INCREMENT,
    "company_id" INT NOT NULL,
    "user_id" INT NOT NULL,
    "company_start_date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "company_end_date" DATETIME,
    "company_begin_type" ENUM("BA", "MA", "PhD"),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "people"("id"),
    FOREIGN KEY("company_id") REFERENCES "companies"("id")
);
