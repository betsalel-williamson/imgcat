<script lang='ts'>
	// NOTE: nested is a dict: {comment_id:[comment, ...]}
	// TODO: This only works one level deep, but 
	const { comment, nested, post_id, user_id } = $props();
	//const my_nested = nested[comment.id];
	//console.log(my_nested);

	let reply_here = $state(false);
	let is_collapsed = $state(true);

</script>

{#snippet comment_block(c)}
	<p>{c.username} - {c.time}</p>
	<span>{c.comment}</span>
{/snippet}

{#snippet reply_block(reply_to)}
	{#if user_id}
		<div class='block'>
		{#if reply_here}
			<!-- TODO: Strip this out into its own control, so CommentBox & Comment can have a common control & codebase, using remote functions. -->
			<button onclick={()=>{reply_here=false}}>Cancel</button>
			<form method='POST' action='/view/{post_id}?/comment'>
				<label for='comment'>Post a comment:</label>
				<textarea name='comment' rows=4 maxlength=255 ></textarea>
				<input type='hidden' name='reply_to' value='{reply_to}' />
				<input type='submit' value='Post' />
			</form>
		{:else}
			<button onclick={()=>{reply_here=true}}>Reply</button>
		{/if}
		</div>
	{/if}
{/snippet}

<div class='cmt'>
	{@render comment_block(comment)}

	{#if nested}
		<div class='block'>
		{#if is_collapsed}
			<button onclick={()=>{is_collapsed=false}}>Show {nested.length} replies</button>
		{:else}
			<button onclick={()=>{is_collapsed=true}}>Hide replies</button>
			<div class='cmt' style='margin-left:10px'>
			{#each nested as c}
				{@render comment_block(c)}
			{/each}
			{@render reply_block(comment.id)}
			</div>
		{/if}
		</div>
	{:else}
		{@render reply_block(comment.id)}
	{/if}
</div>

<style>
	div.block {
		margin-top: 1em;
	}
	div.cmt {
		background-color: var(--cbk1);
		margin: 5px 0px;
		padding: 5px 10px;

		p {
			color: var(--cbk4);
		}

		span {
			margin: 10px 0px 0px 0px;
		}

		button {
			display: block;
		}
	}
</style>