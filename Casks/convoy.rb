cask "convoy" do
  version "0.1.0"
  sha256 "a9e2d81ff74b31a9cec9c646877fa398e70ce9e24688a636a5632fb0be72302d"

  url "https://github.com/myobie/convoy/releases/download/v#{version}/convoy-#{version}-macos-arm64.zip"
  name "Convoy"
  desc "Single front door for a smalltalk agent network — menubar host + CLI"
  homepage "https://github.com/myobie/convoy"

  depends_on macos: :ventura
  depends_on arch: :arm64

  app "Convoy.app"

  # No `binary` stanza on purpose: a symlink would point at the provenance-tainted Caskroom
  # extraction path, and this build isn't notarized yet, so Gatekeeper would block the CLI
  # (a CLI can't be "right-click → Open"ed like an app). Instead we install the CLI as a fresh,
  # un-quarantined copy — a new path avoids the path-level provenance, and clearing the xattr the
  # download carries removes the file-level quarantine. Both become unnecessary after notarization.
  postflight do
    require "fileutils"
    dest = "#{HOMEBREW_PREFIX}/bin/convoy"
    FileUtils.cp staged_path/"convoy", dest
    FileUtils.chmod 0755, dest
    system_command "/usr/bin/xattr", args: ["-c", dest], must_succeed: false
    # Smooth the app's first launch too (it still uses the standard right-click → Open flow).
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Convoy.app"],
                   must_succeed: false
  end

  uninstall delete: "#{HOMEBREW_PREFIX}/bin/convoy"

  caveats <<~CAVEATS
    convoy orchestrates the smalltalk (st) and pty CLIs — install those separately.

    This is a demo prerelease (arm64, ad-hoc signed). The `convoy` CLI is ready to use
    immediately. The first time you launch Convoy.app, right-click it in /Applications → Open.
    A notarized, universal build will remove that last step.
  CAVEATS
end
