<script lang='ts'>
	import Comment from '$lib/Comment.svelte';
	import { getPostComments } from '$lib/CommentBox.remote.ts';

	const { post, user_id } = $props();
	let comments = [];
	if(user_id && post.is_public) {
		comments = getPostComments(post.id);
		comments.then((c)=>{
			//console.log(c);
		})
	}
	
</script>

{#if user_id && post.is_public}
<form method='POST' action='/view/{post.id}?/comment'>
	<label for='comment'>Post a comment:</label>
	<textarea name='comment' rows=4 maxlength=255 ></textarea>
	<input type='submit' value='Post' />
</form>
{/if}

{#await comments then {root, nested} }
	{#each root as c}
		<!-- TODO: This only handles a single layer, not a nested chain -->
		{#if c.id in nested}
			<Comment post_id={post.id} {user_id} comment={c} nested={nested[c.id]} />
		{:else}
			<Comment post_id={post.id} {user_id} comment={c} />
		{/if}
	{/each}
{:catch}
	<p>There was an error loading comments</p>
{/await}

<style>
	label {
		display: block;
	}
	textarea {
		width: 100%;
		min-width: 300px;
		max-width: 800px;
	}
	input {
		margin-bottom: 20px;
	}
</style>