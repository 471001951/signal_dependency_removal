# Signal dependency removal

The Signal package provided by the Signal Foundation through its repository uses a deprecated library.
Their package won't install on Debian Testing at this point.

The Dockerfile provided will repackage with the dependency updated.

## How to use

1. `cd` into this repository
2. `docker build -t signal_dependency_removal .` to build the image
3. `docker run signal_dependency_removal > signal.deb` to get an updated package
4. `sudo dpkg -i signal.deb` to install the package
5. `rm signal.deb` to get rid of the package file
