## 8.2.1 (Withdrawn)
### Summary
This version was mistakenly published as a patch release despite dropping Puppet 7 support, a backwards-incompatible change. It has been removed from the Puppet Forge and superseded by `9.0.0`, which correctly reflects this change as a major version bump. Do not use `8.2.1`.

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
