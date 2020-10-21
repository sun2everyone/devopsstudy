#!/usr/bin/env python3
import subprocess, sys
import json
#check for gcloud 
inventory={"db":{"hosts":[]},"app":{"hosts":[]},"ungrouped":{"hosts":[]},"_meta": {"hostvars": {}}}
try:
    gcloud = subprocess.check_output(["which","gcloud"]).decode('utf-8')
except:
    inventory['ungrouped']['hosts'].append("localhost")
    print(json.dumps(inventory))
    sys.exit(0)
if not '/gcloud' in gcloud:
    inventory['ungrouped']['hosts'].append("localhost")
    print(json.dumps(inventory))
    sys.exit(0)
instances = json.loads(subprocess.check_output(["gcloud","compute","instances","list","--format=json"]).decode('utf-8'))
for instance in instances:
    if instance['status']=='RUNNING':
        if len(instance['networkInterfaces']):
            if not 'accessConfigs' in instance['networkInterfaces'][0].keys():
                continue
        else:
            continue
        if 'natIP' in instance['networkInterfaces'][0]['accessConfigs'][0].keys():
            inventory["_meta"]['hostvars'].update({instance['name']:{"ansible_host":instance['networkInterfaces'][0]['accessConfigs'][0]['natIP']}})
        if '-app' in instance['name']:
            inventory['app']['hosts'].append(instance['name'])
        elif '-db' in instance['name']:
            inventory['db']['hosts'].append(instance['name'])
        else:
            inventory['ungrouped']['hosts'].append(instance['name'])
        #Creating groups for stage-prod-etc
        parts=instance['name'].split('-')
        if len(parts)==3:
            grp=parts[2]
            if grp in inventory.keys():
                inventory[grp]['hosts'].append(instance['name'])
            else:
                group={grp:{"hosts":[instance['name']]}}
                inventory.update(group)
print(json.dumps(inventory))

