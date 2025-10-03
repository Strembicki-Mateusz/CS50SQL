
-- *** The Lost Letter ***
SELECT addresses.address, scans.action, scans.timestamp, addresses.type
FROM scans
JOIN addresses a ON scans.address_id = addresses.id
WHERE scans.package_id = (
    SELECT id
    FROM packages
    WHERE from_address_id = (
        SELECT id FROM addresses WHERE address = '900 Somerville Avenue'
    )
    AND to_address_id = (
        SELECT id FROM addresses WHERE address = '2 Finnigan Street'
    )
);
-- *** The Devious Delivery ***
SELECT scans.id, scans.timestamp, scans.action, addresses.address, drivers.name, addresses.type, packages.contents
FROM scans
JOIN addresses ON scans.address_id = addresses.id
JOIN drivers ON scans.driver_id = drivers.id
JOIN packages ON scans.package_id = packages.id
WHERE scans.package_id = (
    SELECT id FROM packages
    WHERE contents LIKE '%duck%' AND from_address_id IS NULL
);

-- *** The Forgotten Gift ***
SELECT scans.action, drivers.name, packages.contents FROM scans
JOIN drivers ON drivers.id = scans.driver_id
JOIN packages ON packages.id = scans.package_id
WHERE package_id = (
SELECT id FROM packages
WHERE from_address_id = (
        SELECT id FROM addresses WHERE address = "109 Tileston Street"
    )
    AND to_address_id = (
        SELECT id FROM addresses WHERE address = "728 Maple Place"
    )
);

