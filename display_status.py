import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

completed_tasks = 0
total_tasks = len(state['phases']['1']['tasks'])

for task in state['phases']['1']['tasks']:
    if task['status'] == 'completed':
        completed_tasks += 1

print("╔══════════════════════════════════════════════════════════════╗")
print("║  🎯 VERVE CONDUCTOR — Build Orchestrator                    ║")
print("╠══════════════════════════════════════════════════════════════╣")
print("║  Project: Verve Cognitive Commerce Platform                  ║")
print(f"║  Phase:   1 — Invisible Intelligence (Weeks 1-4)            ║")
print(f"║  Status:  IN_PROGRESS                                        ║")
print(f"║  Tasks:   {completed_tasks}/{total_tasks} complete │ 0 failed │ {total_tasks - completed_tasks} pending             ║")
print("║  Metrics: 0/4 measured                                       ║")
print("║  Risks:   0 critical │ 5 high │ 13 total                    ║")
print("║  Trust:   Level 0 implementing │ Levels 1-3 pending          ║")
print("╠══════════════════════════════════════════════════════════════╣")

next_task = None
for task in state['phases']['1']['tasks']:
    if task['status'] == 'pending':
        next_task = task
        break

if next_task:
    print(f"║  Next Task: {next_task['id']} — {next_task['name'][:40].ljust(40)} ║")
    # simplified mapping for builder
    builder = "verve-unknown"
    if "SQLite" in next_task['name'] or "encryption" in next_task['name'] or "CRUD" in next_task['name']:
        builder = "verve-edge-builder"
    elif "Go" in next_task['name'] or "Python" in next_task['name'] or "RAG" in next_task['name']:
        builder = "verve-backend-builder"
    print(f"║  Builder:   {builder.ljust(46)}║")
else:
    print("║  Next Task: Phase 1 tasks complete!                          ║")

print("╚══════════════════════════════════════════════════════════════╝")
