"""Overlap is a RAM-wall decision: more overlap = more rows = a bigger index.

chunk_overlap duplicates boundary text so a fact split across two chunks is still
retrievable. The cost is straightforward: more chunks, more rows in the chunks table,
more vectors in the HNSW graph.
"""

from langchain_text_splitters import RecursiveCharacterTextSplitter

# A longer body so overlap actually changes the chunk count.
doc = " ".join(
    f"Sentence number {i} describes one more idea worth retrieving on its own."
    for i in range(1, 41)
)

base = len(doc)
print(f"document: {base} chars\n")

for overlap in (0, 60, 120):
    splitter = RecursiveCharacterTextSplitter(chunk_size=300, chunk_overlap=overlap)
    chunks = splitter.split_text(doc)
    total = sum(len(c) for c in chunks)
    blowup = total / base
    print(
        f"overlap={overlap:3d} -> {len(chunks):2d} chunks | "
        f"{total:4d} stored chars | {blowup:.2f}x the source"
    )
