# Frequently Asked Questions (FAQs)

### What is the current tech stack?

*   **Frontend:** Svelte and SvelteKit, running on Node.JS. Most of the compute and logic runs on the server, not the browser. It will be more efficient on mobile.
*   **Middleware:** Almost non-existent. Async functions on the server call pre-defined, parameterized stored procedures. Nothing has permission to run raw SQL outside specific Stored Procs. This requires upfront planning, but is very fast & secure.
*   **Backend:** MariaDB, with several, independent, segmented security roles. A data breach in one area cannot impact the others.
    *   Access user accounts, allowing logins and JWT auth refreshes.
    *   Handle all posts, comments, views, etc.
    *   Manage moderation & compliance.
    *   Run various administrative systems.
*   **Image Storage:** The Cloudflare CDN. They handle all storage & delivery. This leaves my servers to handle mostly text: post metadata, comments, and actions performed.
*   **Hosting (test):** The test site is a cloud webhost, running a FreeBSD Jail platform. They charge for compute used, not reserved capacity, which makes it perfect for infrequent burst usage, like a test server.

### What will the tech stack look like in the future?

*   **CDN:** Initially, the CDN will serve full-sized images. This is undesirable, especially on mobile. We have plans to apply transformations and resize thumbnails to reduce data, without compressing the original.
*   **Database:** MariaDB is the right tool for getting this project moving quickly. But when ImgCat scales up, it will not be the right tool for scalability. Therefore, we'll swap it out with a web-scale instance of PostgreSQL.
*   **Hosting (production):** The test webhost can automatically scale memory & compute to dozens of cores, as needed, but is ultimately limited to a single physical server. The production site will be deployed to some (TBD) cloud provider.
*   **Caching:** StoredProcs are fast, but lots of little operations slow the system down. Redis will cache operations such as post views, vote totals, and viral/homepage posts.
*   **Message Queues:** StoredProcs can still become overwhelmed. Message queues will allow users to keep using the site, while the system catches up.
*   **Moderation Tools:** Mods will have a variety of tools, like image-recognition and sentiment-analysis, to help flag trolls & bad-actors as soon as possible.

### Are you going to have dark mode?

Yes. The way we manage colors will allow for multiple themes, localization, and give folks with various forms of color blindness a better experience. But functionality will be prioritized first.

### Are you going to support non-ASCII alphabets?

Yes. Sí. Oui. Ja. Kyllä. Так. Ναι. Evet. نعم. हाँ. 是. はい. 예. Có. Yebo. Bẹẹni. And many other languages.

### This sounds like a lot of work, what's the scale required for this?

About two and a half bananas.