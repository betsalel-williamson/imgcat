CREATE SCHEMA IF NOT EXISTS Mods;

DROP TABLE IF EXISTS Posts.Moderator;
DROP TABLE IF EXISTS Posts.ModDecision;
DROP TABLE IF EXISTS Posts.ModAnalytics;
DROP TABLE IF EXISTS Posts.ModReviewQueue;




CREATE TABLE Mods.ModReport (
	id
		BIGINT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	upload_time
		TIMESTAMP NOT NULL
		DEFAULT CURRENT_TIMESTAMP,
	modify_time
		TIMESTAMP NOT NULL
		DEFAULT CURRENT_TIMESTAMP,
	is_open
		BOOL NOT NULL
		DEFAULT TRUE,
	post_id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	user_id
		INT UNSIGNED NULL
		REFERENCES UserDB.Account(id),
	reason_code
		TINYINT UNSIGNED NOT NULL
		DEFAULT 0,

	PRIMARY KEY(id)
)

CREATE INDEX IX_ModReportByUploadTime
	ON Mods.ModReport(upload_time, is_open);
CREATE INDEX IX_ModReportByModifyTime
	ON Mods.ModReport(modify_time, is_open);
CREATE INDEX IX_ModReportByPost
	ON Mods.ModReport(post_id, is_open);
CREATE INDEX IX_ModReportByUser
	ON Mods.ModReport(user_id, is_open);
CREATE INDEX IX_ModReportByReason
	ON Mods.ModReport(reason_code, is_open);


CREATE TABLE Mods.ModReview (
	id
		BIGINT UNSIGNED NOT NULL
		AUTO_INCREMENT,
	report_id
		BIGINT UNSIGNED NOT NULL
		REFERENCES (Mods.ModReport),
	review_time
		TIMESTAMP NOT NULL
		DEFAULT CURRENT_TIMESTAMP,
	mod_user_id
		INT UNSIGNED NULL
		REFERENCES UserDB.Account(id),
	action_taken
		--
		TINYINT UNSIGNED NOT NULL,

	PRIMARY KEY(id)
)

