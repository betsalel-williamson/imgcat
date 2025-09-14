<script lang='ts'>
	import Button from '$lib/Button.svelte';

	const {
		post,
		user_id
	} = $props();

	const ratings = {
		'kid': 5,
		'std': 4,
		'sxy': 0,
		'xxx': 0,
		'ill': 0
	};

	function rating(e) {
		const v = e.currentTarget.value;
		console.log(e);
		console.log(v);
	}
	function category(e) {
		const v = e.currentTarget.value;
		console.log(e);
		console.log(v);
	}
	

</script>

<div id='modbox'>
	<div id='anon'>
		<label style='color:#F00'>without an account...</label>
		<Button lbl='Flag for moderators' />
		<Button lbl='Report illegal content' />
	</div>
	<hr />
	<div id='user'>
		<label style='color:#F00'>as a user...</label>
		<Button lbl='Hide this post' />
		<Button lbl='Block this user' />
		<Button lbl='Flag for moderators' />
		<Button lbl='Report illegal content' />
	</div>
	<hr />
	<label style='color:#F00'>as a mod...</label>
	<div id='rating'>
		<label>Content Rating</label>
		<Button class='sel' value='kid' lbl='Kid-friendly ({ratings['kid']})' img='/content_g.svg' onclick={rating} />
		<Button value='std' lbl='Normal ({ratings['std']})' img='/content_std.svg' onclick={rating} />
		<Button value='sxy' lbl='Lewd or suggestive ({ratings['sxy']})' img='/content_r.svg' onclick={rating} />
		<Button value='xxx' lbl='Not safe for work ({ratings['xxx']})' img='/content_x.svg' onclick={rating} />
		<Button value='ill' lbl='Illegal ({ratings['ill']})' img='/content_illegal.svg' onclick={rating} />
	</div>
	<div id='category'>
		<label>Category Filters</label>
		<Button lbl='Politics' img='/politics.svg' onclick={(e)=>category(e,'politics')} />
		<Button lbl='News' img='/news.svg' onclick={(e)=>category(e,'news')} />
		<Button lbl='Creator content' img='/artist.svg' onclick={(e)=>category(e,'self')} />
		<Button lbl='AI generated' img='/robot.svg' onclick={(e)=>category(e,'ai')} />
		<Button lbl='Low quality' img='/trash.svg' onclick={(e)=>category(e,'ai')} />
	</div>
	<div id='tags'>
		<label>Tags</label>
		<Button lbl='science' />
		<Button lbl='space' />
		<Button lbl='black holes' />
		<br />
		<input />
		<Button lbl='add' />
	</div>
</div>

<style>
	div#modbox {
		border: 1px solid black;
		padding: 1em;
		margin: 1em 0em;
	}
	div#anon,div#user,div#rating,div#category,div#tags {
		label {
			margin: 0.5em 0px;
			display: block;
			width: 200px;
		}
	}

</style>