#for s3 bucket upload
#run
aws configure
#input access key and secret access key created in IAM managment center. (DELETE ACCESS KEYS WHEN DONE)
#region=us-east-2 and output=table
  #Creating Credentials
  #Select "Users" from IAM sidebar
  #"Security Credentials" section -> Access keys tab -> Create

aws s3 cp $filename s3://bucket-name/path/to/destination/
