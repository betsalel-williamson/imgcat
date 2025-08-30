CREATE USER imgcat_jwt
IDENTIFIED BY <password here>
WITH
	MAX_STATEMENT_TIME 1;

CREATE USER imgcat_posts
IDENTIFIED BY <password here>
WITH
	MAX_STATEMENT_TIME 5;

CREATE USER imgcat_mods
IDENTIFIED BY <password here>
WITH
	MAX_STATEMENT_TIME 5;

CREATE USER imgcat_system
IDENTIFIED BY <password here>
WITH
	MAX_STATEMENT_TIME 5;



GRANT EXECUTE ON PROCEDURE Actions.CreateFavFolder TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.GetFavFolders TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.IsFavMedia TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.IsFavPost TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.RenameFavFolder TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.ToggleFavMedia TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Actions.ToggleFavPost TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Comments.GetPostComments TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.CalcVVCache TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.CreateComment TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.CreateSimpleMedia TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.CreateSimplePost TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetFilename TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetHomePage TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetMediaIdIfExists TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetMyFavs TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetMyPosts TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetMyVote TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetPost TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetRecentPage TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetViewVotes TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.GetViralPage TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.SeqFilename TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.SetPostPublic TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.SetView TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE Posts.SetVote TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE UserDB.CreateAccount TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE UserDB.GetLoginData TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE UserDB.GetLoginId TO imgcat_posts;
GRANT EXECUTE ON PROCEDURE UserDB.IsUserNameFree TO imgcat_posts;