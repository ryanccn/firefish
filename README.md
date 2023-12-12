# firefish

This is my personal fork of [Firefish](https://joinfirefish.org/).

Sources are cloned directly from the upstream [GitLab repository](https://git.joinfirefish.org/firefish/firefish)'s `main` (stable) branch and have patches from the `patches` folder applied.

The revision is pinned in `rev.txt` and automatically updated by GitHub Actions.

## Usage

A Docker image is available at `ghcr.io/ryanccn/firefish:latest`.

To use the repository directly, clone this repository and run `./scripts/gen_source.sh`. The actual Firefish source will be in `src`.

## Patches

- [Use IBM Plex Sans for default font](/patches/0001-ibm-plex-sans.patch)
