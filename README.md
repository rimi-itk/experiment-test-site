# itkdev-test-site

A pragmatic solution to easily deploy test sites utilizing `itkdev-docker-compose-server`[^1].

[^1]: If you don't have a real `itkdev-docker-compose-server` setup on your server, you can use
      [bin/itkdev-docker-compose-server](bin/itkdev-docker-compose-server) as a drop-in replacement (with only the basis
      functionality need for test site deployment).

A test site is deployed by specifying a Git repository URL and a branch name, e.g.

``` shell
itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
```

and then, if everything goes according to plan, a fresh test site is avaliable. See [Usage](#usage) for further details
on the `itkdev-test-site` command.

## Installation

0. [Install Task](https://taskfile.dev/docs/installation) if not already installed
1. Get the code:

   ``` shell
   git clone https://github.com/rimi-itk/experiment-test-site
   ```

2. Add the `./experiment-test-site/bin/itkdev-test-site` to your `PATH` variable (or
   [symlink](https://en.wikipedia.org/wiki/Symbolic_link) it from a directory already your `PATH`).
3. Set the test site base domain by running

   ``` shell
   itkdev-test-site config set site_base_domain «domain»
   ```

   (replace `«domain»` with a real domain, e.g. `test.example.com`)

> [!NOTE]
> A [Wildcard DNS record](https://en.wikipedia.org/wiki/Wildcard_DNS_record) should be set up for all sub-domains of the
> value of `site_base_domain`, e.g. `*.test.example.com`.

Run

``` shell
itkdev-test-site config show
```

to see the full configuration of `itkdev-test-site`'.

## Usage

Deploy a test site with

``` shell
itkdev-test-site deploy «repository URL» «branch»
```

Run

``` shell
itkdev-test-site
```

to see details on how to use `itkdev-test-site`.

## Requirements and assumptions

A test site, i.e. the Git repository, must contain a [Taskfile](https://taskfile.dev/) with two tasks,
`test-site:install` and `test-site:update`, plus a [(Docker) Compose
file](https://docs.docker.com/reference/compose-file/) called `docker-compose.server.test.yml` (or whatever the
`compose_files` configuration value specifies). The two tasks _must_ use `itkdev-docker-compose-server` (the configuration
value `compose_command`) to run any compose commands.

Furthermore, the site must not depend on services that are not defined in the compose file, i.e. no external databases
and such stuff.

See <https://github.com/rimi-itk/experiment-test-site/tree/feature/drupal-admin-theme> for an example.

## Technical details

### Deployment

When running

``` shell
itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
```

say, `itkdev-test-site` does the following:

1. Clones the specified branch of the Git repository into a (hopefully) uniquely named directory in the site base
   directory (the configuration value `site_base_dir`)
2. Generates a `.env.docker.local` (the configuration value `compose_command_config_filename`) file in the site directory,
   e.g

   ``` shell
   COMPOSE_PROJECT_NAME=rimi-itk-experiment-test-91fe1ad6f222bdbe
   COMPOSE_SERVER_DOMAIN=rimi-itk-experiment-test-site--feature-drupal-admin-theme.test.example.com

   COMPOSE_FILES=docker-compose.server.test.yml
   ```

3. Runs `task test-site:install` (or `task test-site:update` if the test site already exists) in the site directory

### Removal

When running

``` shell
itkdev-test-site remove /home/deploy/itkdev/test-sites/rimi-itk-experiment-test-site--feature-drupal-admin-theme
```

say, `itkdev-test-site` does the following:

1. Runs

   ``` shell
   itkdev-docker-compose-server down down --remove-orphans --volumes
   ```

   in the site directory
2. Deletes the site directory

## Example test sites

* <https://github.com/rimi-itk/experiment-test-site/tree/test-site/html>

  ``` shell
  itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site test-site/html
  ```

* <https://github.com/rimi-itk/experiment-test-site/tree/drupal>

  ``` shell
  itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site drupal
  ```

* <https://github.com/rimi-itk/experiment-test-site/tree/drupal-II>

  ``` shell
  itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site drupal-II
  ```

* <https://github.com/rimi-itk/experiment-test-site/tree/feature/drupal-admin-theme>

  ``` shell
  itkdev-test-site deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
  ```

## Development

During development (of `itkdev-test-site` or a test site), you can deploy a branch from a local repository by
using a file path as repository URL, e.g.

``` shell
itkdev-test-site deploy . test-site/html
```

Deploy the current branch by running

``` shell
itkdev-test-site deploy . $(git rev-parse --abbrev-ref HEAD)
```
