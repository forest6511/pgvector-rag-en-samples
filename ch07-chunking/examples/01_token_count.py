"""Count tokens with tiktoken — the unit that actually matters for chunk budgets.

Chunk sizes are in tokens, not characters, because the embedding model's input limit
(8192 for text-embedding-3) and its cost are token-based.
"""

import tiktoken

enc = tiktoken.get_encoding("cl100k_base")

english = "PostgreSQL with pgvector stores embeddings next to the rows you filter by."
# A line with code-ish punctuation and a URL: token density differs from plain prose.
codey = "SELECT * FROM chunks ORDER BY embedding <=> '[0.1,0.2]' LIMIT 5; -- https://example.com"

for label, text in [("english prose", english), ("code + url", codey)]:
    n_chars = len(text)
    n_tokens = len(enc.encode(text))
    ratio = n_chars / n_tokens
    print(f"{label:>14} | {n_chars:3d} chars | {n_tokens:3d} tokens | {ratio:.2f} chars/token")
