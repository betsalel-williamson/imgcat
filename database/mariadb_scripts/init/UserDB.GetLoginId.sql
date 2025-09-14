DELIMITER $$
CREATE OR REPLACE Function UserDB.GetLoginId(
	_user_or_email varchar(255),
	_password varchar(255)
)
RETURNS INT UNSIGNED
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE d TIMESTAMP DEFAULT NULL;
	DECLARE msg VARCHAR(255) DEFAULT NULL;
	DECLARE r_id INT UNSIGNED DEFAULT NULL;
	DECLARE r_is_login_allowed BOOL DEFAULT false;

	SELECT id, is_login_allowed
	INTO r_id, r_is_login_allowed
	FROM UserDB.Account
	WHERE (username = _user_or_email OR email = _user_or_email)
		AND pass_hash = SHA2(CONCAT(pass_salt, _password), 512);

	IF r_id IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account does not exist, or password is not correct';
	END IF;

	IF r_is_login_allowed = false THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account is locked';
	END IF;

	RETURN r_id;
END;
$$
DELIMITER ;