sudo apt update -y && sudo apt install s3fs -y

sudo install unzip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws s3 ls

mkdir mys3bucket

s3fs bucket_name mys3bucket/
## replace bucket_name with your s3 bucket name

cd mys3bucket/

df -h | grep -i s3fs

