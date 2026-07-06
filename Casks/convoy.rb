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

  # This build is first-party and ad-hoc signed (not yet notarized). Strip the download
  # quarantine so the app and CLI run without a Gatekeeper prompt (a quarantined CLI can't be
  # "right-click-Opened" like an app can). Removed once the build is notarized.
  postflight do
    ["#{appdir}/Convoy.app", "#{staged_path}/convoy"].each do |path|
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", path],
                     must_succeed: false
    end
  end

  caveats <<~CAVEATS
    convoy orchestrates the smalltalk (st) and pty CLIs — install those separately.

    This is a demo prerelease (arm64, ad-hoc signed). A notarized, universal build is coming.
  CAVEATS
end
