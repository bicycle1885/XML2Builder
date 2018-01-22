using BinaryBuilder

sources = [
    "ftp://xmlsoft.org/libxml2/libxml2-2.9.7.tar.gz" =>
    "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c",
    "https://zlib.net/zlib-1.2.11.tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
]

products = prefix -> [
    LibraryProduct(prefix, "libxml2")
]


# Linux and Unix
# --------------

platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.Linux(:aarch64, :glibc),
    BinaryProvider.Linux(:armv7l, :glibc),
    BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS(),
]
script = raw"""
cd $WORKSPACE/srcdir
cd zlib-1.2.11/
./configure --prefix=/
make install
cd ../libxml2-2.9.7/
./configure --prefix=/ --host=$target --without-python --with-zlib=$(pwd)/../../destdir
make install
"""
autobuild(pwd(), "XML2Builder", platforms, sources, script, products)


# Windows
# -------

platforms = [
    BinaryProvider.Windows(:i686),
    BinaryProvider.Windows(:x86_64),
]
script = raw"""
cd $WORKSPACE/srcdir
cd zlib-1.2.11/
./configure --prefix=/ --sharedlibdir=/bin
make install LDSHAREDLIBC=''
cd ../libxml2-2.9.7/
./configure --prefix=/ --host=$target --without-python --with-zlib=$(pwd)/../../destdir
make install
"""
autobuild(pwd(), "XML2Builder", platforms, sources, script, products)
