#!/usr/bin/env python
from distutils.core import setup
long_description = 'Tests for installing and distributing Python packages'
setup(name = 'testpackages',
	version = '1.0a',
	description = 'Tests for Python packages',
	maintainer = 'Thomas Thaliath',
	maintainer_email = 'tthaliath@gmail.com',
	url = 'http://www.tickerlick.com',
	long_description = long_description,
	packages = ['testpackages']
	)
