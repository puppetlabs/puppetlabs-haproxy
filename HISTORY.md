## 9.1.0

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v9.0.0...v9.1.0)

> **Note:** This release raises the minimum required `puppetlabs/concat` version to `7.4.0` (from `1.2.3`) to support removing a workaround for Sensitive data handling. Environments pinned to an older `concat` version may fail dependency resolution after upgrading; update your `concat` pin before adopting this release. This dependency change is backwards-incompatible, but is shipped as a minor release rather than a major bump because it follows so soon after `v9.0.0`; the team agreed to treat the first release after a major as an exception rather than bump major again immediately.

### Changed

- Eliminate Workaround for Sensitive Data; raises minimum `puppetlabs/concat` requirement to `7.4.0` [#607](https://github.com/puppetlabs/puppetlabs-haproxy/pull/607) ([cocker-cc](https://github.com/cocker-cc))

### Added

- Add support for running programs [#604](https://github.com/puppetlabs/puppetlabs-haproxy/pull/604) ([deric](https://github.com/deric))
- Pass install_options to package installer [#603](https://github.com/puppetlabs/puppetlabs-haproxy/pull/603) ([deric](https://github.com/deric))

### Fixed

- examples: disable default stats listener [#640](https://github.com/puppetlabs/puppetlabs-haproxy/pull/640) ([bastelfreak](https://github.com/bastelfreak))
- make picking haproxy::globals::sort_options_alphabetic work [#573](https://github.com/puppetlabs/puppetlabs-haproxy/pull/573) ([trefzer](https://github.com/trefzer))

## 9.0.0

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v8.2.0...v9.0.0)

> **Note:** This release supersedes and corrects the withdrawn `8.2.1`, which was mistakenly published as a patch despite dropping Puppet 7 support. `8.2.1` has been removed from the Puppet Forge; use `9.0.0` instead.

### Changed

- **Remove Puppet 7 support; the module now requires `puppet >= 8.0.0 < 9.0.0`** [#631](https://github.com/puppetlabs/puppetlabs-haproxy/pull/631) ([gavindidrichsen](https://github.com/gavindidrichsen))

### Added

- Add support for `cache` resource, extra backend options, and docs [#626](https://github.com/puppetlabs/puppetlabs-haproxy/pull/626)
- (MODULES-11840) Allow puppetlabs/stdlib 10.x [#642](https://github.com/puppetlabs/puppetlabs-haproxy/pull/642) ([imaqsood](https://github.com/imaqsood))
- Allow puppetlabs/concat 10.x [#641](https://github.com/puppetlabs/puppetlabs-haproxy/pull/641)

### Fixed

- dependency: create mapfile before configfile [#572](https://github.com/puppetlabs/puppetlabs-haproxy/pull/572)

## [v8.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v8.2.0) - 2025-01-31

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v8.1.0...v8.2.0)

### Added

- remove stats as default [#616](https://github.com/puppetlabs/puppetlabs-haproxy/pull/616) ([elfranne](https://github.com/elfranne))

## [v8.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v8.1.0) - 2024-12-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v8.0.0...v8.1.0)

### Added

- (CAT-2101) Add support for Debian-12 [#619](https://github.com/puppetlabs/puppetlabs-haproxy/pull/619) ([skyamgarp](https://github.com/skyamgarp))
- Allow ports parameters as Stdlib::Ports [#610](https://github.com/puppetlabs/puppetlabs-haproxy/pull/610) ([traylenator](https://github.com/traylenator))

### Fixed

- (CAT-2158) Upgrade rexml to address CVE-2024-49761 [#621](https://github.com/puppetlabs/puppetlabs-haproxy/pull/621) ([amitkarsale](https://github.com/amitkarsale))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v8.0.0) - 2023-11-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.2.1...v8.0.0)

### Changed

- merge_options: Switch default false->true [#592](https://github.com/puppetlabs/puppetlabs-haproxy/pull/592) ([bastelfreak](https://github.com/bastelfreak))

### Added

- Add `merge_options` for `haproxy::defaults` [#588](https://github.com/puppetlabs/puppetlabs-haproxy/pull/588) ([yakatz](https://github.com/yakatz))

### Other

- Add bastelfreak to codeowners [#594](https://github.com/puppetlabs/puppetlabs-haproxy/pull/594) ([bastelfreak](https://github.com/bastelfreak))

## [v7.2.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v7.2.1) - 2023-09-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.2.0...v7.2.1)

### Fixed

- Replace merge() with native puppet code [#579](https://github.com/puppetlabs/puppetlabs-haproxy/pull/579) ([hawkeye-7](https://github.com/hawkeye-7))
- haproxy::backend: Always set $_sort_options_alphabetic [#576](https://github.com/puppetlabs/puppetlabs-haproxy/pull/576) ([bastelfreak](https://github.com/bastelfreak))

## [v7.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v7.2.0) - 2023-08-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.1.0...v7.2.0)

### Added

- (CONT-1144) - Conversion of ERB to EPP templates [#564](https://github.com/puppetlabs/puppetlabs-haproxy/pull/564) ([praj1001](https://github.com/praj1001))

### Fixed

- (CAT-1314) Fix for template bug with maxconn since PR#564 [#569](https://github.com/puppetlabs/puppetlabs-haproxy/pull/569) ([praj1001](https://github.com/praj1001))
- Correct warnings about deprecated parameter [#557](https://github.com/puppetlabs/puppetlabs-haproxy/pull/557) ([hawkeye-7](https://github.com/hawkeye-7))

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v7.1.0) - 2023-07-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.0.0...v7.1.0)

### Added

- pdksync - (MAINT) - Allow Stdlib 9.x [#556](https://github.com/puppetlabs/puppetlabs-haproxy/pull/556) ([LukasAud](https://github.com/LukasAud))
- (CONT-880) Update concat dependency [#549](https://github.com/puppetlabs/puppetlabs-haproxy/pull/549) ([LukasAud](https://github.com/LukasAud))

### Fixed

- (CONT-966) Replace replace `.is_hash` with `.is_a(Hash)` [#551](https://github.com/puppetlabs/puppetlabs-haproxy/pull/551) ([david22swan](https://github.com/david22swan))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v7.0.0) - 2023-04-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.5.0...v7.0.0)

### Changed

- (Cont 779) Add Support for Puppet 8 / Drop Support for Puppet 6 [#544](https://github.com/puppetlabs/puppetlabs-haproxy/pull/544) ([david22swan](https://github.com/david22swan))

## [v6.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.5.0) - 2023-03-31

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.4.0...v6.5.0)

### Added

- (CONT-353) Syntax update [#536](https://github.com/puppetlabs/puppetlabs-haproxy/pull/536) ([LukasAud](https://github.com/LukasAud))

### Fixed

- (CONT-651) Adjusting datatypes [#540](https://github.com/puppetlabs/puppetlabs-haproxy/pull/540) ([LukasAud](https://github.com/LukasAud))
- (CONT-560) Fix facter typos after syntax update [#539](https://github.com/puppetlabs/puppetlabs-haproxy/pull/539) ([LukasAud](https://github.com/LukasAud))
- (CONT-173) - Updating deprecated facter instances [#534](https://github.com/puppetlabs/puppetlabs-haproxy/pull/534) ([jordanbreen28](https://github.com/jordanbreen28))
- pdksync - (CONT-189) Remove support for RedHat6 / Scientific6 [#533](https://github.com/puppetlabs/puppetlabs-haproxy/pull/533) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) - Dropping Support for Debian 9 [#530](https://github.com/puppetlabs/puppetlabs-haproxy/pull/530) ([jordanbreen28](https://github.com/jordanbreen28))
- update resolver parameters [#526](https://github.com/puppetlabs/puppetlabs-haproxy/pull/526) ([bugfood](https://github.com/bugfood))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.4.0) - 2022-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.3.0...v6.4.0)

### Added

- (MAINT) Add support for Ubuntu 22.04 [#528](https://github.com/puppetlabs/puppetlabs-haproxy/pull/528) ([jordanbreen28](https://github.com/jordanbreen28))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.3.0) - 2022-06-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.2.1...v6.3.0)

### Added

- pdksync - (GH-cat-12) Add Support for Redhat 9 [#519](https://github.com/puppetlabs/puppetlabs-haproxy/pull/519) ([david22swan](https://github.com/david22swan))
- Allow specifying mapfile entries to be collected later [#508](https://github.com/puppetlabs/puppetlabs-haproxy/pull/508) ([yakatz](https://github.com/yakatz))
- Added possibility filling description field [#504](https://github.com/puppetlabs/puppetlabs-haproxy/pull/504) ([michaelkoettenstorfer](https://github.com/michaelkoettenstorfer))
- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#502](https://github.com/puppetlabs/puppetlabs-haproxy/pull/502) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1751) - Add Support for Rocky 8 [#501](https://github.com/puppetlabs/puppetlabs-haproxy/pull/501) ([david22swan](https://github.com/david22swan))
- Adding chroot_dir_manage parameter. [#498](https://github.com/puppetlabs/puppetlabs-haproxy/pull/498) ([tamerz](https://github.com/tamerz))

### Fixed

- pdksync - (GH-iac-334) Remove Support for Ubuntu 14.04/16.04 [#511](https://github.com/puppetlabs/puppetlabs-haproxy/pull/511) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1787) Remove Support for CentOS 6 [#507](https://github.com/puppetlabs/puppetlabs-haproxy/pull/507) ([david22swan](https://github.com/david22swan))
- [MODULES-11274] Allow usage of parameter manage_config_dir [#506](https://github.com/puppetlabs/puppetlabs-haproxy/pull/506) ([tuxmea](https://github.com/tuxmea))
- haproxy_userlist: fix empty users/groups handling. [#505](https://github.com/puppetlabs/puppetlabs-haproxy/pull/505) ([bzed](https://github.com/bzed))
- pdksync - (IAC-1598) - Remove Support for Debian 8 [#500](https://github.com/puppetlabs/puppetlabs-haproxy/pull/500) ([david22swan](https://github.com/david22swan))

## [v6.2.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.2.1) - 2021-08-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.2.0...v6.2.1)

### Fixed

- (IAC-1741) Allow stdlib v8.0.0 [#495](https://github.com/puppetlabs/puppetlabs-haproxy/pull/495) ([david22swan](https://github.com/david22swan))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.2.0) - 2021-08-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.1.0...v6.2.0)

### Added

- pdksync - (IAC-1709) - Add Support for Debian 11 [#493](https://github.com/puppetlabs/puppetlabs-haproxy/pull/493) ([david22swan](https://github.com/david22swan))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.1.0) - 2021-07-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.0.2...v6.1.0)

### Added

- allow type 'default-server' for balancermember [#489](https://github.com/puppetlabs/puppetlabs-haproxy/pull/489) ([trefzer](https://github.com/trefzer))
- Use Puppet-Datatype Sensitive [#487](https://github.com/puppetlabs/puppetlabs-haproxy/pull/487) ([cocker-cc](https://github.com/cocker-cc))

## [v6.0.2](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.0.2) - 2021-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.0.1...v6.0.2)

### Fixed

- Fix haproxy_version fact for versions >= 2.4.0 [#486](https://github.com/puppetlabs/puppetlabs-haproxy/pull/486) ([bp85](https://github.com/bp85))

## [v6.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.0.1) - 2021-05-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v6.0.0...v6.0.1)

### Fixed

- Fix 'option' entry name in option_order hash [#477](https://github.com/puppetlabs/puppetlabs-haproxy/pull/477) ([antaflos](https://github.com/antaflos))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v6.0.0) - 2021-03-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v5.0.0...v6.0.0)

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v5.0.0) - 2021-03-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.5.0...v5.0.0)

### Changed

- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#465](https://github.com/puppetlabs/puppetlabs-haproxy/pull/465) ([carabasdaniel](https://github.com/carabasdaniel))

## [v4.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.5.0) - 2020-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.4.0...v4.5.0)

### Added

- pdksync - (feat) Add support for Puppet 7 [#456](https://github.com/puppetlabs/puppetlabs-haproxy/pull/456) ([daianamezdrea](https://github.com/daianamezdrea))

## [v4.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.4.0) - 2020-11-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.3.0...v4.4.0)

### Added

- Fix incorrect options order in HAproxy 2.2.x [#442](https://github.com/puppetlabs/puppetlabs-haproxy/pull/442) ([pkaroluk](https://github.com/pkaroluk))

### Fixed

- (bugfix) backend: dont log warnings if not necessary [#449](https://github.com/puppetlabs/puppetlabs-haproxy/pull/449) ([bastelfreak](https://github.com/bastelfreak))
- frontend options: order default_backend after specific backends & test [#447](https://github.com/puppetlabs/puppetlabs-haproxy/pull/447) ([MajorFlamingo](https://github.com/MajorFlamingo))

## [v4.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.3.0) - 2020-09-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.2.1...v4.3.0)

### Added

- pdksync - (IAC-973) - Update travis/appveyor to run on new default branch main [#437](https://github.com/puppetlabs/puppetlabs-haproxy/pull/437) ([david22swan](https://github.com/david22swan))
- (IAC-746) - Add ubuntu 20.04 support [#430](https://github.com/puppetlabs/puppetlabs-haproxy/pull/430) ([david22swan](https://github.com/david22swan))

### Fixed

- (IAC-988) - Removal of inappropriate terminology [#443](https://github.com/puppetlabs/puppetlabs-haproxy/pull/443) ([david22swan](https://github.com/david22swan))

## [v4.2.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.2.1) - 2020-05-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.2.0...v4.2.1)

### Fixed

- Ensure multiple instances may be created with the default package. [#348](https://github.com/puppetlabs/puppetlabs-haproxy/pull/348) ([surprisingb](https://github.com/surprisingb))

## [v4.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.2.0) - 2019-12-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.1.0...v4.2.0)

### Added

- (FM-8674) - Support added for CentOS 8 [#397](https://github.com/puppetlabs/puppetlabs-haproxy/pull/397) ([david22swan](https://github.com/david22swan))

## [v4.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.1.0) - 2019-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v4.0.0...v4.1.0)

### Added

- pdksync - Add support on Debian10 [#380](https://github.com/puppetlabs/puppetlabs-haproxy/pull/380) ([lionce](https://github.com/lionce))
- FM-8140 Add redhat8 support [#374](https://github.com/puppetlabs/puppetlabs-haproxy/pull/374) ([sheenaajay](https://github.com/sheenaajay))
- (FM-8220) convert to use litmus [#373](https://github.com/puppetlabs/puppetlabs-haproxy/pull/373) ([tphoney](https://github.com/tphoney))

### Fixed

- MODULES-9783 - Removed option tcplog [#376](https://github.com/puppetlabs/puppetlabs-haproxy/pull/376) ([uberjew666](https://github.com/uberjew666))
- Add check of OS for the systemd unitfile [#347](https://github.com/puppetlabs/puppetlabs-haproxy/pull/347) ([surprisingb](https://github.com/surprisingb))

## [v4.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v4.0.0) - 2019-05-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/3.0.1...v4.0.0)

### Changed

- pdksync - (MODULES-8444) - Raise lower Puppet bound [#362](https://github.com/puppetlabs/puppetlabs-haproxy/pull/362) ([david22swan](https://github.com/david22swan))

### Added

- [FM-7934] - Puppet Strings [#365](https://github.com/puppetlabs/puppetlabs-haproxy/pull/365) ([carabasdaniel](https://github.com/carabasdaniel))

### Fixed

- (MODULES-8930) Fix stahnma/epel dependency failures [#364](https://github.com/puppetlabs/puppetlabs-haproxy/pull/364) ([eimlav](https://github.com/eimlav))
- Remove execute bit on systemd unit file [#354](https://github.com/puppetlabs/puppetlabs-haproxy/pull/354) ([shanemadden](https://github.com/shanemadden))

## [3.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/3.0.1) - 2019-02-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/3.0.0...3.0.1)

## [3.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/3.0.0) - 2019-02-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.2.0...3.0.0)

### Changed

- (FM-7675) - Support has been removed for RHEL 6 [#345](https://github.com/puppetlabs/puppetlabs-haproxy/pull/345) ([david22swan](https://github.com/david22swan))

### Added

- (MODULES-8539) Added 'accepted_payload_size' to resolver [#346](https://github.com/puppetlabs/puppetlabs-haproxy/pull/346) ([genebean](https://github.com/genebean))
- Sergey leskov/servertemplatekwimp [#337](https://github.com/puppetlabs/puppetlabs-haproxy/pull/337) ([LeskovSergey](https://github.com/LeskovSergey))

### Fixed

- (MODULES-8566) Only create entries for defined settings [#350](https://github.com/puppetlabs/puppetlabs-haproxy/pull/350) ([genebean](https://github.com/genebean))
- (MODULES-8407) Add option to set the service's name [#342](https://github.com/puppetlabs/puppetlabs-haproxy/pull/342) ([genebean](https://github.com/genebean))
- pdksync - (FM-7655) Fix rubygems-update for ruby < 2.3 [#341](https://github.com/puppetlabs/puppetlabs-haproxy/pull/341) ([tphoney](https://github.com/tphoney))

## [2.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.2.0) - 2018-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.1.0...2.2.0)

### Added

- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#333](https://github.com/puppetlabs/puppetlabs-haproxy/pull/333) ([tphoney](https://github.com/tphoney))
- pdksync - (MODULES-7658) use beaker4 in puppet-module-gems [#330](https://github.com/puppetlabs/puppetlabs-haproxy/pull/330) ([tphoney](https://github.com/tphoney))
- (MODULES-7562) - Addition of support for Ubuntu 18.04 to haproxy [#324](https://github.com/puppetlabs/puppetlabs-haproxy/pull/324) ([david22swan](https://github.com/david22swan))
- (MODULES-5992) Add debian 9 compatibility [#321](https://github.com/puppetlabs/puppetlabs-haproxy/pull/321) ([hunner](https://github.com/hunner))

### Fixed

- pdksync - (MODULES-7658) use beaker3 in puppet-module-gems [#327](https://github.com/puppetlabs/puppetlabs-haproxy/pull/327) ([tphoney](https://github.com/tphoney))
- (MODULES-7630) - Update README Limitations section [#325](https://github.com/puppetlabs/puppetlabs-haproxy/pull/325) ([eimlav](https://github.com/eimlav))
- [FM-6964] Removal of unsupported OS from haproxy [#323](https://github.com/puppetlabs/puppetlabs-haproxy/pull/323) ([david22swan](https://github.com/david22swan))
- (maint) Add netstat for debian9 testing [#322](https://github.com/puppetlabs/puppetlabs-haproxy/pull/322) ([hunner](https://github.com/hunner))
- Change bind_options default value [#313](https://github.com/puppetlabs/puppetlabs-haproxy/pull/313) ([bdandoy](https://github.com/bdandoy))

## 2.1.0
### Summary
This release uses the PDK convert functionality which in return makes the module PDK compliant. It also includes a roll up of maintenance changes.

#### Added
- PDK convert HAProxy ([MODULES-6457](https://tickets.puppet.com/browse/MODULES-6457)).

#### Fixed
- Bump allowed concat module version to 5.0.0.
- Changes to address additional Rubocop failures.
- Modulesync updates.
- Re-add support for specifying package version in package_ensure.

## Supported Release 2.0.1
### Summary

A minor release made in order to implement Rubocop within the module.

#### Added
- Rubocop has been implemented in the module.

## Supported Release 2.0.0
### Summary

A substantial release made to create a clean base from which Rubocop may be implemented. Notable changes include the addition of HAproxy Resolver and a Puppet 4 update.

#### Added
- fast_gettext added to gems.
- Locales folder and config.yml added.
- Support added for balancemember weights.
- Concat validate_cmd can be configured.
- Space now added to headers for formatting.
- Haproxy Resolver added, only supported by Haproxy version 1.6+.
- Update to match Puppet 4 datatypes.

#### Changed
- Tests updated to match ruby version 2.0.0.
- Mocha version updated.
- Multiple Modulesync updates.
- A listen check was added to the code.
- System service flap detection avoided during acceptance tests.
- Undefined values have been dropped from config template.
- Verifyhost parameter added to balancemember resource.
- validate_* replaced with datatypes.

#### Fixed
- Fix to $bind_options.
- Fix to example ports listening value.
- Fix to lint warnings.

#### Removed
- spec.opts removed.
- Validate_cmd no longer attempted on puppet versions below 3.5.
- Pe requirement removed from metadata.
- Ubuntu 10.04 and 12.04 entry in 'metadata.json'.
- Debian 6 entry in 'metadata.json'.

## Supported Release 1.5.0
### Summary

A substantial release with many new feature additions, including added Ubuntu Xenial support. Also includes several bugfixes, including the removal of unsupported platform testing restrictions to allow for easier testing on unsupported OSes.

#### Features
- Addition of mode to the backend class.
- Addition of Ubuntu 16.04 support.
- Addition of docs example on how to set up stick-tables.
- Updated to current modulesync configs.
- Basic usage now clarified in readme.
- Now uses concat 2.0.
- Addition of mailers.
- New option to use multiple defaults sections.
- Additional option to manage config_dir.
- Adds sysconfig_options param for /etc/sysconfig/haproxy.

#### Bugfixes
- No longer adds $ensure to balancermember concat fragments.
- Improved the ordering of options.
- Correct class now used for sort_options_alphabetic.
- Netcat has now been replaced with socat.
- Tests adjusted to work under strict_variables.
- Config file now validated before added.
- Removal of unsupported platforms restrictions in testing.
- Removal of the default-server keyword from test.
- Now uses haproxy::config_file instead of deafult config_file.

## Supported Release 1.4.0
### Summary

This release adds the addition of the capability to create multiple instances of haproxy on a host. It also adds Debian 8 compatibility, some updates on current features and numerous bug fixes.

#### Features
- Debian 8 compatibility added.
- Adds haproxy::instance for the creation of multiple instances of haproxy on a host (MODULES-1783)
- Addition of `service_options` parameter for `/etc/defaults/haproxy` file on Debian.
- Merge of global and default options with user-supplied options - Allows the ability to override or add arbitrary keys and values to the `global_options` and `defaults_options` hashes without having to reproduce the whole hash.
- Addition of a defined type haproxy::mapfile to manage map files.

#### Bugfixes
- Prevents warning on puppet 4 from bind_options.
- Value specified for timeout client now in seconds instead of milliseconds.
- Consistent use of ::haproxy::config_file added (MODULES-2704)
- Fixed bug in which Ruby 1.8 doesn't have `.match` for symbols.
- Fix determining $haproxy::config_dir in haproxy::instance.
- Removed ssl-hello-chk from default options.


## Supported Release 1.3.1
### Summary

Small release for support of newer PE versions. This increments the version of PE in the metadata.json file.

## 2015-07-15 - Supported Release 1.3.0
### Summary
This release adds puppet 4 support, and adds the ability to specify the order
of option entries for `haproxy::frontend` and `haproxy::listen` defined
resources.

#### Features
- Adds puppet 4 compatibility
- Updated readme
- Gentoo compatibility
- Suse compatibility
- Add ability for frontend and listen to be ordered


## 2015-03-10 - Supported Release 1.2.0
### Summary
This release adds flexibility for configuration of balancermembers and bind settings, and adds support for configuring peers. This release also renames the `tests` directory to `examples`

#### Features
- Add support for loadbalancer members without ports
- Add `haproxy_version` fact (MODULES-1619)
- Add `haproxy::peer` and `haproxy::peers` defines
- Make `bind` parameter processing more flexible

#### Bugfixes
- Fix 'RedHat' name for osfamily case in `haproxy::params`
- Fix lint warnings
- Don't set a default for `ipaddress` so bind can be used (MODULES-1497)

## 2014-11-04 - Supported Release 1.1.0
### Summary

This release primarily adds greater flexibility in the listen directive.

#### Features
- Added `bind` parameter to `haproxy::frontend`

#### Deprecations
- `bind_options` in `haproxy::frontend` is being deprecated in favor of `bind`
- Remove references to deprecated concat::setup class and update concat dependency

## 2014-07-21 - Supported Release 1.0.0
### Summary

This supported release is the first stable release of haproxy! The updates to
this release allow you to customize pretty much everything that HAProxy has to
offer (that we could find at least).

#### Features
- Brand new readme
- Add haproxy::userlist defined resource for managing users
- Add haproxy::frontend::bind_options parameter
- Add haproxy::custom_fragment parameter for arbitrary configuration
- Add compatibility with more recent operating system releases

#### Bugfixes
- Check for listen/backend with the same names to avoid misordering
- Removed warnings when storeconfigs is not being used
- Passing lint
- Fix chroot ownership for global user/group
- Fix ability to uninstall haproxy
- Fix some linting issues
- Add beaker-rspec tests
- Increase unit test coverage
- Fix balancermember server lines with multiple ports

## 2014-05-28 - Version 0.5.0
### Summary

The primary feature of this release is a reorganization of the
module to match best practices.  There are several new parameters
and some bug fixes.

#### Features
- Reorganized the module to follow install/config/service pattern
- Added bind_options parameter to haproxy::listen
- Updated tests

#### Fixes
- Add license file
- Whitespace cleanup
- Use correct port in README
- Fix order of concat fragments

## 2013-10-08 - Version 0.4.1

### Summary

Fix the dependency for concat.

#### Fixes
- Changed the dependency to be the puppetlabs/concat version.

## 2013-10-03 - Version 0.4.0

### Summary

The largest feature in this release is the new haproxy::frontend
and haproxy::backend defines.  The other changes are mostly to
increase flexibility.

#### Features
- Added parameters to haproxy:
 - `package_name`: Allows alternate package name.
- Add haproxy::frontend and haproxy::backend defines.
- Add an ensure parameter to balancermember so they can be removed.
- Made chroot optional

#### Fixes
- Remove deprecation warnings from templates.

## 2013-05-25 - Version 0.3.0
#### Features
- Add travis testing
- Add `haproxy::balancermember` `define_cookies` parameter
- Add array support to `haproxy::listen` `ipaddress` parameter

#### Bugfixes
- Documentation
- Listen -> Balancermember dependency
- Config line ordering
- Whitespace
- Add template lines for `haproxy::listen` `mode` parameter

## 2012-10-12 - Version 0.2.0
- Initial public release
- Backwards incompatible changes all around
- No longer needs ordering passed for more than one listener
- Accepts multiple listen ips/ports/server_names

[2.1.0]:https://github.com/puppetlabs/puppetlabs-apt/compare/2.1.0...2.1.0
