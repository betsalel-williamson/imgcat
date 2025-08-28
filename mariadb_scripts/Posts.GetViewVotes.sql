DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.GetViewVotes(
	_post_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	-- TODO: Eventually, this will go into Redis
	CALL CalcVVCache(_post_id);

	SELECT
		view_total, vote_total,
		up, up_yes, up_ohno, up_smart,
		down, down_cringe, down_creep, down_troll
	FROM Posts.VVCache
	WHERE id = _post_id
	LIMIT 1;
END
$$
DELIMITER ;


DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.GetViews(
	_post_id INT UNSIGNED
)
RETURNS INT UNSIGNED
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	-- TODO: Eventually, this will go into Redis
	CALL CalcVVCache(_post_id);

	RETURN (
		SELECT view_total
		FROM Posts.VVCache
		WHERE id = _post_id
		LIMIT 1
	);
END
$$
DELIMITER ;


DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.GetVotes(
	_post_id INT UNSIGNED
)
RETURNS INT SIGNED
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	-- TODO: Eventually, this will go into Redis
	CALL CalcVVCache(_post_id);

	RETURN (
		SELECT vote_total
		FROM Posts.VVCache
		WHERE id = _post_id
		LIMIT 1
	);
END
$$
DELIMITER ;