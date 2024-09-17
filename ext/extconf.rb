require "mkmf"
require "fileutils"

def sys(cmd)
  puts "  -- Running command: #{cmd}"
  unless ret = xsystem(cmd)
    raise <<-ERROR

***************************************************************************************
Error: Command `#{cmd}` failed.

Please ensure the following:
1. You have all necessary build tools installed (e.g., make, g++, etc.).
2. The command can be run in your environment.
3. If this error persists, please report it along with the full error output here:
   https://github.com/wordtreefoundation/melisa/issues

***************************************************************************************
    ERROR
  end
  ret
end

def check_command_exists(command)
  if `which #{command}`.strip.empty?
    STDERR.puts <<-ERROR

***************************************************************************************
Error: `#{command}` is required but not installed.

You can install it by running:
  apt-get install make build-essential

On macOS, you may need to run:
  xcode-select --install

Please install the required tool and try again.
***************************************************************************************

    ERROR
    exit(1)
  end
end

# Check if essential commands are available
check_command_exists("make")
check_command_exists("g++")

MARISA_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "marisa-trie-0.2.6"))
PREFIX = File.expand_path(File.join(File.dirname(__FILE__), "pkg"))

# Ensure linker sees the installed marisa lib
$LDFLAGS << " -Wl,-rpath,#{File.join(PREFIX, "lib")}"

# Build Marisa Trie from source
FileUtils.cd(MARISA_ROOT) do
  sys "autoreconf -i"
  sys "./configure --enable-native-code --prefix='#{PREFIX}'"
  sys "make"
  sys "make install"
end

# Update flags to avoid potential security issues
$CFLAGS.sub!('-Werror=format-security', '')
$CXXFLAGS.sub!('-Werror=format-security', '')
$CFLAGS   << " -I#{File.join(PREFIX, 'include')}"
$CXXFLAGS << " -I#{File.join(PREFIX, 'include')}"
$LDFLAGS  << " -L#{File.join(PREFIX, 'lib')} -lmarisa"

# Create makefile for marisa
create_makefile("marisa")
