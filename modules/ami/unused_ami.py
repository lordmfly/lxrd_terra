import boto3
from pprint import pprint
#import dotenv
import os



# create boto3 client for ec2
client = boto3.client('ec2',region_name='us-east-1')
instances = client.describe_instances()
used_ami = []
for reservation in instances['Reservations']:
     for instance in reservation['Instances']:
         state = instance['State']
         state = (state['Name'])
         if state == 'running':
             used_ami.append(instance['ImageId'])
used_ami = list(set(used_ami))
print(used_ami)
images = client.describe_images(
    Filters=[
        {
            'Name': 'state',
            'Values': ['available']
        },
    ],
    Owners=['self'],
)
custom_ami = [] 
for image in images['Images']:
    custom_ami.append(image['ImageId'])
print(custom_ami)
deregister_list = []
for ami in custom_ami:
    if ami not in used_ami:
        print("AMI {} has been deregistered".format(ami))
        client.deregister_image(ImageId=ami)
        deg = ("-----Unused AMI ID = {} is Deregistered------".format(ami))
        deregister_list.append(deg)
print(deregister_list)