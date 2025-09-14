DELIMITER $$
CREATE OR REPLACE PROCEDURE UserDB.GetLoginData(
	_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE v_username VARCHAR(255) DEFAULT NULL;
	DECLARE v_content_level TINYINT DEFAULT NULL;
	DECLARE v_is_login_allowed BOOL DEFAULT false;

	SELECT username, content_level, is_login_allowed
	INTO v_username, v_content_level, v_is_login_allowed
	FROM UserDB.Account
	WHERE id = _id;

	IF v_username IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account does not exist';
	END IF;

	IF v_is_login_allowed = false THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account is locked';
	END IF;

	-- Return profile data
	SELECT
		_id as 'id',
		v_username as 'username',
		v_content_level as 'content_level';

	-- Return claims
	SELECT b.name
	FROM UserDB.AccountClaim a
	INNER JOIN UserDB.Claim b
		ON a.claim_id = b.id
	WHERE a.account_id = _id;
END;
$$
DELIMITER ;