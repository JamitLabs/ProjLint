class Projlint < Formula
  desc "Project Linter to enforce your non-code best practices"
  homepage "https://github.com/JamitLabs/ProjLint"
  url "https://github.com/JamitLabs/ProjLint.git", :tag => "0.1.5", :revision => "fc237787482c6d6e8d895954ef8e40cdc058ed99"
  head "https://github.com/JamitLabs/ProjLint.git"

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
