# itkdev-test-site-deploy

A pragmatic solution to easily deploy test sites utilizing `itkdev-docker-compose-server`[^1].

[^1]: If you don't have a real `itkdev-docker-compose-server` setup on your server, you can use
      [bin/itkdev-docker-compose-server](bin/itkdev-docker-compose-server) as a drop-in replacement (with only the basis
      functionality need for test site deployment).

A test site is deployed by specifying a Git repository URL and a branch name, e.g.

``` shell
itkdev-test-site-deploy deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
```

and then, if everything goes according to plan, a fresh test site is avaliable. See [Usage](#usage) for further details
on the `itkdev-test-site-deploy` command.

## Installation

1. Get the code:

   ``` shell
   git clone https://github.com/rimi-itk/experiment-test-site
   ```

2. Add the `./experiment-test-site/bin/itkdev-test-site-deploy` to your `PATH` variable.
3. Set the test site base domain by running

   ``` shell
   itkdev-test-site-deploy config set site.baseDomain
   ```

Run

``` shell
itkdev-test-site-deploy config list
```

to see the full configuration.

## Usage

Deploy a test site with

``` shell
itkdev-test-site-deploy deploy «repository URL» «branch»
```

Run

``` shell
itkdev-test-site-deploy
```

to see details on how to use `itkdev-test-site-deploy`.

## Requirements and assumptions

A test site, i.e. the Git repository, must contain a [Taskfile](https://taskfile.dev/) with two tasks,
`test-site:install` and `test-site:update`, plus a [(Docker) Compose
file](https://docs.docker.com/reference/compose-file/) called `docker-compose.server.test.yml` (or whatever the
`compose.files` configuration value specifies). The two tasks _must_ use `itkdev-docker-compose-server` (the configuration
value `compose.command`) to run any compose commands.

Furthermore, the site must not depend on services that are not defined in the compose file, i.e. no external databases
and such stuff.

See <https://github.com/rimi-itk/experiment-test-site/tree/feature/drupal-admin-theme> for an example.

## Technical details

### Deployment

When running

``` shell
itkdev-test-site-deploy deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
```

say, `itkdev-test-site-deploy` does the following:

1. Clones the specified branch of the Git repository into a (hopefully) uniquely named directory in the site base
   directory (the configuration value `site.baseDir`)
2. Generates a `.env.docker.local` (the configuration value `compose.commandConfigFilename`) file in the site directory,
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
itkdev-test-site-deploy remove /Users/example/itkdev/test-sites/rimi-itk-experiment-test-site--feature-drupal-admin-theme
```

say, `itkdev-test-site-deploy` does the following:

1. Runs

   ``` shell
   itkdev-docker-compose-server down down --remove-orphans --volumes
   ```

   in the site directory
2. Deletes the site directory
