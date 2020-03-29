class Spacebar < Formula
  desc "A stausbar for yabai tiling window manager."
  homepage "https://github.com/somdoron/spacebar"
  url "https://github.com/somdoron/spacebar/releases/download/v0.1/spacebar-v0.1.0.tar.gz"
  sha256 "ff455a2c6e85663c77dcb1814b3bd2996cd592b38bffc179c9ad642f2c33febb"
  head "https://github.com/somdoron/spacebar.git"

  depends_on :macos => :catalina

  def install
    (var/"log/spacebar").mkpath
    man.mkpath

    if build.head?
      ENV.O2
      system "make", "install"
    end

    bin.install "#{buildpath}/bin/spacebar"
    (pkgshare/"examples").install "#{buildpath}/examples/spacebarrc"
    man1.install "#{buildpath}/doc/spacebar.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/spacebarrc ~/.spacebarrc
    Logs will be found in
      #{var}/log/spacebar/spacebar.[out|err].log
    EOS
  end

  plist_options :manual => "spacebar"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/spacebar</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardOutPath</key>
      <string>#{var}/log/spacebar/spacebar.out.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/spacebar/spacebar.err.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "spacebar-v#{version}", shell_output("#{bin}/spacebar --version")
  end
end
