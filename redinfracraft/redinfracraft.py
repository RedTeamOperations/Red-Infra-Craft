import argparse
import os

current_dir = os.getcwd()

def change_directory(path):
    os.chdir(current_dir+path)


def createTerrformCommand():
    os.system('terraform init')
    os.system('terraform apply -auto-approve')


def destroyTerrformCommand():
    os.system('terraform init')
    os.system('terraform destroy -auto-approve')


# Function to deploy Mythic C2
def deploy_mythic_c2():
    change_directory("\Terraform\Mythic_C2")
    createTerrformCommand()


# Function to deploy ELB C2
def deploy_elb_c2():
    change_directory("\Terraform\EC2 Instance")
    createTerrformCommand()


# Function to deploy pwndrop
def deploy_pwndrop():
    change_directory("\Terraform\Payload Server")
    createTerrformCommand()


# Function to deploy gophish
def deploy_gophish():
    change_directory("\Terraform\gophish")
    createTerrformCommand()


# Function to deploy Evilginx
def deploy_evilginx():
    change_directory("\Terraform\Phishing")
    createTerrformCommand()


# Function to destroy Mythic C2
def destroy_mythic_c2():
    change_directory("\Terraform\Mythic_C2")
    destroyTerrformCommand()


# Function to destroy ELB C2
def destroy_elb_c2():
    change_directory("\Terraform\EC2 Instance")
    destroyTerrformCommand()


# Function to destroy pwndrop
def destroy_pwndrop():
    change_directory("\Terraform\Payload Server")
    destroyTerrformCommand()


# Function to destroy gophish
def destroy_gophish():
    change_directory("\Terraform\gophish")
    destroyTerrformCommand()


# Function to destroy Evilginx
def destroy_evilginx():
    change_directory("\Terraform\Phishing")
    destroyTerrformCommand()


# Main function
def main():
    parser = argparse.ArgumentParser(description='Tool for deploying or destroying infrastructure.')
    subparsers = parser.add_subparsers(dest='action', help='Action to perform')

    # Sub-parser for creating infrastructure
    parser_create = subparsers.add_parser('create', help='To Create infrastructure')
    parser_create.add_argument('infra', choices=['c2', 'payload', 'phishing', 'full_infra'],
                               help='Infrastructure to create')
    parser_create.add_argument('type', nargs='?', choices=['mythic', 'elb_c2', 'pwndrop', 'gophish', 'evilginx'],
                               help='Type of infrastructure')

    # Sub-parser for destroying infrastructure
    parser_destroy = subparsers.add_parser('destroy', help='To Destroy infrastructure')
    parser_destroy.add_argument('infra', choices=['c2', 'payload', 'phishing', 'full_infra'],
                                help='Infrastructure to destroy')
    parser_destroy.add_argument('type', nargs='?', choices=['mythic', 'elb_c2', 'pwndrop', 'gophish', 'evilginx'],
                                help='Type of infrastructure to destroy')

    # Add info command
    parser_info = subparsers.add_parser('info',
                                        help='Shows info message, Try "redinfracraft.py.py info" to know more about this tool.')

    # Add help command
    parser_help = subparsers.add_parser('help',
                                        help='Shows help message, Try "redinfracraft.py.py help" to view available options.')

    args = parser.parse_args()

    if args.action == 'create':
        if args.infra == 'c2':
            if args.type == 'mythic':
                deploy_mythic_c2()
            elif args.type == 'elb_c2':
                deploy_elb_c2()

        elif args.infra == 'payload':
            if args.type == 'pwndrop':
                deploy_pwndrop()

        elif args.infra == 'phishing':
            if args.type == 'gophish':
                deploy_gophish()
            elif args.type == 'evilginx':
                deploy_evilginx()

        elif args.infra == 'full_infra':
            deploy_elb_c2()
            deploy_pwndrop()
            deploy_gophish()
            deploy_evilginx()

    elif args.action == 'destroy':
        if args.infra == 'c2':
            if args.type == 'mythic':
                destroy_mythic_c2()
            elif args.type == 'elb_c2':
                destroy_elb_c2()

        elif args.infra == 'payload':
            if args.type == 'pwndrop':
                destroy_pwndrop()

        elif args.infra == 'phishing':
            if args.type == 'gophish':
                destroy_gophish()
            elif args.type == 'evilginx':
                destroy_evilginx()

        elif args.infra == 'full_infra':
            destroy_elb_c2()
            destroy_pwndrop()
            destroy_gophish()
            destroy_evilginx()

    elif args.action == 'help':
        print_help_message()

    elif args.action == 'info':
        print_info_message()

    else:
        print("""

    Invalid action!!

    I am here to assist You

    Try "redinfracraft.py info" to know more about this tool.

    Try "redinfracraft.py --help" to know about arguments.

    Try "redinfracraft.py help" to view available options. 
    
        """)


