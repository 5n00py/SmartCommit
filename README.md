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

## Contributing

Contributions are welcome! Please fork this repository and open a pull request
with your changes.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.
