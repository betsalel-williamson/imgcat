<script lang='ts'>
	import type { ActionData } from './$types';
	import { enhance } from '$app/forms';

	export let form: ActionData;
</script>

<h2>Log In</h2>
<form method="POST" use:enhance={() => {
		return async ({ update }) => {
			return await update({reset:false});
		};
	}}>

	<label for='email'>Email or Username</label>
	{#if form?.email}
	<input type='text' name='email' required placeholder='user@example.com' value={form?.email ?? ''}/>
	{:else}
	<input type='text' name='email' required placeholder='user@example.com'/>
	{/if}

	<label for='password'>Password</label>
	<input type='password' name='password' required />

	{#if form?.success === false}
	<p style="color:red">{form?.message}</p>
	{/if}
	<a href="/signup">Create an account</a>
	<button type='submit'>Login</button>
</form>

<style>
	form {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		width: 300px;
		
		* {	
			margin-top: 15px;
		}

		label,p {
			
			grid-column-start: 1;
  			grid-column-end: 4;
		}

		input {
			margin-top: 0px;
			grid-column-start: 1;
  			grid-column-end: 4;
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