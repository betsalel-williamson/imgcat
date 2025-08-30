
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
	UNIQUE KEY(user_id, name),
	INDEX(user_id)
);


CREATE TABLE Posts.FavoritePost (
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	folder_id
		INT UNSIGNED NULL
		REFERENCES Posts.UserFolders(id),

	PRIMARY KEY(user_id, post_id),
	INDEX(user_id),
	INDEX(folder_id)
);


CREATE TABLE Posts.FavoriteMedia (
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	media_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Media(id),
	folder_id
		INT UNSIGNED NULL
		REFERENCES Posts.UserFolders(id),

	PRIMARY KEY(user_id, media_id)
	INDEX(user_id),
	INDEX(folder_id),
);

