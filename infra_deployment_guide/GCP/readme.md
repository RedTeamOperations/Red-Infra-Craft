#  Infrastructure Walkthroughs:

**Common steps required to perform for each infrastructure deployment.**

Before spinning any of the infra make sure you modify **terraform.auto.tfvars** and provide the following required details:

Location of **terraform.auto.tfvars** file: RedInfraCraft (V2) << Terraform << terraform.auto.tfvars


**Once you make the required changes, you can spawn your infra, every architectures command you will find further in this document!! **

After that you will see that your infra is deployed successfully. 

> [!NOTE]
> Once the command is successfuly executed, you'll find the secret file (with the given name) in the same folder were you have deployed the tool inside the 
  respective infra's directory. Now, you need to connect the VM instance.

1. **First limit the permissions of the secret file:**

```bash
chmod 400 YourSecretFileName
```

You can also do it manually as well by visiting properties of the secret file.

2. **Make an SSH connection with the machine:**

```bash
ssh -i "YourSecretFileName" username@ip_address
```


<br>

## 2 Mythic C2 with ALB

<br>
<br>

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/Mythic_C2_ALB_GCP_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Mythic_C2_ALB_GCP_Black.png">
  <img align="center" alt="Mythic_c2_elb" src="assets/Mythic_C2with_ELB_Azure_White.png">
</picture>
</div>

<br>

- To Deploy this infra you need to execute following command:

  ```bash
  redinfracraft.py create aure c2 elb_c2
  ```

> [!NOTE]
> Perform Common necessary steps mentioned above

- After making the ssh connection with instance, Check for the “access” directory inside it, You will find Mythic, navigate into it:

  ```bash
  cd access/Mythic
  ```

- To get the credentials of Mythic, run the following command:

  ```bash
  cat .env
  ```

- If you encounter a "directory not found" error, you need to restart Mythic by running the following command:

  ```bash
  sudo ./mythic-cli start
  ```

- Open a different PowerShell window to make a localhost connection for Mythic:

  ```bash
  ssh -L 7443:127.0.0.1:7443 -i "YourSecretFileName" machine_name
  ```

- Now, you can open the .env file to retrieve the credentials:

  ```bash
  cat .env
  ```

These steps will help you properly set up and connect to Mythic after provisioning the infrastructure.


**To Create Payload:**

After accessing Mythic, follow these steps to create a payload:

1. Visit "https://localhost:7443/new/login" to access Mythic.
2. Once logged in, navigate to the payload creation section.
3. In the "Domain" field, add the domain of the CloudFront distribution. You can obtain this domain from the management console of AWS.
4. Set the "Callback port" to 443.
5. Review your payload configuration.
6. You can view your payload details and download it for use. 

These steps will help you create a payload in Mythic with the appropriate domain and callback port settings for your CloudFront distribution.

<br>
