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

- Python 3.7 or higher
- An OpenAI API key, see: [Where do I find my Secret API Key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)
- Git installed on your system
- Staged changes in the current repo to be commited
- `tmp_commit_msg.txt` has to be configured as commit template (see below)

## Installation and Setup

1. Clone this repository to your local machine using git:

    ```bash
    git clone https://github.com/5n00py/SmartCommit.git
    ```

2. Setting up the Python Environment:

    The necessary Python libraries have to be installed and isolated for this
    project in a virtual environment called `venv` within the `python` folder.
    The `gc-smart` script will automatically activate and deactivate this
    virtual environment, so manual activation is not required.

    Navigate to the `python` directory in the `SmartCommit` project:

    ```bash
    cd SmartCommit/python
    ```

    Create a virtual environment named `venv`:

    ```bash
    python3 -m venv venv
    ```

    Activate the virtual environment:

    ```bash
    source venv/bin/activate
    ```

    Install the required Python libraries:

    ```bash
    pip3 install -r requirements.txt
    ```

    Deactivate the virtual environment:

    ```bash
    deactivate
    ```

    Now the python environment is set up with all the openai dependences, and
    the `gp-smart` script will automatically use this environment when
    executed.

3. Set your OpenAI API key as an environment variable:

    ```bash
    export OPENAI_API_KEY=<your_api_key>
    ```

    To avoid having to export the OpenAI API key every time you open a new
    terminal session, you can set it permanently by adding it to your shell's
    configuration file by adding the above line for example to the .bashrc or
    .zshrc depending on the shell.

4. Add the location of the `gc-smart` script to your shell's PATH
   environment variable. This allows you to run it from any
   directory. To do this, use a command like the following:

    ```bash
    export PATH=$PATH:/path/to/SmartCommit
    ```
    (Don't forget to replace `/path/to/SmartCommit` with the actual path 
    to the directory containing `gc-smart`.) 

    To make this change permanent, you can add this command to your shell's
    config file (like `.bashrc` or `.zshrc`).

    Alternatively, you can create an alias for `gc-smart` providing the full path.

5. Make the `gc-smart` and `gpt-commit-prompter` script executable:

    ```bash
        chmod +x /path/to/SmartCommit/gc-smart
        chmod +x /path/to/SmartCommit/python/gpt-commit-prompter.py
    ```
    (Don't forget to replace `/path/to/gc-smart` with the actual path to the script.

## Note on Commit Template Handling from gc-smart Version 0.4.0

Starting from version 0.4.0 of `gc-smart`, there is no longer a need to
manually set `tmp_commit_msg.txt` as the global commit template in your Git
configuration. The script has been updated to automatically handle the commit
template for you.

When you run `gc-smart`, it will now:

1. Temporarily back up any existing Git commit template you have configured. 
2. Set `tmp_commit_msg.txt` as the commit template for the duration of its
   execution.
3. Once the script completes or exits, it will restore your original commit
   template. 

This improvement ensures to maintain your existing Git configurations while
gc-smart is in operation.

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

The `gpt-commit-prompter` script uses the `imperative` style as its default for
the commit messages it generates. However, you have the flexibility to
configure the style through the `-s` or `--style` option.

Available styles are:

- `imperative`: Generates a message in the imperative mood and uses
  conventional title with bullets.
- `simple`: Generates a concise, straightforward commit message in one line.
- `detailed`: Generates a more verbose commit message, detailing the changes.
- `conventional`: Generates a commit message following the conventional commits
  specification.

These styles can also be used in combination with the `gc-smart` script.

You can see how the styles are configured and further customize them by
checking the `config.json` file.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.
