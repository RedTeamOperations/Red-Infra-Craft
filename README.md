# Automate-Red-Team-Infra

Welcome to the **"InfraCraft"** GitHub repository - your gateway to automating the deployment of robust red team infrastructures! InfraCraft is your trusted companion in effortlessly setting up and managing red team infrastructures, streamlining the process so you can focus on your mission. Whether it's deploying Mythic C2s, orchestrating ELB architectures, or crafting sophisticated phishing setups, InfraCraft empowers red teams to deploy with ease and efficiency. Join us in revolutionizing the way red team infrastructures are built and managed - let's craft infrastructures together with InfraCraft!

## 1. Terraform Installation
To Download Terraform, you can visit their official website [HasiCorp](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli). They provide instructions on how to install Terraform on Windows, Linux, and macOS.

<br>

## 2. InfraCraft Tool Installation
To acquire the tool, you'll need to clone this GitHub repository. Try following command:

`Command`
```bash
git clone https://github.com/RedTeamOperations/Automate-Red-Team-Infra
```

<br>

## 3. How to spawn an Infrastructure

Available Infrastructures:

1) C2 - "Mythic C2, Mythic C2 with CloudFront and Load Balancer"
2) Payload - "Pwndrop"
3) Phishing - "EvilGinx, GoPhish"
4) All in One Infra - "Mythic C2 with CloudFront and Load Balancer & Pwndrop & EvilGinx & GoPhish"

<br>

Commands to Spawn and Destroy Infras:

| Infrastructure | Command | Description |
| ------ | ------------ | ------ |
| Mythic C2 | impact.py create c2 mythic | To Create Mythic C2 infrastructure. | 
| Mythic C2 | impact.py destroy c2 mythic | To Destroy Mythic C2 infrastructure. | 
| Mythic C2 | impact.py create c2 elb_c2 | To Create Mythic C2 with ELB & CloudFront infrastructure. | 
| Mythic C2 | impact.py destroy c2 elb_c2 | To Destroy Mythic C2 with ELB & CloudFront infrastructure. | 
| Payload | impact.py create payload pwndrop | To Create pwndrop payload infrastructure. | 
| Payload | impact.py destroy payload pwndrop | To Destroy pwndrop payload infrastructure. |
| Phishing | impact.py create phishing gophish | To Create Gophish phishing infrastructure. |
| Phishing | impact.py destroy phishing gophish | To Destroy Gophish phishing infrastructure. |
| Phishing | impact.py create phishing evilginx | To Create Evilginx phishing infrastructure. |
| Phishing | impact.py destroy phishing evilginx | To Destroy Evilginx phishing infrastructure. |
| All-in-one | impact.py create full_infra | To Create all infrastructures in one go (Mythic C2, Payload, Phishing). |
| All-in-one | impact.py destroy full_infra | To Destroy all infrastructures in one go (Mythic C2, Payload, Phishing). |

<br>

## 4. Infrastructure Walkthroughs:

**Common steps required to perform for each infrastructure deployment.**

Upon executing command to spawn infra, you need to authenticate yourself and provide the following details.:

- var.access_key: AWS Access Key ID - you need to enter your AWS Management console Access Key ID here.
- var.key_name - InfraCraft automates the retrieval of the secret PEM key file for your EC2 instances, ensuring a hassle-free experience. To ensure uniqueness, you'll provide a distinct name each time. Remembering the PEM file name is essential as you'll need it frequently throughout your operations.
- var.secret_key: AWS Secret Access Key - you need to enter your AWS Management console Secret Access Key here.

you will see that your infra is deployed successfully. 

Once the command is successfuly executed, you'll find the secret file (with the given name) in the same folder were you have deployed the tool inside the respective infra's directory. Now, you need to connect the EC2 instance.

first limit the permissions of the secret file:

`Command`
```bash
chmod 400 YourSecretFileName
```
You can also do it manually as well by visiting properties of the secret file.

Make an SSH connection with the machine:

`Command`
```bash
ssh -i "YourSecretFileName" machine_name
```
you can get this command from your AWS Management Console as well, remember you dont need to add .pem while entering "YourSecretFileName"

<br>

### 4.1 Mythic C2

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create c2 mythic
```

**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:

`Command`
```bash
cd access/Mythic
```

To get the credentials of Mythic, run the following command:

`Command`
```bash
cat .env
```

If you encounter a "directory not found" error, you need to restart Mythic by running the following command:

`Command`
```bash
sudo ./mythic-cli start
```

Open a different PowerShell window to make a localhost connection for Mythic:

`Command`
```bash
ssh -L 7443:127.0.0.1:7443 -i "YourSecretFileName" machine_name
```

Now, you can open the .env file to retrieve the credentials:

`Command`
```bash
cat .env
```

These steps should help you properly set up and connect to Mythic after provisioning the infrastructure


<br>

### 4.2 Mythic C2 with ELB & CloudFront

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create c2 elb_c2
```

**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:

`Command`
```bash
cd access/Mythic
```

To get the credentials of Mythic, run the following command:

`Command`
```bash
cat .env
```

If you encounter a "directory not found" error, you need to restart Mythic by running the following command:

`Command`
```bash
sudo ./mythic-cli start
```

Open a different PowerShell window to make a localhost connection for Mythic:

`Command`
```bash
ssh -L 7443:127.0.0.1:7443 -i "YourSecretFileName" machine_name
```

Now, you can open the .env file to retrieve the credentials:

`Command`
```bash
cat .env
```

These steps should help you properly set up and connect to Mythic after provisioning the infrastructure

To Create Payload:

1. After accessing Mythic, follow these steps to create a payload:
2. Visit "https://localhost:7443/new/login" to access Mythic.
3. Once logged in, navigate to the payload creation section.
4. In the "Domain" field, add the domain of the CloudFront distribution. You can obtain this domain from the management console of AWS.
5. Set the "Callback port" to 443.
6. Review your payload configuration.

You can view your payload details and download it for use. These steps will help you create a payload in Mythic with the appropriate domain and callback port settings for your CloudFront distribution.

<br>

### 4.3 Payload - Pwndrop

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create payload pwndrop
```
**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:

<br>

### 4.4 Phishing - GoPhish

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create phishing gophish
```

**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:

<br>

### 4.5 Phishing - EvilGinx

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create phishing evilginx
```

**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:

<br>

### 4.6 All-in-one

To Deploy this infra you need to execute following command:

`Command`
```bash
impact.py create full_infra
```

**Perform Common necessary steps mentioned above**

After making ssh connection with EC2 instance, Check for the “access” directory inside it You will find Mythic, navigate into it:


