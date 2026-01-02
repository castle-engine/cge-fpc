# FPC (Free Pascal Compiler) version that is easy to distribute together with CGE

This repository contains our infrastructure to build FPC [Free Pascal Compiler](https://www.freepascal.org/) version that we can easily distribute together with [Castle Game Engine](https://castle-engine.io/download) binary download.

This includes:

- bash script in [build_fpc](build_fpc) file.
- bootstrap FPC binaries, in [bootstrap-fpc/](bootstrap-fpc/) subdirectory.
- [GitHub Actions](https://castle-engine.io/github_actions) workflow, in [.github/workflows/build.yml](.github/workflows/build.yml) file.

The resulting FPC build is released as [snapshot](https://github.com/castle-engine/cge-fpc/releases/tag/snapshot) release.

The FPC version is determined here, as the "best stable FPC version on given platform" (3.2.2 or 3.2.3 now, depending on the platform).

While the primary use-case is that people download [Castle Game Engine bundled with FPC](https://castle-engine.io/download) and use it, you can also
- directly download the FPC build from [snapshot release](https://github.com/castle-engine/cge-fpc/releases/tag/snapshot) and use it.
- You can also just run `build_fpc` script yourself, to build FPC for your platform. It's a regular bash script and we put effort that it "just works" on all platforms. All you need is a basic set of Unix tools (on Windows, make sure you have MSys2/Cygwin installed).

## Why

Goal: Provide ready precompiled FPC to later be included ("bundled") with the [CGE download](https://castle-engine.io/download).

For:

- This "bundled FPC in CGE download" is for people who don't want to use FPC outside of CGE.

- Maybe they are new to Pascal, maybe they are new to FPC, maybe they just _"want something that works with CGE as easily as possible"_ and don't care about having specific FPC version etc.

- It is important that CGE works as "out of the box" as it can, to be friendly to new users. Part of this is that you can _"just download Castle Game Engine, create new project from template, hit F9 and it builds and runs"_.

Note that we don't fork FPC here.

- We merely download upstream FPC sources and build them, following recommended FPC practices (proper bootstrap FPC).

- So we don't have any additional maintenance burden to synchronize FPC sources. Each run of [build_fpc](build_fpc) script just downloads latest FPC sources from https://gitlab.com/freepascal.org/fpc/source .

- This way, we also always allow [using FPC as distributed by FPC team](https://castle-engine.io/supported_compilers.php) with CGE. Using "bundled FPC" with CGE is just an option, an easy option for people who don't want/need to manually get FPC from https://www.freepascal.org/ or https://www.lazarus-ide.org/ . But it's only an option, you can still use any other FPC version you want.

## How

- We want a binary FPC build, as a simple zip, for major platforms supported by CGE.

- This repository contains [GitHub Actions](https://castle-engine.io/github_actions) workflows (see inside `.github` subdirectory) to build FPC for major CGE supported platforms.

    See the [snapshot release assets](https://github.com/castle-engine/cge-fpc/releases/tag/snapshot) for a list of available OS/CPU combinations.

- FPC is build, installed and packaged to a simple zip. Later, this zip is included in CGE binary download (this is handled during CGE build).

- Note: We **don't** use binary downloads from https://sourceforge.net/projects/lazarus/files/ , for various reasons they are not good enough.

    E.g. for Windows they only contain FPC in exe (installer) format. They don't provide zip for Linux.

    We also don't use binary downloads from https://sourceforge.net/projects/freepascal/ .They don't provide Win64 compiler (only Win32, unexpected by most users).

    We also need to use FPC 3.2.3 (fixed branch) on some platforms. We can decide about it here, and later CGE build process can just take the version from this repo as "best stable version".

    Building FPC ourselves, as a simple zip for all platforms we need, is simplest.

Note: We have also repo where we build Lazarus, https://github.com/castle-engine/cge-lazarus . But it has more limited use-case now (as we don't bundle Lazarus with CGE).

## Future

- This may be extended to include cross-compilers. In particular

    - between `Linux/x86_64` and `Windows/x86_64`
    - to Android (`Android/Arm`, `Android/Aarch64`), from all other platforms.
