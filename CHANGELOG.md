<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/v7.0.1) - 2023-05-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/v7.0.0...v7.0.1)

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

### Added

- [FM-7934] - Puppet Strings [#365](https://github.com/puppetlabs/puppetlabs-haproxy/pull/365) ([carabasdaniel](https://github.com/carabasdaniel))

### Changed
- pdksync - (MODULES-8444) - Raise lower Puppet bound [#362](https://github.com/puppetlabs/puppetlabs-haproxy/pull/362) ([david22swan](https://github.com/david22swan))

### Fixed

- (MODULES-8930) Fix stahnma/epel dependency failures [#364](https://github.com/puppetlabs/puppetlabs-haproxy/pull/364) ([eimlav](https://github.com/eimlav))
- Remove execute bit on systemd unit file [#354](https://github.com/puppetlabs/puppetlabs-haproxy/pull/354) ([shanemadden](https://github.com/shanemadden))

## [3.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/3.0.1) - 2019-02-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/3.0.0...3.0.1)

## [3.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/3.0.0) - 2019-02-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.2.0...3.0.0)

### Added

- (MODULES-8539) Added 'accepted_payload_size' to resolver [#346](https://github.com/puppetlabs/puppetlabs-haproxy/pull/346) ([genebean](https://github.com/genebean))
- Sergey leskov/servertemplatekwimp [#337](https://github.com/puppetlabs/puppetlabs-haproxy/pull/337) ([LeskovSergey](https://github.com/LeskovSergey))

### Changed
- (FM-7675) - Support has been removed for RHEL 6 [#345](https://github.com/puppetlabs/puppetlabs-haproxy/pull/345) ([david22swan](https://github.com/david22swan))

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

### Other

- Release prep 2.1.0 [#310](https://github.com/puppetlabs/puppetlabs-haproxy/pull/310) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-6457) - PDK convert haproxy [#309](https://github.com/puppetlabs/puppetlabs-haproxy/pull/309) ([pmcmaw](https://github.com/pmcmaw))
- (maint) modulesync 65530a4 Update Travis [#308](https://github.com/puppetlabs/puppetlabs-haproxy/pull/308) ([michaeltlombardi](https://github.com/michaeltlombardi))
- Re-add support for specifying package version in package_ensure [#307](https://github.com/puppetlabs/puppetlabs-haproxy/pull/307) ([antaflos](https://github.com/antaflos))
- Release mergeback 2.0.1 [#306](https://github.com/puppetlabs/puppetlabs-haproxy/pull/306) ([tphoney](https://github.com/tphoney))

## [2.0.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.0.1) - 2017-12-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/2.0.0...2.0.1)

### Other

- RubocopChange [#305](https://github.com/puppetlabs/puppetlabs-haproxy/pull/305) ([david22swan](https://github.com/david22swan))
- (maint) - modulesync 384f4c1 [#304](https://github.com/puppetlabs/puppetlabs-haproxy/pull/304) ([tphoney](https://github.com/tphoney))
- 2.0.1PreRelease [#303](https://github.com/puppetlabs/puppetlabs-haproxy/pull/303) ([david22swan](https://github.com/david22swan))
- bump allowed concat module version to 5.0.0 [#302](https://github.com/puppetlabs/puppetlabs-haproxy/pull/302) ([mateusz-gozdek-sociomantic](https://github.com/mateusz-gozdek-sociomantic))
- Release mergeback [#301](https://github.com/puppetlabs/puppetlabs-haproxy/pull/301) ([tphoney](https://github.com/tphoney))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/2.0.0) - 2017-12-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/list...2.0.0)

### Other

- Rubocop Implementation (Waiting on Clean Release) [#300](https://github.com/puppetlabs/puppetlabs-haproxy/pull/300) ([david22swan](https://github.com/david22swan))
- 2.0.0PreRelease [#299](https://github.com/puppetlabs/puppetlabs-haproxy/pull/299) ([david22swan](https://github.com/david22swan))
- (maint) - modulesync 1d81b6a [#298](https://github.com/puppetlabs/puppetlabs-haproxy/pull/298) ([pmcmaw](https://github.com/pmcmaw))
- Puppet4 update [#297](https://github.com/puppetlabs/puppetlabs-haproxy/pull/297) ([willmeek](https://github.com/willmeek))
- (maint) modulesync 892c4cf [#296](https://github.com/puppetlabs/puppetlabs-haproxy/pull/296) ([HAIL9000](https://github.com/HAIL9000))
- Adding spaces in headers for formatting [#295](https://github.com/puppetlabs/puppetlabs-haproxy/pull/295) ([pmcmaw](https://github.com/pmcmaw))
- Removing Debian 6 [#294](https://github.com/puppetlabs/puppetlabs-haproxy/pull/294) ([pmcmaw](https://github.com/pmcmaw))
- fix lint warnings [#293](https://github.com/puppetlabs/puppetlabs-haproxy/pull/293) ([PascalBourdier](https://github.com/PascalBourdier))
- on freebsd haproxy lives on /usr/local/sbin [#292](https://github.com/puppetlabs/puppetlabs-haproxy/pull/292) ([rmdir](https://github.com/rmdir))
- Add haproxy::resolver supported only by haproxy version 1.6+ [#291](https://github.com/puppetlabs/puppetlabs-haproxy/pull/291) ([missingcharacter](https://github.com/missingcharacter))
- (MODULES-5501) - Remove unsupported Ubuntu [#290](https://github.com/puppetlabs/puppetlabs-haproxy/pull/290) ([pmcmaw](https://github.com/pmcmaw))
- Fixed example ports listenning value 18140->8140 [#289](https://github.com/puppetlabs/puppetlabs-haproxy/pull/289) ([tux-o-matic](https://github.com/tux-o-matic))
- (maint) modulesync 915cde70e20 [#288](https://github.com/puppetlabs/puppetlabs-haproxy/pull/288) ([glennsarti](https://github.com/glennsarti))
- (maint) fix let() ordering [#287](https://github.com/puppetlabs/puppetlabs-haproxy/pull/287) ([eputnam](https://github.com/eputnam))
- (WIP) Puppet4 update [#285](https://github.com/puppetlabs/puppetlabs-haproxy/pull/285) ([HelenCampbell](https://github.com/HelenCampbell))

## [list](https://github.com/puppetlabs/puppetlabs-haproxy/tree/list) - 2017-07-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.5.0...list)

### Other

- (MODULES-5187) mysnc puppet 5 and ruby 2.4 [#284](https://github.com/puppetlabs/puppetlabs-haproxy/pull/284) ([eputnam](https://github.com/eputnam))
- Change if $bind_options to if $bind_options != '' [#283](https://github.com/puppetlabs/puppetlabs-haproxy/pull/283) ([jnieuwen](https://github.com/jnieuwen))
- (MODULES-5144) Prep for puppet 5 [#282](https://github.com/puppetlabs/puppetlabs-haproxy/pull/282) ([hunner](https://github.com/hunner))
- [MODULES-4831] bumps puppet version requirement [#puppethack] [#281](https://github.com/puppetlabs/puppetlabs-haproxy/pull/281) ([chadh](https://github.com/chadh))
- Add support for balancermember weights [#280](https://github.com/puppetlabs/puppetlabs-haproxy/pull/280) ([johanek](https://github.com/johanek))
- [msync] 786266 Implement puppet-module-gems, a45803 Remove metadata.json from locales config [#279](https://github.com/puppetlabs/puppetlabs-haproxy/pull/279) ([wilson208](https://github.com/wilson208))
- [maint] modulesync e25ca9 - Add locales folder and config.yaml [#277](https://github.com/puppetlabs/puppetlabs-haproxy/pull/277) ([wilson208](https://github.com/wilson208))
- [MODULES-4556] Remove PE requirement from metadata.json [#276](https://github.com/puppetlabs/puppetlabs-haproxy/pull/276) ([wilson208](https://github.com/wilson208))
- (MODULES-4098) Sync the rest of the files [#275](https://github.com/puppetlabs/puppetlabs-haproxy/pull/275) ([hunner](https://github.com/hunner))
- (MODULES-4097) Sync travis.yml [#273](https://github.com/puppetlabs/puppetlabs-haproxy/pull/273) ([hunner](https://github.com/hunner))
- harden chmod of haproxy config file [#272](https://github.com/puppetlabs/puppetlabs-haproxy/pull/272) ([tphoney](https://github.com/tphoney))
- (FM-5972) gettext and spec.opts [#270](https://github.com/puppetlabs/puppetlabs-haproxy/pull/270) ([eputnam](https://github.com/eputnam))
- (MODULES-3631) msync Gemfile for 1.9 frozen strings [#269](https://github.com/puppetlabs/puppetlabs-haproxy/pull/269) ([hunner](https://github.com/hunner))
- Add verifyhost parameter to balancermember resource [#268](https://github.com/puppetlabs/puppetlabs-haproxy/pull/268) ([JAORMX](https://github.com/JAORMX))
- workaround usage of 'which' in Ubuntu 12.04 (puppet 2.7.11) [#267](https://github.com/puppetlabs/puppetlabs-haproxy/pull/267) ([eumel8](https://github.com/eumel8))
- (MODULES-3704) Update gemfile template to be identical [#266](https://github.com/puppetlabs/puppetlabs-haproxy/pull/266) ([hunner](https://github.com/hunner))
- mocha version update [#265](https://github.com/puppetlabs/puppetlabs-haproxy/pull/265) ([eputnam](https://github.com/eputnam))
- (MODULES-3983) Update parallel_tests for ruby 2.0.0 [#264](https://github.com/puppetlabs/puppetlabs-haproxy/pull/264) ([pmcmaw](https://github.com/pmcmaw))
- Drop :undef values from haproxy config template [#262](https://github.com/puppetlabs/puppetlabs-haproxy/pull/262) ([mks-m](https://github.com/mks-m))
- Update modulesync_config [51f469d] [#261](https://github.com/puppetlabs/puppetlabs-haproxy/pull/261) ([DavidS](https://github.com/DavidS))
- Don't attempt validate_cmd on Puppet < 3.5 [#260](https://github.com/puppetlabs/puppetlabs-haproxy/pull/260) ([andybotting](https://github.com/andybotting))
- allow concat validate_cmd to be configured [#258](https://github.com/puppetlabs/puppetlabs-haproxy/pull/258) ([andrewkro](https://github.com/andrewkro))
- Update modulesync_config [a3fe424] [#257](https://github.com/puppetlabs/puppetlabs-haproxy/pull/257) ([DavidS](https://github.com/DavidS))
- Update modulesync_config [0d59329] [#256](https://github.com/puppetlabs/puppetlabs-haproxy/pull/256) ([DavidS](https://github.com/DavidS))
- (FM-5470) Avoid systemd service flap detection during acceptance testing [#254](https://github.com/puppetlabs/puppetlabs-haproxy/pull/254) ([DavidS](https://github.com/DavidS))
- (MAINT) Update for modulesync_config 72d19f184 [#253](https://github.com/puppetlabs/puppetlabs-haproxy/pull/253) ([DavidS](https://github.com/DavidS))
- (MODULES-3547) Added listen check, fix tests [#252](https://github.com/puppetlabs/puppetlabs-haproxy/pull/252) ([hunner](https://github.com/hunner))
- (MODULES-3581) modulesync [067d08a] [#249](https://github.com/puppetlabs/puppetlabs-haproxy/pull/249) ([DavidS](https://github.com/DavidS))
- {maint} modulesync 0794b2c [#248](https://github.com/puppetlabs/puppetlabs-haproxy/pull/248) ([tphoney](https://github.com/tphoney))
- 1.5.0 Release Mergeback [#247](https://github.com/puppetlabs/puppetlabs-haproxy/pull/247) ([bmjen](https://github.com/bmjen))
- MODULES-2938/restore target feature [#218](https://github.com/puppetlabs/puppetlabs-haproxy/pull/218) ([oshaughnessy](https://github.com/oshaughnessy))

## [1.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.5.0) - 2016-06-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.4.0...1.5.0)

### Added

- add option to use multiple defaults sections [#232](https://github.com/puppetlabs/puppetlabs-haproxy/pull/232) ([vicinus](https://github.com/vicinus))

### Fixed

- (MODULES-3412) Use haproxy::config_file instead of default config_file [#239](https://github.com/puppetlabs/puppetlabs-haproxy/pull/239) ([ctiml](https://github.com/ctiml))

### Other

- Trying to fix CI [#246](https://github.com/puppetlabs/puppetlabs-haproxy/pull/246) ([bmjen](https://github.com/bmjen))
- Release Prep 1.5.0 [#244](https://github.com/puppetlabs/puppetlabs-haproxy/pull/244) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-3366) Add missing check flag [#243](https://github.com/puppetlabs/puppetlabs-haproxy/pull/243) ([hunner](https://github.com/hunner))
- Add /etc/sysconfig/haproxy(instance_name) support [#242](https://github.com/puppetlabs/puppetlabs-haproxy/pull/242) ([sjoeboo](https://github.com/sjoeboo))
- (maint) removes default-server keyword from test [#241](https://github.com/puppetlabs/puppetlabs-haproxy/pull/241) ([bmjen](https://github.com/bmjen))
- (maint) Fixes acceptance test error on CI [#240](https://github.com/puppetlabs/puppetlabs-haproxy/pull/240) ([bmjen](https://github.com/bmjen))
- Update to newest modulesync_configs [9ca280f] [#237](https://github.com/puppetlabs/puppetlabs-haproxy/pull/237) ([DavidS](https://github.com/DavidS))
- (MODULES-3258) Validate the config before adding it [#236](https://github.com/puppetlabs/puppetlabs-haproxy/pull/236) ([hunner](https://github.com/hunner))
- (maint) adjust tests to work under strict_variables [#234](https://github.com/puppetlabs/puppetlabs-haproxy/pull/234) ([DavidS](https://github.com/DavidS))
-  (MODULES-3055) Add mailers [#231](https://github.com/puppetlabs/puppetlabs-haproxy/pull/231) ([hunner](https://github.com/hunner))
- Missed dependency [#230](https://github.com/puppetlabs/puppetlabs-haproxy/pull/230) ([hunner](https://github.com/hunner))
- Socat is way better than netcat [#229](https://github.com/puppetlabs/puppetlabs-haproxy/pull/229) ([hunner](https://github.com/hunner))
- bugfix: correct class for sort_options_alphabetic acceptance test [#228](https://github.com/puppetlabs/puppetlabs-haproxy/pull/228) ([vicinus](https://github.com/vicinus))
- Concat Dependancy Update [#227](https://github.com/puppetlabs/puppetlabs-haproxy/pull/227) ([HelenCampbell](https://github.com/HelenCampbell))
- No longer add $ensure to balancermember concat fragments [#226](https://github.com/puppetlabs/puppetlabs-haproxy/pull/226) ([jyaworski](https://github.com/jyaworski))
- Fix indent/formatting of config samples in README [#225](https://github.com/puppetlabs/puppetlabs-haproxy/pull/225) ([antaflos](https://github.com/antaflos))
- improve ordering of options [#224](https://github.com/puppetlabs/puppetlabs-haproxy/pull/224) ([vicinus](https://github.com/vicinus))
- (FM-4046) Update to current msync configs [006831f] [#223](https://github.com/puppetlabs/puppetlabs-haproxy/pull/223) ([DavidS](https://github.com/DavidS))
- Fix markup around section "Manage a map file" [#222](https://github.com/puppetlabs/puppetlabs-haproxy/pull/222) ([antaflos](https://github.com/antaflos))
- Clarify readme [#220](https://github.com/puppetlabs/puppetlabs-haproxy/pull/220) ([alexharv074](https://github.com/alexharv074))
- (FM-4049) update to modulesync_configs [#219](https://github.com/puppetlabs/puppetlabs-haproxy/pull/219) ([DavidS](https://github.com/DavidS))
- Add docs on how-to setup stick-tables [#217](https://github.com/puppetlabs/puppetlabs-haproxy/pull/217) ([bogdando](https://github.com/bogdando))
- Metadata update to new formatting [#216](https://github.com/puppetlabs/puppetlabs-haproxy/pull/216) ([HelenCampbell](https://github.com/HelenCampbell))
- 1.4.0 merge back to master [#215](https://github.com/puppetlabs/puppetlabs-haproxy/pull/215) ([tphoney](https://github.com/tphoney))
- Only create config_dir in specific cases. [#210](https://github.com/puppetlabs/puppetlabs-haproxy/pull/210) ([pmlee](https://github.com/pmlee))

## [1.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.4.0) - 2016-01-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.3.1...1.4.0)

### Other

- Version 1.4.0 of haproxy [#214](https://github.com/puppetlabs/puppetlabs-haproxy/pull/214) ([HelenCampbell](https://github.com/HelenCampbell))
- Adding mode to backend class [#211](https://github.com/puppetlabs/puppetlabs-haproxy/pull/211) ([DavidS](https://github.com/DavidS))
- Mergeback 1.3.x [#209](https://github.com/puppetlabs/puppetlabs-haproxy/pull/209) ([jonnytdevops](https://github.com/jonnytdevops))
- Fix port parameter name on haproxy::peer defined type [#208](https://github.com/puppetlabs/puppetlabs-haproxy/pull/208) ([tomashejatko](https://github.com/tomashejatko))
- Validate global_options and defaults_options. [#207](https://github.com/puppetlabs/puppetlabs-haproxy/pull/207) ([tlimoncelli](https://github.com/tlimoncelli))
- Add support for managing map files [#203](https://github.com/puppetlabs/puppetlabs-haproxy/pull/203) ([antaflos](https://github.com/antaflos))
- Remove ssl-hello-chk from default options [#200](https://github.com/puppetlabs/puppetlabs-haproxy/pull/200) ([jpadams](https://github.com/jpadams))

## [1.3.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.3.1) - 2015-12-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.3.0...1.3.1)

### Other

- 1.3.1 release prep [#206](https://github.com/puppetlabs/puppetlabs-haproxy/pull/206) ([tphoney](https://github.com/tphoney))
- Match only on strings because ruby1.8-- [#205](https://github.com/puppetlabs/puppetlabs-haproxy/pull/205) ([hunner](https://github.com/hunner))
- Merge global and default options with user-supplied options [#202](https://github.com/puppetlabs/puppetlabs-haproxy/pull/202) ([antaflos](https://github.com/antaflos))
- (MODULES-2704) Consistent use of ::haproxy::config_file [#201](https://github.com/puppetlabs/puppetlabs-haproxy/pull/201) ([traylenator](https://github.com/traylenator))
- Merge 1.3.x back to master [#199](https://github.com/puppetlabs/puppetlabs-haproxy/pull/199) ([DavidS](https://github.com/DavidS))
- fixed frontend description [#195](https://github.com/puppetlabs/puppetlabs-haproxy/pull/195) ([zoojar](https://github.com/zoojar))
- Allow the contents of /etc/default/haproxy to be overridden [#194](https://github.com/puppetlabs/puppetlabs-haproxy/pull/194) ([DavidS](https://github.com/DavidS))
- Update examples to use seconds (default is ms) [#193](https://github.com/puppetlabs/puppetlabs-haproxy/pull/193) ([ryanschwartz](https://github.com/ryanschwartz))
- prevent warning on puppet 4 [#191](https://github.com/puppetlabs/puppetlabs-haproxy/pull/191) ([mlehner616](https://github.com/mlehner616))
- Add haproxy::instance for the creation of multiple instances of haproxy [#166](https://github.com/puppetlabs/puppetlabs-haproxy/pull/166) ([tlimoncelli](https://github.com/tlimoncelli))

## [1.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.3.0) - 2015-07-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.2.0...1.3.0)

### Other

- Release 1.3.0 [#190](https://github.com/puppetlabs/puppetlabs-haproxy/pull/190) ([hunner](https://github.com/hunner))
- Add helper to install puppet/pe/puppet-agent [#188](https://github.com/puppetlabs/puppetlabs-haproxy/pull/188) ([hunner](https://github.com/hunner))
- (maint) allow setting PUPPET_VERSION in acceptance [#187](https://github.com/puppetlabs/puppetlabs-haproxy/pull/187) ([justinstoller](https://github.com/justinstoller))
- relax unit test for puppet 2.7 [#186](https://github.com/puppetlabs/puppetlabs-haproxy/pull/186) ([tphoney](https://github.com/tphoney))
- changes to fix puppet4 unit tests [#185](https://github.com/puppetlabs/puppetlabs-haproxy/pull/185) ([tphoney](https://github.com/tphoney))
- Updated travisci file to remove allow_failures on Puppet 4 [#184](https://github.com/puppetlabs/puppetlabs-haproxy/pull/184) ([jonnytdevops](https://github.com/jonnytdevops))
- ignore the log directory [#183](https://github.com/puppetlabs/puppetlabs-haproxy/pull/183) ([tphoney](https://github.com/tphoney))
- Rewrite README per DOC-1499 [#182](https://github.com/puppetlabs/puppetlabs-haproxy/pull/182) ([psoloway](https://github.com/psoloway))
- Modulesync updates [#181](https://github.com/puppetlabs/puppetlabs-haproxy/pull/181) ([underscorgan](https://github.com/underscorgan))
- Add Suse to list of supported OSes [#180](https://github.com/puppetlabs/puppetlabs-haproxy/pull/180) ([voroniys](https://github.com/voroniys))
- gentoo compatibility [#179](https://github.com/puppetlabs/puppetlabs-haproxy/pull/179) ([tphoney](https://github.com/tphoney))
- Adds documentation to peer and peers resource types [#178](https://github.com/puppetlabs/puppetlabs-haproxy/pull/178) ([melan](https://github.com/melan))
- Implement `options` as array of hashes so order is preserved [#173](https://github.com/puppetlabs/puppetlabs-haproxy/pull/173) ([antaflos](https://github.com/antaflos))
- (BKR-147) add Gemfile setting for BEAKER_VERSION for puppet... [#169](https://github.com/puppetlabs/puppetlabs-haproxy/pull/169) ([anodelman](https://github.com/anodelman))
- (WIP) Testing updates [#168](https://github.com/puppetlabs/puppetlabs-haproxy/pull/168) ([cmurphy](https://github.com/cmurphy))
- Remove extraneous spaces. Update tests to reflect change. [#167](https://github.com/puppetlabs/puppetlabs-haproxy/pull/167) ([tlimoncelli](https://github.com/tlimoncelli))
- Merge 1.2.x to master [#165](https://github.com/puppetlabs/puppetlabs-haproxy/pull/165) ([underscorgan](https://github.com/underscorgan))
- make it future parser compatible [#162](https://github.com/puppetlabs/puppetlabs-haproxy/pull/162) ([duritong](https://github.com/duritong))

## [1.2.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.2.0) - 2015-03-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.1.0...1.2.0)

### Added

- Peers feature [#125](https://github.com/puppetlabs/puppetlabs-haproxy/pull/125) ([josecastroleon](https://github.com/josecastroleon))
- Add support for loadbalancer member without ports [#120](https://github.com/puppetlabs/puppetlabs-haproxy/pull/120) ([ericlaflamme](https://github.com/ericlaflamme))

### Other

- 1.2.0 prep [#161](https://github.com/puppetlabs/puppetlabs-haproxy/pull/161) ([underscorgan](https://github.com/underscorgan))
- Lint cleanup [#160](https://github.com/puppetlabs/puppetlabs-haproxy/pull/160) ([underscorgan](https://github.com/underscorgan))
- Renames tests directory examples [#159](https://github.com/puppetlabs/puppetlabs-haproxy/pull/159) ([underscorgan](https://github.com/underscorgan))
- Missing ensure for peer [#156](https://github.com/puppetlabs/puppetlabs-haproxy/pull/156) ([underscorgan](https://github.com/underscorgan))
- Make `bind` parameter processing more flexible [#154](https://github.com/puppetlabs/puppetlabs-haproxy/pull/154) ([antaflos](https://github.com/antaflos))
- Pin rspec gems [#153](https://github.com/puppetlabs/puppetlabs-haproxy/pull/153) ([cmurphy](https://github.com/cmurphy))
- future parser fix [#151](https://github.com/puppetlabs/puppetlabs-haproxy/pull/151) ([underscorgan](https://github.com/underscorgan))
- adding a default option into nodesets [#150](https://github.com/puppetlabs/puppetlabs-haproxy/pull/150) ([tphoney](https://github.com/tphoney))
- add support for freebsd [#148](https://github.com/puppetlabs/puppetlabs-haproxy/pull/148) ([sethlyons](https://github.com/sethlyons))
- Modules 1497 [#147](https://github.com/puppetlabs/puppetlabs-haproxy/pull/147) ([tphoney](https://github.com/tphoney))
- Set ipaddress default value to undef [#146](https://github.com/puppetlabs/puppetlabs-haproxy/pull/146) ([sergakaibis](https://github.com/sergakaibis))
- Corrected namespaces on variables [#145](https://github.com/puppetlabs/puppetlabs-haproxy/pull/145) ([t0mmyt](https://github.com/t0mmyt))
- MODULES-1619 Add haproxy version fact [#144](https://github.com/puppetlabs/puppetlabs-haproxy/pull/144) ([petems](https://github.com/petems))
- Fix the TOC in the README [#142](https://github.com/puppetlabs/puppetlabs-haproxy/pull/142) ([matthewfischer](https://github.com/matthewfischer))
- Sync with modulesync [#141](https://github.com/puppetlabs/puppetlabs-haproxy/pull/141) ([cmurphy](https://github.com/cmurphy))
- Fixed RedHat name for osfamily case [#137](https://github.com/puppetlabs/puppetlabs-haproxy/pull/137) ([gildub](https://github.com/gildub))
- Update for using Geppetto plugin in CI [#136](https://github.com/puppetlabs/puppetlabs-haproxy/pull/136) ([justinstoller](https://github.com/justinstoller))
- FM-1523: Added module summary to metadata.json [#134](https://github.com/puppetlabs/puppetlabs-haproxy/pull/134) ([jbondpdx](https://github.com/jbondpdx))
- (maint) Allow setting gem mirror via GEM_SOURCE env var [#133](https://github.com/puppetlabs/puppetlabs-haproxy/pull/133) ([justinstoller](https://github.com/justinstoller))
- merge 1.1.x into master [#131](https://github.com/puppetlabs/puppetlabs-haproxy/pull/131) ([underscorgan](https://github.com/underscorgan))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.1.0) - 2014-11-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/1.0.0...1.1.0)

### Other

- 1.1.0 prep [#130](https://github.com/puppetlabs/puppetlabs-haproxy/pull/130) ([underscorgan](https://github.com/underscorgan))
- Remove deprecated concat::setup class [#129](https://github.com/puppetlabs/puppetlabs-haproxy/pull/129) ([blkperl](https://github.com/blkperl))
- Fix issue with puppet_module_install, removed and using updated method f... [#126](https://github.com/puppetlabs/puppetlabs-haproxy/pull/126) ([cyberious](https://github.com/cyberious))
- Spec updates for consistency [#123](https://github.com/puppetlabs/puppetlabs-haproxy/pull/123) ([underscorgan](https://github.com/underscorgan))
- Allow greater flexibility in listen directive. [#119](https://github.com/puppetlabs/puppetlabs-haproxy/pull/119) ([Spredzy](https://github.com/Spredzy))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/1.0.0) - 2014-07-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.5.0...1.0.0)

### Fixed

- Add checks for passive failover and PE module paths [#107](https://github.com/puppetlabs/puppetlabs-haproxy/pull/107) ([hunner](https://github.com/hunner))

### Other

- The spec helper should only run on supported platforms [#118](https://github.com/puppetlabs/puppetlabs-haproxy/pull/118) ([hunner](https://github.com/hunner))
- CentOS 5 gets haproxy from epel [#117](https://github.com/puppetlabs/puppetlabs-haproxy/pull/117) ([hunner](https://github.com/hunner))
- Rearrange helper to run tests standalone [#116](https://github.com/puppetlabs/puppetlabs-haproxy/pull/116) ([hunner](https://github.com/hunner))
- Release 1.0.0 [#115](https://github.com/puppetlabs/puppetlabs-haproxy/pull/115) ([hunner](https://github.com/hunner))
- Add redhat 7 and ubuntu 14.04 compatibility info [#114](https://github.com/puppetlabs/puppetlabs-haproxy/pull/114) ([hunner](https://github.com/hunner))
- A few variable linting issues [#113](https://github.com/puppetlabs/puppetlabs-haproxy/pull/113) ([hunner](https://github.com/hunner))
- Test that windows receives the incompatibility failure [#112](https://github.com/puppetlabs/puppetlabs-haproxy/pull/112) ([hunner](https://github.com/hunner))
- Fix concat module name in the docs [#111](https://github.com/puppetlabs/puppetlabs-haproxy/pull/111) ([adamcrews](https://github.com/adamcrews))
- OSX not compatible, and windows doesn't have hieraconf [#110](https://github.com/puppetlabs/puppetlabs-haproxy/pull/110) ([hunner](https://github.com/hunner))
- Add backports for debian testing [#109](https://github.com/puppetlabs/puppetlabs-haproxy/pull/109) ([hunner](https://github.com/hunner))
- Disable userlist tests on rhel5 osfamily [#108](https://github.com/puppetlabs/puppetlabs-haproxy/pull/108) ([hunner](https://github.com/hunner))
- Only support PE 3.3.x [#106](https://github.com/puppetlabs/puppetlabs-haproxy/pull/106) ([hunner](https://github.com/hunner))
- dont assume foss paths for hiera.yaml [#105](https://github.com/puppetlabs/puppetlabs-haproxy/pull/105) ([justinstoller](https://github.com/justinstoller))
- Readme [#104](https://github.com/puppetlabs/puppetlabs-haproxy/pull/104) ([hunner](https://github.com/hunner))
- Update specs to work on more operatingsystems [#103](https://github.com/puppetlabs/puppetlabs-haproxy/pull/103) ([hunner](https://github.com/hunner))
- Fix the metadata after build [#101](https://github.com/puppetlabs/puppetlabs-haproxy/pull/101) ([hunner](https://github.com/hunner))
- Prepare a 0.5.1 release. [#100](https://github.com/puppetlabs/puppetlabs-haproxy/pull/100) ([apenney](https://github.com/apenney))
- Fix puppet-lint tests [#98](https://github.com/puppetlabs/puppetlabs-haproxy/pull/98) ([adamgraves-choices](https://github.com/adamgraves-choices))
- Update specs with lots of test cases [#97](https://github.com/puppetlabs/puppetlabs-haproxy/pull/97) ([hunner](https://github.com/hunner))
- Update the readme to look something like the readme template [#96](https://github.com/puppetlabs/puppetlabs-haproxy/pull/96) ([hunner](https://github.com/hunner))
- Correctly privetize define [#95](https://github.com/puppetlabs/puppetlabs-haproxy/pull/95) ([hunner](https://github.com/hunner))
- Add bind_options for frontends [#94](https://github.com/puppetlabs/puppetlabs-haproxy/pull/94) ([hunner](https://github.com/hunner))
- Define each server/port combination on its own line [#93](https://github.com/puppetlabs/puppetlabs-haproxy/pull/93) ([hunner](https://github.com/hunner))
- Avoid mixing up backend servers [#92](https://github.com/puppetlabs/puppetlabs-haproxy/pull/92) ([hunner](https://github.com/hunner))
- Reduce template code duplication [#91](https://github.com/puppetlabs/puppetlabs-haproxy/pull/91) ([hunner](https://github.com/hunner))
- Add custom_fragment parameter [#89](https://github.com/puppetlabs/puppetlabs-haproxy/pull/89) ([hunner](https://github.com/hunner))
- Fix the mkdir for moduledir [#88](https://github.com/puppetlabs/puppetlabs-haproxy/pull/88) ([hunner](https://github.com/hunner))
- Add chroot ownership [#87](https://github.com/puppetlabs/puppetlabs-haproxy/pull/87) ([hunner](https://github.com/hunner))
- haproxy::userlist resource [#85](https://github.com/puppetlabs/puppetlabs-haproxy/pull/85) ([kitchen](https://github.com/kitchen))
- Remove warnings when storeconfigs is not being used [#81](https://github.com/puppetlabs/puppetlabs-haproxy/pull/81) ([yasn77](https://github.com/yasn77))
- Fix ordering of options changing [#69](https://github.com/puppetlabs/puppetlabs-haproxy/pull/69) ([lboynton](https://github.com/lboynton))

## [0.5.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.5.0) - 2014-05-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.4.1...0.5.0)

### Other

- Prepare for 0.5.0 release. [#86](https://github.com/puppetlabs/puppetlabs-haproxy/pull/86) ([underscorgan](https://github.com/underscorgan))
- Add haproxy::listen bind_options parameter for setting arbitrary 'bind' options [#82](https://github.com/puppetlabs/puppetlabs-haproxy/pull/82) ([misterdorm](https://github.com/misterdorm))
- Rewrite with install/config/service classes, and correct parameter naming. [#80](https://github.com/puppetlabs/puppetlabs-haproxy/pull/80) ([hunner](https://github.com/hunner))
- Remove redundant params section [#79](https://github.com/puppetlabs/puppetlabs-haproxy/pull/79) ([kurthuwig](https://github.com/kurthuwig))
- Add Travis build status to README [#78](https://github.com/puppetlabs/puppetlabs-haproxy/pull/78) ([blkperl](https://github.com/blkperl))
- Pin Rake to ~> 10.1 to support Ruby 1.8.7 [#77](https://github.com/puppetlabs/puppetlabs-haproxy/pull/77) ([blkperl](https://github.com/blkperl))
- Archlinux Support added. [#70](https://github.com/puppetlabs/puppetlabs-haproxy/pull/70) ([aboe76](https://github.com/aboe76))
- Standardized module docs [#68](https://github.com/puppetlabs/puppetlabs-haproxy/pull/68) ([retr0h](https://github.com/retr0h))
- Moved from `#include_class` to `#contain_class` [#67](https://github.com/puppetlabs/puppetlabs-haproxy/pull/67) ([retr0h](https://github.com/retr0h))
- Add missing LICENSE file [#66](https://github.com/puppetlabs/puppetlabs-haproxy/pull/66) ([toabctl](https://github.com/toabctl))
- Support minus in service names [#60](https://github.com/puppetlabs/puppetlabs-haproxy/pull/60) ([ymc-dabe](https://github.com/ymc-dabe))
- Allow user-defined service restart parameter. [#57](https://github.com/puppetlabs/puppetlabs-haproxy/pull/57) ([bleach](https://github.com/bleach))
- Prepare 0.4.1 release. [#56](https://github.com/puppetlabs/puppetlabs-haproxy/pull/56) ([apenney](https://github.com/apenney))

## [0.4.1](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.4.1) - 2013-10-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.4.0...0.4.1)

### Other

- Use puppetlabs/concat [#55](https://github.com/puppetlabs/puppetlabs-haproxy/pull/55) ([hunner](https://github.com/hunner))
- Prepare 0.4.0 release. [#53](https://github.com/puppetlabs/puppetlabs-haproxy/pull/53) ([apenney](https://github.com/apenney))
- Fix test description [#51](https://github.com/puppetlabs/puppetlabs-haproxy/pull/51) ([bleach](https://github.com/bleach))

## [0.4.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.4.0) - 2013-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/0.3.0...0.4.0)

### Other

- Update travis, add Gemfile. [#54](https://github.com/puppetlabs/puppetlabs-haproxy/pull/54) ([apenney](https://github.com/apenney))
- Prepare 0.4.0 release. [#53](https://github.com/puppetlabs/puppetlabs-haproxy/pull/53) ([apenney](https://github.com/apenney))
- Update CHANGELOG [#45](https://github.com/puppetlabs/puppetlabs-haproxy/pull/45) ([godp1301](https://github.com/godp1301))
- Add an ensure parameter to balancermember. [#43](https://github.com/puppetlabs/puppetlabs-haproxy/pull/43) ([bleach](https://github.com/bleach))
- Add parameter to specify an alternate package name to install [#42](https://github.com/puppetlabs/puppetlabs-haproxy/pull/42) ([rharrison10](https://github.com/rharrison10))
- remove deprecation warnings from templates [#39](https://github.com/puppetlabs/puppetlabs-haproxy/pull/39) ([kitchen](https://github.com/kitchen))
- adds backend and frontend config sections [#37](https://github.com/puppetlabs/puppetlabs-haproxy/pull/37) ([kitchen](https://github.com/kitchen))
- Release 0.3.0 [#35](https://github.com/puppetlabs/puppetlabs-haproxy/pull/35) ([hunner](https://github.com/hunner))
- Made chroot optional [#27](https://github.com/puppetlabs/puppetlabs-haproxy/pull/27) ([francois](https://github.com/francois))

## [0.3.0](https://github.com/puppetlabs/puppetlabs-haproxy/tree/0.3.0) - 2013-05-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-haproxy/compare/c4799e59b9d9891e6c296c554a11814f14a5abfc...0.3.0)
