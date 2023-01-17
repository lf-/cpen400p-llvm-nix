## LLVM pass sample for CPEN400P in Nix

This repository provides a sample of writing a LLVM pass in a Nix environment.
It's somewhat banged together quickly (for instance, I haven't implemented
building it with Nix, just a dev shell). I have provided the tools you should
have.

It uses out-of-tree LLVM, entirely avoiding building LLVM ourselves.

Resources used:
- https://github.com/banach-space/llvm-tutor/blob/main/HelloWorld/HelloWorld.cpp
- https://llvm.org/docs/WritingAnLLVMPass.html#setting-up-the-build-environment
- https://llvm.org/docs/WritingAnLLVMPass.html#running-a-pass-with-opt
- https://llvm.org/docs/CMake.html#developing-llvm-passes-out-of-source

## Usage

### Requirements

- Nix installation on any Linux or macOS
  (https://nixos.org/download.html#nix-install-linux)

  Put `extra-experimental-features = nix-command flakes` into
  `~/.config/nix/nix.conf`.
- direnv: https://direnv.net/
- nix-direnv, configured in your direnv config:
  https://github.com/nix-community/nix-direnv

### Getting started

Allow the `.envrc` with `direnv allow`. This will probably build a copy of klee
and afl++.

Build the pass with `cmake -GNinja && ninja`.

Try out the pass like so:

```ShellSession
$ clang -O3 -emit-llvm hello.c -c -o hello.bc
$ opt -enable-new-pm=0 -load HelloPass/libHelloPass.so -legacy-hello-world -disable-output hello.bc
```

### Making the clangd language server work

Put the following somewhere in `$PATH` in a file called `direnv-clangd`. It's a
thin shim that uses direnv to get the clangd package. I think that you can
probably not use this also, since other clangd installs should Just Work.

```bash
#!/bin/sh

direnv exec . clangd "$@"
```

Your editor should then be configured to use `clangd.path` of `direnv-clangd`.
