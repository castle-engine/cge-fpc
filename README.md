# FPC (Free Pascal Compiler) version that is easy to distribute together with CGE

This repository contains our infrastructure to build FPC [Free Pascal Compiler](https://www.freepascal.org/) version that we can easily distribute together with [Castle Game Engine](https://castle-engine.io/download) binary download.

The scripts are organized in [GitHub Actions](https://castle-engine.io/github_actions) workflows inside the `.github` subdirectory.

## Why

- The goal of this is to provide ready working FPC along with the CGE download for people who don't want to use FPC outside of CGE.

    Maybe they are new to Pascal, maybe they are new to FPC, maybe they just _"want something that works with CGE as easily as possible"_ and don't care about having specific FPC version etc.

    It is important that CGE works as "out of the box" as it can, to be friendly to new users. Part of this is that you can _"just download Castle Game Engine, create new project from template, hit F9 and it builds and runs"_.

- We don't fork FPC here.

    - Because we don't want to have additional maintenance burden of synchronizing it.

    - Because we always want to allow [using FPC as distributed by FPC team](https://castle-engine.io/supported_compilers.php) and we're proud of it. This repository just provides an option, easy option, for people who don't want/need to manually get FPC from https://www.freepascal.org/ or https://www.lazarus-ide.org/ .

## How

- We want a binary FPC build, as a simple zip, for major platforms supported by CGE.

- This repository contains [GitHub Actions](https://castle-engine.io/github_actions) workflows (see inside `.github` subdirectory) to build FPC for major CGE supported platforms. For now:

    - Windows/x86_64
    - Linux/x86_64
    - Linux/Arm (32-bit Raspberry Pi)
    - Linux/Aarch64 (64-bit Raspberry Pi)
    - macOS/x86_64

    The results of the workflows are released as GitHub Releases with `snapshot` tag.

    They will later be placed in CGE binary download.

- FPC is build, installed and packaged to a simple zip. Later, such bundle is included in CGE binary download.

- Note: We **don't** use binary downloads from https://sourceforge.net/projects/lazarus/files/ , as for Windows they only contain FPC in exe (installer) format and they don't provide zip for Linux. We don't use binary downloads from https://sourceforge.net/projects/freepascal/files/ as for Windows they only provide Win32 installers (and not Win64 that is expected by most users).

    Building FPC ourselves, as a simple zip for all platforms we need, is simplest.

Note: We have also repo where we build Lazarus, https://github.com/castle-engine/cge-lazarus . But it has more limited use-case now (as we don't bundle Lazarus with CGE).

## Future

- This may be extended to include cross-compilers. In particular

    - between `Linux/x86_64` and `Windows/x86_64`
    - to Android (`Android/Arm`, `Android/Aarch64`), from all other platforms.
