# tests/ directory

## Purpose
Contains unit and integration tests for the intent engine service.

## Contained Files
- __init__.py: Marks the directory as a Python package.
- test_whisper_transcriber.py: Unit tests for the WhisperTranscriber class.

## Data Flow
Tests import modules from core/ and rag/ and assert correct behavior.

## Constraints
Tests should be runnable with pytest from the service root or repository root with proper PYTHONPATH set.
