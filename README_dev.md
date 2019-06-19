# Getting Started
  
## Requirements

- XCode 10.2~
- Homebrew 2.1.0~
- Carthage 0.32.0~
- Swiftlint 0.27.0~

## Setup

```sh
brew install swiftlint
brew install carthge
carthage bootstrap --platform iOS --no-use-binaries --cache-builds
```

## Lint

```sh
swiftlint
```
or
```sh
swiftlint autocorrect
```

