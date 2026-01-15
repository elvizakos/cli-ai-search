# cli-ai-search

Command line tool for semantic search.

## Requirements

  * Bash
  * coreutils
  * curl
  * jq
  * awk or gawk
  * findutils
  * ocrmypdf
  * tesseract-ocr
  * pandoc
  * sqlite3
  * inotify-tools
  * ollama

## Supported document formats

  * plain text
  * ms-office documents docx
  * libreoffice/openoffice documents odt
  * PDF
  * HTML
  * RTF
  * EPUB
  * rst
  * org
  * markdown

## Install

### For current user only

#### Using make

```sh
make clean
make install-user
```

#### Manually
For local user use only:
```sh
cp cli-ai-search .local/bin/
chmod +x .local/bin/cli-ai-search

./cli-ai-search build
./cli-ai-search scan /path/to/documents
```

## To Do:

  * Support LM-Studio
  * Support vllm
  * Support llama.cpp
  * Support Open AI's v1 API
  * Support Google's API
  * Support for MySQL and MariaDB databases
  * Support for PostgreSQL
