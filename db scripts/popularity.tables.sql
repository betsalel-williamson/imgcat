
CREATE TABLE Posts.PopularityCache (
	pop_date
		DATE NOT NULL,
	pop_slice -- 255 slices allows us to add a slice every 6m (if we want to)
		TINYINT UNSIGNED NOT NULL,
	id
		INT UNSIGNED NOT NULL
		REFERENCES Posts.Post(id),
	total
		INT SIGNED NOT NULL,

	PRIMARY KEY(pop_date, pop_slice, id)
);

CREATE INDEX IX_BySlice
	ON Posts.PopularityCache(pop_date, pop_slice);

