# Agents

Guidance for any coding agent working in this repository.

- Repository contract: [CLAUDE.md](CLAUDE.md)
- Estate-wide conventions: https://github.com/JorisJonkers-dev/workspace/blob/main/CLAUDE.md

## What it holds

The estate's karakeep, chrome and search images, each with a `Dockerfile` under `karakeep`, `chrome` and `search`. deploy-kit delivers them as the Project karakeep.

## Build and test

After building the three images, run the restricted smoke test CI runs (it needs Docker):

```bash
scripts/smoke-test.sh <karakeep-image> <chrome-image> <search-image>
```
