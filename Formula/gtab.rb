class Gtab < Formula
  desc "Ghostty tab workspace manager with an interactive TUI"
  homepage "https://github.com/yunluoxin/gtab"
  version "1.8.1"
  license "MIT"
  head "https://github.com/yunluoxin/gtab.git", branch: "main"

  on_arm do
    url "https://github.com/yunluoxin/gtab/releases/download/v1.8.1/gtab-1.8.1-aarch64-apple-darwin.tar.gz"
    sha256 "ab96cd3c3ec8f5ac71f751574b736533830bfc71f03dbf3204a52984b8952995"
  end

  on_intel do
    url "https://github.com/yunluoxin/gtab/releases/download/v1.8.1/gtab-1.8.1-x86_64-apple-darwin.tar.gz"
    sha256 "fc24a3f6084c81a4c81c42d99b1f332e9e61b14c578cebb7b448ee98eee4d13b"
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
