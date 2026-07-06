# homebrew-convoy

Homebrew tap for [convoy](https://github.com/myobie/convoy) — the single front door to a
smalltalk agent network (a menubar host app + the `convoy` CLI).

```sh
brew install --cask myobie/convoy/convoy
```

This installs `Convoy.app` to `/Applications` and symlinks the `convoy` CLI onto your PATH.

> The current build is a demo prerelease: arm64, ad-hoc signed. On first launch, right-click
> `Convoy.app` in `/Applications` and choose **Open** to bypass Gatekeeper. A notarized,
> universal build will remove that step.

convoy orchestrates the `st` (smalltalk) and `pty` CLIs — install those separately.
