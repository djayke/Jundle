#!/bin/bash

function Clean()
{
  rm -rf "$1"
}

function RecursiveFolder
{
  local directory="$1"
  local out="$2"
  # Loop through files in the target directory
  for file in "$directory"/*; do
    if [ -f "$file" ]; then
      local extension="${file##*.}"
      if [ $extension == "java" ];then
        echo "$file" >> "$out"
      fi
    fi
    if [ -d "$file" ]; then
      RecursiveFolder "$file" "$out"
    fi
  done
}

function ClassPath()
{
    classpath=""
    while IFS= read -r line; do
      classpath="$classpath$lib$line "
    done < "$compile/.classpathjar"
}

function GenerateClass()
{
  local ret=""
  while IFS= read -r line; do
    ret="$ret $line"
  done < "$1"

  ClassPath

  javac -d "$output" -cp $compile/$classpath $ret
}

function Compile()
{
  local arg=""
  while IFS= read -r line; do
     arg="$arg ${line:1}"
  done < "$1"

  cd $compile
  compilejar=$(echo "jar cfm "$name".jar "manifest.txt" "$arg"")

  eval "$compilejar"
}

function GenerateManifest()
{
    echo "Main-Class: $main" > "$1"
    echo "Class-Path: $classpath" >> "$1"
}

function ModifyBundlerForTargetPath()
{
      readarray -t lines < "$1"
      for line in "${lines[@]}"; do
          local f=$(echo "${line##*$2}")
          echo "${f%.java}.class" >> "$compile/.jundle"
      done
}

function DownloadDependencies()
{
     while IFS= read -r line; do
         group=$(echo ${line} | cut -d ' ' -f 1)
         artifact=$(echo ${line} | cut -d ' ' -f 2)
         version=$(echo ${line} | cut -d ' ' -f 3)
         url="https://repo1.maven.org/maven2/$group/$artifact/$version/$artifact-$version.jar"
         curl "$url" --output $compile/$lib"$artifact.jar"
          echo "$artifact.jar" >> $compile/.classpathjar
     done < "$dependencies"
}

# some config
name="MyApp"
manifest="manifest.txt"
compile="MyJavaApp"

# project settings
main="io.jzk.Main"

# dependencies path for external files READ
dependencies="bash/dep"
resources="target/resource/"

# relative path to project
working="/home/jxk/IdeaProjects/jzk/"
output="$working$compile/"
dir="src/main/java/"
lib="libs/"

# Go to root project
cd "$working"

# Clean previous build dir and create a fresh one
echo "$(tput setaf 5)$(tput bold)"
echo "===================================================="
echo "=                    JUNDLE                        ="
echo "===================================================="
echo "$(tput sgr 0)"

echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Cleaning older files and directories if any found..."
Clean "$output"
echo "$(tput setaf 2)Done!"

echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Initialize environement for Jundle..."
mkdir -p "$output/libs/"
echo "$(tput setaf 2)Done!"

# Download Dependencies
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Fetch external librairies used in the project setted in dependencies file..."
DownloadDependencies
echo "$(tput setaf 2)Done!"

# .bundle the project java file in a single file with their path
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Bundle the sources directories and create needed files for Jundle..."
RecursiveFolder "$dir" "$compile/.bundle"
echo "$(tput setaf 2)Done!"

# create class with javac
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Create the class files from .java found in sub-tree..."
GenerateClass "$compile/.bundle"
echo "$(tput setaf 2)Done!"

# create manifest
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Generate manifest do not forget to change the main settings variable in the script..."
GenerateManifest "$compile/manifest.txt"
echo "$(tput setaf 2)Done!"

# Adjust bundler with new file path
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Create temporary resources from bundle to generate jar file..."
ModifyBundlerForTargetPath "$compile/.bundle" "$dir" "$compile"
echo "$(tput setaf 2)Done!"

# compile
echo "$(tput setaf 5)[Jundle]$(tput sgr 0) Attempt to create jar file using tmp resource with given config..."
Compile "$compile/.jundle" "$output" "$name"
echo "$(tput setaf 2)Done!"

echo "$(tput setaf 5)[Jundle]$(tput sgr 0) $(tput setaf 2)Jar succesfuly generated on : $(tput setaf 4)$(tput bold)$compile$(tput sgr 0) as $(tput setaf 4)$(tput bold)$name$(tput sgr 0). $(tput setaf 5)Enjoy!"

