-- PASSENGERS
CREATE TABLE "passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    PRIMARY KEY("id")
);

-- AIRLINES
CREATE TABLE "airlines" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "concourse" TEXT NOT NULL CHECK(concourse IN ('A', 'B', 'C', 'D', 'E', 'F', 'T')),
    PRIMARY KEY("id")
);

-- FLIGHTS
CREATE TABLE "flights" (
    id INTEGER,
    flight_number TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    departure_airport_code TEXT NOT NULL,
    arrival_airport_code TEXT NOT NULL,
    expected_departure_datetime NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expected_arrival_datetime NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("airline_id") REFERENCES "airlines"("id")
);

-- CHECK-INS
CREATE TABLE "check_ins" (
    "id" INTEGER,
    "passenger_id" INTEGER NOT NULL,
    "flight_id" INTEGER NOT NULL,
    "checkin_datetime" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("passenger_id") REFERENCES "passengers"("id"),
    FOREIGN KEY("flight_id") REFERENCES "flights"("id")
);

