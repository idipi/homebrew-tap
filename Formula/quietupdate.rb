class Quietupdate < Formula
  desc "Quietly track macOS security updates without Apple's upgrade nag"
  homepage "https://github.com/idipi/quietupdate"
  url "https://github.com/idipi/quietupdate/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "acd8bf287c3b39f27c9a2e6032498c3b016617b46c10bc8d66395ed71a5f23b9"
  license "MIT"

  depends_on "jq"

  def install
    bin.install "bin/quietupdate"

    inreplace bin/"quietupdate",
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX.to_s

    inreplace bin/"quietupdate",
      "@@HOMEBREW_VAR@@", var.to_s

    (var/"quietupdate").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"quietupdate", "watch"]
    run_type :immediate
    keep_alive true
    log_path var/"log/quietupdate.log"
    error_log_path var/"log/quietupdate.err.log"
  end

  test do
    assert_match "quietupdate", shell_output("#{bin}/quietupdate help")
  end
end
