#!/bin/bash

# Check if a file path was provided as an argument
if [ $# -eq 0 ]; then
    echo "No file path provided. Please provide a file path as an argument."
    exit 1
fi

# Set the base directory where your Dockerfiles are located
BASE_DIR="$PWD"

# Set your DockerHub username
DOCKERHUB_USERNAME="jpcaparas"

# File to store the tags of the successfully built images
TAGS_FILE="$1"

# Function to build and tag Docker images
build_and_tag() {
    local dockerfile="$1"

    # Get the relative path of the Dockerfile
    rel_path="${dockerfile#$BASE_DIR/}"

    # Extract the image name (first directory after BASE_DIR)
    # ... "/" char is the delimiter, "-f1" denotes selecting the first field
    image_name=$(echo "$rel_path" | cut -d'/' -f1)

    # Skip directories starting with a dot
    if [[ "$image_name" == .* ]]; then
        return
    fi

    # Extract the tag (remaining path without the image name and 'Dockerfile')
    tag=$(dirname "${rel_path#$image_name/}" | tr '/' '-')

    echo "Building image: $DOCKERHUB_USERNAME/$image_name:$tag"
    docker build -t "$DOCKERHUB_USERNAME/$image_name:$tag" -f "$dockerfile" "$(dirname "$dockerfile")"

    if [ $? -eq 0 ]; then
        echo "Successfully built $DOCKERHUB_USERNAME/$image_name:$tag"
        echo "$DOCKERHUB_USERNAME/$image_name:$tag" >> "$TAGS_FILE"
    else
        echo "Failed to build $DOCKERHUB_USERNAME/$image_name:$tag"
        exit 1
    fi
}

# Export the function so it can be used by GNU parallel
export -f build_and_tag
export DOCKERHUB_USERNAME
export BASE_DIR
export TAGS_FILE

# Clear the tags file
echo "" > "$TAGS_FILE"

# Iterate through the directory structure
find "$BASE_DIR" -name Dockerfile | parallel --verbose --halt soon,fail=1 build_and_tag

if [ $? -eq 0 ]; then
    # Remove leading blank lines from the TAGS_FILE
    sed -i '/^$/d' "$TAGS_FILE"
    echo "All images have been built and tagged. Here are the tags:"
    cat "$TAGS_FILE"
else
    echo "Build failed."
    exit 1
fi