# itkdev-test-site-deploy

A pragmatic solution to easily deploy test sites utilizing `itkdev-docker-compose-server`.

A test site is deployed by specifying a Git repository URL and a branch name, e.g.

``` shell
itkdev-test-site-deploy deploy https://github.com/rimi-itk/experiment-test-site feature/drupal-admin-theme
```

and then, if everything goes according to plan, a fresh test site is avaliable. See [Usage](#usage) for further details.

## Installation

``` shell
git clone https://github.com/rimi-itk/experiment-test-site
```

Run

``` shell
./experiment-test-site/bin/itkdev-test-site-deploy config
```

to see the default configuration and where to edit them.

## Usage

Run

``` shell
./experiment-test-site/bin/itkdev-test-site-deploy
```

to see details on how to use the script.

## Requirements and assumptions

A test site, i.e. the Git repository, must contain a [Taskfile](https://taskfile.dev/) with two tasks,
`test-site:install` and `test-site:update`, plus a [(Docker) Compose
file](https://docs.docker.com/reference/compose-file/) called `docker-compose.server.test.yml` (or whatever the
`compose_files` config value specifies).

Furthermore, the site must not depend on services that are not defined in the compose file, i.e. no external databases
and such stuff.

See <https://github.com/rimi-itk/experiment-test-site/tree/feature/drupal-admin-theme> for an example.
