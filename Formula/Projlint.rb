class Projlint < Formula
  desc "Project Linter to enforce your non-code best practices"
  homepage "https://github.com/JamitLabs/ProjLint"
  url "https://github.com/JamitLabs/ProjLint.git", :tag => "0.2.1", :revision => "064b5244339749266bfa90c1646b749371f8f872"
  head "https://github.com/JamitLabs/ProjLint.git"

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
