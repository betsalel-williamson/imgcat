<script lang="ts">
	let { logged_in	} = $props();
</script>

<nav><div id="l">
	<img src="/cat.svg" alt="Welcome to ImgCat" fetchpriority="high"/>	
</div><div id="m">
	<a href="/home"><img src="/home.svg" alt="Home"/></a>
	<a href="/viral"><img src="/viral.svg" alt="Viral posts"/></a>
	{#if logged_in}
	<a href="/recent"><img src="/recent.svg" alt="Recent posts"/></a>
	
	{/if}
	<input type="search" placeholder="Search for #tags and @users"/>
	{#if logged_in}
	<a href="/post"><img src="/post.svg" height="42px" alt="Upload and post an image"/></a>
	<!--<a href="/meme"><img src="/meme.svg" height="42px" alt="Build a meme"/></a>-->
	{/if}
</div><div id="r">
	{#if logged_in}
	<!--<a href="/chat"><img src="/chat.svg" height="42px" alt="Chat"/></a>-->
	<a href="/myfavs"><img src="/myfavs.svg" alt="My favorites"/></a>
	<a href="/myposts"><img src="/myposts.svg" alt="My posts"/></a>
	<a href="/profile"><img src="/profile.svg" height="42px" alt="Profile"/></a>
	{:else}
	<a href="/login"><img src="/profile.svg" height="42px" alt="Log in"/></a>
	{/if}
</div></nav>

<style>
	nav {
		position: sticky;
		top: 0px;
		background-color: var(--cbk1)/*#EEE*/;

		display: grid;
		grid-template-columns: repeat(5, 1fr);

		div#m img,div#r img {
			filter: brightness(0) saturate(100%) invert(12%) sepia(18%) saturate(5938%) hue-rotate(224deg) brightness(92%) contrast(95%);
		}

		div#l, div#m, div#r {
			display: flex;
		}

		div#l {
			grid-column-start: 1;
			grid-column-end: 2;
			justify-content: left;

			img {
				height: 75px;
			}
		}
		div#m {
			grid-column-start: 2;
			grid-column-end: 5;
			justify-content: left;
		}
		div#r {
			grid-column-start: 5;
			grid-column-end: 6;
			justify-content: right;
		}

		div {
			* {
				display: inline-block;
				height: 48px;
				margin: auto 0px;
			}
			a {
				padding: 10px;
			}
			input {
				padding: 5px 10px;
				width: 400px;
			}
			img {
				vertical-align: middle;
			}
		}
	}
</style>