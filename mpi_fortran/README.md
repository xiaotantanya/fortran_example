# OpenMuPRO

[![OpenMuPRO Build & Test](https://github.com/muprosoftware/openmupro/actions/workflows/build_test.yml/badge.svg)](https://github.com/muprosoftware/openmupro/actions/workflows/build_test.yml)

openmupro is **NOT** an open source software, the source code is only available to the buyers of Mu-PRO software. We welcome all buyers to actively contribute to the openmupro project, by sharing your code and experience with the Mu-PRO community, we can accumulate more features and use cases in our repository.

## License
Full license can be found in the **License** file. In plain language, here are the main points of our license:
- only buyers of Mu-PRO software can use these codes
- buyers cannot redistribute the codes or modification of the codes in any form
- buyers cannot distribute binaries compile from the codes or modification of the codes

## Install scripts
```
# full command with three arguments
sh <(curl -s https://download.muprosoftware.com/install.sh) muprosdk latest-debug ubuntu-22.04
# Or use a shorter command
sh <(curl -s https://download.muprosoftware.com/install.sh) 
# Install an apps
sh <(curl -s https://download.muprosoftware.com/install.sh) muFerro
```

## Folders
- **docker**: docker files for a simple Mu-PRO environment
- **library**: commonly used utilities for server software. The libopenmupro is used by our close-sourced muprosdk.
- **clibrary**: other commonly used utilities for the desktop software. We are still working on merging the library and clibrary.
- **gui**: shared GUI code between different desktop software.
- **cmake**, the cmake modules folder
- **playground**, a playground for you to test out different ideas

## Commands

To build the program
```
cmake --preset="linux-Debug" -S "."
cmake --build --preset="linux-Debug"
```

To develop the docs
```
pnpm install
pnpm dev:docs
```


## GUI

To achieve cross-platfom gui using one set of code, I choose electronjs + Reactjs + Antd + VTK + vite and typescript. So to develop the graphical interface, you need to have at least some familiarity with these web technologies.

## Intel oneapi on WSL2

https://www.intel.com/content/www/us/en/developer/articles/technical/vs-code-wsl2-and-oneapi-cross-platform-development.html