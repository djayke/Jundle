# Jundle
A bash script that use javac CLI and build a JAR from source file, the project is not as powerful as maven or gradle
but it show the complexity of building a jar file from scratch with the language build system `javac` `jar` to make a jar.
So this is a limited and very minimalist build system for java!

### Prequired
You need to have `curl` installed and indeed `javac` `jar` `java` command on your system the 3 last are basic command CLI for java SDK so if you have java installed you should be good...
To install `curl` use your packet manager 

1.Ubuntu
```
sudo apt-get install curl
```
2.Fedora
```
sudo dnf install curl
```
3.Arch
```
sudo pacman -Syu curl
#or
yay install curl
```


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

![Capture d’écran du 2024-06-28 00-07-39](https://github.com/djayke/Jundle/assets/146222213/b351bc8e-d22d-4424-bb8a-737b2dbc7430)


### Idea for further developpement
I really should have use a more high level language for the whole processing it would make the test jar file easily generated as well
also adding git branch would make the project really interesting as you would be able to fetch the generated jar from a branch dev and run test throughly before switching to main branch and do some task like building prod jar for a automation test environement and also completely make the script capable of pushing to remote project for the CI/CD with builded file that would make the whole build fail and haing them to locally do some testing as QA... Maybe on another coding sprint! 
