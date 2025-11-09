import boto3
from prettytable import PrettyTable

def list_volumes_instances_ids():

    ec2_client = boto3.client('ec2')
    volumes = ec2_client.describe_volumes()['Volumes']
    table = PrettyTable()
    table.field_names = ["Volume ID", "Instance ID", "Device"]

    for volume in volumes:
        volume_id = volume['VolumeId']
        attachments = volume['Attachments'] 
        if attachments:
            for attachment in attachments:
                instance_id = attachment['InstanceId']
                device = attachment['Device']
                table.add_row([volume_id, instance_id, device])      
        else:
            print("  Not attached to any instance")
        print(table)

if __name__ == "__main__":
    list_volumes_instances_ids()