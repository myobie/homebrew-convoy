cask "convoy" do
  version "0.1.0"
  sha256 "a9e2d81ff74b31a9cec9c646877fa398e70ce9e24688a636a5632fb0be72302d"

  url "https://github.com/myobie/convoy/releases/download/v#{version}/convoy-#{version}-macos-arm64.zip"
  name "Convoy"
  desc "Single front door for a smalltalk agent network — menubar host + CLI"
  homepage "https://github.com/myobie/convoy"

  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "Convoy.app"
  binary "convoy"

  caveats <<~CAVEATS
    Convoy.app is ad-hoc signed (not yet notarized). On first launch, right-click the
    app in /Applications and choose Open to bypass Gatekeeper. A notarized build will
    remove this step.

    convoy orchestrates the smalltalk (st) and pty CLIs — install those separately.
  CAVEATS
end
