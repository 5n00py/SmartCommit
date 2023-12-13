check_git_repo() {
    # Check if inside a $GIT_CMDgit repo and abort script otherwise
    if ! $GIT_CMD rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not inside a Git repository."
        exit 2
    fi
}

check_staged_changes() {
    # Check if staged changes exist within the repo and abort otherwise
    if $GIT_CMD diff --cached --quiet; then
        echo "No staged changes to commit"
        exit 1
    fi
}

check_ai_helper() {
    # Check if ai script exists and is executable and abort otherwise
    if ! [[ -x "$GCS_ROOT/python/gpt-commit-prompter" ]] && ! command -v "$DIR/python/gpt-commit-prompter" &> /dev/null; then
        echo "Error: gpt-commit-prompter not found or not executable."
        exit 2
    fi
}

check_commit_template() {
    # Check if the commit template is set to tmp_commit_msg.txt. If not, inform
    # the user and give them an option to set it. If the user decides not to
    # set it, the script will abort. This is essential because the script
    # relies on the template to be set to tmp_commit_msg.txt for its
    # AI-generated commit messages.
    local current_template
    current_template=$(git config --get commit.template)

    # Check if the current commit template is set to tmp_commit_msg.txt
    if [[ "$current_template" != *'tmp_commit_msg.txt' ]]; then
        echo "The 'gc-smart' script requires 'tmp_commit_msg.txt' as the commit template to function correctly."
        # Ask if user wants to set tmp_commit_msg.txt as the commit template
        read -p "Would you like to set tmp_commit_msg.txt as your commit template? (y/n) " choice
        case "$choice" in
            y|Y )
                git config --global commit.template tmp_commit_msg.txt
                echo "tmp_commit_msg.txt is now set as your commit template."
                echo "Please re-run the gc-smart script to make the change effective!"
                exit 1
                ;;
            n|N|* )
                echo "Commit template not set to required tmp_commit_msg.txt. Script will abort."
                exit 1
                ;;
        esac
    fi
}

handle_git_commit_error() {
    # Handle specific Git errors encountered during the commit process,
    # particularly when a user does not modify the default commit message. If
    # the error log contains a message indicating that the user did not edit
    # the default commit message, this function will prompt the user with a
    # warning and provide them with an option to proceed without editing the
    # message or to abort the commit. Check if the error log contains a
    # specific message
    if grep -q "you did not edit the message" "$GIT_ROOT/git_error.log"; then
        # Warn the user
        echo "Warning: You either did not make any changes to the commit" \
        "message or you exited without saving. It's a good practice to customize" \
        "commit messages for clarity."
        read -p "Do you want to proceed without further editing and commit nevertheless? (y/n) " choice
        case "$choice" in
            y|Y )
                # Bypass commit.template and directly provide a
                # message from the file
                 $GIT_CMD commit -m "$(cat "$GIT_ROOT/tmp_commit_msg.txt")"
                ;;
            n|N )
                echo "Commit aborted."
                ;;
            * )
                echo "Invalid choice. Commit aborted."
                ;;
        esac
    else
        cat "$GIT_ROOT/git_error.log" # Display other errors if there are any
    fi
}

