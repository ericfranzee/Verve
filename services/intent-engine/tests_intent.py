import pytest
import datetime
from rag.prompt_builder import PromptBuilder
from rag.dietary_enforcer import DietaryEnforcer
from rag.temporal_resolver import TemporalResolver
from core.moe_router import MoERouter
from core.tts_engine import TTSEngine

def test_prompt_builder():
    pb = PromptBuilder()
    context = [{"trust_level_required": 1, "data": "Milk"}, {"trust_level_required": 3, "data": "Allergies"}]
    prompt_level_1 = pb.build_prompt("Buy stuff", 1, context)
    assert "Milk" in prompt_level_1
    assert "Allergies" not in prompt_level_1

def test_dietary_enforcer():
    enforcer = DietaryEnforcer(allergen_blocklist=["peanut"])
    skus = [
        {"id": "A", "ingredients": ["peanut", "sugar"]},
        {"id": "B", "ingredients": ["flour", "sugar"]}
    ]
    safe = enforcer.enforce(skus)
    assert len(safe) == 1
    assert safe[0]["id"] == "B"

def test_moe_router():
    router = MoERouter()
    res_simple = router.route_and_infer("prompt", False)
    assert res_simple["model"] == "fast"

    res_complex = router.route_and_infer("prompt", True)
    assert res_complex["model"] == "large"

def test_temporal_resolver():
    tr = TemporalResolver()
    # It resolves day offsets. Let's see if it successfully parses a date instead of crashing.
    res = tr.resolve("I need this by next Monday please.")
    assert "resolved_date" in res
    assert "temporal_weight" in res

def test_tts_engine():
    engine = TTSEngine()
    audio = engine.generate_speech("Testing voice generation.")
    assert audio is not None
    assert len(audio) > 0
