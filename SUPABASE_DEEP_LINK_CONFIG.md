# Supabase Deep Link Configuration

## Steps to Update Redirect URL

1. **Go to Supabase Dashboard**
   - Navigate to your project at https://supabase.com/dashboard

2. **Open Authentication Settings**
   - Click **Authentication** in the left sidebar
   - Click **URL Configuration**

3. **Update Redirect URLs**
   - Find the **"Redirect URLs"** section
   - Add the following URL:
     ```
     scripturelens://confirm
     ```
   - Click **Save**

4. **Verify Email Template**
   - Go to **Authentication** → **Email Templates**
   - Select **"Confirm signup"**
   - The template should use `{{ .ConfirmationURL }}` which will automatically use the redirect URL

## What This Does

- Email confirmation links will now open your app with the scheme `scripturelens://confirm`
- The app will automatically handle the auth callback via Supabase
- No more localhost:3000 errors!

## Testing

1. Sign up with a new email address
2. Check your email for the confirmation link
3. Click the link on your mobile device
4. The app should open automatically and log you in

> **Note**: Make sure you've restarted the app after running `flutter pub get` to ensure the deep link configuration is active.
