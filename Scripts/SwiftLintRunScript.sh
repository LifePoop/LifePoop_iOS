if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
    project_root=$(git rev-parse --show-toplevel)
    swiftlint --config "${project_root}/.swiftlint.yml" --quiet
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
