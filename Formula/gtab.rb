class Gtab < Formula
  desc "Ghostty tab workspace manager with an interactive TUI"
  homepage "https://github.com/yunluoxin/gtab"
  version "1.8.0"
  license "MIT"
  head "https://github.com/yunluoxin/gtab.git", branch: "main"

  on_arm do
    url "https://github.com/yunluoxin/gtab/releases/download/v1.8.0/gtab-1.8.0-aarch64-apple-darwin.tar.gz"
    sha256 "c431c4add525c638ff7b37ba480a9b70467c730532863dfa784ab0a60a2186a1"
  end

  on_intel do
    url "https://github.com/yunluoxin/gtab/releases/download/v1.8.0/gtab-1.8.0-x86_64-apple-darwin.tar.gz"
    sha256 "6dad0b3d668d2e605a328e796965fead1c00cda647dc7700a46d23f22b1efc03"
  end

  depends_on :macos

  def install
    bin.install "gtab"
  end

  def caveats
    <<~EOS
      Run this once to enable the default Ghostty-local Cmd+G:
        gtab init

      Workspaces are stored in ~/.config/gtab/ by default.
      Override with: export GTAB_DIR="/your/path"

      Requires Ghostty terminal: https://ghostty.org
    EOS
  end

  test do
    ENV["GTAB_DIR"] = testpath/"gtab"
    (testpath/"gtab").mkpath
    (testpath/"gtab/demo.applescript").write <<~APPLESCRIPT
      tell application "Ghostty"
      end tell
    APPLESCRIPT

    assert_match version.to_s, shell_output("#{bin}/gtab --version")
    assert_match "demo", shell_output("#{bin}/gtab list")
    assert_match "close_tab = off", shell_output("#{bin}/gtab set")
    assert_match "ghostty_shortcut = cmd+g", shell_output("#{bin}/gtab set")
    assert_match "Ghostty-local shortcut is the default fast path", shell_output("#{bin}/gtab set")

    system bin/"gtab", "set", "close_tab", "on"
    assert_match "close_tab = on", shell_output("#{bin}/gtab set")

    assert_match "launch_mode has been removed", shell_output("#{bin}/gtab set launch_mode window", 1)
  end
end
