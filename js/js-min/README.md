Files in this folder are generated automatically by by a minififer

The source files to be minified are generated by typescipt/ TSC

this folder should not be tracked by github aside from this readme, so that the folder does exist in structure (prevents errors from folder not existing when commands are used)

To fill this folder:

tsc --build .ts/src/tsconfig.json
then run whatever minifier you wish on the js/ folder, with the output set to js-min/