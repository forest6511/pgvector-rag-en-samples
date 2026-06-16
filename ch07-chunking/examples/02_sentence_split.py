"""Sentence boundaries: naive split fails, spaCy and NLTK do not.

A chunk that cuts mid-sentence hurts retrieval. The classic naive failure is splitting
on ". " which breaks on abbreviations like "U.K." and decimals like "3.14".
"""

text = (
    "Apple is looking at buying a U.K. startup for $1 billion. "
    "The deal could close in Q3. "
    "Analysts expect the price to settle near 3.14 times revenue."
)

print("=== naive split on '. ' (WRONG) ===")
naive = text.split(". ")
for i, s in enumerate(naive):
    print(f"  [{i}] {s}")
print(f"  -> {len(naive)} fragments (note 'U.K' and '3' got cut)")

print("\n=== NLTK sent_tokenize (Punkt) ===")
import nltk
from nltk.tokenize import sent_tokenize

# punkt_tab is the current resource name; punkt is the legacy name.
try:
    nltk_sents = sent_tokenize(text)
except LookupError:
    nltk.download("punkt_tab", quiet=True)
    nltk_sents = sent_tokenize(text)
for i, s in enumerate(nltk_sents):
    print(f"  [{i}] {s}")
print(f"  -> {len(nltk_sents)} sentences")

print("\n=== spaCy doc.sents (parser-based) ===")
import spacy

nlp = spacy.load("en_core_web_sm")
spacy_sents = [s.text for s in nlp(text).sents]
for i, s in enumerate(spacy_sents):
    print(f"  [{i}] {s}")
print(f"  -> {len(spacy_sents)} sentences")
