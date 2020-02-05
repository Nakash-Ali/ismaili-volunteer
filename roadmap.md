# Roadmap

## Internationalization

For running OTS in multiple countries (Canada, US, UK, etc...), we will not enforce multi-tenancy at the database or database-schema level. Instead, we'll use regions to enforce it at the row-level.

1. Subdomain with top-level dropdown scopes all data to a particular root region.
1. All queries are manually told to handle this region.
  - Listing::index
  - API.Listing::index
  - Admin.Listing::index
  - Admin.Regions::index
  - Admin.Groups::index
  - Admin.Users::index - what do we do about this one?
1. Queries for objects that belong to a different region are redirected. For example, visiting https://uk.ots.ismaili/listings/72 redirects you to https://kenya.ots.ismaili/listings/72 (because listing #:72 is part of Kenya, and not the UK)
  - Initially, to make implementation easier, we will return NotFound instead of the redirect.

## Trade-offs

Problems with column-level multi-tenancy:
- Larger chance of programming error to reveal another tenant's data
- Will need some permissions to prevent users in one country creating listings in another

Problems with database-schema level multi-tenancy:
- Users will need logins for each country's website
- Migrations will need to be run for all tenants
- Expiry reminders will need to be run for all tenants
- Can't query data across tenants
  - We could use Postgres Views to query across schemas
  - IDs will conflict across schemas, will need to move to binary_id maybe?


If a country doesn't have official email addresses, we'll need to implement permissions to create listings regardless. If we go with column-level, we'll have to scope those permissions to a particular country.

**If a country doesn't have official email addresses**, there's a large amount of work we'll need to do to support them. It will take longer.

## Authentication

To better support the international future of this project, we need an authentication system, with the following features:
- Login/logout
- Sign up
- MFA
- Email confirmation
- Forget password

Instead of implementing this ourselves, we're going to use Azure's AD B2C system. It's cost effective, well made, and quite popular. We looked at Google's Identity Service, AWS Cognito, Auth0, and other open-source providers (Gluu, Keycloak), but decided that this is the best option.
