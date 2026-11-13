class AgentSandbox < Formula
  desc "Kernel-level Seatbelt Sandbox & Hardware Broker for AI Agents on macOS"
  homepage "https://github.com/idipi/macos-agent-sandbox"
  url "https://github.com/idipi/macos-agent-sandbox/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/idipi/macos-agent-sandbox.git", branch: "master"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "share/man/man1/agent-sandbox.1"
    man1.install "share/man/man1/agent-broker.1"

    bash_completion.install "completions/agent-sandbox.bash" => "agent-sandbox"
    bash_completion.install "completions/agent-broker.bash" => "agent-broker"
    zsh_completion.install "completions/_agent-sandbox" => "_agent-sandbox"
    zsh_completion.install "completions/_agent-broker" => "_agent-broker"
    fish_completion.install "completions/agent-sandbox.fish"
    fish_completion.install "completions/agent-broker.fish"
  end

  def caveats
    <<~EOS
      macOS Agent Sandbox is installed with man pages and shell completions.

      Audit system capabilities:
        agent-sandbox doctor

      Launch an isolated agent shell:
        agent-sandbox shell

      AI Agent MCP Server configuration (~/.gemini/config/mcp_config.json):
        {
          "mcpServers": {
            "macos-broker": {
              "command": "#{opt_bin}/agent-broker",
              "args": ["mcp"]
            }
          }
        }
    EOS
  end

  test do
    assert_match "macOS Agent Sandbox", shell_output("#{bin}/agent-sandbox doctor")
    assert_match "Audited macOS System", shell_output("#{bin}/agent-broker --help")
  end
end
