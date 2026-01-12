# Enabling Anonymous Authentication in Supabase

To complete the authentication setup, you need to enable anonymous sign-ins in your Supabase dashboard:

## Steps:

1. **Go to Supabase Dashboard**
   - Open your project at [supabase.com](https://supabase.com)

2. **Navigate to Authentication**
   - Click **Authentication** in the left sidebar
   - Click **Providers**

3. **Enable Anonymous Sign-ins**
   - Scroll down to find **"Anonymous Sign-ins"**
   - Toggle it **ON** (enable it)
   - Click **Save** if prompted

4. **Restart Your App**
   - After enabling, do a **Hot Restart** in your Flutter app (press `Shift + R`)
   - The app will automatically sign in anonymously on startup

## What This Does:

- ✅ Users get a persistent anonymous account
- ✅ No signup/login required
- ✅ Journal entries are saved with proper `user_id`
- ✅ RLS policies work correctly
- ✅ Data persists across app restarts

## Verification:

After enabling and restarting:
1. Open the AI Mentor Panel
2. Type a reflection and tap Save
3. Check your Supabase dashboard → **Table Editor** → `journal_entries`
4. You should see your entry with a `user_id` populated!
