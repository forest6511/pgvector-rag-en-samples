# Chapter 7: chunking for English & multilingual corpora

Runnable samples for *pgvector at Scale for PostgreSQL*, Chapter 7 — turning documents into
chunks you can embed. These are pure tokenizer / text-splitter demos; no database is needed
(each chunk would become one row in the Chapter 5 `chunks` table, which Chapter 8 indexes).

## Environment

- Python 3 (venv)
- tiktoken, langchain-text-splitters, spaCy (+ `en_core_web_sm`), NLTK (+ `punkt_tab`)

> **At time of writing**: tiktoken 0.13.0, langchain-text-splitters 1.1.2, spaCy 3.8.13
> (model en_core_web_sm 3.8.0), NLTK 3.9.4.

## Run

```bash
python3 -m venv .venv
.venv/bin/pip install tiktoken langchain-text-splitters spacy nltk
.venv/bin/python -m spacy download en_core_web_sm
# NLTK punkt_tab downloads on first run of 02 if missing.

.venv/bin/python examples/01_token_count.py
.venv/bin/python examples/02_sentence_split.py
.venv/bin/python examples/03_recursive_splitter.py
.venv/bin/python examples/04_overlap_rowcount.py
```

Use `.venv/bin/python`, not a bare `python3`, so you get the pinned dependencies.

## Files

- `examples/01_token_count.py` — count tokens with tiktoken; show that token density drops for
  code and URLs versus plain English prose.
- `examples/02_sentence_split.py` — the naive `". "` split breaking on "U.K." and "3.14", then
  NLTK and spaCy doing it right.
- `examples/03_recursive_splitter.py` — RecursiveCharacterTextSplitter by characters vs by
  tokens (`from_tiktoken_encoder`); prints the default separator hierarchy.
- `examples/04_overlap_rowcount.py` — how `chunk_overlap` multiplies the chunk (row) count: the
  RAM-wall tie-in.
