---
name: keychain
description: Store and retrieve small secrets or configuration values in the macOS Keychain for Codex and skills. Use when a user asks to save a token, credential, secret, value, API key, password, or reusable project/session value in Keychain, or to read one back by item name in later Codex chats without committing it to files.
---

# Keychain

Use macOS Keychain as the persistent secret store. The user-facing contract is intentionally small:

- Write requires exactly two user inputs: item name and value.
- Read requires exactly one user input: item name.

Never put real secret values in `SKILL.md`, `AGENTS.md`, repo files, `.codex/config.toml`, generated docs, logs, or final chat text. Print only confirmation metadata unless the user explicitly asks for the raw value.

## Required Tools

Use the bundled scripts from this skill. Do not improvise different `security` commands unless a script itself is broken.

Run commands from the directory that contains this `SKILL.md`, or set `SKILL_ROOT` to that directory after locating the skill folder in the current Codex session. Do not assume a user-specific absolute path.

## Write

When the user asks to write a value, require:

- item name
- value

Run:

```bash
./scripts/keychain-write.sh "ITEM_NAME" "VALUE"
```

Expected successful output:

```text
stored=yes
item=ITEM_NAME
value_length=N
```

If the command fails with Keychain authorization, sandbox, or “unable to obtain authorization” behavior, immediately retry the exact same command with escalated/outside-sandbox permission. The escalation justification should say that Codex needs permission to write the named test or secret value to macOS Keychain.

Do not echo the value before, during, or after writing.

## Read

When the user asks to read a value, require:

- item name

Run:

```bash
./scripts/keychain-read.sh "ITEM_NAME"
```

Expected successful output:

```text
rc=0
found=yes
item=ITEM_NAME
length=N
```

The script deliberately does not print the raw value. If another command needs the secret, compose a command that reads it into a local variable and uses it without printing it.

If the read command exits nonzero, do not report “not found” automatically. Sandboxed Keychain reads can falsely look like missing items. Retry the exact same read command with escalated/outside-sandbox permission first. Only after an escalated retry fails should you report the item as not readable or not found, including the return code and sanitized error.

## Raw Value Use

Default: do not show raw values in chat.

If the user explicitly asks to print the raw value, confirm that this will expose the secret in the chat transcript before doing it. For normal verification, report metadata only:

```text
found=yes
length=N
value_matches_expected=yes/no
```

For using a value in another command, prefer:

```bash
secret="$(./scripts/keychain-read-raw.sh "ITEM_NAME")"
```

Then pass `$secret` to the command without printing it.

## Common Examples

Store a value:

```bash
./scripts/keychain-write.sh "codex_test_value" "42"
```

Check that it exists:

```bash
./scripts/keychain-read.sh "codex_test_value"
```

Check that it equals an expected value without printing it:

```bash
v="$(./scripts/keychain-read-raw.sh "codex_test_value")"
printf "found=yes\nlength=%d\nvalue_is_42=%s\n" "${#v}" "$([[ "$v" == "42" ]] && echo yes || echo no)"
```
