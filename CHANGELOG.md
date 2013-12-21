# CHANGELOG for nginx

This file is used to list changes made in each version of nginx.

## 0.5.4 (2013-11-14)

* Add `phusion` repository source option
* Fix ensure log directory exists

## 0.5.3 (2013-11-13)

* Delay service restart on config file updates
* Fix template restart notifications
* Add `mime.types` file
* Fix service startup via chef

## 0.5.2 (2013-11-12)

* Don't start, only enable the service since 1.4.x starts automatically and errors

## 0.5.1 (2013-11-12)

* Add missed default attribute from `0.5.0` release

## 0.5.0 (2013-11-12)

* Make installation package names configurable
* Only start the service if not already running

## 0.4.6 (2013-08-09)

* Add `skip_default_site` attribute

## 0.4.5 (2013-06-27)

* Add option to use PPA repository

## 0.4.4 (2013-06-27)

* Add attribute for nginx version
* Cleanup development files

## 0.4.3 (2013-04-09)

* Add attribute for nginx status port
* Update executable bit for directories
* Add missing LICENSE file

## 0.4.2 (2013-02-02)

* Prevent unnecessary `apt-get update` run

## 0.4.1 (2013-02-01)

* FC023: Prefer conditional attributes

## 0.4.0 (2013-02-01)

* Make `stub_status` support optional

## 0.3.0 (2013-01-18)

* Ensure `sites-available` and `sites-enabled` directories exist

## 0.2.0 (2013-01-18)

* Replace `light` recipe with `server` and `debug` recipes.

## 0.1.0:

* Initial release of nginx