def print_info_message():
    print(""" 
    
********************************************************************************************************************************************************
*    ________   _______   _____   _________   ___         _   _______   ________     ----       _______   ________     ----     _______   _________    *   
*   (  ____  ) (  _____) (  _  \ (___   ___) (   \       | ) (  _____) (  ____  )   / __ \     / ______) (  ____  )   / __ \   (  _____) (___   ___)   *     
*   | |    | | | (       | (  \ \    | |     | |\ \      | | | (       | |    | |  / /  \ \   / /        | |    | |  / /  \ \  | (           | |       *
*   | |____| | | |       | |   \ \   | |     | | \ \     | | | |       | |____| | | |    | | / /         | |____| | | |    | | | |           | |       *
*   | _  ___ ) | (_____  | |   | |   | |     | |  \ \    | | | (_____  |  _ ___ ) | (____) | | |         |  _ ___ ) | (____) | | (_____      | |       *
*   | |\ \     |  _____) | |   | |   | |     | |   \ \   | | |  _____) | |\ \     |  ____  | | |         | |\ \     |  ____  | |  _____)     | |       *  
*   | | \ \    | (       | |   | |   | |     | |    \ \  | | | (       | | \ \    | (    ) | | |         | | \ \    | (    ) | | (           | |       *
*   | |  \ \   | |       | |  / /    | |     | |     \ \ | | | |       | |  \ \   | |    | | \ \         | |  \ \   | |    | | | |           | |       *  
*   | |   \ \  | (_____  | (_/ /  ___| |___  | |      \ \| | | |       | |   \ \  | |    | |  \ \______  | |   \ \  | |    | | | |           | |       * 
*   (_|    \_\ (_______) (___ /  (_________) (_|       \___) (_|       (_|    \_\ (_|    |_)   \_______) (_|    \_\ (_|    |_) (_|           |_|       *     
*                                                                                                                                                      *
********************************************************************************************************************************************************   
          

                 Introducing RedInfraCraft - your go-to tool for seamlessly crafting and overseeing cloud infrastructures, tailored 
        specifically for Red Teamers! With RedInfraCraft, you're not just deploying some infrastructure; you are crafting a digital 
        masterpiece. Whether you're forging Mythic C2s, shaping ELB architectures, or crafting cunning phishing setups, RedInfraCraft 
        empowers you to build, deploy, and manage with unparalleled ease. Let's turn your cloud dreams into infrastructural realities 
        with RedInfraCraft - where every deployment is a stroke of genius!"

                                                                                                         - CyberWarFare Labs

    """)


def print_help_message():
    print("""

Infrastructures:

    1) C2 - "Mythic C2, Mythic C2 with CloudFront and Load Balancer"
    2) Payload - "Pwndrop"
    3) Phishing - "EvilGinx, GoPhish"
    4) All in One Infra - "Mythic C2 with CloudFront and Load Balancer & Pwndrop & EvilGinx & GoPhish"     

To Create Infrastructure:

    --> Create Mythic C2 infrastructure:
            redinfracraft.py create c2 mythic 
    --> Create ELB C2 infrastructure:
            redinfracraft.py create c2 elb_c2
    --> Create pwndrop payload infrastructure:
            redinfracraft.py create payload pwndrop
    --> Create Gophish phishing infrastructure:
            redinfracraft.py create phishing gophish
    --> Create Evilginx phishing infrastructure:
            redinfracraft.py create phishing evilginx
    --> Create all infrastructures (Mythic C2 with ELB & CloudFront, pwndrop, Gophish, and Evilginx):
            redinfracraft.py create full_infra

To Destroy Infrastructure:

    --> Destroy Mythic C2 infrastructure:
            redinfracraft.py destroy c2 mythic
    --> Destroy ELB C2 infrastructure:
            redinfracraft.py destroy c2 elb_c2
    --> Destroy pwndrop payload infrastructure:
            redinfracraft.py destroy payload pwndrop
    --> Destroy GoPhish phishing infrastructure:
            redinfracraft.py destroy phishing gophish
    --> Destroy EvilGinx phishing infrastructure:
            redinfracraft.py destroy phishing evilginx
    --> Destroy all infrastructures (Mythic C2 with ELB & CloudFront,, pwndrop, GoPhish, and EvilGinx):
            redinfracraft.py destroy full_infra

    """)


# Execute main function
if __name__ == "__main__":
    main()
    print(current_dir)
