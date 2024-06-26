#!/bin/bash

# Set the base directory where your Dockerfiles are located
BASE_DIR="$PWD"

# Set your DockerHub username
DOCKERHUB_USERNAME="jpcaparas"

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
    else
        echo "Failed to build $DOCKERHUB_USERNAME/$image_name:$tag"
    fi
}

# Export the function so it can be used by GNU parallel
export -f build_and_tag
export DOCKERHUB_USERNAME
export BASE_DIR

# Iterate through the directory structure
find "$BASE_DIR" -name Dockerfile | parallel build_and_tag

echo "All images have been built and tagged."