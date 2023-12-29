# BASHGENN IS DEPRECATED: [RBGN](https://github.com/romw314/rust-bashgenn) IS A MODERN ALTERNATIVE TO BASHGENN. IF YOU STILL NEED TO USE BASHGENN, WRITE YOUR SCRIPTS WITHOUT ANY BASHGENN-SPECIFIC COMMANDS!

RBGN is a new, cross-platform and modern Bashgenn interpreter written in Rust. RBGN is currently in development and if you need Bashgenn-specific features, use Bashgenn. **YOU SHOULD NOT USE BASHGENN IF RBGN CAN RUN YOUR SCRIPT PROPERLY.**

Using RBGN is very simple. First of all, you need to [install Rust](https://rustup.rs). Then, you need to install RBGN (if you are on Windows, run it with Powershell):

```sh
cargo install --git https://github.com/romw314/rust-bashgenn.git
```

When you have RBGN installed, you can run any script by running this command (replace `/path/to/your/script.bgn` with the actual path to the Bashgenn script you want to run):

```sh
rbgn -i /path/to/your/script.bgn
```

To get help about RBGN, run this command:

```sh
rbgn --help
```

# Bashgenn

Bashgenn - the ***Bash*** script ***gen***erator for text ma***n***iputaion

## Installation

Currently, Bashgenn can be installed by cloning this repo and adding the `bashgenn` script to your PATH:

```sh
git clone https://github.com/romw314/bashgenn
cd bashgenn
cp bashgenn ~/.local/bin/
```

Or install it per-machine:

```sh
git clone https://github.com/romw314/bashgenn
cd bashgenn
sudo cp bashgenn /usr/local/bin/
```

## Tutorial

Bashgenn scripts always read from standard input and write to standard output. They don't have any other input or output.

Bashgenn scripts are created from **commands**. Each command has it's own line in our file and must be written UPPERCASE. Each commands can have up to 2 arguments, separated by spaces.

There are also variables. Variables does not have their types, they are always strings (or numbers stored as strings).

The most basic commands in Bashgenn are `READ` and `ECHO`.

`READ` reads one line of input and saves it to a variable. `READ` takes one argument - the name of the variable to save the input in.

`ECHO` writes data from a variable to the output. `ECHO` takes one argument - the name of the variable to write the data from.

Here is a basic script which reads one line and prints it out:

```
READ our_variable
ECHO our_variable
```

We can compile and run the script by saving it into a file named `our_script.bgn` and running the following commands:

```sh
bashgenn our_script.bgn
./bg-f
```

Please note that Bashgenn always saves the output script to a file named `bg-f`. There's no option to change the output file. It also can't compile the script to a binary, it compiles it only to Bash.

We can also write the text three times:

```
READ our_variable
ECHO our_variable
ECHO our_variable
ECHO our_variable
```

And if we want to write the text 500 times? Should we add the `ECHO` command 500 times? No! The `REPEAT` commands is designed for that:

```
READ our_variable
REPEAT 500
  ECHO our_variable
DONE
```

We can also read and write out two lines:

```
READ our_variable
READ another_variable
ECHO our_variable
ECHO another_variable
```

Now, it's time for a practice. Adapt the code above to write the two lines in reversed order. When we enter this input:

```
Hello
World
```

The output should be:

```
World
Hello
```

<details><summary>Click to expand the solution</summary>
  
```
READ our_variable
READ another_variable
ECHO another_variable
ECHO our_variable
```

</details>

How to write a script that just prints `Hello, World!`, without any input. The `CONST_SET` and `CONST_WRITE` commands are for that. We create a **constant** (not a variable) and copy it to a variable. Then, we write the variable. Please note that we need to add `_OPT ireq true` at the beginning of the script in order to use `CONST_WRITE`.

```
_OPT ireq true
CONST_SET our_constant Hello, World!
CONST_WRITE our_constant our_variable  
ECHO our_variable
```

In bashgenn lines starting with `-` are comments, for example:
```
- This is a comment,
- comments are ignored
- by the compiler.

- This script does not do anything.
```

Next, we'll try to reverse a string (for example `olleh` from `hello`):
```
- This script is slow because we reverse the string by characters.

- Read the input into a variable named `input`
READ input

- STRGET repeats the commands inside until the variable in the first argument (in this case `input`) is not an empty string.
STRGET input
  - This command removes the last character from the variable `input` and saves it in the `last` variable.
  STORELAST input last
  - This appends the data from the `first` variable to the end of the `result` variable. Please note that all variables are empty at the beginning.
  STRCAT first result
DONE

- When we move all characters from the input to the result (this also reverses the string because we always move the last character of the input to the end of the result), we write the result.
ECHO result
```
