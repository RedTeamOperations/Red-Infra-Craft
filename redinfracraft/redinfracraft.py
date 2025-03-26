import argparse
import os

current_dir = os.getcwd()
tfvars_file = os.path.join(current_dir, "Terraform", "terraform.auto.tfvars")


def change_directory(path):
    # Use os.path.join to handle cross-platform paths
    target_path = os.path.join(current_dir, path)
    os.chdir(target_path)


def createTerrformCommand():
    os.system('terraform init')
    os.system(f'terraform apply -auto-approve -var-file={tfvars_file}')


def destroyTerrformCommand():
    os.system('terraform init')
    os.system(f'terraform destroy -auto-approve -var-file={tfvars_file}')


# Function to deploy Mythic C2 for AWS
def deploy_mythic_c2_aws():
    change_directory("Terraform/AWS/AWS_Mythic_C2")
    createTerrformCommand()


# Function to deploy Mythic C2 for Azure
def deploy_mythic_c2_azure():
    change_directory("Terraform/Azure/Azure_Mythic_C2")
    createTerrformCommand()


# Function to deploy Mythic C2 with ELB and CloudFront for AWS
def deploy_elb_c2_aws():
    change_directory("Terraform/AWS/AWS_Mythic_C2_with_CloudFront")
    createTerrformCommand()


# Function to deploy Mythic C2 with Frontdoor for Azure
def deploy_elb_c2_azure():
    change_directory("Terraform/Azure/Azure_Mythic_C2_with_Frontdoor")
    createTerrformCommand()


# Function to deploy Mythic C2 with ELB for GCP
def deploy_elb_c2_gcp():
    change_directory("Terraform/GCP/GCP_Mythic_C2_with_ELB")
    createTerrformCommand()


# Function to deploy Pwndrop for AWS
def deploy_pwndrop_aws():
    change_directory("Terraform/AWS/AWS_Pwndrop_Payload_Server")
    createTerrformCommand()


# Function to deploy Pwndrop for Azure
def deploy_pwndrop_azure():
    change_directory("Terraform/Azure/Azure_Pwndrop_Payload_Server")
    createTerrformCommand()


# Function to deploy gophish for AWS
def deploy_gophish_aws():
    change_directory("Terraform/AWS/AWS_GoPhish_Phishing_Server")
    createTerrformCommand()


# Function to deploy gophish for Azure
def deploy_gophish_azure():
    change_directory("Terraform/Azure/Azure_GoPhish_Phishing_Server")
    createTerrformCommand()


# Function to deploy Evilginx for AWS
def deploy_evilginx_aws():
    change_directory("Terraform/AWS/AWS_Evilginx_Phishing_Server")
    createTerrformCommand()


# Function to deploy Evilginx for Azure
def deploy_evilginx_azure():
    change_directory("Terraform/Azure/Azure_Evilginx_Phishing_Server")
    createTerrformCommand()


# Function to destroy Mythic C2 for AWS
def destroy_mythic_c2_aws():
    change_directory("Terraform/AWS/AWS_Mythic_C2")
    destroyTerrformCommand()


# Function to destroy Mythic C2 for Azure
def destroy_mythic_c2_azure():
    change_directory("Terraform/Azure/Azure_Mythic_C2")
    destroyTerrformCommand()


# Function to destroy Mythic C2 with ELB and CloudFront for AWS
def destroy_elb_c2_aws():
    change_directory("Terraform/AWS/AWS_Mythic_C2_with_CloudFront")
    destroyTerrformCommand()


# Function to destroy Mythic C2 with Frontdoor for Azure
def destroy_elb_c2_azure():
    change_directory("Terraform/Azure/Azure_Mythic_C2_with_Frontdoor")
    destroyTerrformCommand()


# Function to destroy Mythic C2 with ELB for GCP
def destroy_elb_c2_gcp():
    change_directory("Terraform/GCP/GCP_Mythic_C2_with_Frontdoor")
    destroyTerrformCommand()

# Function to destroy Pwndrop for AWS
def destroy_pwndrop_aws():
    change_directory("Terraform/AWS/AWS_Pwndrop_Payload_Server")
    destroyTerrformCommand()


