---
trigger: always_on
---

# Privacy & Data Handling (Crucial)

- **The Toggle Rule:** Every journal entry creation flow MUST include an `ai_access_enabled` boolean.
- **On-Device First:** - All initial sentiment analysis must be performed on-device using Gemini Nano.
    - Never send journal content to cloud APIs (Claude/GPT) unless `ai_access_enabled` is explicitly TRUE.
- **Encryption:** Use AES-256 for local storage via `flutter_secure_storage`.
- **Vector Sync:** When syncing to Pinecone, strip all PII (Personally Identifiable Information) before embedding generation.
- **Confirmation:** Before any terminal command that alters the Database Schema or Environment Variables, ask for explicit manual approval.
## Security & Data Handling
- **The "Local-First" Guardrail:** All raw journal text must be stored in an encrypted local database (Drift + SQLCipher). Never store raw text in unencrypted shared preferences.
- **AI Toggle Logic:** - The `ai_access_enabled` field must be a mandatory parameter in the Journal Model.
    - If `false`, the embedding service must be completely bypassed.
    - If `true`, the agent must show a one-time "Privacy Consent" modal explaining how the vector memory works.
- **PII Scrubbing:** Before sending any journal content to the Embedding API (OpenAI/Gemini), use a Regex filter to strip potential names, phone numbers, or email addresses.
- **Offline Mode:** The Bible reader must be fully functional offline. Only "AI Insights" and "Vector Sync" require an internet connection.