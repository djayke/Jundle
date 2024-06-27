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
    done < "$compile/classpath"
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

  cd target
  compile=$(echo "jar cfm "$name".jar "manifest.txt" "$arg"")

  eval "$compile"
}

function GenerateManifest()
{
    echo "Main-Class: $main" > "$1"

    ClassPath

    echo "Class-Path: $classpath" >> "$1"
}

function ModifyBundlerForTargetPath()
{
      readarray -t lines < "$1"
      for line in "${lines[@]}"; do
          local f=$(echo "${line##*$2}")
          echo "${f%.java}.class" >> "$compile/jundle"
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
          echo "$artifact.jar" >> $compile/classpath
     done < "$dependencies"
}

# some config
name="Main"
manifest="manifest.txt"
compile="target"

# project settings
main="io.jzk.Main"

# dependencies path for external files READ
dependencies="bash/dep2"
resources="target/resource/"

# relative path to project
working="/home/jxk/IdeaProjects/jzk/"
output="$working$compile/"
dir="src/main/java/"
lib="libs/"

# Go to root project
cd "$working"

# Clean previous build dir and create a fresh one
Clean "$output"
mkdir -p "$output/libs/"

# Download Dependencies
DownloadDependencies

# Bundle the project java file in a single file with their path
RecursiveFolder "$dir" "$compile/bundle"

# create class with javac
GenerateClass "$compile/bundle"

# create manifest
GenerateManifest "$compile/manifest.txt"

# Adjust bundler with new file path
ModifyBundlerForTargetPath "$compile/bundle" "$dir" "$compile"

# compile
Compile "$compile/jundle" "$output" "$name"