# Function to destroy Pwndrop for Azure
def destroy_pwndrop_azure():
    change_directory("Terraform/Azure/Azure_Pwndrop_Payload_Server")
    destroyTerrformCommand()


# Function to destroy gophish for AWS
def destroy_gophish_aws():
    change_directory("Terraform/AWS/AWS_GoPhish_Phishing_Server")
    destroyTerrformCommand()


# Function to destroy GoPhish for Azure
def destroy_gophish_azure():
    change_directory("Terraform/Azure/Azure_GoPhish_Phishing_Server")
    destroyTerrformCommand()


# Function to destroy Evilginx for AWS
def destroy_evilginx_aws():
    change_directory("Terraform/AWS/AWS_Evilginx_Phishing_Server")
    destroyTerrformCommand()


# Function to destroy Evilginx for Azure
def destroy_evilginx_azure():
    change_directory("Terraform/Azure/Azure_Evilginx_Phishing_Server")
    destroyTerrformCommand()


# Main function
def main():
    parser = argparse.ArgumentParser(description='Tool for deploying or destroying infrastructure.')
    subparsers = parser.add_subparsers(dest='action', help='Action to perform')

    # Sub-parser for creating infrastructure
    parser_create = subparsers.add_parser('create', help='To Create infrastructure')
    parser_create.add_argument('cloud', choices=['aws', 'azure', 'gcp'], help='Cloud provider (aws/azure/gcp)')
    parser_create.add_argument('infra', choices=['c2', 'payload', 'phishing', 'full_infra'],
                               help='Infrastructure to create')
    parser_create.add_argument('type', nargs='?', choices=['mythic', 'mythic_lb', 'pwndrop', 'gophish', 'evilginx'],
                               help='Type of infrastructure')

    # Sub-parser for destroying infrastructure
    parser_destroy = subparsers.add_parser('destroy', help='To Destroy infrastructure')
    parser_destroy.add_argument('cloud', choices=['aws', 'azure', 'gcp'], help='Cloud provider (aws/azure/gcp)')
    parser_destroy.add_argument('infra', choices=['c2', 'payload', 'phishing', 'full_infra'],
                                help='Infrastructure to destroy')
    parser_destroy.add_argument('type', nargs='?', choices=['mythic', 'mythic_lb', 'pwndrop', 'gophish', 'evilginx'],
                                help='Type of infrastructure to destroy')

    # Add info command
    parser_info = subparsers.add_parser('info',
                                        help='Shows info message, Try "redinfracraft.py.py info" to know more about this tool.')

    # Add help command
    parser_help = subparsers.add_parser('help',
                                        help='Shows help message, Try "redinfracraft.py.py help" to view available options.')

    args = parser.parse_args()

    # Mapping infrastructure and cloud types to functions
    action_map = {
        'create': {
            'aws': {
                'c2': {'mythic': deploy_mythic_c2_aws, 'mythic_lb': deploy_elb_c2_aws},
                'payload': {'pwndrop': deploy_pwndrop_aws},
                'phishing': {'gophish': deploy_gophish_aws, 'evilginx': deploy_evilginx_aws},
                'full_infra': lambda: (
                deploy_elb_c2_aws(), deploy_pwndrop_aws(), deploy_gophish_aws(), deploy_evilginx_aws())
            },
            'azure': {
                'c2': {'mythic': deploy_mythic_c2_azure, 'mythic_lb': deploy_elb_c2_azure},
                'payload': {'pwndrop': deploy_pwndrop_azure},
                'phishing': {'gophish': deploy_gophish_azure, 'evilginx': deploy_evilginx_azure},
                'full_infra': lambda: (
                deploy_elb_c2_azure(), deploy_pwndrop_azure(), deploy_gophish_azure(), deploy_evilginx_azure())
            },
            'gcp': {
                'c2': {'mythic_lb': deploy_elb_c2_gcp}
            }
        },
        'destroy': {
            'aws': {
                'c2': {'mythic': destroy_mythic_c2_aws, 'mythic_lb': destroy_elb_c2_aws},
                'payload': {'pwndrop': destroy_pwndrop_aws},
                'phishing': {'gophish': destroy_gophish_aws, 'evilginx': destroy_evilginx_aws},
                'full_infra': lambda: (
                destroy_elb_c2_aws(), destroy_pwndrop_aws(), destroy_gophish_aws(), destroy_evilginx_aws())
            },
            'azure': {
                'c2': {'mythic': destroy_mythic_c2_azure, 'mythic_lb': destroy_elb_c2_azure},
                'payload': {'pwndrop': destroy_pwndrop_azure},
                'phishing': {'gophish': destroy_gophish_azure, 'evilginx': destroy_evilginx_azure},
                'full_infra': lambda: (
                destroy_elb_c2_azure(), destroy_pwndrop_azure(), destroy_gophish_azure(), destroy_evilginx_azure())
            },
            'gcp': {
                'c2': {'mythic_lb': destroy_elb_c2_gcp},
            }
        }
    }

    # Execute the mapped function
    if args.action in action_map:
        try:
            if args.infra == 'full_infra':
                action_map[args.action][args.cloud][args.infra]()
            else:
                action_map[args.action][args.cloud][args.infra][args.type]()
        except KeyError:
            print("""
    Invalid combination of arguments!!

    I am here to assist You :)

        Try "redinfracraft.py info" to know more about this tool.

        Try "redinfracraft.py --help" to know about arguments.

        Try "redinfracraft.py help" to view available options. 
                    """)
    elif args.action == 'info':
        print_info_message()
    elif args.action == 'help':
        print_help_message()



