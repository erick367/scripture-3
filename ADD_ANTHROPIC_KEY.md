# Adding Your Anthropic API Key

To enable AI-powered insights, you need to add your Anthropic API key to `config.json`.

## Steps:

1. **Get your API key** from https://console.anthropic.com/settings/keys

2. **Open** `config.json` in your project root

3. **Add** the `ANTHROPIC_API_KEY` field:

```json
{
  "SUPABASE_URL": "your-supabase-url",
  "SUPABASE_ANON_KEY": "your-supabase-key",
  "ANTHROPIC_API_KEY": "sk-ant-api03-..."
}
```

4. **Save** the file

5. **Restart** your app

## Testing

1. Tap any insight trigger in the Bible reader
2. You should see "Generating Revelation..." shimmer
3. After a few seconds, AI-generated insights will appear in the Meaning tab

> **Note**: The API key is kept in `config.json` which is gitignored for security.
