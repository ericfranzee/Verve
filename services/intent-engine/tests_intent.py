import pytest
from rag.prompt_builder import PromptBuilder
from rag.dietary_enforcer import DietaryEnforcer
from core.moe_router import MoERouter

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
