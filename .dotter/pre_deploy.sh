#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect archive type using file command
detect_archive_type() {
    local archive_path="$1"

    if ! command_exists file; then
        print_error "file command not found. Please install file utilities."
        return 1
    fi

    local file_output=$(file -b "$archive_path" 2>/dev/null)

    # Convert to lowercase for easier matching
    file_output=$(echo "$file_output" | tr '[:upper:]' '[:lower:]')

    case "$file_output" in
        *"zip archive"*)
            echo "zip"
            ;;
        *"gzip compressed"*)
            # Need to distinguish between .tar.gz and .gz files
            if detect_gzip_content "$archive_path"; then
                echo "tar_gz"
            else
                echo "gzip"
            fi
            ;;
        *"xz compressed"*)
            echo "xz"
            ;;
        *"bzip2 compressed"*)
            echo "bzip2"
            ;;
        *"posix tar archive"*|*"tar archive"*)
            echo "tar"
            ;;
        *)
            print_error "Unsupported or unrecognized archive format: $file_output"
            return 1
            ;;
    esac
}

# Function to detect if gzip file contains tar data
detect_gzip_content() {
    local gzip_file="$1"

    # Method 1: Check file command output for original filename hints
    local file_output=$(file -b "$gzip_file" 2>/dev/null)

    # If the original filename is preserved and doesn't end with .tar, it's likely a single file
    if echo "$file_output" | grep -q 'was ".*[^r]"' && ! echo "$file_output" | grep -q 'was ".*\.tar"'; then
        return 1  # It's just .gz (single file)
    fi

    # Method 2: Content inspection - peek at decompressed content
    local peek_cmd=""
    if command_exists zcat; then
        peek_cmd="zcat"
    elif command_exists gunzip; then
        peek_cmd="gunzip -c"
    elif command_exists gzip; then
        peek_cmd="gzip -dc"
    else
        # If no decompression tools available, use filename heuristics
        print_warning "No gzip decompression tools found. Using filename heuristics."
        case "$(basename "$gzip_file")" in
            *.tar.gz|*.tgz)
                return 0  # Assume tar.gz
                ;;
            *)
                return 1  # Assume single .gz
                ;;
        esac
    fi

    # Peek at first 512 bytes of decompressed content and check if it's tar
    local content_type=$($peek_cmd "$gzip_file" 2>/dev/null | head -c 512 | file -b - 2>/dev/null | tr '[:upper:]' '[:lower:]')

    case "$content_type" in
        *"posix tar archive"*|*"tar archive"*|*"ustar archive"*)
            return 0  # It's tar.gz
            ;;
        *)
            return 1  # It's just .gz
            ;;
    esac
}

# Function to extract archive
extract_archive() {
    local archive_path="$1"
    local extract_dir="$2"

    print_info "Extracting archive: $archive_path"

    # Detect archive type using file command
    local archive_type=$(detect_archive_type "$archive_path")
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    print_info "Detected archive type: $archive_type"

    case "$archive_type" in
        "zip")
            if command_exists unzip; then
                unzip -q "$archive_path" -d "$extract_dir"
            else
                print_error "unzip command not found. Please install unzip."
                return 1
            fi
            ;;
        "tar_gz")
            if command_exists tar; then
                tar -xzf "$archive_path" -C "$extract_dir" --strip-components=1
            else
                print_error "tar command not found. Please install tar."
                return 1
            fi
            ;;
        "gzip")
            # Handle single .gz files
            if command_exists gunzip || command_exists gzip; then
                local filename=$(basename "$archive_path")
                local output_name="${filename%.gz}"
                if [[ "$output_name" == "$filename" ]]; then
                    output_name="${filename}.decompressed"
                fi

                if command_exists gunzip; then
                    gunzip -c "$archive_path" > "$extract_dir/$output_name"
                else
                    gzip -dc "$archive_path" > "$extract_dir/$output_name"
                fi
            else
                print_error "gunzip or gzip command not found. Please install gzip utilities."
                return 1
            fi
            ;;
        "xz")
            if command_exists tar; then
                tar -xJf "$archive_path" -C "$extract_dir" --strip-components=1
            else
                print_error "tar command not found. Please install tar."
                return 1
            fi
            ;;
        "bzip2")
            if command_exists tar; then
                tar -xjf "$archive_path" -C "$extract_dir" --strip-components=1
            else
                print_error "tar command not found. Please install tar."
                return 1
            fi
            ;;
        "tar")
            if command_exists tar; then
                tar -xf "$archive_path" -C "$extract_dir" --strip-components=1
            else
                print_error "tar command not found. Please install tar."
                return 1
            fi
            ;;
        *)
            print_error "Unsupported archive type: $archive_type"
            return 1
            ;;
    esac
}

