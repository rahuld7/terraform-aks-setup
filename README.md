#Azure Terraform Documentation for AKS and ACR Deployment Using Classic Editor Pipeline

This repository contains Terraform scripts to automate the deployment of an Azure Kubernetes Service (AKS) cluster and Azure Container Registry (ACR) within an Azure environment. The deployment is managed via Terraform and can be integrated into an Azure DevOps Classic Editor pipeline for continuous infrastructure deployment.

#Prerequisites

Before using these Terraform scripts, ensure the following:

- Azure Subscription: You need an active Azure subscription.
- Terraform: Ensure Terraform is installed. You can download it from [Terraform Downloads](https://www.terraform.io/downloads.html).
- Azure CLI: Ensure Azure CLI is installed and configured. You can download it from [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Azure DevOps Account: This setup is intended for use with Azure DevOps pipelines. You need an Azure DevOps account to automate the deployment.
- Basic Azure Knowledge: Understanding of Azure Kubernetes Service (AKS), Azure Container Registry (ACR), and resource groups.

## File Structure

- `main.tf`: Contains the main Terraform configuration to create resources such as the AKS cluster and ACR.
- `variables.tf`: Defines input variables for customization.
- `terraform.tfvars`: Contains variable values for the deployment (can be customized for each environment).
- `backend.tf`: (Optional) Configures remote state storage in Azure Storage.

## Terraform Configuration Overview

### `main.tf`

This file defines the core Azure resources, including:

- azurerm_resource_group: Creates the Azure resource group `k8s-demo-rg`.
- azurerm_kubernetes_cluster: Provisions an Azure Kubernetes Service (AKS) cluster named `k8s-demo-cluster`.
- azurerm_container_registry: Creates an Azure Container Registry (ACR) named `k8sdemoacr`.
- Outputs:
  - `kube_config`: Outputs the Kubernetes configuration for accessing the AKS cluster.
  - `acr_login_server`: Outputs the ACR login server address.

### `variables.tf`

Defines the configurable variables for the infrastructure:

- `resource_group_name`: Name of the resource group (`k8s-demo-rg`).
- `location`: Azure region for resource deployment (e.g., `East US`).
- `aks_name`: Name of the AKS cluster (`k8s-demo-cluster`).
- `dns_prefix`: DNS prefix for the AKS cluster (`k8sdemo`).
- `node_count`: Number of nodes in the AKS cluster (e.g., `2`).
- `vm_size`: Size of the virtual machines in the AKS node pool (e.g., `Standard_DS2_v2`).
- `acr_name`: Name of the Azure Container Registry (`k8sdemoacr`).

### Steps for creating Classic Editor Pipeline
# Step 1: Create a New Pipeline
Navigate to your Azure DevOps project: Open your Azure DevOps organization and go to your desired project.
Create a new pipeline:
From the left-hand sidebar, go to Pipelines.
Click on New Pipeline.
Choose Classic Editor (not YAML).
Select the repository that contains your Terraform scripts.
Choose the Pipeline type (e.g., Azure Repos Git or GitHub).
Click on Continue.

# Step 2: Configure Pipeline Tasks
You will now need to add specific tasks to the pipeline to initialize, plan, and apply the Terraform configuration. Here's how to do it:

Add Terraform Task for Initialization

Click on the + icon to add a new task.
Search for Terraform and select the Terraform Installer task. This ensures that the Terraform CLI is available on the build agent.
Configure the task:
Terraform Version: Specify the version of Terraform you need.
Installation Method: Choose how to install Terraform (default options usually work).
Add Terraform Task for Initialization (terraform init)

Click on the + icon again to add another task.
Search for Terraform and select the Terraform CLI task.
Configure the task:
Command: Select init (this initializes your Terraform configuration).
Working Directory: Set the working directory to where your main.tf and other Terraform files are located.
Environment Variables: Optionally, set up any environment variables, such as authentication credentials for Azure.
Add Terraform Task for Planning (terraform plan)

Click on the + icon to add a new task again.
Search for Terraform and select the Terraform CLI task.
Configure the task:
Command: Select plan (this generates an execution plan and shows the changes that will be made).
Working Directory: Point to the directory containing your Terraform files.
Environment Variables: Provide necessary variables for authentication, if required.
Add Terraform Task for Applying (terraform apply)

Click on the + icon to add another task.

Search for Terraform and select the Terraform CLI task.

Configure the task:

Command: Select apply (this applies the Terraform plan and creates resources in Azure).
Working Directory: Again, point to the directory where your Terraform files are located.
Environment Variables: Ensure your environment variables or authentication details are properly set.
For the apply step, you will likely want to ensure that the pipeline automatically approves the changes (to avoid manual intervention). To do this, set the Auto-approve option for the terraform apply task.

Optional: Add Terraform Task for State Management (if using remote backend)

If you're using a remote backend (e.g., Azure Storage), ensure that your backend is configured correctly in backend.tf (as you showed earlier).
This step is optional but recommended for centralized management of Terraform state files.
# Step 3: Configure Azure Service Connection
To enable Terraform to authenticate with Azure, you must create a Service Principal and set up a service connection in Azure DevOps.

Go to Project Settings.
Under the Pipelines section, click on Service connections.
Click on New Service Connection and choose Azure Resource Manager.
Select Service principal (automatic) and provide necessary permissions.
Configure the service connection with the required Azure subscription, and make sure it has the right permissions (Contributor or higher) to manage resources in the target Azure subscription.
# Step 4: Configure Pipeline Variables (Optional)
If you have variables like resource_group_name, location, aks_name, etc., that are defined in variables.tf and terraform.tfvars, you may want to add them as pipeline variables for flexibility.

Go to the Variables section of your pipeline.
Add the relevant variables (e.g., resource_group_name, location, aks_name) and their respective values.
You can also override the default values from the terraform.tfvars file in the pipeline by specifying them here.
# Step 5: Run the Pipeline
Once you've added all the necessary tasks and configured the pipeline:

Save and run the pipeline.
Azure DevOps will automatically execute the Terraform commands in the order you specified: terraform init, terraform plan, and terraform apply.
Monitor the output in the pipeline logs to see if everything completes successfully.
Once the pipeline finishes, your AKS and ACR resources should be provisioned in your Azure environment.
# Step 6: Review Outputs
After the pipeline has completed successfully, review the output from the Terraform apply step. You should see the details of the created resources.

Kubernetes Configuration (kube_config): This will allow you to interact with your AKS cluster. You can download the kube_config and use it with kubectl.
ACR Login Server: The Azure Container Registry login server URL, which you can use to push Docker images.
Example of the Pipeline Task Sequence
Here’s a quick summary of what the task sequence will look like in the Classic Editor:

Terraform Installer - Install Terraform CLI.
Terraform CLI: Init - Initialize the Terraform configuration (terraform init).
Terraform CLI: Plan - Generate the Terraform execution plan (terraform plan).
Terraform CLI: Apply - Apply the Terraform configuration (terraform apply).
Optional: Automating the Pipeline
Triggers: You can set up triggers to automatically run the pipeline when certain conditions are met (e.g., on commits to the main branch).
Approval Gates: If needed, you can configure manual approval gates before the terraform apply task is executed, especially in production environments.
