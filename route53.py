# NOT WORKING... NEED TO DEBUG.
import boto3

client = boto3.client('route53') 
record_names = ['vote','www','result','bg','canary']
for record_name in record_names:
    client.change_resource_record_sets(
    ChangeBatch={
            'Changes': [
                {
                    'Action': 'CREATE',
                    'ResourceRecordSet': {
                    'Name': record_name,
                    'ResourceRecords': [
                        {
                        'Value': 'a80de3b18f68c4775848a974621105dd-2424006bcfea6580.elb.us-east-1.amazonaws.com'
                        }
                    ],
                    'TTL': 60,
                    'Type': 'A',
                    'Region': 'us-east-1'
                },
            },
        ],
    },
    HostedZoneId='Z0583331TTLC7JNPSR0J',
    )