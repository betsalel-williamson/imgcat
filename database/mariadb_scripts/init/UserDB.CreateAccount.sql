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