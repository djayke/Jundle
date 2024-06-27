# Jundle
A bash script that use javac CLI and build a JAR from source file, the project is not as powerful as maven or gradle
but it show the complexity of building a jar file from scratch with the language build system `javac` `jar` to make a jar

### Information
It use 2 files one call `build.sh` which is the script to process the whole source tree and files and generate class files add dependencies
for the jar resulting

1. most of the path set in this file are to be paramterized on another file such as jar name, librairies used, etc.
