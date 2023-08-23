# SmartCommit

After tirelessly working on a project feature, adjusting functions here and
there, you might find yourself with numerous modified files, facing a final
task: Commiting your changes in a way that maintains clarity for future
reference. Diligently scrolling through the diff, attempting to pinpoint and
acticulate every modification can be a daunting task.

This is where `gc-smart` steps in.

The script generates an AI enhanced commit message based on the diffs of your
staged changes, reducing the manual effort involved in crafting meaningful
commit descriptions. By default, after running the script within a repository,
a preview of the AI-generated commit message is displayed. You are then
presented with the options:

1. To continue with the current commit message.
2. To regenerate a new commit message.
3. To regenerate a new commit message by adding further instruction.
4. To view the staged changes.
5. To abort the commit process altogether.

If you choose to continue, the generated message is used as a template for the 
`git commit` command, allowing you to review and further customize the message
if needed before finalizing it.

For quick commits, you can use the `-q` or `--quick` options to skip the
preview and commit directly with the AI-generated message. To see all the
possible options, run `gc-smart --help`.

## Prerequisites

- Python 3.6 or higher
- An OpenAI API key, see: [Where do I find my Secret API Key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)
- Git installed on your system
- Staged changes in the current repo to be commited
- `tmp_commit_msg.txt` has to be configured as commit template (see below)

## Installation and Setup

1. Clone this repository to your local machine using git:

    ```bash
    git clone https://github.com/5n00py/SmartCommit.git
    cd SmartCommit
    ```

    Alternatively just copy the files `gc-smart` and `ai_commit_helper.py` to
    the preferred location.
    
2. Install the necessary Python libraries:

    ```bash
    pip install openai
    ```

    If you want to isolate the libraries for this project, create a virtual
    environment, activate it and run the python script within the virtual
    environment.

3. Set your OpenAI API key as an environment variable:

    ```bash
    export OPENAI_API_KEY=<your_api_key>
    ```

    To avoid having to export the OpenAI API key every time you open a new
    terminal session, you can set it permanently by adding it to your shell's
    configuration file by adding the above line for example to the .bashrc or
    .zshrc depending on the shell.

4. In order to use `gc-smart`, the `tmp_commit_msg.txt` file has to be set as
   the commit template in your Git configuration. You can set this using the
   command:

    ```bash
    git config --global commit.template tmp_commit_msg.txt
    ```

    Note: If you skip this step, the first time you run `gc-smart`, the script
    will present you with a prompt to set this up for you.

5. Add the location of the `gc-smart` script to your shell's PATH
   environment variable. This allows you to run it from any
   directory. To do this, use a command like the following:

    ```bash
    export PATH=$PATH:/path/to/your/scripts
    ```
    (Don't forget to replace `/path/to/your/scripts` with the actual path 
    to the directory containing `gc-smart`.) 

    To make this change permanent, you can add this command to your shell's
    config file (like `.bashrc` or `.zshrc`).

    Alternatively, you can create an alias for `gc-smart` providing the full path.

    To use the `gc-smart` script, you need to make it executable. You can do this
    with the following command:

    ```bash
        chmod +x /path/to/gc-smart
    ```
    (Don't forget to replace `/path/to/gc-smart` with the actual path to the script.

## Examples

Let's assume you've made some code changes in your Git repository and have
staged them ready to commit.

For illustration, suppose the staged changes are as follows:

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

When you run the `gc-smart` script from within the repository, you'll be
presented with an interactive preview of the auto-generated commit message,
which might look something like this:

```bash
Refactor arithmetic functions

- Change `add` function to return the absolute value of the sum
- Rename `subtract` function to `subtract_absolute`
- Modify `multiply` function to raise a ValueError if either input is not positive
- Add new `exponentiate` function to calculate the exponential power of two numbers
```

After reviewing the proposed commit message, if you decide to proceed, this
message will appear as a template in your default Git editor. You can then
finalize the message or make any necessary modifications before committing the
changes to your repository.

## Commit Message Style

The `ai_commit_helper.py` script uses a specific style for the commit messages it
generates. The messages include a summary title, followed by a detailed list of
changes. Each change is denoted by a bullet point - and written in an
imperative style. See the example above.

The configuration for this style is hard-coded in the script. If
you wish to change the style, feel free to modify the system_prompt and
changes variables in the script.

As of now, there is no option to select different styles of commit messages
directly. However, this may be a feature in future versions.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.
