DELIMITER $$
CREATE OR REPLACE FUNCTION Posts.GetFilename()
RETURNS CHAR(12)
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
BEGIN
	-- BINARY(9) is too large for bit-operators, so I have to do this in chunks
	-- And even then, half my effort is just working around automatic casts
	-- Seriously, FUCK this shit-ass database...
	-- 0: random byte
	-- 1: timestamp[3]
	-- 2: Seq[0]
	-- 3: timestamp[2]
	-- 4: random byte
	-- 5: timestamp[1]
	-- 6: Seq[1]
	-- 7: timestamp[0]
	-- 8: random byte

	DECLARE r0 INT DEFAULT 0;
	DECLARE r1 INT DEFAULT 0;
	DECLARE r2 INT DEFAULT 0;

	DECLARE ts INT DEFAULT 0;
	DECLARE sq INT DEFAULT 0;

	SET ts = UNIX_TIMESTAMP();
	SET sq = NEXTVAL(Posts.SeqFilename);

	SET r0 = CAST(FLOOR(RAND()*256) AS INT) << 16
	       | CAST(ts & 0x000000FF   AS INT) << 8
	       | CAST(sq & 0x0000FF00   AS INT) >> 8;
	SET r1 = CAST(ts & 0x0000FF00   AS INT) << 8
	       | CAST(FLOOR(RAND()*256) AS INT) << 8
	       | CAST(ts & 0x00FF0000   AS INT) >> 16;
	SET r2 = CAST(sq & 0x000000FF   AS INT) << 16
	       | CAST(ts & 0xFF000000   AS INT) >> 16
	       | CAST(FLOOR(RAND()*256) AS INT);

	-- Do Base64Url, b/c works better with filenames/paths
	RETURN REPLACE(REPLACE(CONCAT(
		TO_BASE64(UNHEX(HEX(r0))),
		TO_BASE64(UNHEX(HEX(r1))),
		TO_BASE64(UNHEX(HEX(r2)))
	), '+', '-'), '/', '_');

END
$$
DELIMITER ;