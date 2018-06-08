using BinaryBuilder

sources = [
    "ftp://xmlsoft.org/libxml2/libxml2-2.9.7.tar.gz" =>
    "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c",
]

script = raw"""
cd ${WORKSPACE}/srcdir/libxml2-*
./configure --prefix=${prefix} --host=${target} --without-python --with-zlib=${prefix}/lib
make -j${nproc} install
"""

products(prefix) = [
    LibraryProduct(prefix, "libxml2", :libxml2)
]

platforms = supported_platforms()

dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/blob/v1.2.11-3/build_tarballs.jl"
]

autobuild(pwd(), "XML2Builder", platforms, sources, script, products, dependencies)
