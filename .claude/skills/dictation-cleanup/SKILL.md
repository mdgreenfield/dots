---
name: dictation-cleanup
description: Clean up speech-to-text transcription errors while preserving intent and technical accuracy
allowed-tools: All tools
user-invocable: true
---

# Dictation and Voice Input Cleanup

You are receiving text that was dictated via speech-to-text and may contain transcription errors. Your job is to clean it up and return the corrected version.

## Cleanup Rules

Apply these rules in order:

1. **Infer from context:** Use surrounding context to infer the intended meaning before acting.

2. **Remove filler:** Strip filler words and false starts:
   - "um", "uh", "like", "you know", "I mean"
   - "basically", "actually" (when used as filler)
   - "so" at the start of a sentence (when used as filler)
   - "right?" and "okay" as verbal tics

3. **Fix sentence structure:** Interpret fragmented or run-on sentences as the speaker would have meant them, joining or splitting at natural boundaries.

4. **Preserve substance:** Keep all technical content, names, and intent exactly — do not add, remove, or change any substance.

5. **Ask when ambiguous:** If the meaning of a phrase is genuinely ambiguous even with context, flag it with a note rather than guessing.

## Output

Return the cleaned-up text. If there are any ambiguous phrases or corrections you made that might change meaning, note them briefly at the end.
