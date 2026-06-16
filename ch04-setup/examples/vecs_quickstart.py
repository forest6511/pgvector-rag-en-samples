"""Supabase vecs against the same local Postgres+pgvector container.

vecs only needs a Postgres connection string with pgvector installed, so the
exact code you'd run against Supabase runs against the Chapter 4 Docker box too.

    pip install vecs
    python examples/vecs_quickstart.py
"""

import vecs

DB_CONNECTION = "postgresql://postgres:postgres@localhost:5432/ragdb"

vx = vecs.create_client(DB_CONNECTION)

# A collection is a managed table + index, created for you.
docs = vx.get_or_create_collection(name="docs", dimension=3)

docs.upsert(
    records=[
        ("vec0", [0.1, 0.2, 0.3], {"year": 1973}),
        ("vec1", [0.7, 0.8, 0.9], {"year": 2012}),
    ]
)

# Build an HNSW index with explicit parameters.
docs.create_index(
    method=vecs.IndexMethod.hnsw,
    measure=vecs.IndexMeasure.cosine_distance,
    index_arguments=vecs.IndexArgsHNSW(m=16, ef_construction=64),
)

# Query with a metadata filter.
results = docs.query(
    data=[0.4, 0.5, 0.6],
    limit=1,
    filters={"year": {"$eq": 2012}},
)
print(results)

vx.disconnect()
