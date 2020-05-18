andrewrothstein.cmake
=========
[![Build Status](https://travis-ci.org/andrewrothstein/ansible-cmake.svg?branch=master)](https://travis-ci.org/andrewrothstein/ansible-cmake)

Installs [CMake](https://cmake.org/)

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.cmake
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
