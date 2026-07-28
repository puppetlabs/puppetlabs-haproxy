<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v9.1.0) - 2026-07-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v9.0.0...v9.1.0)

> **Note:** This release raises the minimum required `puppetlabs/concat` version to `7.4.0` (from `1.2.3`) to support removing a workaround for Sensitive data handling. Environments pinned to an older `concat` version may fail dependency resolution after upgrading; update your `concat` pin before adopting this release.

### Changed

- Eliminate Workaround for Sensitive Data; raises minimum `puppetlabs/concat` requirement to `7.4.0` [#607](https://github.com/puppetlabs/puppetlabs-haproxy/pull/607) ([cocker-cc](https://github.com/cocker-cc))

### Added

- Add support for running programs [#604](https://github.com/puppetlabs/puppetlabs-haproxy/pull/604) ([deric](https://github.com/deric))
- Pass install_options to package installer [#603](https://github.com/puppetlabs/puppetlabs-haproxy/pull/603) ([deric](https://github.com/deric))

### Fixed

- examples: disable default stats listener [#640](https://github.com/puppetlabs/puppetlabs-haproxy/pull/640) ([bastelfreak](https://github.com/bastelfreak))
- make picking haproxy::globals::sort_options_alphabetic work [#573](https://github.com/puppetlabs/puppetlabs-haproxy/pull/573) ([trefzer](https://github.com/trefzer))
