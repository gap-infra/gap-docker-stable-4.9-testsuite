[![Build Status](https://travis-ci.org/gap-system/gap-docker-stable-4.9-testsuite.svg?branch=master)](https://travis-ci.org/gap-system/gap-docker-stable-4.9-testsuite)

# gap-docker-stable-4.9-testsuite

This repository is used to run GAP test suite using the Docker container
with GAP from the tip of the stable-4.9 branch and packages from the archive
https://www.gap-system.org/pub/gap/gap4pkgs/packages-stable-4.9.tar.gz

This Travis test allows everyone (not only to those who can access Jenkins)
to see how testinstall/standard/bugfix behaves with no packages, with default
packages, and with all packages loaded, using the GAP Docker container for
the stable-4.9 branch with packages from the packages-stable-4.9.tar.gz archive.

This is Travis CI cron job, scheduled to run daily.
