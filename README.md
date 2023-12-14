# SmartCommit

After tirelessly working on a project feature, adjusting functions here and
there, you might find yourself with numerous modified files, facing a final
task: Commiting your changes in a way that maintains clarity for future
reference. Diligently scrolling through the diff, attempting to pinpoint and
acticulate every modification can be a daunting task.

This is where `gc-smart` steps in.

The script generates an AI enhanced commit message based on the diffs of your
staged changes, reducing the manual effort involved in crafting meaningful
commit descriptions. The generated message will be used as a template for the
further editing of the commit message, allowing to review and further customize
the message if needed before finalizing the commit.

**IMPORTANT NOTE:** `SmartCommit` is primarily designed for users working in a
UNIX-like OS environment performing git operations directly from the command
line. Its functionality and commands are tailored to these systems and
workflows and might not be fully compatible or perform as expected in other
environments.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
   - [Quick Setup with One-Liner](#quick-setup-with-one-liner)
   - [Using the Setup Script](#using-the-setup-script)
   - [Manual Installation](#manual-installation)
- [Configuration](#configuration)
   - [Commit Message Style](#commit-message-style)
   - [GPT Model Configuration](#gpt-model-configuration)
- [Usage](#usage)
   - [Basic Workflow](#basic-workflow)
   - [Quick Commits](#quick-commits)
   - [Additional Options](#additional-options)
- [Note on Commit Template Handling](#note-on-commit-template-handling-from-gc-smart-version-040)
- [Examples](#examples)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Prerequisites

Before you begin with SmartCommit, ensure you have the following prerequisites
set up:

- **Python 3.7 or higher**: This is the core language used for accessing the
  OpenAI API. To check your current Python version, use `python3 --version`.
  Python 3.11 is recommended for the best compatibility and performance. You
  can download it from the [Python Download
  Site](https://www.python.org/downloads/) or use your operating system's
  package manager for installation.

- **Python venv**: This module is crucial for creating an isolated Python
  environment, which is necessary for the proper functioning of SmartCommit.
  It's usually included with Python 3.7 and later. To verify if it's installed,
  run `python3 -m venv --help`. If you're using a Debian-based system and it's
  not installed, you can install it with `sudo apt install python3.x-venv`,
  replacing x with your Python 3 version number. For other systems, please
  consult the relevant documentation or package manager.

- **OpenAI API Key**: Essential for accessing the OpenAI API functionalities.
  You can obtain your API key following [Where do I find my Secret API
  Key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)

- **Git**: Make sure Git is installed on your system, as SmartCommit integrates with
it for version control. If you need to install or update Git, visit [Git's
official site](https://git-scm.com/downloads) or consult your package manager.

- **Staged Changes in Your Repository**: `gc-smart` is designed to generate
  commit messages based on the changes staged in your Git repository. Ensure
  you have changes staged for commit before using the script.

## Installation

### Quick Setup with One-Liner

For a quick setup you can use a one-liner that clones the repository into
`~/.local/share/SmartCommit` and then runs the setup script. Make sure you have
Python 3.7 or higher and venv installed and run:

```bash bash <(curl -sL
https://raw.githubusercontent.com/5n00py/SmartCommit/main/setup/setup_quick_wget.sh)
```

Upon completion don't forget to restart or source your shell configuration as
described under 6. in the Manuall Installation section above.

### Using the Setup Script

For an automated setup process after cloning, you can use the
[setup_sc.sh](setup/setup_sc.sh) script located in the `setup` directory. This
will set up the Python environment, install necessary dependencies, configure
the OpenAI API key and update the shell's configuration.

**Note:** If the `OPENAI_API_KEY` environment variable is not already set, the
script will prompt you to enter an OpenAI API key. You will need to paste the
key at the prompt, so make sure you have it ready, see also
[Where do I find my API key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-api-key).

1. Clone the Repository as described in the first step of the Manual
   Installation.

2. Navigate to the setup directory, make the script executable and run it:

  ```bash
  cd SmartCommit/setup && chmod +x setup_sc.sh && ./setup_sc.sh
  ```

  The script will perform several actions:
  - Create and set up a virtual environment for Python
  - Check if Python version is 3.7 or higher
  - Install requiret python libraries in the venv
  - Prompt for adding an `OPENAI_API_KEY` and adding it to `.bashrc` or
    `.zshrc` if they exist.
  - Add `gc-smart` script to the shell's PATH environment variable.
  - Make the necessary scripts executable.

3. Restart or source your shell configuration as descripted under 6. in the
   Manual Installation above.

### Manual Installation

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

6. After the setup you will either have to restart your terminal or source your
   shell configuration for the changes to take efferc. If you use Bash, run:

   ```bash
   source ~/.bashrc
   ```

   If you use Zsh, run:

   ```bash
   source ~/.zshrc
   ```

## Configuration

The `gpt-commit-prompter` used in `gc-smart` allows configuration through the
`config.json` file. This flexibility ensures that the tool can be easily
adjusted to specific needs for generating commit messages.

The default configuration is located in the [config.json](config.json) file
within the SmartCommit directory. For personalized settings, you can create a
custom configuration file at

```bash 
~/.config/SmartCommit/config.json
```

When present, this file will be prioritized over the default configuration in
the SmartCommit folder.

To do this you can create the `~/.config/SmartCommit` directory (if it doesn't
exist yet) and copy the default `config.json` file to it:

```bash
mkdir -p ~/.config/SmartCommit/
cp /path/to/SmartCommit/config.json ~/.config/SmartCommit/
```

### Commit Message Style

By default, the script uses the `imperative` style for commit messages. You can
choose a different style by using the `-s` or `--style` option when running the
script. The available styles, as defined in the `config.json` file, are:

- `imperative`: Generates a message in the imperative mood with a conventional
  title and bullet points.
- `simple`: Produces a concise, one-line commit message.
- `detailed`: Creates a verbose commit message, elaborating on the changes.
- `conventional`: Follows the Conventional Commits specification for the commit
  message format.

You can view and customize the styles by editing their corresponding entries in
the `config.json` file.

### GPT Model Configuration

In addition to style customization, the `config.json` file allows you to
configure the GPT model used by the script. This feature enables you to select
the most appropriate model version for your needs, ensuring optimal performance
and relevance of the generated commit messages. To change the model, simply
update the `model` section in the `config.json` file.

For instance, if you have access to newer models like GPT-4, you can change the 
model configuration to use `gpt-4`. This might improve the quality of the 
generated commit messages.

To change the model, simply update the `model` section in the `config.json` file. 

For example:
```json
{
    "model": {
        "name": "gpt-4"
    }
    ...
```

Keep in mind that using different models may require different levels of access
or subscription plans with OpenAI.

## Usage

`gc-smart` is designed to improve the commit process in a Git repository.
Before using the script, ensure that you are in a Git repository and have
changes staged for commit. The script works best when there are meaningful
changes staged that need clear and descriptive commit messages.

### Basic Workflow 

By default, after running the script within a repository, a preview of the
AI-generated commit message is displayed. You are then presented with the
following options:

1. Continue with the current commit message: Use the AI-generated message as a
   template for the git commit command. You can review and further customize
   the message if needed before finalizing the commit. 
2. Regenerate a new commit message: Generate a new message without additional
   input. 
3. Regenerate with further instruction: Provide additional context or
   instructions to guide the AI in generating a more accurate commit message.
   
4. View the staged changes: Review the changes that are staged for commit. 
5. Abort the commit process: Exit the script without committing. 

### Quick Commits 

For quick commits, you can use the `-q` or `--quick` options to skip the
preview and commit directly with the AI-generated message:

```bash gc-smart --quick ```

### Additional Options 

The `gc-smart` script offers several options to customize the commit message
generation process:

- `-h`, `--help`: Display the help message with information about all available
  options. 
- `-i`, `--instruction`: Provide an instruction for the AI to guide the commit
  message generation. 
- `-s`, `--style`: Specify a style for the AI-generated commit message.
  Available styles include imperative, detailed, simple, and conventional. 
- `--keep-files`: Retain intermediate files created during the commit process
  in the root directory of the repository. 
- `--cmd`: Specify a custom command for Git operations. The default is 'git'. 

To see all the possible options and get more detailed information, run:

```bash 
gc-smart --help 
```

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

## Acknowledgments

The roots of this project stem from my personal journey exploring the
possibilities of AI. While I've observed that AI has its limitations in
implementing code, at least from my perspective, it can be very helpful for
documentation purposes. This is an aspect of my workflow that I often found to
be tortuous and time-consuming, especially when it comes to writing meaningful
commit messages. Thus, I began using my own script for fine-tuning commit
messages, which eventually led to the development of this project. It is
designed to integrate AI assistance into my workflow as seamlessly as possible,
without the need for copying diffs.

The core design, architecture, and implementation of this project, as well as
the selection of libraries, are the product of my initiative, borne out of
personal experimentation and implementation. AI was partially considered for
the implementation part, mainly in the integration of the OpenAI API within the
Python script. AI was mainly utilized for documentation, commenting, and
occasional troubleshooting. It proved particularly useful in ensuring clarity
and coherence in the project documentation.

While there might be other similar tools available, particularly those
integrated into IDEs, they were not considered in the development of this
project (at least not yet).

The ShellCheck tool has been useful in analyzing and finding bugs in the
shell scripts, helping to improve the overall implementation of the project.

SmartCommit itself was used for creating the commit messages and the commit
messages itself reflect also the changes within this project for the default
commit style setup.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.
