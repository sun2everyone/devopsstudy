#!/usr/bin/env python3
import subprocess, sys, os
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
#check for environment
script_path=" ".join(sys.argv[:])
env_mode=False
if 'environments' in script_path: #if run from environments - use environment mode to get only environment-specific hosts
    env_mode=True
    env=""
    env_pts=script_path.split('/')
    for  i in range(0,len(env_pts)-1):
        if env_pts[i]=='environments':
            env=env_pts[i+1]
#
for instance in instances:
    if instance['status']=='RUNNING':
        if len(instance['networkInterfaces']):
            if not 'accessConfigs' in instance['networkInterfaces'][0].keys():
                continue
        else:
            continue
        #Creating groups for stage-prod-etc and checking for environment. VM must be named as namep1(-name2-...nameN)-environment or namep1(-name2-...nameN)-group
        parts=instance['name'].split('-')
        if len(parts)>=2:
            grp=parts.pop() #assume that last of three is environment|group
            if not env_mode or (env_mode and grp==env):
                if grp in inventory.keys():
                    inventory[grp]['hosts'].append(instance['name'])
                else:
                    group={grp:{"hosts":[instance['name']]}}
                    inventory.update(group)
            elif env_mode:
                continue
        else:
            if env_mode: #skip if unable to detect environment
                continue
        if 'natIP' in instance['networkInterfaces'][0]['accessConfigs'][0].keys():
            inventory["_meta"]['hostvars'].update({instance['name']:{"ansible_host":instance['networkInterfaces'][0]['accessConfigs'][0]['natIP']}})
        if '-app' in instance['name']:
            inventory['app']['hosts'].append(instance['name'])
        elif '-db' in instance['name']:
            inventory['db']['hosts'].append(instance['name'])
        else:
            inventory['ungrouped']['hosts'].append(instance['name'])
print(json.dumps(inventory))

