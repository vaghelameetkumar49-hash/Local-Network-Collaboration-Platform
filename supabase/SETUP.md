# Supabase setup for Orbit

This repository is prepared for a Supabase-backed shared workspace. The SQL creates accounts-compatible workspace membership, projects, tasks, row-level security policies, invite codes and Realtime publication.

## Android-friendly setup
1. Open https://supabase.com/dashboard and create a free project.
2. Choose a strong database password and save it privately.
3. Open **SQL Editor → New query**.
4. Copy all contents of `schema.sql` from this folder, paste it, and press **Run**.
5. Open **Project Settings → API** and copy the **Project URL** and **anon/public key**. Never expose the service_role key.
6. The frontend connection still needs those two public values. Add them to the app's public configuration only after the next integration step.

## Security model
- User identity is handled by Supabase Auth.
- Row Level Security limits workspace, project, task and roster reads/writes to signed-in workspace members.
- Workspace owners create a workspace and share its invite code; teammates join with that code.
- The anon/public key is intended for browser use with RLS enabled. The service_role key must never be placed in frontend code or shared in chat.

## Current status
The SQL backend schema is provided. The current published frontend remains the local-storage demo until the Supabase URL/public key are entered and the authentication + data-sync frontend integration is completed and tested.
