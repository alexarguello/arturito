# Arturito

A starter kit for a personal AI agent built on Hermes Agent (Nous Research).
People fork this repo, run `bash setup.sh`, and get their own Arturito.
The repo holds no agent code. Hermes is the engine. This repo adds a personality and a setup script.

## Files

- `README.md` — user guide: needs, quick start, Discord steps, key safety.
- `setup.sh` — installs Hermes if missing, copies `SOUL.md`, sets the model, saves the user's own xAI key.
- `SOUL.md` — public personality template. `{{NAME}}` is replaced by `setup.sh`.
- `.env.example` — key names only. Values stay empty.
- `.gitignore` — blocks every private Hermes file.
- `Hermes_Tech_Talk_Slides.pdf` — the talk this project came from.

## Rules

- This repo is public. Never commit keys, tokens, user IDs, or anything copied from a real `~/.hermes` folder.
- Never read, print, or copy `~/.hermes/.env` or `~/.hermes/auth.json`. To check key names, use `sed 's/=.*/=<hidden>/' ~/.hermes/.env`.
- `SOUL.md` here must stay generic. Keep the `{{NAME}}` placeholder. No personal projects, employers, or plans.
- Do not add a full `config.yaml`. The script sets only what differs from Hermes defaults.
- The README tells users to run `bash setup.sh`, not `./setup.sh`. Web uploads drop the run permission.
- Write docs in plain words and short sentences.
- Check Hermes commands against the Hermes source or docs before you put them in the README. Hermes changes fast.

## How setup.sh works

1. Installs Hermes with `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup`, after asking.
2. Backs up any existing `$HERMES_HOME/SOUL.md`, then writes the template with the user's name.
3. Runs `hermes config set` for `model.provider` (xai), `model.default`, and `model.base_url`.
4. Reads the xAI key with a hidden prompt and writes `XAI_API_KEY` to `$HERMES_HOME/.env` with mode 600.

Discord is not handled by the script. Users run `hermes gateway setup`, then `hermes gateway run`.

Options: `HERMES_HOME` (default `~/.hermes`) and `ARTURITO_MODEL` (default `grok-4-1-fast-reasoning`).

## How to test

```bash
shellcheck setup.sh
HERMES_HOME="$(mktemp -d)" bash setup.sh      # use a fake key such as xai-TEST
```

Then check, with the same `HERMES_HOME`:

- `SOUL.md` has the name filled in and no `{{NAME}}` left.
- `.env` has one `XAI_API_KEY` line and mode 600.
- `hermes config get model.default` prints the model.
- `hermes auth status xai` says logged in.

Never test against the real `~/.hermes` folder.

## Open items

- The slides say Hermes v0.12, Telegram, and Docker + VPS. The README says Discord and xAI. One of them needs updating.
- The Hermes download step in `setup.sh` has not been run end to end on a clean machine.
- A real chat with a real xAI key after `setup.sh` has not been tested.
- Suggested: turn on Secret scanning and Push protection in the GitHub repo settings.
