<script lang='ts'>
	import type { ActionData } from './$types';
	import { enhance } from '$app/forms';
	import { GetCountryCodes } from '$lib/country_codes.ts';

	export let form: ActionData;
</script>

<h2>Signup</h2>
<form method="POST" use:enhance={() => {
		return async ({ update }) => {
			return await update({reset:false});
		};
	}}>

	<label for='email'>Email</label>
	<input type='text' name='email' required placeholder='user@example.com' value={form?.email || ''}/>

	<label for='username'>Username</label>
	<input type='text' name='username' required value={form?.username || ''}/>

	<label style="grid-column-start:1;grid-column-end:3" for='country'>Country</label>
	<label style="grid-column-start:3;grid-column-end:4" for='age'>Age</label>
	<select style="grid-column-start:1;grid-column-end:3" type='text' name='country' required value={form?.country || 'US'}>
		<option></option>
		{#each GetCountryCodes() as {k, v} }
		<option value="{v}">{k}</option>
		{/each}
	</select>
	<input style="grid-column-start:3;grid-column-end:4" type='number' name='age' required value={form?.age} />

	<label for='password'>Password</label>
	<input type='password' name='password' required />

	{#if form?.success === false}
	<p style="color:red">{form?.message}</p>
	{/if}
	
	<a href="/login">I have an account</a>
	<button type='submit'>Signup</button>
</form>

<style>
	form {
		display: grid;
		grid-template-columns: repeat(3, 100px);
		width: 300px;
		
		* {	
			margin-top: 15px;
		}

		label {
			
			grid-column-start: 1;
  			grid-column-end: 4;
		}

		input {
			margin-top: 0px;
			grid-column-start: 1;
  			grid-column-end: 4;
		}
		select {
			margin-top: 0px;
		}

		a {
			grid-column-start: 1;
  			grid-column-end: 3;
		}

		button {
			grid-column-start: 3;
  			grid-column-end: 4;
		}
	}
</style>