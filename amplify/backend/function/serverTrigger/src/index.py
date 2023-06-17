from time import sleep
import boto3
import os

def handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.environ['instanceID'] 

    while True:
        resp = ec2.describe_instances(InstanceIds=[instance_id])
        state = resp['Reservations'][0]['Instances'][0]['State']['Name']
        if state == 'running':
            ec2.stop_instances(InstanceIds=[instance_id])
            action = 'stopped'
            break
        elif state in ['stopped']:
            ec2.start_instances(InstanceIds=[instance_id])
            action = 'started'
            break
        elif state == 'pending':
            sleep(5)
            continue
        else: 
            # Includes 'stopping' state, should it?
            return {
                'statusCode': 500,
                'body': f'Instance is in an invalid state: {state}'
            }

    return {
        'statusCode': 200,
        'body': f'Instance {action}.'
    }
