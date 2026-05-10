import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

for task in state['phases']['1']['tasks']:
    if task['id'] == 'P1-T01':
        task['status'] = 'completed'

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
