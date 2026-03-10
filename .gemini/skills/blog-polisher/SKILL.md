---
name: blog-polisher
description: Use this skill to polish personal blog content. It ensures no spelling or grammar mistakes while keeping the original tone.
---

# Blog Polisher

## Overview
This skill provides a workflow for polishing personal blog content, ensuring technical correctness (spelling, grammar, punctuation) while strictly preserving the author's unique voice and tone.

## Workflow

### 1. Tone Analysis
Before making any changes, analyze the draft's tone (e.g., casual, academic, enthusiastic, cynical). Identify key linguistic markers such as:
- Sentence structure (long/complex vs. short/punchy).
- Vocabulary level.
- Use of slang, jargon, or personal anecdotes.

### 2. Surgical Polishing
Apply corrections only where necessary.
- **Spelling & Grammar:** Fix all objective errors.
- **Clarity:** If a sentence is grammatically correct but confusing, rephrase it ONLY if it can be done without altering the tone.
- **Punctuation:** Ensure consistent use of commas, periods, and Oxford commas (if preferred by the author).

### 3. Verification
Compare the polished version with the original.
- **Check:** Does it sound like the same person wrote it?
- **Check:** Are all red underlines (hypothetical) gone?
- **Check:** Is the formatting (Markdown, frontmatter) intact?

## Examples

**Input:** "Hey guys, so i've been thinking about ai lately and its kinda crazy how fast things move."
**Output:** "Hey guys, so I've been thinking about AI lately and it's kinda crazy how fast things move."
**Rationale:** Corrected capitalization and contractions while keeping "Hey guys" and "kinda crazy."

## Guidelines
- **Tone Preservation:** NEVER substitute a formal word for a casual one if the blog is casual.
- **Technical Integrity:** Ensure Markdown syntax and YAML frontmatter (if present) are preserved.
- **No Over-Editing:** If a sentence is fine, leave it alone.
