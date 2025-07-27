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

# Function to clone or update git repository
manage_git_dependency() {
    local url="$1"
    local path="$2"
    local branch="$3"
    local description="$4"

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
            print_info "Updating existing repository: $path"
            cd "$path"

            # Fetch latest changes
            if git fetch origin >/dev/null 2>&1; then
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

                # Pull latest changes
                if git pull origin "$target_branch" >/dev/null 2>&1; then
                    print_success "Updated $path"
                else
                    print_warning "Failed to pull latest changes for $path"
                fi
            else
                print_warning "Failed to fetch updates for $path"
            fi
            cd - >/dev/null
        else
            print_warning "$path exists but is not a git repository. Removing and re-cloning."
            rm -rf "$path"
            manage_git_dependency "$url" "$path" "$branch" "$description"
        fi
    else
        # Directory doesn't exist, clone it
        print_info "Cloning repository: $url -> $path"

        if [[ -n "$branch" ]]; then
            if git clone --branch "$branch" --depth 1 "$url" "$path" >/dev/null 2>&1; then
                print_success "Cloned $path (branch: $branch)"
            else
                print_error "Failed to clone $url (branch: $branch)"
                return 1
            fi
        else
            if git clone --depth 1 "$url" "$path" >/dev/null 2>&1; then
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
    # Process dependency: {{@key}}
    {{#if (eq this.type "git")}}
    if ! manage_git_dependency \
        "{{this.url}}" \
        "{{this.path}}" \
    {{#if this.branch }}
        "{{this.branch}}" \
    {{else}}
        "master" \
    {{/if}}
        "{{this.description}}"; then
        ((failed_count++))
    fi
    {{else}}
    print_warning "Unsupported dependency type: {{this.type}} for {{@key}}"
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
main "$@"
