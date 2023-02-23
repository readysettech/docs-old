# Contribute to ReadySet Docs

The ReadySet docs are open source. We welcome your contributions!

## Setup

This section helps you set up the tools you'll need to write the docs and use ReadySet.

These instructions assume that you use macOS. If you use Linux, use your default package manager to install the packages mentioned in these steps, rather than Homebrew.

1. Install [Homebrew](https://brew.sh/), a macOS package manager you'll use for a few different installations:

    ``` sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    ```

1. Install the latest version of Git from Homebrew:

    ``` sh
    brew install git
    ```

    You can find instructions to install [git](https://www.atlassian.com/git/tutorials/install-git) for Linux or other operating systems.

1. Install the [MkDocs](https://www.mkdocs.org/) static site generator and the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme:

    ``` sh
    pip3 install mkdocs
    pip3 install mkdocs-material
    ```

## Get started

Once you're ready to contribute:

1. Fork the [ReadySet docs repository](https://github.com/readysettech/docs).

1. [Create a local clone](https://help.github.com/articles/cloning-a-repository/) of your fork.

1. Create a new local branch for your work:

    ``` sh
    cd path/to/docs
    git checkout -b "<your branch name>"
    ```

1. Make your changes in the text editor of your choice (e.g., [VS Code](https://code.visualstudio.com/), [Sublime Text](https://www.sublimetext.com/)).


1. Check the files you've changed:

    ``` sh
    git status
    ```

1. Stage your changes for commit:

    ``` sh
    git add <filename>
    ```

1. Commit your changes:

    ``` sh
    git commit -m "<concise message describing changes>"
    ```

1. Use MkDocs to [build a version of the site locally](#build-and-test-the-docs-locally) so you can view your changes in a browser:

    ``` sh
    mkdocs serve -s
    ```

1. [Push your local branch to your remote fork](https://help.github.com/articles/pushing-to-a-remote/).

1. Back in your fork of the ReadySet docs repo in the GitHub UI, [open a pull request](https://github.com/readysettech/docs/pulls). If you check the `Allow edits from maintainers` option when creating your pull request, we'll be able to make minor edits or fixes directly, if it seems easier than commenting and asking you to make those revisions, which can streamline the review process.

We'll review your changes, providing feedback and guidance as necessary.

## Keep contributing

If you want to regularly contribute to the ReadySet docs, there are a few things we recommend:

1. Make it easy to bring updated docs into your fork by tracking us upstream:

    ``` sh
    git remote add --track master upstream https://github.com/readysettech/docs.git
    ```

1. When you're ready to make your next round of changes, get our latest docs:

    ``` sh
    git fetch upstream
    git merge upstream/master
    ```

1. Repeat the write, build, push, pull flow from the [Get Started](#get-started) section above.

## Build and Test the Docs Locally

Once you've installed [MkDocs](https://www.mkdocs.org/) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) and have a local clone of the docs repository, you can build and test the docs as follows:

1. From the root directory of your clone, run:

    ``` sh
    mkdocs serve -s
    ```

1. Go to `http://127.0.0.1:8000/` and manually check your changes.

    When you make additional changes, MkDocs automatically regenerates the HTML content. No need to stop and re-start MkDocs; just refresh your browser.

    Once you're done viewing your changes, use **CTRL-C** to stop the MkDocs server.