def print_info_message():
    print(""" 

**********************************************************************************************************************************************************
*    ________   _______   _____     _________   ___         _   _______   ________     ----       _______   ________     ----     _______   _________    *   
*   (  ____  ) (  _____) (  __ \   (___   ___) (   \       | ) (  _____) (  ____  )   / __ \     / ______) (  ____  )   / __ \   (  _____) (___   ___)   *     
*   | |    | | | (       | (  \ \      | |     | |\ \      | | | (       | |    | |  / /  \ \   / /        | |    | |  / /  \ \  | (           | |       *
*   | |____| | | |       | |   \ \     | |     | | \ \     | | | |       | |____| | | |    | | / /         | |____| | | |    | | | |           | |       *
*   | _  ____) | (_____  | |    \ \    | |     | |  \ \    | | | (_____  | _  ____) | (____) | | |         | _  ____) | (____) | | (_____      | |       *
*   | |\ \     |  _____) | |    | |    | |     | |   \ \   | | |  _____) | |\ \     |  ____  | | |         | |\ \     |  ____  | |  _____)     | |       *  
*   | | \ \    | (       | |    / /    | |     | |    \ \  | | | (       | | \ \    | (    ) | | |         | | \ \    | (    ) | | (           | |       *
*   | |  \ \   | |       | |   / /     | |     | |     \ \ | | | |       | |  \ \   | |    | | \ \         | |  \ \   | |    | | | |           | |       *  
*   | |   \ \  | (_____  | (__/ /   ___| |___  | |      \ \| | | |       | |   \ \  | |    | |  \ \______  | |   \ \  | |    | | | |           | |       * 
*   (_|    \_\ (_______) (_____/   (_________) (_|       \___) (_|       (_|    \_\ (_|    |_)   \_______) (_|    \_\ (_|    |_) (_|           |_|       *     
*                                                                                                                                                        *
*                                                                                                                                         - Version-2    *
*                                                                                                                                                        *
********************************************************************************************************************************************************** 



                       Introducing RedInfraCraft (V2) - your go-to tool for seamlessly crafting and overseeing cloud infrastructures, tailored 
            specifically for Red Teamers!! With RedInfraCraft (V2), you're not just deploying some infrastructures; you are crafting a digital 
            masterpiece. Whether you're forging Mythic C2s, shaping ELB architectures, or crafting cunning phishing setups, RedInfraCraft (V2) 
            empowers you to build, deploy, and manage with unparalleled ease. Let's turn your cloud dreams into infrastructural realities with 
            RedInfraCraft (V2) - where every deployment is a stroke of genius!"

                                                                                                             - CyberWarFare Labs

    """)


