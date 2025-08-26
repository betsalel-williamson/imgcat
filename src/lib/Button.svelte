<script lang='ts'>
	import type { ClassValue } from 'svelte/elements';
	import { error } from '@sveltejs/kit';

	const {
		// Core (required) props:
		lbl,
		img,
		onclick = $bindable(),

		// HTML props:
		id = null,
		class: classes = null,
		title = null,
		name = null,
		value = null,
		style = null

		// Color props:
		// --bkg='#ABCDEF'
		// --bdr='#ABCDEF'

		// Color props (if class='sel')
		// --bkg-sel='#ABCDEF'
		// --bdr-sel='#ABCDEF'

	} = $props();

	if(!lbl&&!img) {
		error(500, '<Button> must have either lbl or img');
	}

</script>

<button {id} class={classes} {onclick} {title} {name} {value} {style}>
	{#if img}
	<img src="{img}" alt='{lbl}'/>
	{/if}
	{#if lbl}
	<span>{lbl}</span>
	{/if}
</button>

<style>
	button {
		display: inline-block;
		padding: 5px 10px;
		border: 1px solid var(--bdr, black);
		border-radius: 10px;
		background-color: var(--bkg, var(--cbk1));
		cursor: pointer;
		margin-right: 5px;
	}
	button.sel {
		background-color: var(--bkg-sel, var(--cbk2));
		border-color: var(--bdr-sel, var(--bdr, black));
	}
	img {
		margin-right: 5px;
		vertical-align: middle;
	}
	span {

	}
</style>