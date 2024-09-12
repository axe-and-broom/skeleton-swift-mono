# skeleton-swift-mono
An extensible Swift platform monorepo (can accomodate modules and multiple projects). This repo is a skeleton repo that you can fork or use as a template repo.

# Folder Structure

## `Modules` 
Contains all the modules that can be shared across projects.

## `Apps`
 Contains all the projects that can be built using the modules.

## `utils`
Contains all utilities like git hooks, vendor checkouts, scripts, etc. that can be used across the repo.

## `rake-tasks`
Contains all the rake tasks that can be used across the repo. Rake tasks can be defined in the Apps/*/rake-tasks folder as well and get automatically picked up by the rake tasks defined in the root folder.

# Task runner
In order to efficiently use and define tasks you should pick one single frontend for running any type of script or task. In our case since we are building a Swift monorepo we picked Ruby and Rake as the task runner. 

Just run `rake` to see all the available tasks.

# Github Actions
This repo is setup with Github Actions. You can define your own workflows in the `.github/workflows` folder.

## Monorepo considerations
In a monorepo it is not uncommon to run some CI checks for all changes but only some checks depending on what has changed. This is called build avoidance. This repo is setup with a build avoidance strategy.