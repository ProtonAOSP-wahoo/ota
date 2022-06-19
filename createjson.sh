#!/bin/bash
# make executable (chmod +x ota/initial/createjson.sh) and run it (./ota/initial/createjson.sh)

device=$1
variant=$2

#don't modify from here
script_path="${PWD}"
zip_path=$script_path/out/target/product/$device
zip_name=`ls -1t $zip_path/*-$variant.zip* | head -1`
buildprop=$zip_path/system/build.prop

if [ -f $script_path/ota/$device-$variant.json ]; then
  rm $script_path/ota/$device-$variant.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
ver=`echo "$zip_only" | cut -d'-' -f2`
version=$ver-NS
echo "done."
echo '{
  "response": [
    {
        "filename": "'$zip_only'",
        "download": "https://sourceforge.net/projects/wahooo/files/ProtonAOSP/'$device'/'$zip_only'/download",
        "datetime": '$timestamp',
        "md5": "'$md5'",
        "size": '$size',
        "version": "'$version'"
    }
  ]
}' >> ota/$device-$variant.json