# Function to download file
download_file() {
    local url="$1"
    local output_path="$2"

    if command_exists curl; then
        curl -L -o "$output_path" "$url" >/dev/null 2>&1
    elif command_exists wget; then
        wget -O "$output_path" "$url" >/dev/null 2>&1
    else
        print_error "Neither curl nor wget is available. Please install one of them."
        return 1
    fi
}

# Function to manage file dependencies
manage_file_dependency() {
    local url="$1"
    local path="$2"
    local version="$3"
    local description="$4"

    print_info "Managing file dependency: $description"

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$path")
    if [[ ! -d "$parent_dir" ]]; then
        print_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    # Add version to URL if specified
    local download_url="$url"
    if [[ -n "$version" ]]; then
        download_url="${url/\{version\}/$version}"
    fi

    # Check if file already exists and compare version
    local version_file="${path}.version"
    local current_version=""
    if [[ -f "$version_file" ]]; then
        current_version=$(cat "$version_file")
    fi

    if [[ -f "$path" && "$current_version" == "$version" ]]; then
        print_success "$path is already up to date (version: $version)"
        return 0
    fi

    print_info "Downloading file: $download_url -> $path"
    if download_file "$download_url" "$path"; then
        # Save version info
        if [[ -n "$version" ]]; then
            echo "$version" > "$version_file"
        fi
        print_success "Downloaded $path"
    else
        print_error "Failed to download $download_url"
        return 1
    fi
}

# Function to manage archive dependencies
manage_archive_dependency() {
    local url="$1"
    local path="$2"
    local version="$3"
    local description="$4"

    print_info "Managing archive dependency: $description"

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$path")
    if [[ ! -d "$parent_dir" ]]; then
        print_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    # Add version to URL if specified
    local download_url="$url"
    if [[ -n "$version" ]]; then
        download_url="${url/\{version\}/$version}"
    fi

    # Check if directory already exists and compare version
    local version_file="${path}/.version"
    local current_version=""
    if [[ -f "$version_file" ]]; then
        current_version=$(cat "$version_file")
    fi

    if [[ -d "$path" && "$current_version" == "$version" ]]; then
        print_success "$path is already up to date (version: $version)"
        return 0
    fi

    # Create temporary file for download
    local temp_file=$(mktemp)
    local archive_name=$(basename "$download_url")

    print_info "Downloading archive: $download_url"
    if download_file "$download_url" "$temp_file"; then
        # Remove existing directory if it exists
        if [[ -d "$path" ]]; then
            rm -rf "$path"
        fi

        # Create target directory
        mkdir -p "$path"

        # Extract archive
        if extract_archive "$temp_file" "$path"; then
            # Save version info
            if [[ -n "$version" ]]; then
                echo "$version" > "$version_file"
            fi
            print_success "Extracted archive to $path"
        else
            print_error "Failed to extract archive"
            rm -f "$temp_file"
            return 1
        fi

        # Clean up temporary file
        rm -f "$temp_file"
    else
        print_error "Failed to download $download_url"
        rm -f "$temp_file"
        return 1
    fi
}

# Function to manage binary dependencies
manage_binary_dependency() {
    local url="$1"
    local path="$2"
    local version="$3"
    local description="$4"

    print_info "Managing binary dependency: $description"

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$path")
    if [[ ! -d "$parent_dir" ]]; then
        print_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    # Add version to URL if specified
    local download_url="$url"
    if [[ -n "$version" ]]; then
        download_url="${url/\{version\}/$version}"
    fi

    # Check if binary already exists and compare version
    local version_file="${path}.version"
    local current_version=""
    if [[ -f "$version_file" ]]; then
        current_version=$(cat "$version_file")
    fi

    if [[ -f "$path" && "$current_version" == "$version" ]]; then
        print_success "$path is already up to date (version: $version)"
        return 0
    fi

    print_info "Downloading binary: $download_url -> $path"
    if download_file "$download_url" "$path"; then
        # Make binary executable
        chmod +x "$path"

        # Save version info
        if [[ -n "$version" ]]; then
            echo "$version" > "$version_file"
        fi
        print_success "Downloaded and installed binary $path"
    else
        print_error "Failed to download $download_url"
        return 1
    fi
}

