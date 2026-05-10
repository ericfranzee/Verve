import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

for task in state['phases']['1']['tasks']:
    if task['id'] in ['P1-T19', 'P1-T20', 'P1-T21']:
        task['status'] = 'completed'

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
