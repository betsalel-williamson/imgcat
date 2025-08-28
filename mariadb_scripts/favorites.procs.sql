DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.GetFavFolders(
	p_user_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	SELECT id, folder_name
	FROM Posts.UserFolders
	WHERE user_id = p_user_id;
END
$$
DELIMITER ;



DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.CreateFavFolder(
	p_user_id INT UNSIGNED,
	p_name TINYTEXT
)
RETURNS INT UNSIGNED
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	INSERT INTO Posts.UserFolders(user_id, name)
	VALUES (p_user_id, p_name);

	RETURN LAST_INSERT_ID();
END
$$
DELIMITER ;



DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.RenameFavFolder(
	p_user_id INT UNSIGNED,
	p_folder_id INT UNSIGNED,
	p_name TINYTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	UPDATE Posts.UserFolders
	SET name = p_name
	WHERE id = p_folder_id
		AND user_id = p_user_id;
END
$$
DELIMITER ;



DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.ToggleFavPost(
	p_user_id INT UNSIGNED,
	p_post_id INT UNSIGNED,
	p_name TINYTEXT
)
RETURNS BOOL
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE v_folder_id INT UNSIGNED DEFAULT NULL;

	-- Check if we're favoriting or unfavoriting a post
	IF NOT EXISTS(
		SELECT 1
		FROM Posts.FavoritePost
		WHERE user_id = p_user_id
			AND post_id = p_post_id
	) THEN
		IF p_name IS NOT NULL THEN
			SELECT id
			INTO v_folder_id
			FROM Posts.UserFolders
				WHERE user_id = p_user_id
				AND name = p_name;
		END IF;

		INSERT INTO Posts.FavoritePost(user_id, post_id, folder_id)
		VALUES (p_user_id, p_post_id, v_folder_id);

		RETURN TRUE;
	ELSE
		DELETE FROM Posts.FavoritePost
		WHERE user_id = p_user_id
			AND post_id = p_post_id;

		RETURN FALSE;
	END IF;
END
$$
DELIMITER ;


DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.ToggleFavMedia(
	p_user_id INT UNSIGNED,
	p_media_id INT UNSIGNED,
	p_name TINYTEXT
)
RETURNS BOOL
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE v_folder_id INT UNSIGNED DEFAULT NULL;

	-- Check if we're favoriting or unfavoriting a post
	IF NOT EXISTS(
		SELECT 1
		FROM Posts.FavoriteMedia
		WHERE user_id = p_user_id
			AND media_id = p_media_id
	) THEN
		IF p_name IS NOT NULL THEN
			SELECT id
			INTO v_folder_id
			FROM Posts.UserFolders
				WHERE user_id = p_user_id
				AND name = p_name;
		END IF;

		INSERT INTO Posts.FavoriteMedia(user_id, media_id, folder_id)
		VALUES (p_user_id, p_media_id, v_folder_id);

		RETURN TRUE;
	ELSE
		DELETE FROM Posts.FavoriteMedia
		WHERE user_id = p_user_id
			AND media_id = p_post_id;

		RETURN FALSE;
	END IF;
END
$$
DELIMITER ;



DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.IsFavPost(
	p_user_id INT UNSIGNED,
	p_post_id INT UNSIGNED
)
RETURNS BOOL
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	RETURN EXISTS(
		SELECT 1
		FROM Posts.FavoritePost
		WHERE user_id = p_user_id
			AND post_id = p_post_id
	);
END
$$
DELIMITER ;


DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.IsFavMedia(
	p_user_id INT UNSIGNED,
	p_media_id INT UNSIGNED
)
RETURNS BOOL
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	RETURN EXISTS(
		SELECT 1
		FROM Posts.FavoriteMedia
		WHERE user_id = p_user_id
			AND media_id = p_media_id
	);
END
$$
DELIMITER ;
