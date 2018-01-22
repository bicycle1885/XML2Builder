using BinaryBuilder

# These are the platforms built inside the wizard
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]


# If the user passed in a platform (or a few, comma-separated) on the
# command-line, use that instead of our default platforms
if length(ARGS) > 0
    platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(platforms), ", "))")

# Collection of sources required to build XML2Builder
sources = [
    "ftp://xmlsoft.org/libxml2/libxml2-2.9.7.tar.gz" =>
    "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c",

    "https://zlib.net/zlib-1.2.11.tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
]

script = raw"""
cd $WORKSPACE/srcdir
cd zlib-1.2.11/
./configure --prefix=/
make
make install
cd ../libxml2-2.9.7/
./configure --prefix=/ --host=$target --without-python --with-zlib=$(pwd)/../../destdir
make
make install

"""

products = prefix -> [
    LibraryProduct(prefix,"libxml2")
]


# Build the given platforms using the given sources
hashes = autobuild(pwd(), "XML2Builder", platforms, sources, script, products)

