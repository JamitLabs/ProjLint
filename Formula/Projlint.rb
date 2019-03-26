class Projlint < Formula
  desc "Project Linter to enforce your non-code best practices"
  homepage "https://github.com/JamitLabs/ProjLint"
  url "https://github.com/JamitLabs/ProjLint.git", :tag => "0.2.0", :revision => "35874caa7bbdcad3221f1d01ee5fce2e99e6e01f"
  head "https://github.com/JamitLabs/ProjLint.git"

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
