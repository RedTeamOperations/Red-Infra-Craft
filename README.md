<div align="center">
  <img width="40%" height="40%" src="https://github.com/RedTeamOperations/Automate-Red-Team-Infra/assets/86774143/72e4d4ab-8de9-4b17-be1e-df36516b0f55" alt="Redinfracraft Logo">
</div>

# Red-Infra-Craft

Welcome to the **RedInfraCraft** Tool - your gateway to automating the deployment of robust red team infrastructures! RedInfraCraft is your trusted companion in effortlessly setting up and managing red team infrastructures, streamlining the process so you can focus on your mission. 

- Simplifies the deployment of Mythic Command and Control (C2) frameworks.
- Facilitates the creation and management of sophisticated phishing and payload setups
- Designed to be intuitive and easy to use, reducing the learning curve for red teamers.
- Provides thorough documentation and guides to assist users at every step.

Let's craft infrastructures together with **RedInfraCraft**!!

## 1. Prerequisite

To follow this guide, you'll need to have the following software installed on your machine:

- **Terraform**

  To Download Terraform, you can visit their official website [HashiCorp](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli). They     provide instructions on how to install Terraform on Windows, Linux, and macOS.

- **Python**

  Make sure you have [Python](https://www.python.org/) installed in your system.

## 2. RedInfraCraft Tool Installation
To acquire the tool, you need to clone this GitHub repository. Paste the below command in your terminal.

> [!IMPORTANT]
> Make sure you have installed [git](https://git-scm.com/downloads) in your machine

```bash
git clone https://github.com/RedTeamOperations/Red-Infra-Craft.git
```

## 3. How to spawn an Infrastructure?

RedInfraCraft enables you to deploy any infrastructure in a single step, automating your tasks efficiently.

<br>

<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/Common_user1.png">
    <source media="(prefers-color-scheme: light)" srcset="assets/Common_user.png">
    <img align="center" alt="spawn an Infrastructure" src="assets/Common_user.png">
  </picture>
</div>

### Available Infrastructures:

- **C2:**
  - Mythic C2 
  - Mythic C2 with CloudFront and Load Balancer
- **Payload:**
  - Pwndrop
- **Phishing:** 
  - EvilGinx
  - GoPhish
- **All in One Infra:** 
  - Mythic C2 with CloudFront and Load Balancer, Pwndrop, EvilGinx, GoPhish.

### Help Commands:

- To know more about this tool 💡
  ```bash
  redinfracraft.py info
  ```
  
- To know about arguments 💡
  ```bash
  redinfracraft.py --help
  ```
  
- To view available options 💡
  ```bash 
  redinfracraft.py help
  ```
  
### Commands to Spawn 🔧 and Destroy 🗑️ Infras:

  | Infrastructure | Command | Description |
  | ------ | ------------ | ------ |
  | Mythic C2 🔧 | redinfracraft.py create c2 mythic | To Create Mythic C2 infrastructure. | 
  | Mythic C2 🗑️ | redinfracraft.py destroy c2 mythic | To Destroy Mythic C2 infrastructure. | 
  | Mythic C2 🔧 | redinfracraft.py create c2 elb_c2 | To Create Mythic C2 with ELB & CloudFront infrastructure. | 
  | Mythic C2 🗑️ | redinfracraft.py destroy c2 elb_c2 | To Destroy Mythic C2 with ELB & CloudFront infrastructure. | 
  | Payload 🔧 | redinfracraft.py create payload pwndrop | To Create pwndrop payload infrastructure. | 
  | Payload 🗑️ | redinfracraft.py destroy payload pwndrop | To Destroy pwndrop payload infrastructure. |
  | Phishing 🔧 | redinfracraft.py create phishing gophish | To Create Gophish phishing infrastructure. |
  | Phishing 🗑️ | redinfracraft.py destroy phishing gophish | To Destroy Gophish phishing infrastructure. |
  | Phishing 🔧 | redinfracraft.py create phishing evilginx | To Create Evilginx phishing infrastructure. |
  | Phishing 🗑️ | redinfracraft.py destroy phishing evilginx | To Destroy Evilginx phishing infrastructure. |
  | All-in-one 🔧 | redinfracraft.py create full_infra | To Create all infrastructures in one go (Mythic C2 with CloudFront and Load Balancer, Payload, Phishing). |
  | All-in-one 🗑️ | redinfracraft.py destroy full_infra | To Destroy all infrastructures in one go (Mythic C2 with CloudFront and Load Balancer, Payload, Phishing). |

<br>


## Learning Content

If you want to learn more, please refer to this content:

<br>

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/Certification1.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/Certifications.png">
  <img align="center" alt="Certifications" src="assets/Certifications.png">
</picture>
</div>

- Red Team Infra Dev [[CRT-ID](https://cyberwarfare.live/product/red-team-infra-developer/)]
- Multi-Cloud Red Team Analyst [[MCRTA](https://cyberwarfare.live/product/multi-cloud-red-team-analyst-mcrta/)]
- Hybrid Multi-Cloud Red Team Specialist [[CHMRTS](https://cyberwarfare.live/product/hybrid-multi-cloud-red-team-specialist-chmrts/)]

<br>

## Future Releases
This is the initial version of our tool, currently hosted on the AWS cloud platform. We've laid the groundwork for this release, focusing on delivering robust and reliable services on AWS.

However, this is just the beginning.

In the near future, we plan to significantly expand the tool's capabilities.
Our roadmap includes adding support for more frameworks, which will give users more options to meet their specific needs. This expansion will improve the tool's flexibility and usability, targeting a broader audience.

Additionally, we are working to make this tool available on other major cloud providers. Soon, users will be able to access this tool on Microsoft Azure and Google Cloud Platform (GCP). This multi-cloud support will ensure that our tool can integrate seamlessly into a variety of cloud environments, providing more choice and convenience to our users.
Stay tuned for these exciting updates as we continue to develop and improve our tools to better meet your needs.

<br>

## Your Feedback

We highly value your feedback, as it plays a crucial role in the continuous development of RedInfraCraft. Your suggestions and comments are invaluable in further enhancing the tool. Please don't hesitate to share your thoughts either by creating an Issue or reaching out to us via email at [info@cyberwarfare.live](mailto:info@cyberwarfare.live) with the subject **RedInfraCraft**.
