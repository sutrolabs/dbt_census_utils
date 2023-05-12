<p align="center">
    <a alt="License"
        href="https://github.com/census/dbt_census_utils/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Census Utils dbt Package ([Docs](https://sutrolabs.github.io/dbt_census_utils/#!/overview/census_utils))
# 🎁 What does this dbt package do?
- Adds a number of macros that are useful when transforming data to be synced via reverse ETL (with Census or your own pipelines).
- Adds documentation for the macros at: [dbt docs site](https://sutrolabs.github.io/dbt_census_utils/#!/overview/census_utils).

# 👩‍💻 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- A **BigQuery**, **Snowflake**, or **Redshift** data warehouse.

## Step 2: Install the package
Include the following census_utils package version in your `packages.yml` file, then run 'dbt deps':
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: census/census_utils
    version: [">=1.0.0", "<2.0.0"]

```

## Step 3: Run dbt seed
This package uses seeds for macros such as converting country codes to country names.  Run 'dbt seed' after 'dbt deps' to materialize these seeds in your data warehouse.

## (Optional) Step 4: Define internal user variables
The [is_internal macro (<a href="macros/is_internal.sql">source</a>)](#is_internal-source) identifies internal users based off of several potential methods: their email address domain, an existing list of email addresses, or an existing list of IP Addresses. If you want to use the `is_internal` macro, you'll need to specify at least one of these approaches. Add variables to your root `dbt_project.yml` file to reflect the domain of your company and the relations and columns where internal users are tracked.  These relations can be a dbt seed or a dbt model. Common methods of maintaining this relation include: a seed file of internal users and IP address, a dbt model that identifies internal users directly from your application database, or a dbt model referencing a Google Sheet of internal users.  For example, if your company used the domains sawtelleanalytics.com and sawtelleanalytics.co.uk, and you have a dbt seed called 'my_internal_users' with an email_address column for the emails of internal users and an ip_address column for the IPs of internal users, you would add this to your vars:

```yml
vars:
  internal_domain: ('sawtelleanalytics.com', 'sawtelleanalytics.co.uk')
  internal_email_relation: 'my_internal_users'
  internal_email_column: 'email_address'
  internal_ip_relation: 'my_internal_users'
  internal_ip_column: 'ip_address'
```

## (Optional) Step 5: Sync your dbt models to destinations with Census
<details><summary>Expand for details</summary>
<br>
    
Census lets you sync your dbt models to destinations such as Salesforce, Hubspot, Zendesk, Facebook, and Google.  Learn how to [sync your data](https://www.getcensus.com/demo).
</details>

# List of macros:
* [parse_ga4_client_id (<a href="macros/parse_ga4_client_id.sql">source</a>)](#parse_ga4_client_id-source)
* [clean_name (<a href="macros/clean_name.sql">source</a>)](#clean_name-source)
* [is_internal (<a href="macros/is_internal.sql">source</a>)](#is_internal-source)
* [extract_email_domain (<a href="macros/extract_email_domain.sql">source</a>)](#extract_email_domain-source)
* [is_personal_email (<a href="macros/is_personal_email.sql">source</a>)](#is_personal_email-source)
* [get_country_code (<a href="macros/get_country_code.sql">source</a>)](#get_country_code-source)



## parse_ga4_client_id ([source](macros/parse_ga4_client_id.sql))

This macro takes a Google Analytics 4 client ID and returns either the unique ID part, the timestamp part, or the entire ID without any 'GA1.2' type prefix before it.

**Args:**

- `client_id` (required):  The raw GA 4 client ID to parse.
- `extract_value` (required): Specifies what to extract from the raw client ID.  Should be either 'unique_id', 'timestamp', or 'client_id'.

**Usage:**

```sql
select 
    ga4_client_id,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'unique_id') }} as unique_id,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'timestamp') }} as timestamp,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'client_id') }} as client_id
from ga4_client
```

## clean_name ([source](macros/clean_name.sql))

This macro cleans names so that they will be accepted by APIs such as Facebook or Google.

**Args:**

- `name` (required):  The name to be cleaned.
- `type` (required): The destination to clean the name for, such as 'facebook'.

**Usage:**

```sql
select 
    {{ census_utils.clean_name(city_name, 'facebook') }} as cleaned_city_name
```

## is_internal ([source](macros/is_internal.sql))

This macro reports whether a user is an internal user based on their email domain, email address, or IP address.  Relies on at least one variable being set in [dbt_project.yml](https://github.com/sutrolabs/dbt_census_utils#optional-step-4-define-internal-user-variables).

**Args:**

- `email` (optional):  The email address of the user.
- `ip_address` (optional): The IP address of the user.

**Usage:**

```sql
select 
    email_address
    , ip_address
    , {{ census_utils.is_internal(email='email_address',ip_address='ip_address') }} as is_internal_user
    , {{ census_utils.is_internal(email='email_address') }} as is_internal_email
    , {{ census_utils.is_internal(ip_address='ip_address') }} as is_internal_ip
from
    users
```

## extract_email_domain ([source](macros/extract_email_domain.sql))

This macro extracts the domain from an email address.

**Args:**

- `email` (required):  The email address of the user.

**Usage:**

```sql
select 
    email_address,
    {{ census_utils.extract_email_domain('email_addresses') }} as email_domain
```

## is_personal_email ([source](macros/is_personal_email.sql))

This macro determines whether an email address is personal, based on a list of common personal email domains.

**Args:**

- `email` (required):  The email address of the user.

**Usage:**

```sql
select 
    email_address,
    {{ census_utils.is_personal_email('email_addresses') }} as is_personal_email
```

## get_country_code ([source](macros/get_country_code.sql))

This macro converts a country name to a [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code.
**Args:**

- `country_name` (required):  The country name to be converted to a code.

**Usage:**

```sql
select 
    c.country_name,
    {{ census_utils.get_country_code('country_name') }} as country_code
```

# 🎢 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: dbt-labs/dbt_utils
      version: [">=.9.0", "<2.0.0"]
```
# 🤝 How is this package maintained and can I contribute?
## Package Maintenance
The Census team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/census/census_utils/) of the package and refer to the changelog and release notes for more information on changes across versions.

## Contributions
We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🧭 How can I get help or make suggestions?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/sutrolabs/dbt_census_utils/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Census or would like to request a new dbt package, please join the [Operational Analytics Slack](https://www.operationalanalytics.club/).
