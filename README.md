# Jundle
A bash script that use javac CLI and build a JAR from source file, the project is not as powerful as maven or gradle
but it show the complexity of building a jar file from scratch with the language build system `javac` `jar` to make a jar

### Information
It use 2 files one call `build.sh` which is the script to process the whole source tree and files and generate class files add dependencies
for the jar resulting

1. most of the path set in this file are to be paramterized on another file such as jar name, librairies used, etc.
   ```
   # some config
      name="Main"                              the output name of the jar
      manifest="manifest.txt"                  manifest name (to be parmaterizable at run)
      compile="target"                         the output folder with the jar and dependencies since it does not rn as a standalone yet due to librairies fetch
      
      # project settings
      main="io.jzk.Main"                       the maain class as a package path
      
      # dependencies
      dependencies="bash/dep2"                 the file with librairies depencie
      resources="target/resource/" 
      
      # relative path to project
      working="/home/jxk/IdeaProjects/jzk/"     path to folder project
      output="$working$compile/"            
      dir="src/main/java/"                      sub directories to get java file in the working tree
      lib="libs/"                               folder name for external jar file
   ```
2. the dependencies files is like the maven tag `<dependency>` or gradle `require`
   It contains {groupid} {atrifcatid} and {version} as exmaple
   ```
   com/google/code/gson gson 2.11.0
   ```
   They are separted with a space the script extract it to a URL and curl the content from maven central where jar are hosted for the build system it does download it locally and bind them to your jar file output folder

### Usage
Example of working tree with the script to generate the jar file

![Capture d’écran du 2024-06-27 23-32-12](https://github.com/djayke/Jundle/assets/146222213/7f83747f-e059-4ff0-abe8-e039c40774d9)

Here is the output in folder target

![Capture d’écran du 2024-06-27 23-34-20](https://github.com/djayke/Jundle/assets/146222213/b095b65d-542c-4852-bee8-beac7b9fefe8)

Just Run the command
`java -jar path/to/myjar.jar` -> `java -jar target/Main.jar`
