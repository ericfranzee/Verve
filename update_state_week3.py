import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

for task in state['phases']['1']['tasks']:
    if task['id'] in ['P1-T07', 'P1-T08', 'P1-T09', 'P1-T17', 'P1-T18']:
        task['status'] = 'completed'

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
