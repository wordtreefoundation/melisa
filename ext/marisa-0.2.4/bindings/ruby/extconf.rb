require "mkmf"
require "fileutils"

def sys(cmd)
  puts "  -- #{cmd}"
  unless ret = xsystem(cmd)
    raise "#{cmd} failed, please report issue on https://github.com/wordtreefoundation/melisa"
  end
  ret
end

if `which make`.strip.empty?
  STDERR.puts "\n\n"
  STDERR.puts "***************************************************************************************"
  STDERR.puts "*************** make required (apt-get install make build-essential) =( ***************"
  STDERR.puts "***************************************************************************************"
  exit(1)
end

MARISA_ROOT = File.join(File.dirname(__FILE__), '..', '..')
PREFIX = File.join(File.expand_path(MARISA_ROOT), 'pkg')

FileUtils.cd(MARISA_ROOT) do
  sys "./configure --prefix='#{PREFIX}'"
  sys "make install"
  sys "make distclean"
end

$CFLAGS   << " -I#{File.join(PREFIX, 'include')}"
$CPPFLAGS << " -I#{File.join(PREFIX, 'include')}"
$LDFLAGS  << " -L#{File.join(PREFIX, 'lib')} -lmarisa"

create_makefile("marisa")
