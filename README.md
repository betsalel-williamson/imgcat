# ImgCat

ImgCat is an open-source, meme-sharing community focused on users!

Our core principles:
*   **Data privacy:** We apply EU-level privacy to all users.
*   **Simple feeds:** We use votes & views, not engagement models.
*   **Content controls:** Users decide the content they want to see.
*   **Moderation:** Users have powerful tools to shape their community.

Open-sourcing our code is an important step in building trust with the community


## Documentation

*   [About the project](./docs/about.md)
*   [Development Resources](./docs/development-resources.md)
*   [Frequently Asked Questions](./docs/faqs.md)
*   [Funding Model](./docs/funding-model.md)
*   [Code of Conduct](./CODE_OF_CONDUCT.md)


## Docker build

Instructions for installing and running locally with Docker are contained in [BUILD.md](./BUILD.md)

## Quick Build Setup
1. Install MariaDB, Node, and setup an S3 cloud provider
2. Follow /mariadb_scripts/readme.txt
	* NOTE: init_users.sql must be manually edited, to add passwords
3. Use TEMPLATE.env as a baseline
4. Add both FE users to the .env file
5. Setup certs for JWT validation, add path to .env
	* openssl genpkey -algorithm ed25519 -out id_jwtsign.pvt
	* openssl pkey -in id_jwtsign.pvt -pubout -out id_jwtsign.pub
6. Add S3 credentials to .env file
7. Run "npm run dev"


## Contributions

> [!NOTE]
> While we do accept contributions, we prioritize high quality issues and pull requests. Adhering to the below guidelines will ensure a more timely review.

**Rules:**

- We may not respond to your issue or PR.
- We may close an issue or PR without much feedback.
- We may lock discussions or contributions if our attention is getting DDOSed.
- We're not going to provide support for build issues.

**Guidelines:**

- Check for existing issues before filing a new one please.
- Open an issue and give some time for discussion before submitting a PR.
- Stay away from PRs like...
  - Refactoring the codebase, e.g., to replace Svelte with another framework.
  - Adding entirely new features without prior discussion.

Remember, we serve a wide community of users. Our day-to-day involves us constantly asking "which top priority is our top priority." If you submit well-written PRs that solve problems concisely, that's an awesome contribution. Otherwise, as much as we'd love to accept your ideas and contributions, we really don't have the bandwidth. That's what forking is for!

## Forking guidelines

You have our blessing 🪄✨ to fork this application! However, it's very important to be clear to users when you're giving them a fork.

Please be sure to:

- Change all branding in the repository and UI to clearly differentiate from ImgCat.
- Change any support links (feedback, email, terms of service, etc) to your own systems.
- Replace any analytics or error-collection systems with your own so we don't get super confused.

## Security disclosures

PLACEHOLDER POLICY

<!-- If you discover any security issues, please send an email to a designated security contact (e.g., foo@example.com or open an issue). The email is automatically CC'd to the entire team and we'll respond promptly. -->

## License (MIT)

See [./LICENSE](./LICENSE) for the full license.

## P.S.

We ❤️ you and all of the ways you support us. Thank you for making ImgCat a great place!
