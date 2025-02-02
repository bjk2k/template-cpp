# Red-Panda Template app

This is a cpp template app for personal development after [this reference template](https://github.com/storvik/nix-templates.git).
Structure is based on [The Pitchfork Layout](https://github.com/vector-of-bool/pitchfork).

## Development

Development can be done in a `nix shell` by running which is also available
with `nix-direnv`

```shell
nix develop
mkdir build
cmake -Bbuild -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
cd build
ninja
```

Building with nix works with:

```shell
nix build ".?submodules=1#" -L
```

In order to build and run tests there's a `<app-name>` package that can be used.
This sets `doCheck = true` and adds `-DENABLE_TESTING=ON`cmake flag.

```shell
nix build .#<app-name> --print-build-logs
nix build
```

## Project Customization

```shell
grep --exclude=README.md -rl redPandaTemplateApp . | xargs sed -i 's/mylib/mysuperapp/g'

```
