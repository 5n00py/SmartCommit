# SmartCommit

SmartCommit is a Python script that helps generating meaningful commit
messages for git projects. It uses the OpenAI's GPT-3 model to summarize your 
change based on a .diff file and provides a starting point for editing commit
messages. 

## Prerequisites

To run the smartcommit.py script, you need:

- Python 3.6 or higher
- An OpenAI API key

## Installation and Setup

1. Clone this repository to your local machine using git:

    ```bash
    git clone https://github.com/5n00py/SmartCommit.git
    cd SmartCommit
    ```
    
2. Install the necessary Python libraries:

    ```bash
    pip install openai
    ```

3. Set your OpenAI API key as an environment variable:

    ```bash
    export OPENAI_API_KEY=<your_api_key>
    ```

    To avoid having to export the OpenAI API key every time you open a new
    terminal session, you can set it permanently by adding it to your shell's
    configuration file by adding the above line for example to the .bashrc or
    .zshrc depending on the shell.

4. To make the script available system-wide by just calling `smartcommit` instead 
of `python /path/to/smartcommit.py`, you have to make it executable and move it 
to a directory that's on your system's PATH (e.g. /usr/local/bin).

    ```bash
    chmod +x /path/to/smartcommit.py
    sudo mv /path/to/smartcommit.py /usr/local/bin/smartcommit
    ```

    As an alternative, you can define an alias `smartcommit` by adding the
    following to .bashrc or .zshrc:

    ```bash
    alias smartcommit='python3 /path/to/smartcommit.py'
    ```

## Usage

Run the script by passing a .diff file as argument:

```bash
python smartcommit.py changes.diff
```

## Examples

Let's suppose we have the following diff file `changes.diff`:

```diff
--- old_version.py  2021-08-01 12:00:00.000000000 +0100
+++ new_version.py  2021-08-02 12:00:00.000000000 +0100
@@ -1,9 +1,11 @@
 def add(a, b):
-    return a + b
+    return abs(a + b)

-def subtract(a, b):
-    return a - b
+def subtract_absolute(a, b):
+    return abs(a - b)

 def multiply(a, b):
-    return a * b
+    if a > 0 and b > 0:
+        return a * b
+    else:
+        raise ValueError("Both inputs must be positive.")
     
-def divide(a, b):
-    if b != 0:
-        return a / b
-    else:
-        print("Error: Division by zero.")
-        return None
+
+def exponentiate(a, b):
+    return a**b
```

Running the command
```bash
python smartcommit.py changes.diff
```

Will output a commit message like this:

```bash
Refactor arithmetic functions

- Change `add` function to return the absolute value of the sum
- Rename `subtract` function to `subtract_absolute`
- Modify `multiply` function to raise a ValueError if either input is not positive
- Add new `exponentiate` function to calculate the exponential power of two numbers
```

To capture the output of the smartcommit.py script into a text file rather than
printing it to the terminal, you can use output redirection in the command
line:

```bash
python smartcommit.py changes.diff > commit_message.txt
```

## Commit Message Style

The smartcommit.py script uses a specific style for the commit messages it
generates. The messages include a summary title, followed by a detailed list of
changes. Each change is denoted by a bullet point - and written in an
imperative style. See the example above.

The configuration for this style is hard-coded in the smartcommit.py script. If
you wish to change the style, feel free to modify the system_prompt and
changes variables in the script.

As of now, there is no option to select different styles of commit messages
directly. However, this may be a feature in future versions.

## Contributing

Contributions are welcome! Please fork this repository and open a pull request
with your changes.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.
