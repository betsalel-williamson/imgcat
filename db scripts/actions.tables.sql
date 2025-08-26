DROP TABLE IF EXISTS Posts.View;
DROP TABLE IF EXISTS Posts.Vote;
DROP TABLE IF EXISTS Posts.Report;



CREATE TABLE Posts.View (
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	count
		INT UNSIGNED NOT NULL
		DEFAULT 1,

	PRIMARY KEY(post_id, user_id)
);

CREATE INDEX IX_ViewsByPost
	ON Posts.View(post_id);
CREATE INDEX IX_ViewsByUser
	ON Posts.View(user_id);


CREATE TABLE Posts.Vote (
	id
		BIGINT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	type
		TINYINT UNSIGNED NOT NULL,
		-- HARDCODED:
		-- 0: N/A (user voted, then cleared it)
		-- 1: +1
		-- 2: +1 Happy/Excited
		-- 3: +1 Love/Sympathy
		-- 4: +1 Top Quality
		-- 5: -1
		-- 6: -1 What is this?
		-- 7: -1 Spam
		-- 8: -1 Troll

	PRIMARY KEY(id),
	UNIQUE(post_id, user_id),
	CONSTRAINT CHECK (type IN (0,1,2,3,4,5,6,7,8))
);

CREATE INDEX IX_VotesByPost
	ON Posts.Vote(post_id);
CREATE INDEX IX_VotesByUser
	ON Posts.Vote(user_id);


-- This creates a dropdown menu for the user to pick an existing folder
CREATE TABLE Posts.UserFolders (
	id
		INT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	name
		TINYTEXT NOT NULL,

	PRIMARY KEY(id),
	UNIQUE KEY(user_id, name)
);

CREATE INDEX IX_UserFolders
	ON Posts.UserFolders(user_id);


CREATE TABLE Posts.FavoritePost (
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	folder_id
		INT UNSIGNED NULL
		REFERENCES Posts.UserFolders(id),

	PRIMARY KEY(user_id, post_id)
);

CREATE INDEX IX_FavoritePost
	ON Posts.FavoritePost(user_id);
CREATE INDEX IX_FavoritePostByFolder
	ON Posts.FavoritePost(folder_id);



CREATE TABLE Posts.HiddenPost (
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	upload_time
		TIMESTAMP NOT NULL
		DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY(user_id, post_id)
);

CREATE INDEX IX_HiddenPost
	ON Posts.HiddenPost(user_id);


CREATE TABLE Posts.



CREATE TABLE Posts.Report (
	id
		INT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	reason_code
		-- HARDCODED: TBD
		-- 1x: Hide this [post, tag, w/e TBD]
		-- 2x: Block this [user, etc.]
		-- 3x: Report incorrect rating
		-- 4x: Report for mod review
		-- 5x: Report illegal content
		TINYINT UNSIGNED NOT NULL,
	context
		TINYTEXT NULL,

	PRIMARY KEY(id)
);