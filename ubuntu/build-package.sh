#! /bin/bash

# Should be run as fakeroot
chown -R root:root solumns-0.0-2 && \
dpkg-deb --build solumns-0.0-2
