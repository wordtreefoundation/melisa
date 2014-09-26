require "mkmf"
require "fileutils"

FileUtils.cd(File.join(File.dirname(__FILE__), '..', '..')) do
  system "./configure"
  system "make"
end

have_library("marisa")

create_makefile("marisa")
