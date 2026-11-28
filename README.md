# Campus Hub

## Deploy to Render

1. Push this repository to GitHub.
2. In Render, create a Blueprint and select this repository. Render reads
   `render.yaml` to create the Flutter web site, Django API, and PostgreSQL
   database.
3. Wait for the API and web build/deploy to finish, then open the web service's
   `onrender.com` URL.

The Blueprint uses Render's free plans. The API may sleep between requests, and
the free PostgreSQL database has retention and availability limits. Move to a
persistent database plan before using this for production data.
