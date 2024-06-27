# Jundle
A bash script that use javac CLI and build a JAR from source file, the project is not as powerful as maven or gradle
but it show the complexity of building a jar file from scratch with the language build system `javac` `jar` to make a jar

### Information
It use 2 files one call `build.sh` which is the script to process the whole source tree and files and generate class files add dependencies
for the jar resulting

1. most of the path set in this file are to be paramterized on another file such as jar name, librairies used, etc.
   ```
   # some config
      name="Main"                  the output name of the jar
      manifest="manifest.txt"      manifest name (to be parmaterizable at run)
      compile="target"             the output folder with the jar and dependencies since it does not rn as a standalone yet due to librairies fetch
      
      # project settings
      main="io.jzk.Main"           the maain class as a package path
      
      # dependencies
      dependencies="bash/dep2"     the file with librairies depencie
      resources="target/resource/" 
      
      # relative path to project
      working="/home/jxk/IdeaProjects/jzk/"  path to folder project
      output="$working$compile/"            
      dir="src/main/java/"                   sub directories to get java file in the working tree
      lib="libs/"                            folder name for external jar file
   ```
