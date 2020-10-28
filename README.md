# Auto Branch Merge Action

Automatically merge the source branch into the target branch.

If the merge is not necessary, the action will do nothing.
If the merge fails due to conflicts, the action will fail, and the repository
maintainer should perform the merge manually.

## Installation

To enable the action simply create the `.github/workflows/auto-merge.yml`
file with the following content:

```yml
name: 'Auto Merge'

on:
  schedule:
    - cron:  '0 0 * * *'

jobs:
  auto-merge:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Auto Merge
      uses: objt-va/auto_branch_merge@master
      with:
        source_branch: 'master'
        target_branch: 'devel'
        allow_ff: false
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Even though this action was created to run as a scheduled workflow,
[`on`](https://help.github.com/en/articles/workflow-syntax-for-github-actions#on)
can be replaced by any other trigger.

For example, this will run the action whenever something is pushed on the
`master` branch:

```yml
on:
  push:
    branches:
      - master
```

This will add a button to the action to trigger it manually:

```yml
on:
  workflow_dispatch:
```

## Parameters

### `source_branch`

The name of the source branch.

### `target_branch`

The name of the development branch.

### `allow_ff`

Allow fast forward merge (default `false`). If not enabled, merges will use
`--no-ff`.

### `allow_git_lfs`

Allow support for repositories that use `git lfs` (default `false`). 

### `ff_only`

Refuse to merge and exit unless the current HEAD is already up to date or the
merge can be resolved as a fast-forward (default `false`).
Requires `allow_ff=true`.

### `allow_forks`

Allow action to run on forks (default `false`).

### `user_name`

User name for git commits (default `Auto Merge Action`).

### `user_email`

User email for git commits (default `actions@github.com`).

### `push_token`

Environment variable containing the token to use for push (default
`GITHUB_TOKEN`).
Useful for pushing on protected branches.
Using a secret to store this variable value is strongly recommended, since this
value will be printed in the logs.
The `GITHUB_TOKEN` is still used for API calls, therefore both token should be
available.

```yml
      with:
        push_token: 'FOO_TOKEN'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        FOO_TOKEN: ${{ secrets.FOO_TOKEN }}
```
