import pytest
from rag.ambiguity_resolver import AmbiguityResolver

@pytest.fixture
def resolver():
    return AmbiguityResolver()

def test_resolve_dunno_exhausted(resolver):
    """Test 'dunno' intent with 'exhausted' emotional state."""
    assert resolver.resolve("I dunno what to eat", "exhausted") == "Proposing comfort food bundle based on 'exhausted' state."

def test_resolve_dunno_neutral(resolver):
    """Test 'dunno' intent with 'neutral' emotional state."""
    assert resolver.resolve("I dunno", "neutral") == "Proposing standard popular bundle."

def test_resolve_surprise_exhausted(resolver):
    """Test 'surprise' intent with 'exhausted' emotional state."""
    assert resolver.resolve("surprise me", "exhausted") == "Proposing comfort food bundle based on 'exhausted' state."

def test_resolve_surprise_happy(resolver):
    """Test 'surprise' intent with 'happy' emotional state."""
    assert resolver.resolve("surprise me", "happy") == "Proposing standard popular bundle."

def test_resolve_normal_intent(resolver):
    """Test an intent that doesn't trigger any ambiguity resolution."""
    intent = "I want a pizza"
    assert resolver.resolve(intent, "neutral") == intent

def test_resolve_empty_intent(resolver):
    """Test with an empty intent string."""
    assert resolver.resolve("", "neutral") == ""

def test_resolve_empty_emotional_state(resolver):
    """Test 'dunno' intent with an empty emotional state string."""
    assert resolver.resolve("I dunno", "") == "Proposing standard popular bundle."

def test_resolve_case_sensitivity(resolver):
    """
    Test case sensitivity.
    Current implementation is case-sensitive, so 'DUNNO' should not trigger the same logic as 'dunno'.
    """
    intent = "I DUNNO"
    assert resolver.resolve(intent, "exhausted") == intent

def test_resolve_partial_match(resolver):
    """Test that partial matches also trigger the logic (as per 'in' operator)."""
    assert resolver.resolve("idunno", "exhausted") == "Proposing comfort food bundle based on 'exhausted' state."
