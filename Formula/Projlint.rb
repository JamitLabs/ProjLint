class Projlint < Formula
  desc "Project Linter to enforce your non-code best practices"
  homepage "https://github.com/JamitLabs/ProjLint"
  url "https://github.com/JamitLabs/ProjLint.git", :tag => "0.1.5", :revision => "94b675d65e2d1f1c555f07f5ccbe683677f2cf38"
  head "https://github.com/JamitLabs/ProjLint.git"

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
