
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
	user_id
		INT UNSIGNED NOT NULL
		REFERENCES UserDB.Account(id),
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	folder_id
		INT UNSIGNED NULL
		REFERENCES Posts.UserFolders(id),

	PRIMARY KEY(user_id, post_id)
);

CREATE INDEX IX_FavoritePost
	ON Posts.FavoritePost(user_id);
CREATE INDEX IX_FavoritePostByFolder
	ON Posts.FavoritePost(folder_id);



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
);

CREATE INDEX IX_FavoriteMedia
	ON Posts.FavoriteMedia(user_id);
CREATE INDEX IX_FavoriteMediaByFolder
	ON Posts.FavoriteMedia(folder_id);
