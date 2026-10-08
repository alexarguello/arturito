# Arturito

A personal AI agent built on [Hermes Agent](https://hermes-agent.nousresearch.com/).

"Arturito" is how R2‑D2 sounds in Spanish. Like the droid, he is loyal, short on words, and good at getting things done.

Fork this repo, run one script, and you have your own Arturito. He remembers what you tell him, learns new skills over time, and can talk to you from the terminal or from Discord.

## What is in this repo

| File | What it is |
|---|---|
| `SOUL.md` | Arturito's personality. Hermes reads it at the start of every chat. |
| `setup.sh` | Installs Hermes, copies the personality, and saves your own key. |
| `.env.example` | The key names Hermes expects. No real keys. |
| `Hermes_Tech_Talk_Slides.pdf` | The talk this project came from. |

Everything else (memory, skills, chat history) is created by Hermes on your machine and stays there.

## What you need

- **Linux, macOS, or Windows with WSL.** On Windows, run `wsl --install` in PowerShell first, then open Ubuntu.
- **Your own xAI API key.** Get one at [console.x.ai](https://console.x.ai/). Arturito uses Grok by default.
- **A Discord account**, only if you want to chat from Discord.

You pay for your own model usage. No key is shared through this repo.

## Quick start

```bash
git clone https://github.com/alexarguello/arturito.git
cd arturito
bash setup.sh
```

The script asks three things:

1. May it install Hermes? (Skipped if you already have it.)
2. What should Arturito call you?
3. Your xAI key. It does not show on screen.

Then say hello:

```bash
hermes
```

Try `who are you?` first. Then give him a real task.

## What the script changes

| Change | Where |
|---|---|
| Installs Hermes with the official installer | `~/.hermes/hermes-agent` |
| Writes the personality, with your name in it | `~/.hermes/SOUL.md` |
| Sets the model to `xai` / `grok-4-1-fast-reasoning` | `~/.hermes/config.yaml` |
| Saves your key, readable only by you | `~/.hermes/.env` |

If you already had a `SOUL.md`, the script keeps a backup next to it.

Want a different model? Answer "n" at the xAI question and the Hermes model picker opens. Or set another Grok model up front:

```bash
ARTURITO_MODEL=grok-4-fast-reasoning bash setup.sh
```

## Talk to Arturito on Discord

1. Create a bot in the [Discord Developer Portal](https://discord.com/developers/applications) and copy its token.
2. On the bot page, turn on **Message Content Intent** and **Server Members Intent**. The bot will not connect without them.
3. Run the guided setup and pick Discord:

   ```bash
   hermes gateway setup
   ```

   It checks your token, prints an invite link for your server, and offers to add you as an allowed user.

4. Start the gateway:

   ```bash
   hermes gateway run
   ```

The full walkthrough is in the [Hermes Discord guide](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/discord). Hermes also supports Telegram, Slack, WhatsApp and more through the same `hermes gateway setup` command.

## Make it yours

Open `~/.hermes/SOUL.md` and edit it. This is the part that makes the agent yours.

- Change the name. He does not have to be Arturito.
- Rewrite **What I help with** to match your real work.
- Keep it short. Hermes sends this text with every chat.

Changes apply to your next chat.

## Keep your keys safe

Your Hermes folder holds private data. If you copy files from it into your fork, **never commit these**:

| File or folder | Why |
|---|---|
| `.env`, `auth.json` | Your API keys and logins |
| `memories/` | What your agent knows about you |
| `sessions/`, `logs/`, `pastes/`, `state.db` | Your chat history |
| `channel_directory.json`, `discord_threads.json`, `gateway_state.json`, `pairing/` | Your Discord or Telegram details |
| `config.yaml` | Can hold IDs and keys. Share a cleaned copy only. |

The `.gitignore` in this repo already blocks all of them. Also turn on **Secret scanning** and **Push protection** in your fork's GitHub settings. GitHub will then stop a push that contains a key.

If a key ever leaks, delete it in the provider's console and make a new one. Removing the commit is not enough.

## Useful commands

```bash
hermes                  # chat in the terminal
hermes model            # change model or provider
hermes gateway setup    # connect Discord, Telegram, Slack...
hermes gateway run      # run the chat gateway (best choice on WSL)
hermes update           # get the latest Hermes
hermes config edit      # open your config file
```

## Learn more

- [Hermes Agent docs](https://hermes-agent.nousresearch.com/docs)
- [Slides: "HERMES: From Chatbots to Long-Running AI Agents"](Hermes_Tech_Talk_Slides.pdf)

## License

MIT. See [LICENSE](LICENSE).

Built by [Alexandra Arguello](https://github.com/alexarguello). Fork it. Make it yours.
