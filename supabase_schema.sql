-- Enable pgvector extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS vector;

-- Create journal_entries table
CREATE TABLE IF NOT EXISTS public.journal_entries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    local_id INTEGER, -- Reference to local SQLite ID
    content TEXT, -- Optional, can keep null for privacy if only storing embeddings
    ai_access_enabled BOOLEAN DEFAULT false,
    embedding vector(1536), -- For OpenAI embeddings
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create function to match journal entries
CREATE OR REPLACE FUNCTION public.match_journal_entries(
  query_embedding vector(1536),
  match_threshold float,
  match_count int
)
RETURNS TABLE (
  id UUID,
  local_id INTEGER,
  content TEXT,
  similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    journal_entries.id,
    journal_entries.local_id,
    journal_entries.content,
    1 - (journal_entries.embedding <=> query_embedding) AS similarity
  FROM journal_entries
  WHERE 1 - (journal_entries.embedding <=> query_embedding) > match_threshold
  ORDER BY journal_entries.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- Create user_vault table for secure key backup
CREATE TABLE IF NOT EXISTS public.user_vault (
    user_id UUID REFERENCES auth.users(id) NOT NULL PRIMARY KEY,
    encrypted_db_key TEXT NOT NULL, -- The AES-256 key for Drift
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for Vault
ALTER TABLE public.user_vault ENABLE ROW LEVEL SECURITY;

-- Vault Policy: Full access to own vault
CREATE POLICY "Users can manage own vault" ON public.user_vault
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Create index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_journal_entries_user_id ON public.journal_entries(user_id);

-- Create index on created_at for sorting
CREATE INDEX IF NOT EXISTS idx_journal_entries_created_at ON public.journal_entries(created_at DESC);

-- Create index on embedding for vector similarity search
CREATE INDEX IF NOT EXISTS idx_journal_entries_embedding ON public.journal_entries 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Enable Row Level Security
ALTER TABLE public.journal_entries ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see their own entries
CREATE POLICY "Users can view own journal entries"
ON public.journal_entries
FOR SELECT
USING (auth.uid() = user_id);

-- Create policy: Users can insert their own entries
CREATE POLICY "Users can insert own journal entries"
ON public.journal_entries
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can update their own entries
CREATE POLICY "Users can update own journal entries"
ON public.journal_entries
FOR UPDATE
USING (auth.uid() = user_id);

-- Create policy: Users can delete their own entries
CREATE POLICY "Users can delete own journal entries"
ON public.journal_entries
FOR DELETE
USING (auth.uid() = user_id);

-- Create function to automatically set user_id on insert
CREATE OR REPLACE FUNCTION public.handle_journal_entry_user_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.user_id = auth.uid();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to set user_id
CREATE TRIGGER set_journal_entry_user_id
BEFORE INSERT ON public.journal_entries
FOR EACH ROW
EXECUTE FUNCTION public.handle_journal_entry_user_id();

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
CREATE TRIGGER set_journal_entry_updated_at
BEFORE UPDATE ON public.journal_entries
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();
