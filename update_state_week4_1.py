import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

for task in state['phases']['1']['tasks']:
    if task['id'] in ['P1-T10', 'P1-T11', 'P1-T12', 'P1-T13']:
        task['status'] = 'completed'

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
