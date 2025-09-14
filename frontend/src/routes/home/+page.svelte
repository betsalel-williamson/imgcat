<script lang="ts">
	import PostThumb from '$lib/PostThumb.svelte';

	let data = $props();
	let post_promise = data.data['posts'];
	//post_promise.then((d)=>{
	//	console.log(d);
	//});
</script>

<h1>Homepage</h1>

{#await post_promise then posts}
	{#each posts as post}
	<PostThumb {post} />
	{/each}
{:catch}
<p>There was an error displaying posts</p>
{/await}