## How to use this environments with GCP:

Name your gcp VMS as **{somename}-app-{environment}** and **{somename}-db-{environment}**

Run ansible from devopsstudy/ansible this way:

```
ansible-inventory -i ./environments/test/gcp_inventory.py --graph
```

You can specify default environment in **ansible.cfg**

If you run **gcp_inventory.py** outside environments path, it will generate full dynamic inventory splitting hosts by groups using **{namept1}-{group}** pattern.
