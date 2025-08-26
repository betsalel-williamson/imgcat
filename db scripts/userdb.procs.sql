DROP FUNCTION IF EXISTS UserDB.IsUsernameFree;
DROP FUNCTION IF EXISTS UserDB.IsIPBanned;
DROP FUNCTION IF EXISTS UserDB.CreateAccount;
DROP FUNCTION IF EXISTS UserDB.GetLoginId;

DROP PROCEDURE IF EXISTS UserDB.GetLoginData;



DELIMITER $$
CREATE OR REPLACE FUNCTION UserDB.IsUsernameFree(
	_username varchar(50)
)
RETURNS BOOL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	IF _username IS NULL OR EXISTS (
		SELECT 1
		FROM UserDB.Account
		WHERE username = _username
	) THEN
		RETURN 0;
	ELSE
		RETURN 1;
	END IF;
END
$$
DELIMITER ;

-- NOTE: Moved to the app layer
--DELIMITER $$
--CREATE OR REPLACE FUNCTION UserDB.IsIPBanned(
--	_ip_address INET6
--)
--RETURNS BOOL
--NOT DETERMINISTIC
--READS SQL DATA
--SQL SECURITY DEFINER
--BEGIN
--	DECLARE d TIMESTAMP DEFAULT false;
--
--	SELECT MAX(ban_end)
--	INTO d
--	FROM UserDB.BannedIPs
--	WHERE ip_address = _ip_address;
--
--	IF _ip_address IS NULL OR d IS NULL OR d < CURRENT_TIMESTAMP THEN
--		RETURN 0;
--	ELSE
--		RETURN 1;
--	END IF;
--END
--$$
--DELIMITER ;
--
--  -- Here's the block used in various functions/procs
--	IF UserDB.IsIPBanned(_ip_address) THEN
--
--		SELECT MAX(ban_end)
--		INTO d
--		FROM UserDB.BannedIPs
--		WHERE ip_address = _ip_address;
--
--		IF d IS NULL THEN
--			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='IP Address is permanently banned';
--		ELSE
--			SET msg = CONCAT('IP Address is banned until [', d, ' UTC]');
--			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=msg;
--		END IF;
--	END IF;
--




DELIMITER $$
CREATE OR REPLACE FUNCTION UserDB.CreateAccount(
	_email varchar(255),
	_password varchar(255),
	_username varchar(50),
	_location char(2),
	_age tinyint
)
RETURNS INT UNSIGNED
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE d TIMESTAMP DEFAULT NULL;
	DECLARE msg VARCHAR(255) DEFAULT NULL;
	DECLARE salt BINARY(16) DEFAULT NULL;
	DECLARE result INT UNSIGNED DEFAULT NULL;

	IF EXISTS (
		SELECT 1
		FROM UserDB.Account
		WHERE email = _email
	) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Email is already registered';
	END IF;

	IF EXISTS (
		SELECT 1
		FROM UserDB.Account
		WHERE username = _username
	) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Username is already registered';
	END IF;

	-- Validation OK
	SET salt = RANDOM_BYTES(16);
	
	INSERT INTO UserDB.Account(
		username,
		pass_hash,
		pass_salt,
		email,
		location,
		age_category,
		content_level
	)
	VALUES(
		_username,
		SHA2(CONCAT(salt, _password), 512),
		salt,
		LOWER(_email),
		_location,
		_age,
		-- All user acct
		CASE WHEN _age < 18 THEN 1 ELSE 2 END
	);

	SET result = LAST_INSERT_ID();

	INSERT INTO UserDB.AccountClaim
	SELECT result, id
	FROM UserDB.Claim
	WHERE name IN ('is_unverified');

	RETURN result;
END;
$$
DELIMITER ;


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