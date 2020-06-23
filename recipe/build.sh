#!/bin/bash

if [ $(uname) == Darwin ]; then
    PGFLAG=""
    export LDFLAGS="-headerpad_max_install_names"
else
    PGFLAG="--with-pg=$PREFIX/bin/pg_config"
fi

echo "PREFIX=${PREFIX}"

# Fix for missing liblzma.
perl -pi -e "s#(/[^\s]*?lib)/lib([^\s]+).la#-L\$1 -l\$2#g" ${PREFIX}/lib/*.la

echo prefix is "${PREFIX}"
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
echo "CPPFLAGS=${CPPFLAGS}"
echo "LDFLAGS=${LDFLAGS}"

./configure \
    --prefix=$PREFIX \
    --with-openjpeg=${PREFIX} \
    --without-bsb \
    --without-cfitsio \
    --without-dods-root \
    --without-dwg-plt \
    --without-dwgdirect \
    --without-ecw \
    --without-epsilon \
    --without-expat \
    --without-expat-inc \
    --without-expat-lib \
    --without-fme \
    --without-gif \
    --without-grass \
    --without-hdf4 \
    --without-hdf5 \
    --without-idb \
    --without-ingres \
    --without-jasper \
    --without-jp2mrsid \
    --without-kakadu \
    --without-libgrass \
    --without-macosx-framework \
    --without-mrsid \
    --without-msg \
    --without-mysql \
    --without-netcdf \
    --without-oci \
    --without-oci-include \
    --without-oci-lib \
    --without-odbc \
    --without-ogdi \
    --without-pcidsk \
    --without-pcraster \
    --without-perl \
    --without-pg \
    --without-php \
    --without-pymoddir \
    --without-python \
    --without-sde \
    --without-sde-version \
    --without-spatialite \
    --without-sqlite3 \
    --without-static-proj4 \
    --without-xerces \
    --without-xerces-inc \
    --without-xerces-lib \
    --without-libiconv-prefix \
    --without-libiconv \
    --without-xml2 \
    --without-pcre \
    --without-freexl \
    --without-json-c \
    --without-kea \
    --disable-rpath

make -j${CPU_COUNT}
make install

if [ $(uname) == Darwin ]; then
    # Copy TIFF and GeoTIFF Headers to build against internal libraries.
    mkdir -p $PREFIX/include/gdal/frmts/gtiff/libgeotiff
    cp frmts/gtiff/libgeotiff/*.h $PREFIX/include/gdal/frmts/gtiff/libgeotiff
    cp frmts/gtiff/libgeotiff/*.inc $PREFIX/include/gdal/frmts/gtiff/libgeotiff
    mkdir -p $PREFIX/include/gdal/frmts/gtiff/libtiff
    cp frmts/gtiff/libtiff/*.h $PREFIX/include/gdal/frmts/gtiff/libtiff
fi

# # Make sure GDAL_DATA and set and still present in the package.
# # https://github.com/conda/conda-recipes/pull/267
# ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
# DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
# mkdir -p $ACTIVATE_DIR
# mkdir -p $DEACTIVATE_DIR

# cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/gdal-activate.sh
# cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/gdal-deactivate.sh
