function parseLinks(fieldToGet,fieldToLookUp) {
  if(FNR>1) {
     if(fieldToGet == "URL") {
       if($1 == fieldToLookUp) {
        sub(/^[ \t]+/, "", $3)
        gsub(/ /, "", $3)
        gsub(/\t/, "", $3)
        print $3
      }
     } else if(fieldToGet == "Method") {
      if($1 == fieldToLookUp) {
        sub(/^[ \t]+/, "", $2)
        gsub(/ /, "", $2)
        gsub(/\t/, "", $2)
        print $2
      }
    } else if(fieldToGet == "Command") {
      if($1 == fieldToLookUp) {
        sub(/^[ \t]+/, "", $2)
        print $2
      }
    } else if(fieldToGet == "Entries") {
      print $1
    }
  }
}
function parsePackages(packageName) {
  if(FNR!=1 && /^[^#\n].*/) {
    if(packageName == "all") {
      print $1
    } else {
      if(index($1,packageName) != 0) {
        sub(/^[ \t]+/, "", $2)
        print $2
      }
    }
  }
}
BEGINFILE {
  FS = ","
}
{
  if(filesToParse == "downloadables" || filesToParse == "executables") {
    parseLinks(fieldToGet,fieldToLookUp)
  }
  else if(filesToParse == "packages") {
    parsePackages(packageName)
  }
}
