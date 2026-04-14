# ai-client

Simple containerized AI client environment for working with attached repositories.

---

## Environment variables

Before running the container:

Add the required variable `ANTHROPIC_API_KEY`

Example:

```bash
ANTHROPIC_API_KEY=your_api_key_here
```

This variable is required for the AI client to work correctly.

### Optional: export globally in your shell

If you want to make the key available in your host shell as well, run:

```bash
export ANTHROPIC_API_KEY=your_api_key_here
```

To make it persistent across terminal sessions:

Linux
```bash
echo 'export ANTHROPIC_API_KEY=your_api_key_here' >> ~/.bashrc
source ~/.bashrc
```
Mac
```bash
echo 'export ANTHROPIC_API_KEY=your_api_key_here' >> ~/.zshrc
source ~/.zshrc
```

---

## Project structure

```text
.
├── bin/
│   ├── build                # build image + initialize config
│   └── run                  # run container
├── workspace/               # place repositories and project files here
├── templates/               # default template files
├── claude_config/           # generated Claude runtime config
├── .ai_env                  # generated project env file
├── Dockerfile
```

---

## How to run

### 1. Build the image and generate templates

```bash
bin/build
```

This command will automatically:

build the Docker image
create .ai_env if it does not exist
create claude_config/ if it does not exist

You do not need to manually create these files.
---

### 2. Add repositories

Put any repositories or project folders inside:

```text
workspace/
```

Example:

```text
workspace/
├── repo-one/
├── repo-two/
└── test-project/
```

These repositories will be available inside the container.

---
### 3. Add environment variables 
The .ai_env file is used for project-specific environment variables only.

Example:

TEST=test
APP_ENV=dev
FEATURE_FLAG=true

---
### 4. Run the container

```bash
bin/run
```

This launches the AI client container with attached repositories and environment variables loaded from `.ai_env`.

---

## Typical workflow

```bash
bin/build
echo "TEST=test" > .ai_env
cp -r ~/my-project attach/
bin/run
```

---

## Notes

* `.ai_env` is for project variables only
* `ANTHROPIC_API_KEY` should be exported in shell profile
* `claude_config/`, `.ai_env`, and `workspace/*` are ignored by Git
* Never commit API keys, secrets
