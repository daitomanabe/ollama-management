# ollama-management

Safe startup helpers for running Ollama on a MacBook Pro with Apple M5 Max.

## Why this exists

On this machine, plain `ollama serve` with Ollama `0.18.2` can start successfully but then fail on the first `ollama run` with a Metal compile/runtime error in the BF16 path.

This repository contains a minimal workaround that keeps Metal enabled while disabling the problematic BF16 path:

```bash
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KV_CACHE_TYPE=q8_0
export GGML_METAL_BF16_DISABLE=1
```

## Files

- `ollama-serve-safe`
  Starts Ollama with the required environment variables for Apple M5 Max.
  If Ollama is already running on `127.0.0.1:11434`, it exits cleanly instead of failing on a second bind.
- `local.ollama.safe.plist`
  LaunchAgent template. It uses `{repo_path}` as a placeholder so local absolute paths are not committed.
- `install-launchagent.zsh`
  Generates a local LaunchAgent plist in `~/Library/LaunchAgents` with the real path for the current checkout.

## Tested environment

- MacBook Pro
- Apple M5 Max
- macOS `26.3.1`
- Ollama `0.18.2`

## Quick start

Run Ollama manually:

```bash
chmod +x ./ollama-serve-safe
./ollama-serve-safe
```

If Ollama is already running, the script exits with a message like:

```text
Ollama is already running on http://127.0.0.1:11434 (pid 12345).
```

Then verify:

```bash
ollama run qwen3:14b "Reply with OK only."
```

## LaunchAgent usage

Install a real LaunchAgent plist for the current checkout:

```bash
./install-launchagent.zsh
```

This writes:

```text
${HOME}/Library/LaunchAgents/local.ollama.safe.plist
```

Load the LaunchAgent:

```bash
launchctl bootstrap gui/$(id -u) "${HOME}/Library/LaunchAgents/local.ollama.safe.plist"
launchctl kickstart -k gui/$(id -u)/local.ollama.safe
```

Stop it:

```bash
launchctl bootout gui/$(id -u) "${HOME}/Library/LaunchAgents/local.ollama.safe.plist"
```

## Notes

- This workaround disables the BF16 Metal path only.
- `GGML_METAL_TENSOR_DISABLE=1` is broader and was not necessary on this machine.
- The model directory is explicitly set to:

```text
${HOME}/.ollama/models
```

## License

MIT
