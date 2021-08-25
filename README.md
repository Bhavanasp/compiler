# compiler
A compiler for a custom language

## SOURCE CODE ORGANIZATION

# Folder and files

The submitted team11_source_code.tar.gz on extraction (in ubuntu) gives team11_source_code folder which contains compiler folder

In Folder compiler, 
source files: lexer.l, parser.y
header files: ast_nodes.hpp, code_generation.hpp,  symbol_table.hpp
In Folder compiler, Makefile
In the Folder compiler, folder test contains prog1, prog2, prog3, prog4, prog5 test programs and output1, output2, output3, output4, output5 files for the respective test programs and the executable named compiler upon build.

Build and generating compiler executable

Download and unzip and move the compiler folder into a folder of your choice and in that directory

```
cd compiler/ 
make
```

This will generate an executable named compiler and puts it in the test folder

```
make clean
```

To remove the extra files generated during the build

Usage of the compiler executable

Now to run the test cases, In compiler directory

```
cd test/
./compiler <infile> <outfile>
```

Output file <outfile> has the assembly code for the corresponding input file <infile>

To run this output file execute the following command (spim should be installed in prior)

```
spim -file <outfile> run
```

To write and run a new program create a file in the test folder and use the commands specified above to run the code
