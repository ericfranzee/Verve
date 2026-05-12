#!/usr/bin/env python3
import os
import re
import sys

# Scan rules for PII
# 1. 11 digit BVN assignment
# 2. Basic Credit Card match
# 3. Plaintext password assignments
RULES = {
    "BVN_LEAK": r'(?i)bvn\s*[:=]\s*[\'"]?\d{11}[\'"]?',
    "CREDIT_CARD_LEAK": r'(?i)card(?:_number|num)?\s*[:=]\s*[\'"]?(?:\d[ -]*?){13,16}[\'"]?',
    "PASSWORD_LEAK": r'(?i)(?:password|pwd)\s*[:=]\s*[\'"][^\'"]{4,}[\'"]',
    "LOGGING_LEAK_BVN": r'(?i)(?:log|logger|print).*(?:bvn).*',
    "LOGGING_LEAK_CARD": r'(?i)(?:log|logger|print).*(?:card(?:_number)?).*',
}

def scan_file(filepath):
    violations = []
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        for line_num, line in enumerate(f, 1):
            for rule_name, pattern in RULES.items():
                if re.search(pattern, line):
                    # Exclude the scan script itself and basic string prints if we are just defining types
                    if "scripts/ndpa_compliance_audit.py" in filepath:
                        continue
                    # Ignore harmless things
                    if "type" in line.lower() or "interface" in line.lower() or "class" in line.lower() or "hashed" in line.lower():
                        continue
                    violations.append(f"{filepath}:{line_num} -> [{rule_name}] {line.strip()[:100]}")
    return violations

def main():
    root_dirs = ['apps/mobile', 'services/orchestrator', 'services/intent-engine', 'services/nexus-api']
    all_violations = []

    for root_dir in root_dirs:
        for dirpath, _, filenames in os.walk(root_dir):
            for filename in filenames:
                if filename.endswith(('.dart', '.go', '.py', '.ts', '.js', '.sql')) and 'node_modules' not in dirpath:
                    filepath = os.path.join(dirpath, filename)
                    violations = scan_file(filepath)
                    if violations:
                        all_violations.extend(violations)

    if all_violations:
        print("🚨 NDPA Compliance Violations Found:")
        for v in all_violations:
            print(v)
        sys.exit(1)
    else:
        print("✅ NDPA Compliance Audit Passed: No plaintext PII leaks detected.")

if __name__ == "__main__":
    main()
