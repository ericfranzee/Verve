import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

for task in state['phases']['1']['tasks']:
    if task['id'] in ['P1-T04', 'P1-T05', 'P1-T06', 'P1-T14', 'P1-T15', 'P1-T16']:
        task['status'] = 'completed'

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
