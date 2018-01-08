# Volunteer

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Required Files

### Develop

- `~/.ssh/id_rsa`
- `~/.ssh/id_rsa/pub`

### Deploy to Production

- `./config/prod.secret.exs`

### SSH Config

To allow `edeliver` to connect to your local vagrant box, and the remote production host, ensure that the SSH configs defined in `./ops/ssh/iicanada` are included in your `~/.ssh/config` file.

To do so automatically, from the project's folder, run

```
./ops/ssh_install.sh
```

## Operations

### Changing NGINX configs

Anytime you make and deploy a change to NGINX, letsencrypt's cert pragmas will be wiped. You must `ssh` onto the server and regenerate those lines by running:

```shell
sudo certbot --nginx
```
