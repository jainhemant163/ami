# ami
AMI Repository for Organization


#Validate Template

./packer validate  build.json

#Build AMI

./packer build \
    -var 'aws_access_key=REDACTED' \
    -var 'aws_secret_key=REDACTED' \
    -var 'aws_region=us-east-1' \
    ami.json
