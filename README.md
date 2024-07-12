# Code Pit

A simple code versioning tool based off of Git plumbing mixed with a SQLite backend.

## How it works

### Database

Instead of a `.git/` subdirectory, there are two files.

`.code.pit` contains all commits, tags, and repo info.

`.local.pit` contains local data. Remotes, hooks, etc.
