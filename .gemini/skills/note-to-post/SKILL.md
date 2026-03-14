---
name: note-to-post
description: Transforms raw weekly reading notes into polished Markdown blog posts. Use when the user wants to convert notes (e.g., from Apple Notes) into a blog post.
---

# Note To Post

## Overview

This skill transforms raw notes into a well-formatted, published article for the user's Jekyll blog. It handles parsing specific note formats, polishing grammar, and generating the final Markdown file.

## Workflow

### Step 1: Gather Information

1.  **Ask for Title**: "What is the title of the notes to work on?"
2.  **Ask for Source**: "Please provide the notes text directly, or let me know if they are in the `_drafts/` folder. I can search that directory for you."
    *   If the user indicates the file is in `_drafts/`, search that directory for a matching title or recently updated Markdown files.

### Step 2: Process Content

Read the provided text or file.

**Parsing Rules:**
1.  **Ignore Tags**: If the file starts with a tag like `#blog` or `blog`, ignore it.
2.  **Identify Blocks**: Each note entry typically consists of:
    *   **Link**: The original article URL.
    *   **Quote**: An excerpt starting with `>`.
    *   **Comment**: The user's raw commentary.

**Transformation Rules:**
1.  **Polish Comments**: specific instructions:
    *   Fix grammar mistakes.
    *   Keep the original tone.
    *   Do not change the meaning.
2.  **Format Output**:
    *   Create a clean, visual presentation.
    *   Use Markdown.
    *   Format links clearly.
    *   Format quotes using blockquotes (`>`).
    *   Distinguish user comments (e.g., separate paragraph, maybe italicized or bold label).

### Step 3: Generate File

1.  **Construct Filename**:
    *   Pattern: `_posts/YYYY-MM-DD-<slugified-title>.md`
    *   Date: Today's date.
    *   Slug: Kebab-case version of the title.
2.  **Create Content**:
    *   **Frontmatter**:
        ```yaml
        ---
        layout: post
        title: "<Title>"
        description: ""
        category: 
        tags: []
        ---
        ```
    *   **Body**: The processed and formatted notes.
3.  **Write File**: Save the file to the `_posts/` directory.

### Step 4: Finalize

1.  **Preview**: Open the newly created Markdown file in the `_posts/` directory using **Typora** for the user to preview.
    *   On macOS, use: `open -a Typora _posts/YYYY-MM-DD-<slugified-title>.md`
2.  **Confirm**: Tell the user the file has been created and opened in Typora for review.
