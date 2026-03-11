# Error Handling

When any `youmind call` command fails:

1. Show the error **in the user's language** (do NOT use English if the user writes in Chinese/Japanese/Korean/etc.)
2. Suggest the user report persistent issues at https://github.com/YouMindInc/youmind/issues

## Common Errors

Error messages below are English templates. **Always translate to the user's language before showing.**

| Error | User Message (translate to user's language) |
|-------|-------------|
| `401` / `403` | API key is invalid or expired. Get a new one at https://youmind.com/settings/api-keys |
| `429` | Rate limit exceeded. Please wait a moment and try again. |
| `500+` | YouMind service error. Please try again later. |
| CLI not installed | Install the YouMind CLI first: `npm install -g @youmind-ai/cli` |
| API key missing | Set your API key in your shell or `.env` file. Get one at https://youmind.com/settings/api-keys |
