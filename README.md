# firefish

This is my personal fork of [Firefish](https://joinfirefish.org/).

Sources are cloned directly from the upstream [GitLab repository](https://gitlab.prometheus.systems/firefish/firefish)'s `beta` branch and have patches from the `patches` folder applied.

## Usage

A Docker image is available at `ghcr.io/ryanccn/firefish:latest`.

To use the repository directly, clone this repository and run `./gen_source.sh`. The actual Firefish source will be in `src`.

## Patches

- [Use standard system font stack](/patches/0001-system_fonts.patch)
