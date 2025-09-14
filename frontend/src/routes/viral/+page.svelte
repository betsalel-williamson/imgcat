<script lang="ts">
	import PostThumb from '$lib/PostThumb.svelte';

	let data = $props();
	let post_promise = data.data['posts'];
</script>

<h1>Viral posts</h1>
<p>DEV NOTE: Viral is the algorithm page, customized by users</p>
<p>Every few minutes, we'll loop through most-recent, and select popular posts to be viral. It is a sliding scale, and we'll play with the thresholds. Then, based on a user's content settings, we'll show barely/heavily-viral posts.</p>
<p>Every hour or so, we'll loop through viral posts, select the most popular ones, and those will go onto the homepage.</p>

{#await post_promise then posts}
	{#each posts as post}
	<PostThumb {post} />
	{/each}
{:catch}
<p>There was an error displaying posts</p>
{/await}