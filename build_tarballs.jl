using BinaryBuilder

sources = [
    "https://github.com/GNOME/libxml2/archive/v2.9.7.tar.gz" =>
        "a7b52278afca823d263deb8b4b33710735f1b5208a351173b2deb78a6d936412",
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
