# Supabase foundation

The app is currently **local-first**. Supabase is initialized only when both
public build-time values are provided; it does not yet read or write data,
enable authentication, or create a cloud backup.

Use the project dashboard to obtain the URL and the **publishable** key. Never
use a `service_role` or secret key in a mobile build.

For a local Android build:

```powershell
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

For a release build, pass the same two `--dart-define` values to `flutter build`.
Omitting either value is intentional and keeps the application fully local.

Before adding a cloud table, enable RLS and add ownership policies using
`(select auth.uid()) = user_id`; then run the Supabase security advisors and a
test query. Google sign-in remains out of scope until Android OAuth is
configured.
