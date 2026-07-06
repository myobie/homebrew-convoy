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
  binary "convoy"

  # This build is first-party and ad-hoc signed (not yet notarized). An un-notarized *downloaded*
  # binary is provenance-tracked by syspolicyd — which survives removing the com.apple.quarantine
  # xattr — so a CLI (which can't be "right-click → Open"ed like an app) would block on a
  # Gatekeeper decision. Re-materializing the file (fresh inode) clears that provenance so `convoy`
  # runs immediately. All of this becomes unnecessary once the build is notarized.
  postflight do
    require "fileutils"
    bin = staged_path/"convoy"
    if File.exist?(bin)
      tmp = "#{bin}.rematerialized"
      FileUtils.cp(bin, tmp)
      FileUtils.mv(tmp, bin, force: true)
      FileUtils.chmod(0755, bin)
    end
    # The app uses the standard right-click → Open flow; drop its quarantine to smooth that.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Convoy.app"],
                   must_succeed: false
  end

  caveats <<~CAVEATS
    convoy orchestrates the smalltalk (st) and pty CLIs — install those separately.

    This is a demo prerelease (arm64, ad-hoc signed). A notarized, universal build is coming;
    until then, the first time you launch Convoy.app, right-click it in /Applications → Open.
  CAVEATS
end
