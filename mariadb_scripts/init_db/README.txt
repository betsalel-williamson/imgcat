You must generate passwords for the accounts in this file.
These passwords will go into the .env files for the app.

We use the following line to generate it:
SELECT TO_BASE64(RANDOM_BYTES(32));
