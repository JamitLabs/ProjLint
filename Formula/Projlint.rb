class Projlint < Formula
  desc "Project Linter to enforce your non-code best practices"
  homepage "https://github.com/JamitLabs/ProjLint"
  url "https://github.com/JamitLabs/ProjLint.git", :tag => "0.1.4", :revision => "7e35b1fbb9ec37d0b01a1190eb5c00ebdac4975b"
  head "https://github.com/JamitLabs/ProjLint.git"

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