# Function to clone or update git repository
manage_git_dependency() {
    local url="$1"
    local path="$2"
    local branch="$3"
    local description="$4"
    local filter="$5"

    print_info "Managing dependency: $description"

    # Check if git is available
    if ! command_exists git; then
        print_error "Git is not installed. Please install git to manage dependencies."
        return 1
    fi

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$path")
    if [[ ! -d "$parent_dir" ]]; then
        print_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    if [[ -d "$path" ]]; then
        # Directory exists, check if it's a git repository
        if [[ -d "$path/.git" ]]; then
            cd "$path"

            # Determine target branch
            if [[ -n "$branch" ]]; then
                target_branch="$branch"
            else
                # Get remote default branch
                target_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
                # If that fails, try common branch names
                if ! git show-ref --verify --quiet "refs/remotes/origin/$target_branch"; then
                    if git show-ref --verify --quiet "refs/remotes/origin/master"; then
                        target_branch="master"
                    elif git show-ref --verify --quiet "refs/remotes/origin/main"; then
                        target_branch="main"
                    else
                        # Use current branch as fallback
                        target_branch=$(git rev-parse --abbrev-ref HEAD)
                    fi
                fi
            fi

            current_branch=$(git rev-parse --abbrev-ref HEAD)

            # Switch to target branch if needed
            if [[ "$current_branch" != "$target_branch" ]]; then
                print_info "Switching to branch: $target_branch"
                git checkout "$target_branch" >/dev/null 2>&1 || {
                    print_warning "Branch $target_branch not found, trying to create it"
                    git checkout -b "$target_branch" "origin/$target_branch" >/dev/null 2>&1 || {
                        print_error "Failed to switch to branch $target_branch"
                        cd - >/dev/null
                        return 1
                    }
                }
            fi

            # Get current local commit hash
            local local_commit=$(git rev-parse HEAD 2>/dev/null)

            # Fetch latest changes to get remote refs
            if git fetch origin >/dev/null 2>&1; then
                # Get remote commit hash
                local remote_commit=$(git rev-parse "origin/$target_branch" 2>/dev/null)

                if [[ -n "$local_commit" && -n "$remote_commit" && "$local_commit" == "$remote_commit" ]]; then
                    print_success "$path is already up to date (commit: ${local_commit:0:8})"
                else
                    print_info "Updating repository: $path (${local_commit:0:8} -> ${remote_commit:0:8})"
                    # Pull latest changes
                    if git pull origin "$target_branch" >/dev/null 2>&1; then
                        print_success "Updated $path"
                    else
                        print_warning "Failed to pull latest changes for $path"
                    fi
                fi
            else
                print_warning "Failed to fetch updates for $path"
            fi
            cd - >/dev/null
        else
            print_warning "$path exists but is not a git repository. Removing and re-cloning."
            rm -rf "$path"
            manage_git_dependency "$url" "$path" "$branch" "$description" "$filter"
        fi
    else
        # Directory doesn't exist, clone it
        print_info "Cloning repository: $url -> $path"
        git_cmd="git clone"
        if [[ -n "$filter" ]]; then
            git_cmd="$git_cmd --filter=$filter"
        fi

        if [[ -n "$branch" ]]; then
            if $($git_cmd --branch $branch --depth 1 $url $path >/dev/null 2>&1); then
                print_success "Cloned $path (branch: $branch)"
            else
                print_error "Failed to clone $url (branch: $branch)"
                return 1
            fi
        else
            if $($git_cmd $url $path >/dev/null 2>&1); then
                print_success "Cloned $path"
            else
                print_error "Failed to clone $url"
                return 1
            fi
        fi
    fi
}

# Main dependency management
main() {
    print_info "Starting dependency management..."

    # Check if dependencies are defined
    {{#if dependencies}}
    local failed_count=0

    {{#each dependencies}}
    # Process dependency: {{@key}}.{{@key}}
    {{#if (eq this.type "git")}}
    if ! manage_git_dependency \
        "{{this.url}}" \
        "dependencies/{{this.path}}" \
        {{#if this.branch}}"{{this.branch}}"{{else}}"master"{{/if}} \
        "{{this.description}}" \
        {{#if this.filter}}"{{this.filter}}"{{else}}""{{/if}}; then
        ((failed_count++))
    fi
    {{else if (eq this.type "file")}}
    if ! manage_file_dependency \
        "{{this.url}}" \
        "dependencies/{{this.path}}" \
        {{#if this.version}}"{{this.version}}"{{else}}""{{/if}} \
        "{{this.description}}"; then
        ((failed_count++))
    fi
    {{else if (eq this.type "archive")}}
    if ! manage_archive_dependency \
        "{{this.url}}" \
        "dependencies/{{this.path}}" \
        {{#if this.version}}"{{this.version}}"{{else}}""{{/if}} \
        "{{this.description}}" \
        {{#if this.name}}"{{this.name}}"{{else}}{{@key}}{{/if}}; then
        ((failed_count++))
    fi
    {{else if (eq this.type "binary")}}
    if ! manage_binary_dependency \
        "{{this.url}}" \
        "dependencies/{{this.path}}" \
        {{#if this.version}}"{{this.version}}"{{else}}""{{/if}} \
        "{{this.description}}"; then
        ((failed_count++))
    fi
    {{else}}
    print_warning "Unsupported dependency type: {{this.type}} for {{@../key}}.{{@key}}"
    {{/if}}
    {{/each}}

    if [[ $failed_count -gt 0 ]]; then
        print_error "$failed_count dependencies failed to install/update"
        exit 1
    else
        print_success "All dependencies managed successfully!"
    fi
    {{else}}
    print_info "No dependencies defined."
    {{/if}}
}

# Run main function
{{#if download_dependencies}}
main "$@"
{{/if}}

chmod +x ./scripts/*
