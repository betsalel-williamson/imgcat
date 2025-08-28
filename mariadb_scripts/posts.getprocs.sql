
DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.CalcVVCache(
	_post_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE v_view_total INT SIGNED DEFAULT 0;
	DECLARE v_cache_time INT UNSIGNED;

	SELECT view_total, TIME_TO_SEC(TIMEDIFF(CURRENT_TIMESTAMP(), last_calc))
	INTO v_view_total, v_cache_time
	FROM Posts.VVCache
	WHERE id = _post_id;

	-- We'll recalculate it if it's over 30 sec, but this
	-- will do unnecessary things if a user is looking at old posts
	-- ATM we don't care, b/c this should be Redis anyway.
	IF v_cache_time IS NULL OR v_cache_time > 30 THEN
		
		-- Return unique views, if we want total views its: SUM(count)
		SELECT COUNT(*)
		INTO v_view_total
		FROM Posts.View
		WHERE post_id = _post_id;

		-- Votes are a bit more complicated
		INSERT INTO Posts.VVCache(
			id,
			view_total,
			vote_total,
			up, up_yes, up_ohno, up_smart, 
			down, down_cringe, down_creep, down_troll
		)
		WITH v(type, cnt) AS (
			SELECT type, COUNT(*)
			FROM Posts.Vote
			WHERE post_id = _post_id
			GROUP BY type
		), vpvt(c1,c2,c3,c4,c5,c6,c7,c8) AS (
			SELECT
			COALESCE((SELECT cnt FROM v WHERE type=1),0),
			COALESCE((SELECT cnt FROM v WHERE type=2),0),
			COALESCE((SELECT cnt FROM v WHERE type=3),0),
			COALESCE((SELECT cnt FROM v WHERE type=4),0),
			COALESCE((SELECT cnt FROM v WHERE type=5),0),
			COALESCE((SELECT cnt FROM v WHERE type=6),0),
			COALESCE((SELECT cnt FROM v WHERE type=7),0),
			COALESCE((SELECT cnt FROM v WHERE type=8),0)
		)
		SELECT
			_post_id,
			v_view_total,
			c1+c2+c3+c4-c5-c6-c7-c8,
			c1, c2, c3, c4,
			c5, c6, c7, c8
		FROM vpvt
		ON DUPLICATE KEY UPDATE
			last_calc = CURRENT_TIMESTAMP(),
			view_total = v_view_total,
			vote_total = c1+c2+c3+c4-c5-c6-c7-c8,
			up=c1, up_yes=c2, up_ohno=c3, up_smart=c4,
			down=c5, down_cringe=c6, down_creep=c7, down_troll=c8;
	END IF;
END
$$
DELIMITER ;











DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.GetPost(
	p_post_id INT UNSIGNED,
	p_user_content_level TINYINT UNSIGNED,
	p_user_id INT UNSIGNED,
	p_register_view BOOL
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	IF p_register_view THEN
		DO Posts.SetView(p_post_id, p_user_id);
	END IF;

	-- Verify the user is allowed to see the post at all
	IF EXISTS(
		SELECT 1
		FROM Posts.Post a
		INNER JOIN Posts.PostRating b
			ON a.id=b.post_id
		WHERE a.id = p_post_id
			AND (a.is_public = true OR a.user_id = p_user_id)
			AND b.category <= p_user_content_level
	) THEN
		SELECT
			a.id,
			a.title,
			a.user_id,
			b.username,
			a.upload_time as 'time',
			a.is_public
		FROM Posts.Post a
		INNER JOIN UserDB.Account b
			ON a.user_id=b.id
		WHERE a.id = p_post_id
		LIMIT 1;

		SELECT b.link_v1 AS link, a.description
		FROM Posts.Attachment a
		INNER JOIN Posts.Media b
			ON a.media_id = b.id
		WHERE a.post_id = p_post_id
		ORDER BY order_id ASC;
	END IF;
END
$$
DELIMITER ;







DELIMITER $$
CREATE OR REPLACE PROCEDURE Posts.GetPostComments(
	p_post_id INT UNSIGNED
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	SELECT
		a.id,
		b.username,
		a.upload_time as 'time',
		a.reply_to,
		a.link_v1 as 'link',
		a.comment
	FROM Comments.Comment a
	INNER JOIN UserDB.Account b
		ON a.user_id=b.id
	WHERE post_id = p_post_id;
END
$$
DELIMITER ;



DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.GetMyVote(
	p_post_id INT UNSIGNED,
	p_user_id INT UNSIGNED
)
RETURNS TINYINT
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
BEGIN
	DECLARE v_result TINYINT DEFAULT 0;

	SELECT type
	INTO v_result
	FROM Posts.Vote
	WHERE post_id = p_post_id
		AND user_id = p_user_id
	LIMIT 1;

	RETURN v_result;
END
$$
DELIMITER ;



