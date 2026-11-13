class Buckle < Formula
  desc "Kernel-level Seatbelt Sandbox & Hardware Broker for AI Agents on macOS"
  homepage "https://github.com/idipi/buckle"
  url "https://github.com/idipi/buckle/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "23e755e56dfc0fd409d360e1238d6bee86a846e62a6237f8431b3401a27bfcdf"
  license "MIT"
  head "https://github.com/idipi/buckle.git", branch: "master"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "share/man/man1/buckle.1"
    man1.install "share/man/man1/buckle-broker.1"

    bash_completion.install "completions/buckle.bash" => "buckle"
    bash_completion.install "completions/buckle-broker.bash" => "buckle-broker"
    zsh_completion.install "completions/_buckle" => "_buckle"
    zsh_completion.install "completions/_buckle-broker" => "_buckle-broker"
    fish_completion.install "completions/buckle.fish"
    fish_completion.install "completions/buckle-broker.fish"
  end

  def caveats
    <<~EOS
      Buckle is installed with man pages and shell completions.

      Quick start:
        buckle up               # Launch interactive sandboxed shell
        buckle up cargo build   # Execute single isolated command
        buckle doctor           # Audit kernel Seatbelt & device status

      AI Agent MCP Server configuration (~/.gemini/config/mcp_config.json):
        {
          "mcpServers": {
            "buckle-broker": {
              "command": "#{opt_bin}/buckle-broker",
              "args": ["mcp"]
            }
          }
        }
    EOS
  end

  test do
    assert_match "Buckle", shell_output("#{bin}/buckle doctor")
    assert_match "Buckle", shell_output("#{bin}/buckle-broker --help")
  end
end
