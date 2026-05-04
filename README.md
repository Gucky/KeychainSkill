<p align="center">
  <img src="keychain/assets/keychain_circle.png" alt="Keychain" width="140">
</p>

<h1 align="center">Keychain Skill</h1>

<p align="center">
  <img alt="AI Agents - Skill" src="https://img.shields.io/badge/AI--Agents-Skill-EF9035?style=flat">
  <a href="LICENSE"><img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue?style=flat"></a>
  <a href="https://www.linkedin.com/in/wolfgang-muhsal-12408194/"><img alt="LinkedIn" src="https://img.shields.io/badge/Contact-LinkedIn-95a5a6.svg?style=flat"></a>
</p>

Keychain is an agent skill for Codex and other AI coding assistants that stores small secrets and reusable configuration values in the macOS Keychain.

It is useful when an AI workflow needs an API token, password, account-specific setting, or other value across sessions, but you do not want that value in project files, shell history, generated documentation, or chat output.

## Installing Keychain

Install the skill with `npx`:

```bash
npx skills add https://github.com/Gucky/KeychainSkill --skill keychain
```

To install it globally for Codex:

```bash
npx skills add https://github.com/Gucky/KeychainSkill --skill keychain --agent codex --global
```

For a specific agent:

```bash
npx skills add https://github.com/Gucky/KeychainSkill --skill keychain --agent claude-code
```

For all supported agents:

```bash
npx skills add https://github.com/Gucky/KeychainSkill --skill keychain --agent '*'
```

If `npx` is not available, install Node.js first. On macOS with Homebrew:

```bash
brew install node
```

## Using Keychain

In Codex, trigger the skill directly:

```text
$keychain
```

You can also ask naturally:

```text
Use the Keychain skill to store my GitHub token as github_token.
```

or:

```text
Use the Keychain skill to check whether github_token exists.
```

The simple item-name interaction is intentionally small:

- To store a value, provide an item name and the value.
- To read a value, provide the item name.
- Normal read checks show safe metadata, not the secret itself.
- Raw values should only be exposed when you explicitly ask for that.

Internally, each item is stored as a macOS generic password under the fixed service `keychain_skill`. The user-facing item name is stored as the Keychain account, so `github_token` becomes `service=keychain_skill`, `account=github_token`.

The skill also supports explicit service/account storage:

```bash
./scripts/keychain-write-account.sh "example.com" "user@example.com" "TOKEN"
./scripts/keychain-read-account.sh "example.com" "user@example.com"
```

## Safety Model

The skill is designed to avoid accidental secret disclosure:

- Secrets are stored in the macOS Keychain, not in this repository.
- The fixed Keychain service is `keychain_skill`; item names are stored as Keychain accounts.
- Advanced service/account entries use the service and account values provided by the caller.
- Normal reads report whether an item exists and how long the value is.
- Secret values are not printed by default.
- Raw values are meant for controlled command use, not for chat transcripts or generated files.

## Requirements

- macOS
- Node.js for `npx`
- An AI coding assistant that supports agent skills

## License

Keychain was created by [Wolfgang Muhsal](https://github.com/Gucky). It is available under the [MIT License](LICENSE), which permits commercial use, modification, distribution, and private use.
