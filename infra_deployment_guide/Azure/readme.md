#  Infrastructure Walkthroughs:

**Common steps required to perform for each infrastructure deployment.**

Before spinning any of the infra make sure you modify **terraform.auto.tfvars** and provide the following required details:

Location of **terraform.auto.tfvars** file: RedInfraCraft (V2) << Terraform << terraform.auto.tfvars

- **subscription_id = <YOUR_SUBSCRIPTIO_ID>**
  
  You need to enter your Azure Subscription ID here.

- **tenant_id = <YOUR_TENANT_ID>**
  
  You need to enter your Aure Tenant ID here.
  
- **client_id = <YOUR_CLIENT_ID>**
  
  You need to enter Service Account's Client ID here.
  
- **client_secret = <YOUR_CLIENT_SECRET>**
  
  You need to enter Service Account's Client ID here.

- **vm_key_name = <VM_Secret_File_Name>**
  
  RedInfraCraft automates the retrieval of the secret PEM key file for your VM instances, ensuring a hassle-free experience. *To ensure uniqueness, you need to 
  provide different name each time*. Remembering the PEM file name is essential as you'll need it frequently throughout your operations.

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

## 1 Mythic C2

<br>


<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/Mythic_C2_Azure_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Mythic_C2_Azure_Black.png">
  <img align="center" alt="Mythic_C2" src="assets/Mythic_C2_Azure_White.png">
</picture>
</div>
<br>
<br>

- To Deploy this infra you need to execute following command:

  ```bash
  redinfracraft.py create azure c2 mythic
  ```

> [!NOTE]
> Perform Common necessary steps mentioned above

- After making the ssh connection with VM instance, Check for the “access” directory inside it, you will find Mythic, navigate into it:

  ```bash
  cd access/Mythic
  ```

- To get the credentials of Mythic, run the following command:

  ```bash
  cat .env
  ```

- If you encounter a *directory not found* error, you need to restart Mythic by running the following command:

  ```bash
  sudo ./mythic-cli start
  ```

- Open a different PowerShell window to make a localhost connection for Mythic:

  ```bash
  ssh -L 7443:127.0.0.1:7443 -i "YourSecretFileName" machine_name
  ```

- Now, you can open the .env file in the first powershell window to retrieve the credentials:

  ```bash
  cat .env
  ```

These steps will help you properly set up and connect to Mythic after provisioning the infrastructure.

Visit https://localhost:7443/new/login to access Mythic.

<br>

## 2 Mythic C2 with Frontdoor

<br>
<br>

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/Mythic_C2with_ELB_Azure_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Mythic_C2with_ELB_Azure_Black.png">
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

- After making the ssh connection with VM instance, Check for the “access” directory inside it, You will find Mythic, navigate into it:

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

## 3 Payload - Pwndrop

<br>


<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/pwndrop_Azure_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/pwndrop_Azure_Black.png">
  <img align="center" alt="pwndrop" src="assets/pwndrop_Azure_White.png">
</picture>
</div>

<br>
<br>

- To Deploy this infra you need to execute following command:

- ```bash
  redinfracraft.py create azure payload pwndrop
  ```
> [!NOTE] 
> Perform Common necessary steps mentioned above

- After making the ssh connection with VM instance, Check for the “pwndrop” directory, navigate into it:

  ```bash
  cd pwndrop
  ```

- To start the Pwndrop on your machine:

  ```bash
  sudo ./pwndrop
  ```

Visit https://<your_machine_ip>/pwndrop to access Pwndrop dashboard

These steps will help you properly set up and connect to pwndrop after provisioning the infrastructure.

<br>

## 4 Phishing - GoPhish

<br>


<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/GoPhish_Azure_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/GoPhish_Azure_Black.png">
  <img align="center" alt="gophish" src="assets/GoPhish_Azure_White.png">
</picture>
</div>

<br>
<br>

- To Deploy this infra you need to execute following command:

  ```bash
  redinfracraft.py create azure phishing gophish
  ```

> [!NOTE]
> Perform Common necessary steps mentioned above

- After making the ssh connection with VM instance, to start the GoPhish on your machine, you need to execute following command:

  ```bash
  sudo ./gophish
  ```
Visit https://<your_machine_ip>:3333 to access Gophish dashboard

  - Username (default): admin
  - Password (default): gophish

Now you can access all options of GoPhish.

These steps will help you properly set up and connect to GoPhish after provisioning the infrastructure.

<br>

## 5 Phishing - EvilGinx

<br>

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/Evilginx_Azure_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Evilginx_Azure_Black.png">
  <img align="center" alt="evilginx" src="assets/Evilginx_Azure_White.png">
</picture>
</div>

<br>
<br>

- To Deploy this infra you need to execute following command:

  ```bash
  redinfracraft.py create azure phishing evilginx
  ```

> [!NOTE]
> Perform Common necessary steps mentioned above

- After making the ssh connection with VM instance, Check for the “evilginx2” directory, navigate into it:

  ```bash
  cd evilginx2
  ```

- To start the EvilGinx on your machine :

  ```bash
  sudo ~/evilginx2/evilginx2 -p ./phishlets/
  ```

These steps should help you properly set up and connect to EvilGinx after provisioning the infrastructure

<br>

## 6 All-in-one

<br>

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/azure_Full_infra_White.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Azure_Full_infra_Black.png">
  <img align="center" alt="overall" src="assets/azure_Full_infra_White.png">
</picture>
</div>

- To Deploy this infra you need to execute following command:

  ```bash
  redinfracraft.py create azure full_infra
  ```

> [!NOTE]
> Perform Common necessary steps mentioned above**

This infrastructure offers you the flexibility to utilize every component. You must adhere to the specified steps for each respective component.
<br>

