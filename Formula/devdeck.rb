# Homebrew formula for devdeck, filled in by the release workflow (.github/workflows/release.yml) and pushed to
# kavinvenkatachalam/homebrew-tap, with the release's version and checksum filled in.
class Devdeck < Formula
  desc "Dev cockpit: Claude and Codex sessions per worktree, dev servers, on the Mac and the phone"
  homepage "https://github.com/kavinvenkatachalam/devdeck"
  url "https://github.com/kavinvenkatachalam/devdeck/releases/download/v0.5.4/devdeck-0.5.4-darwin-arm64.tar.gz"
  version "0.5.4"
  sha256 "86f0a0ddaea81290eff593d33dd45b8597fd4ca3b167cb32140341820ea15a4e"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  # devdeck runs on its own Node (keg-only, so the node in your PATH stays yours); tmux holds its terminals
  depends_on "node@24"
  depends_on "tmux"

  def install
    libexec.install Dir["*"]
    # DEVDECK_ENTRY: what devdeck saves to run itself later (the login item), stable across upgrades
    (bin/"devdeck").write_env_script libexec/"bin/devdeck",
      DEVDECK_NODE:  Formula["node@24"].opt_bin/"node",
      DEVDECK_ENTRY: HOMEBREW_PREFIX/"bin/devdeck"
  end

  def caveats
    <<~EOS
      Start devdeck and open it:   devdeck open
      The devdeck app:             devdeck desktop install --open
      Start it when you log in:    devdeck autostart on
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/devdeck version").strip
  end
end
