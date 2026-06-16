"""RecursiveCharacterTextSplitter: character-budget vs token-budget chunking.

The recursive splitter walks a separator hierarchy (paragraph -> line -> word -> char)
so each chunk keeps the largest semantic unit that fits. Default length is in characters;
swap in a tiktoken counter to budget by tokens instead.
"""

from langchain_text_splitters import RecursiveCharacterTextSplitter

doc = (
    "Vector search on Postgres starts with chunking. "
    "Each chunk becomes one row in the chunks table, with one embedding. "
    "Smaller chunks mean more rows and a bigger index; larger chunks mean coarser retrieval. "
    "The chunk size you pick is the first lever on the RAM wall.\n\n"
    "Token budgets matter more than character budgets. "
    "The embedding model charges per token and caps input at a token count, not a character count. "
    "So measure chunks in tokens, especially for code and non-Latin text where the ratio shifts."
)

# Show the default separator hierarchy (don't pin it from memory — read it from the instance).
char_splitter = RecursiveCharacterTextSplitter(chunk_size=120, chunk_overlap=0)
print("default separators:", char_splitter._separators)

char_chunks = char_splitter.split_text(doc)
print(f"\n=== char budget (chunk_size=120 chars, overlap=0) -> {len(char_chunks)} chunks ===")
for i, c in enumerate(char_chunks):
    print(f"  [{i}] {len(c):3d} chars: {c[:60]!r}...")

token_splitter = RecursiveCharacterTextSplitter.from_tiktoken_encoder(
    encoding_name="cl100k_base", chunk_size=40, chunk_overlap=0,
)
token_chunks = token_splitter.split_text(doc)
print(f"\n=== token budget (chunk_size=40 tokens, overlap=0) -> {len(token_chunks)} chunks ===")
import tiktoken

enc = tiktoken.get_encoding("cl100k_base")
for i, c in enumerate(token_chunks):
    print(f"  [{i}] {len(enc.encode(c)):2d} tokens: {c[:60]!r}...")
