# ResourceKit
![Version](https://img.shields.io/badge/version-0.5.5-000000.svg) ![License MIT](https://img.shields.io/badge/license-MIT-blue.svg) 

ResourceKit is a framework for reading and handling the legacy ResourceFork/ResourceFile format. This is not intended as a mechanism for storing new data in modern projects, but rather as a way for modern projects to access and utilise data in old files.

The ResourceFork (commonly used under Classic Mac OS) was used to store data and assets for applications, and during the transistion to Mac OS X a flattened version, the `.rsrc` file was created. Both of these are now in a state of deprecation and all of their functionality is contained with the "Carbon" umbrella of frameworks. It is a shame that access to these files will eventually be lost on newer machines.

This framework aims to lessen that loss by ensuring access to those files is still possible.