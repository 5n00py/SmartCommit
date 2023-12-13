# Function to backup existing commit template and set new one
backup_and_set_commit_template() {
    # Get current commit template
    local current_template
    current_template=$(git config --global --get commit.template)

    # Check if the current template is not 'tmp_commit_msg.txt'
    if [ "$current_template" != "tmp_commit_msg.txt" ]; then
        # Backup the current template
        git config --global commit.templateBackup "$current_template"
        # Set 'tmp_commit_msg.txt' as the new commit template
        git config --global commit.template tmp_commit_msg.txt
    fi
}

# Function to restore original commit template
restore_original_commit_template() {
    # Check if backup exists
    if git config --global --get commit.templateBackup > /dev/null 2>&1; then
        # Restore the original template
        git config --global commit.template "$(git config --global --get commit.templateBackup)"
        # Remove the backup entry
        git config --global --unset commit.templateBackup
    fi
}
