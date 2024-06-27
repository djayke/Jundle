#!/bin/bash

function clean()
{
  rm -rf $working/main/java/bundle
  rm -rf $Target*.class
  rm -rf $Target"manifest.txt"
}

function RecursiveFolder
{
  local directory="$1"
  # Loop through files in the target directory
  for file in "$directory"/*; do
    if [ -f "$file" ]; then
      local extension="${file##*.}"
      if [ $extension == "java" ];then
        echo "$(basename $file) $(dirname $file)" >> bundle
        echo "$file" >> jundle
      fi
    fi
    if [ -d "$file" ]; then
      RecursiveFolder "$file"
    fi
  done
}

function loopFile()
{
  local ret=""
  while IFS= read -r line; do
    ret="$ret $line"
  done < "$1"
  echo $ret > .tmpArguments
}

function CompileWithBundle()
{
  readarray -t lines < "$1"
  arg=""
  for line in "${lines[@]}"; do
     local f=$(echo "${line%% *}")
     arg="$arg $2${f%.java}.class"
  done

  jar cfm $JarName "$ManifestPath" "$arg"
}



JarName="name.jar"
ManifestFile="manifest.txt"
Target="io/jzk/"
MainClass="Main"
ClassPath=$( echo $Target$MainClass | sed 's/\//./g' )
ManifestPath="$Target$ManifestFile"
working="/home/jxk/IdeaProjects/jzk/src"

cd "$working/main/java"
RecursiveFolder $working


javac $Target*.java
echo "Main-Class: $ClassPath" > "$ManifestPath"
jar cfm $JarName "$ManifestPath" "$Target""Main.class" $Target"Other.class"
#CompileWithBundle "$working/main/java/bundle" "$Target"

# Move the jar file in tree directory to test if path related files into tree are still needed
#mv $JarName "../../$JarName"

##### RUN THEN CLEAN
#cd ~/IdeaProjects/jzk/src/
#java -jar $JarName





