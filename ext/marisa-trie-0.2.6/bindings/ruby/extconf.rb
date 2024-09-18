require "mkmf"

PREFIX = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "pkg"))
include_path = File.join(PREFIX, 'include')

flags = " -I#{include_path}"
$CFLAGS   << flags
$CXXFLAGS << flags
$CPPFLAGS << flags

have_library("marisa")

create_makefile("marisa")
