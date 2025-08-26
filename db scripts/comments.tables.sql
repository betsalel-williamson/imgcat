
CREATE SCHEMA IF NOT EXISTS Comments;


CREATE TABLE Comments.Comment (
	id
		BIGINT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	upload_time
		TIMESTAMP NOT NULL
		DEFAULT CURRENT_TIMESTAMP,
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	reply_to
		BIGINT UNSIGNED NULL
		REFERENCES Comments.Comment(id),

	link_v1
		char(12) NULL,
	comment
		varchar(255) NOT NULL,

	PRIMARY KEY(id)
);

CREATE INDEX IX_CommentByPost
	ON Comments.Comment(post_id);
CREATE INDEX IX_CommentByUser
	ON Comments.Comment(user_id);


CREATE TABLE IF NOT EXISTS Comments.CommentVote(
	comment_id
		BIGINT UNSIGNED NOT NULL
		REFERENCES Comments.Comment(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),

	type
		TINYINT UNSIGNED NOT NULL,
		-- HARDCODED:
		-- 0: N/A (user voted, then cleared it)
		-- 1: +1
		-- 2: +1 Yes
		-- 3: +1 OhNo
		-- 4: +1 Smart
		-- 5: -1
		-- 6: -1 Cringe
		-- 7: -1 Creep
		-- 8: -1 Troll

	PRIMARY KEY(comment_id, user_id),
	CONSTRAINT CHECK (type IN (0,1,2,3,4,5,6,7,8))
);

CREATE INDEX IX_CommentVoteByComment
	ON Comments.CommentVote(comment_id);
CREATE INDEX IX_CommentVoteByUser
	ON Comments.CommentVote(user_id);

