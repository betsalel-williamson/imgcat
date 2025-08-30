#!/bin/sh

# Create the schemas we'll need
cat init/init_db.sql

# Load the tables in dependency order
cat init/userdb.tables.sql     # dep: n/a
cat init/posts.tables.sql      # dep: userdb
cat init/comments.tables.sql   # dep: posts
cat init/fpcache.tables.sql    # dep: posts
cat init/favorites.tables.sql  # dep: posts
cat init/actions.tables.sql    # dep: favorites

# this should be a 'cat every remaining file in /init'
# Order doesn't matter. SPs are checked at runtime, not creation
cat init/Actions.CreateFavFolder.sql
cat init/Actions.GetFavFolders.sql
cat init/Actions.IsFavMedia.sql
cat init/Actions.IsFavPost.sql
cat init/Actions.RenameFavFolder.sql
cat init/Actions.ToggleFavMedia.sql
cat init/Actions.ToggleFavPost.sql
cat init/Comments.GetPostComments.sql
cat init/Posts.CalcVVCache.sql
cat init/Posts.CreateComment.sql
cat init/Posts.CreateSimpleMedia.sql
cat init/Posts.CreateSimplePost.sql
cat init/Posts.GetFilename.sql
cat init/Posts.GetHomePage.sql
cat init/Posts.GetMediaIdIfExists.sql
cat init/Posts.GetMyFavs.sql
cat init/Posts.GetMyPosts.sql
cat init/Posts.GetMyVote.sql
cat init/Posts.GetPost.sql
cat init/Posts.GetRecentPage.sql
cat init/Posts.GetViewVotes.sql
cat init/Posts.GetViralPage.sql
cat init/Posts.SeqFilename.sql
cat init/Posts.SetPostPublic.sql
cat init/Posts.SetView.sql
cat init/Posts.SetVote.sql
cat init/UserDB.CreateAccount.sql
cat init/UserDB.GetLoginData.sql
cat init/UserDB.GetLoginId.sql
cat init/UserDB.IsUserNameFree.sql
