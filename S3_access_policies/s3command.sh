sudo useradd -m dev1
sudo useradd -m dev2

aws configure
## give access key , secret key, region as us-east-1, output format as json for both users one by one

aws configure list
## to verify the configuration

aws s3 cp sw.txt s3://arn:aws:s3:us-east-1:202977753489:accesspoint/apdev1/folder1/sw.txt

aws s3 cp ab.txt s3://arn:aws:s3:us-east-1:202977753489:accesspoint/apdev2/folder2/ab.txt

