MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
#### Install packages ####
yum update -y
yum install aws-cli -y
yum install jq -y

--//--