def print_help_message():
    print("""

Infrastructures:

    1) C2 - "Mythic C2", "Mythic C2 with CloudFront and Load Balancer", "Mythic C2 with Frontdoor & CDN"
    2) Payload - "Pwndrop"
    3) Phishing - "EvilGinx", "GoPhish"
    4) All in One Infra - "Mythic C2 with CloudFront and Load Balancer, Pwndrop, EvilGinx, GoPhish", "Mythic C2 with Frontdoor & CDN, pwndrop, Gophish, and Evilginx"     


Cloud Providers:
    1) AWS
    2) Azure
    3) GCP


Command Explanation:
    --> redinfracraft.py  action  cloud_provider  infra_type  infra
    E.g redinfracraft.py  create       aws            c2      mythic
    E.g redinfracraft.py  destroy      azure          c2      mythic
    E.g redinfracraft.py  create       gcp            c2      mythic


Commands to Create Infrastructure:

    --> Create Mythic C2 infrastructure for AWS:
            redinfracraft.py create aws c2 mythic 

    --> Create Mythic C2 infrastructure for Azure:
            redinfracraft.py create azure c2 mythic

    --> Create ELB with Mythic C2 infrastructure for AWS:
            redinfracraft.py create aws c2 mythic_lb

    --> Create ELB with Mythic C2 infrastructure for Azure:
            redinfracraft.py create azure c2 mythic_lb
            
    --> Create ELB with Mythic C2 infrastructure for GCP:
            redinfracraft.py create gcp c2 mythic_lb

    --> Create pwndrop payload infrastructure for AWS:
            redinfracraft.py create aws payload pwndrop

    --> Create pwndrop payload infrastructure for Azure:
            redinfracraft.py create azure payload pwndrop

    --> Create Gophish phishing infrastructure for AWS:
            redinfracraft.py create aws phishing gophish

    --> Create Gophish phishing infrastructure for Azure:
            redinfracraft.py create azure phishing gophish

    --> Create Evilginx phishing infrastructure for AWS:
            redinfracraft.py create aws phishing evilginx

    --> Create Evilginx phishing infrastructure for Azure:
            redinfracraft.py create azure phishing evilginx

    --> Create full infrastructure (Mythic C2 with ELB & CloudFront, pwndrop, Gophish, and Evilginx):
            redinfracraft.py create aws full_infra

    --> Create full infrastructure (Mythic C2 with Frontdoor & CDN, pwndrop, Gophish, and Evilginx):
            redinfracraft.py create azure full_infra


Commands to Destroy Infrastructure:
    --> Destroy Mythic C2 infrastructure for AWS:

            redinfracraft.py destroy aws c2 mythic

    --> Destroy Mythic C2 infrastructure for Azure:
            redinfracraft.py destroy azure c2 mythic

    --> Destroy ELB with Mythic C2 infrastructure for AWS:
            redinfracraft.py destroy aws c2 mythic_lb

    --> Destroy ELB with Mythic C2 infrastructure for Azure:
            redinfracraft.py destroy azure c2 mythic_lb

    --> Destroy ELB with Mythic C2 infrastructure for GCP:
            redinfracraft.py destroy gcp c2 mythic_lb

    --> Destroy pwndrop payload infrastructure for AWS:
            redinfracraft.py destroy aws payload pwndrop

    --> Destroy pwndrop payload infrastructure for Azure:
            redinfracraft.py destroy azure payload pwndrop

    --> Destroy GoPhish phishing infrastructure for AWS:
            redinfracraft.py destroy aws phishing gophish

    --> Destroy GoPhish phishing infrastructure for Azure:
            redinfracraft.py destroy azure phishing gophish

    --> Destroy EvilGinx phishing infrastructure for AWS:
            redinfracraft.py destroy aws phishing evilginx

    --> Destroy EvilGinx phishing infrastructure for Azure:
            redinfracraft.py destroy azure phishing evilginx     

    --> Destroy full infrastructure (Mythic C2 with ELB & CloudFront, pwndrop, Gophish, and Evilginx):
            redinfracraft.py destroy aws full_infra

    --> Destroy full infrastructure (Mythic C2 with Frontdoor & CDN, pwndrop, Gophish, and Evilginx):
            redinfracraft.py destroy azure full_infra
    """)


# Execute main function
if __name__ == "__main__":
    main()