# Znas Upload Action

[![GitHub Super-Linter](https://github.com/mall1/znas-upload-action/actions/workflows/linter.yml/badge.svg)](https://github.com/super-linter/super-linter)
![CI](https://github.com/mall1/znas-upload-action/actions/workflows/ci.yml/badge.svg)

This action uploads a file or folder (zipped) to a specified URL using
Puppeteer. It is specifically designed for uploading files to **极空间 (Znas)**
file collection links.

## Use Case

This action is ideal for automating the process of uploading files to **极空间
(Znas)**, which provides centralized file storage and sharing capabilities.
Typical scenarios include:

1. Automatically uploading build artifacts, logs, or other output files
   generated during CI/CD pipeline runs.
1. Compressing files or directories into a ZIP archive and uploading them to
   **极空间** file collection links without manual intervention.

By integrating with GitHub Actions, this action allows teams or organizations
that use **极空间** for file management to streamline their workflow and collect
files in a more efficient and automated manner.

## Usage

Here's an example of how to use this action in a workflow file:

```yaml
name: Example Workflow

on:
  workflow_dispatch:
    inputs:
      upload_url:
        description: The URL to upload files to
        required: true
        default: 'https://example.com/upload'
        type: string
      upload_path:
        description: The path of the folder or file to upload
        required: true
        type: string

jobs:
  upload-znas:
    name: Upload to Znas
    runs-on: ubuntu-latest

    steps:
      # Change @main to a specific commit SHA or version tag, e.g.:
      # mall1/znas-upload-action@e76147da8e5c81eaf017dede5645551d4b94427b
      # mall1/znas-upload-action@v1.2.3
      - name: Upload file to Znas
        uses: mall1/znas-upload-action@main
        with:
          upload_url: ${{ inputs.upload_url }}
          upload_path: ${{ inputs.upload_path }}
```

For example workflow runs, check out the
[Actions tab](https://github.com/mall1/znas-upload-action/actions)! :rocket:

## Inputs

| Input         | Default | Description                              |
| ------------- | ------- | ---------------------------------------- |
| `upload_url`  | N/A     | The URL to upload files to               |
| `upload_path` | N/A     | The path of the folder or file to upload |

## Outputs

| Output          | Description                       |
| --------------- | --------------------------------- |
| `uploaded_file` | The path of the uploaded ZIP file |

## Test Locally

After you've cloned the repository to your local machine or codespace, you'll
need to perform some initial setup steps before you can test your action.

> [!NOTE]  
> You'll need to have a reasonably modern version of
> [Docker](https://www.docker.com/get-started/) handy (e.g. Docker engine
> version 20 or later).

1. :hammer_and_wrench: Build the container

   Make sure to replace `mall1/znas-upload-action` with an appropriate label for
   your container.

   ```bash
   docker build -t mall1/znas-upload-action .
   ```

1. :white_check_mark: Test the container

   You can pass individual environment variables using the `--env` or `-e` flag.

   ```bash
   docker run \
     --env INPUT_UPLOAD_URL="https://example.com/upload" \
     --env INPUT_UPLOAD_PATH="path/to/file" \
     mall1/znas-upload-action
   ```

   Or you can pass a file with environment variables using `--env-file`.

   ```bash
   echo "INPUT_UPLOAD_URL=\"https://example.com/upload\"" > ./.env.test
   echo "INPUT_UPLOAD_PATH=\"path/to/file\"" >> ./.env.test

   docker run --env-file ./.env.test mall1/znas-upload-action
   ```
