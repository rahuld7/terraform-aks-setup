### Azure Terraform Documentation for AKS and ACR Deployment Using Classic Editor Pipeline

## Overview
This repository contains Terraform scripts that automate the deployment of the following Azure resources:
- **Azure Kubernetes Service (AKS)**: A managed Kubernetes cluster for deploying containerized applications.
- **Azure Container Registry (ACR)**: A private registry to store Docker container images.
- **Azure Resource Group**: A container that holds related resources for an Azure solution.

---

### **Files Involved**
1. **backend.tf**
2. **main.tf**
3. **terraform.tfvars**
4. **variables.tf**

---

## **1. Backend Configuration**

### **File: backend.tf**

The `backend.tf` file defines the backend configuration for Terraform's state management. It configures an Azure Storage Account to store the Terraform state file. This enables collaboration and ensures the state is safely stored in the cloud.

- **resource_group_name**: Specifies the resource group to store the Terraform backend.
- **storage_account_name**: Specifies the Azure Storage Account used to store the state.
- **container_name**: Specifies the container in the Storage Account to store the state file.
- **key**: The name of the state file (`k8s-demo.tfstate`).

This file ensures that the Terraform state is stored in a secure and centralized location in Azure.

---

## **2. Resource Creation and Deployment**

### **File: main.tf**

The `main.tf` file defines the resources that will be created on Azure. It includes:

- **Provider Configuration**: Configures the Terraform Azure provider (`azurerm`).
- **Resource Group**: Defines the Azure Resource Group where resources will be created.
- **Azure Kubernetes Service (AKS)**: Defines the managed Kubernetes cluster with details like name, location, node count, and VM size.
- **Azure Container Registry (ACR)**: Defines the Azure Container Registry for storing Docker images.
- **Outputs**: Outputs the Kubernetes cluster configuration (`kube_config`) and ACR login server for further use.

Key resources defined in this file:
- **azurerm_resource_group**: Creates an Azure Resource Group.
- **azurerm_kubernetes_cluster**: Creates an AKS cluster with a specified node pool.
- **azurerm_container_registry**: Creates an ACR instance for Docker image storage.

---

## **3. Variable Definitions**

### **File: variables.tf**

The `variables.tf` file defines all the input variables for the Terraform configuration. These variables allow for dynamic configuration of the resources and help separate configuration from actual values.

The following variables are defined:
- **resource_group_name**: The name of the resource group where the resources will be created.
- **location**: The Azure region where resources will be deployed (e.g., "East US").
- **aks_name**: The name of the Azure Kubernetes Service (AKS) cluster.
- **dns_prefix**: The DNS prefix for the AKS cluster.
- **node_count**: The number of nodes in the AKS cluster.
- **vm_size**: The virtual machine size for the AKS nodes.
- **acr_name**: The name of the Azure Container Registry (ACR).

These variables can be customized in the `terraform.tfvars` file to modify resource configurations.

---

## **4. Terraform Variables Values**

### **File: terraform.tfvars**

The `terraform.tfvars` file contains the actual values for the variables defined in `variables.tf`. These values are used to configure the resources and will be applied when Terraform is run.

Example of the variable values in `terraform.tfvars`:
- **resource_group_name**: "k8s-demo-rg"
- **location**: "East US"
- **aks_name**: "k8s-demo-cluster"
- **dns_prefix**: "k8sdemo"
- **node_count**: 2
- **vm_size**: "Standard_DS2_v2"
- **acr_name**: "k8sdemoacr"


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
