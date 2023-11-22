<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v10.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v10.0.0) - 2023-11-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.2.1...v10.0.0)

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
- Adding chroot_dir_manage parameter. [#498](https://github.com/puppetlabs/puppetlabs-haproxy/pull/498) ([Tamerz](https://github.com/Tamerz))

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

## [2.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.1.0) - 2018-01-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.0.1...2.1.0)

### Fixed

- Re-add support for specifying package version in package_ensure [#307](https://github.com/puppetlabs/puppetlabs-haproxy/pull/307) ([antaflos](https://github.com/antaflos))

## [2.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.0.1) - 2017-12-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.0.0...2.0.1)

### Added

- bump allowed concat module version to 5.0.0 [#302](https://github.com/puppetlabs/puppetlabs-haproxy/pull/302) ([mateusz-gozdek-sociomantic](https://github.com/mateusz-gozdek-sociomantic))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.0.0) - 2017-12-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/list...2.0.0)

### Changed
- (WIP) Puppet4 update [#285](https://github.com/puppetlabs/puppetlabs-haproxy/pull/285) ([HelenCampbell](https://github.com/HelenCampbell))

### Added

- Add haproxy::resolver supported only by haproxy version 1.6+ [#291](https://github.com/puppetlabs/puppetlabs-haproxy/pull/291) ([missingcharacter](https://github.com/missingcharacter))

### Fixed

- on freebsd haproxy lives on /usr/local/sbin [#292](https://github.com/puppetlabs/puppetlabs-haproxy/pull/292) ([rmdir](https://github.com/rmdir))
- Fixed example ports listenning value 18140->8140 [#289](https://github.com/puppetlabs/puppetlabs-haproxy/pull/289) ([tux-o-matic](https://github.com/tux-o-matic))

## [list](https://github.com/puppetlabs/puppetlabs-haproxy/tree/list) - 2017-07-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.5.0...list)

### Added

- Add support for balancermember weights [#280](https://github.com/puppetlabs/puppetlabs-haproxy/pull/280) ([johanek](https://github.com/johanek))
- harden chmod of haproxy config file [#272](https://github.com/puppetlabs/puppetlabs-haproxy/pull/272) ([tphoney](https://github.com/tphoney))
- Add verifyhost parameter to balancermember resource [#268](https://github.com/puppetlabs/puppetlabs-haproxy/pull/268) ([JAORMX](https://github.com/JAORMX))
- (MODULES-3547) Added listen check, fix tests [#252](https://github.com/puppetlabs/puppetlabs-haproxy/pull/252) ([hunner](https://github.com/hunner))

### Fixed

- Change if $bind_options to if $bind_options != '' [#283](https://github.com/puppetlabs/puppetlabs-haproxy/pull/283) ([jnieuwen](https://github.com/jnieuwen))
- workaround usage of 'which' in Ubuntu 12.04 (puppet 2.7.11) [#267](https://github.com/puppetlabs/puppetlabs-haproxy/pull/267) ([eumel8](https://github.com/eumel8))
- Drop :undef values from haproxy config template [#262](https://github.com/puppetlabs/puppetlabs-haproxy/pull/262) ([mks-m](https://github.com/mks-m))

## [1.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.5.0) - 2016-06-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.4.0...1.5.0)

### Added

- Add /etc/sysconfig/haproxy(instance_name) support [#242](https://github.com/puppetlabs/puppetlabs-haproxy/pull/242) ([sjoeboo](https://github.com/sjoeboo))
- (MODULES-3258) Validate the config before adding it [#236](https://github.com/puppetlabs/puppetlabs-haproxy/pull/236) ([hunner](https://github.com/hunner))
- add option to use multiple defaults sections [#232](https://github.com/puppetlabs/puppetlabs-haproxy/pull/232) ([vicinus](https://github.com/vicinus))
-  (MODULES-3055) Add mailers [#231](https://github.com/puppetlabs/puppetlabs-haproxy/pull/231) ([hunner](https://github.com/hunner))
- Socat is way better than netcat [#229](https://github.com/puppetlabs/puppetlabs-haproxy/pull/229) ([hunner](https://github.com/hunner))
- improve ordering of options [#224](https://github.com/puppetlabs/puppetlabs-haproxy/pull/224) ([vicinus](https://github.com/vicinus))

### Fixed

- (MODULES-3366) Add missing check flag [#243](https://github.com/puppetlabs/puppetlabs-haproxy/pull/243) ([hunner](https://github.com/hunner))
- (MODULES-3412) Use haproxy::config_file instead of default config_file [#239](https://github.com/puppetlabs/puppetlabs-haproxy/pull/239) ([ctiml](https://github.com/ctiml))
- bugfix: correct class for sort_options_alphabetic acceptance test [#228](https://github.com/puppetlabs/puppetlabs-haproxy/pull/228) ([vicinus](https://github.com/vicinus))
- No longer add $ensure to balancermember concat fragments [#226](https://github.com/puppetlabs/puppetlabs-haproxy/pull/226) ([jyaworski](https://github.com/jyaworski))
- Fix markup around section "Manage a map file" [#222](https://github.com/puppetlabs/puppetlabs-haproxy/pull/222) ([antaflos](https://github.com/antaflos))
- Only create config_dir in specific cases. [#210](https://github.com/puppetlabs/puppetlabs-haproxy/pull/210) ([pmlee](https://github.com/pmlee))

## [1.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.4.0) - 2016-01-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.3.1...1.4.0)

### Added

- Adding mode to backend class [#211](https://github.com/puppetlabs/puppetlabs-haproxy/pull/211) ([DavidS](https://github.com/DavidS))
- Validate global_options and defaults_options. [#207](https://github.com/puppetlabs/puppetlabs-haproxy/pull/207) ([tlimoncelli](https://github.com/tlimoncelli))

### Fixed

- Fix port parameter name on haproxy::peer defined type [#208](https://github.com/puppetlabs/puppetlabs-haproxy/pull/208) ([tomashejatko](https://github.com/tomashejatko))

## [1.3.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.3.1) - 2015-12-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.3.0...1.3.1)

### Added

- (MODULES-2704) Consistent use of ::haproxy::config_file [#201](https://github.com/puppetlabs/puppetlabs-haproxy/pull/201) ([traylenator](https://github.com/traylenator))

### Fixed

- Allow the contents of /etc/default/haproxy to be overridden [#194](https://github.com/puppetlabs/puppetlabs-haproxy/pull/194) ([DavidS](https://github.com/DavidS))

## [1.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.3.0) - 2015-07-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.2.0...1.3.0)

### Added

- Add helper to install puppet/pe/puppet-agent [#188](https://github.com/puppetlabs/puppetlabs-haproxy/pull/188) ([hunner](https://github.com/hunner))

### Fixed

- ignore the log directory [#183](https://github.com/puppetlabs/puppetlabs-haproxy/pull/183) ([tphoney](https://github.com/tphoney))
- Implement `options` as array of hashes so order is preserved [#173](https://github.com/puppetlabs/puppetlabs-haproxy/pull/173) ([antaflos](https://github.com/antaflos))

## [1.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.2.0) - 2015-03-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.1.0...1.2.0)

### Added

- Make `bind` parameter processing more flexible [#154](https://github.com/puppetlabs/puppetlabs-haproxy/pull/154) ([antaflos](https://github.com/antaflos))
- adding a default option into nodesets [#150](https://github.com/puppetlabs/puppetlabs-haproxy/pull/150) ([tphoney](https://github.com/tphoney))
- Set ipaddress default value to undef [#146](https://github.com/puppetlabs/puppetlabs-haproxy/pull/146) ([sergakaibis](https://github.com/sergakaibis))
- MODULES-1619 Add haproxy version fact [#144](https://github.com/puppetlabs/puppetlabs-haproxy/pull/144) ([petems](https://github.com/petems))
- Peers feature [#125](https://github.com/puppetlabs/puppetlabs-haproxy/pull/125) ([josecastroleon](https://github.com/josecastroleon))
- Add support for loadbalancer member without ports [#120](https://github.com/puppetlabs/puppetlabs-haproxy/pull/120) ([ericlaflamme](https://github.com/ericlaflamme))

### Fixed

- Missing ensure for peer [#156](https://github.com/puppetlabs/puppetlabs-haproxy/pull/156) ([underscorgan](https://github.com/underscorgan))
- Corrected namespaces on variables [#145](https://github.com/puppetlabs/puppetlabs-haproxy/pull/145) ([t0mmyt](https://github.com/t0mmyt))
- Fixed RedHat name for osfamily case [#137](https://github.com/puppetlabs/puppetlabs-haproxy/pull/137) ([gildub](https://github.com/gildub))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.1.0) - 2014-11-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.0.0...1.1.0)

### Added

- Allow greater flexibility in listen directive. [#119](https://github.com/puppetlabs/puppetlabs-haproxy/pull/119) ([Spredzy](https://github.com/Spredzy))

### Fixed

- Remove deprecated concat::setup class [#129](https://github.com/puppetlabs/puppetlabs-haproxy/pull/129) ([blkperl](https://github.com/blkperl))
- Fix issue with puppet_module_install, removed and using updated method f... [#126](https://github.com/puppetlabs/puppetlabs-haproxy/pull/126) ([cyberious](https://github.com/cyberious))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.0.0) - 2014-07-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.5.0...1.0.0)

### Added

- CentOS 5 gets haproxy from epel [#117](https://github.com/puppetlabs/puppetlabs-haproxy/pull/117) ([hunner](https://github.com/hunner))
- Add bind_options for frontends [#94](https://github.com/puppetlabs/puppetlabs-haproxy/pull/94) ([hunner](https://github.com/hunner))
- Define each server/port combination on its own line [#93](https://github.com/puppetlabs/puppetlabs-haproxy/pull/93) ([hunner](https://github.com/hunner))
- Avoid mixing up backend servers [#92](https://github.com/puppetlabs/puppetlabs-haproxy/pull/92) ([hunner](https://github.com/hunner))
- Add custom_fragment parameter [#89](https://github.com/puppetlabs/puppetlabs-haproxy/pull/89) ([hunner](https://github.com/hunner))
- Add chroot ownership [#87](https://github.com/puppetlabs/puppetlabs-haproxy/pull/87) ([hunner](https://github.com/hunner))
- haproxy::userlist resource [#85](https://github.com/puppetlabs/puppetlabs-haproxy/pull/85) ([kitchen](https://github.com/kitchen))

### Fixed

- OSX not compatible, and windows doesn't have hieraconf [#110](https://github.com/puppetlabs/puppetlabs-haproxy/pull/110) ([hunner](https://github.com/hunner))
- Add checks for passive failover and PE module paths [#107](https://github.com/puppetlabs/puppetlabs-haproxy/pull/107) ([hunner](https://github.com/hunner))
- Correctly privetize define [#95](https://github.com/puppetlabs/puppetlabs-haproxy/pull/95) ([hunner](https://github.com/hunner))
- Reduce template code duplication [#91](https://github.com/puppetlabs/puppetlabs-haproxy/pull/91) ([hunner](https://github.com/hunner))
- Fix the mkdir for moduledir [#88](https://github.com/puppetlabs/puppetlabs-haproxy/pull/88) ([hunner](https://github.com/hunner))
- Remove warnings when storeconfigs is not being used [#81](https://github.com/puppetlabs/puppetlabs-haproxy/pull/81) ([yasn77](https://github.com/yasn77))
- Fix ordering of options changing [#69](https://github.com/puppetlabs/puppetlabs-haproxy/pull/69) ([lboynton](https://github.com/lboynton))

## [0.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.5.0) - 2014-05-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.4.1...0.5.0)

### Added

- Add haproxy::listen bind_options parameter for setting arbitrary 'bind' options [#82](https://github.com/puppetlabs/puppetlabs-haproxy/pull/82) ([misterdorm](https://github.com/misterdorm))
- Archlinux Support added. [#70](https://github.com/puppetlabs/puppetlabs-haproxy/pull/70) ([aboe76](https://github.com/aboe76))
- Support minus in service names [#60](https://github.com/puppetlabs/puppetlabs-haproxy/pull/60) ([ymc-dabe](https://github.com/ymc-dabe))

### Fixed

- Rewrite with install/config/service classes, and correct parameter naming. [#80](https://github.com/puppetlabs/puppetlabs-haproxy/pull/80) ([hunner](https://github.com/hunner))
- Remove redundant params section [#79](https://github.com/puppetlabs/puppetlabs-haproxy/pull/79) ([kurthuwig](https://github.com/kurthuwig))
- Moved from `#include_class` to `#contain_class` [#67](https://github.com/puppetlabs/puppetlabs-haproxy/pull/67) ([retr0h](https://github.com/retr0h))
- Allow user-defined service restart parameter. [#57](https://github.com/puppetlabs/puppetlabs-haproxy/pull/57) ([bleach](https://github.com/bleach))

## [0.4.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.4.1) - 2013-10-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.4.0...0.4.1)

### Fixed

- Use puppetlabs/concat [#55](https://github.com/puppetlabs/puppetlabs-haproxy/pull/55) ([hunner](https://github.com/hunner))

## [0.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.4.0) - 2013-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.3.0...0.4.0)

### Added

- Add an ensure parameter to balancermember. [#43](https://github.com/puppetlabs/puppetlabs-haproxy/pull/43) ([bleach](https://github.com/bleach))
- Add parameter to specify an alternate package name to install [#42](https://github.com/puppetlabs/puppetlabs-haproxy/pull/42) ([rharrison10](https://github.com/rharrison10))
- adds backend and frontend config sections [#37](https://github.com/puppetlabs/puppetlabs-haproxy/pull/37) ([kitchen](https://github.com/kitchen))

### Fixed

- remove deprecation warnings from templates [#39](https://github.com/puppetlabs/puppetlabs-haproxy/pull/39) ([kitchen](https://github.com/kitchen))
- Made chroot optional [#27](https://github.com/puppetlabs/puppetlabs-haproxy/pull/27) ([francois](https://github.com/francois))

## [0.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.3.0) - 2013-05-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/c4799e59b9d9891e6c296c554a11814f14a5abfc...0.3.0)
