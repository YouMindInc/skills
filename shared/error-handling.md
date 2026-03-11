# Error Handling

When any `youmind call` command fails:

1. Show the error **in the user's language**
2. Suggest the user report persistent issues at https://github.com/user-attachments/youmind/issues

## Common Errors

| Error | User Message |
|-------|-------------|
| `401` / `403` | API key is invalid or expired. Get a new one at https://youmind.com/settings/api-keys |
| `429` | Rate limit exceeded. Please wait a moment and try again. |
| `500+` | YouMind service error. Please try again later. |
| CLI not installed | Install the YouMind CLI first: `npm install -g @youmind-ai/cli` |
| API key missing | Set your API key in your shell or `.env` file. Get one at https://youmind.com/settings/api-keys |
