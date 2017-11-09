[![Build Status](https://travis-ci.org/gap-system/gap-docker-master-testsuite.svg?branch=master)](https://travis-ci.org/gap-system/gap-docker-master-testsuite)

# gap-docker-master-testsuite

This repository is used to run GAP test suite using the Docker container
with GAP from the tip of the master branch and packages from the archive
https://www.gap-system.org/pub/gap/gap4pkgs/packages-master.tar.gz

This Travis test allows everyone (not only to those who can access Jenkins)
to see how testinstall/standard/bugfix behaves with no packages, with default
packages, and with all packages loaded, using the GAP Docker container for
the master branch with packages from the packages-master.tar.gz archive.

This is Travis CI cron job, scheduled to run daily.
