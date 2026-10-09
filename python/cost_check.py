"""Demo: find AWS resources that waste money.

Lists running EC2 instances without a 'Project' tag and unattached EBS volumes.
Run:  pip install boto3  &&  python cost_check.py
"""
import boto3

REGION = "ap-south-1"
ec2 = boto3.client("ec2", region_name=REGION)

print(f"Checking {REGION} for cost waste...\n")

# 1. Running instances with no Project tag
untagged = []
for r in ec2.describe_instances(
    Filters=[{"Name": "instance-state-name", "Values": ["running"]}]
)["Reservations"]:
    for inst in r["Instances"]:
        tags = {t["Key"]: t["Value"] for t in inst.get("Tags", [])}
        if "Project" not in tags:
            untagged.append((inst["InstanceId"], inst["InstanceType"]))

print(f"Untagged running instances: {len(untagged)}")
for iid, itype in untagged:
    print(f"  - {iid} ({itype})")

# 2. EBS volumes not attached to anything
vols = ec2.describe_volumes(
    Filters=[{"Name": "status", "Values": ["available"]}]
)["Volumes"]
total_gb = sum(v["Size"] for v in vols)

print(f"\nUnattached EBS volumes: {len(vols)} ({total_gb} GB)")
for v in vols:
    print(f"  - {v['VolumeId']} {v['Size']} GB")

print(f"\nEstimated EBS waste: ~${total_gb * 0.08:.2f}/month (gp2/gp3 approx.)")
