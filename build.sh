# change into infra directory
cd infra

# initialize the provider
terraform init 

# Create a terraform plan
terraform plan

# validate the configuration and terraform state 
terraform validate

# Format the terraform files
terraform fmt

# Apply the terraform state.
terraform apply --auto-approve

# change the dir back to root.
cd ..

# Az command to download fiel from Azure Gen2 Storage DL . 
# export AZCOPY_CRED_TYPE=Anonymous;
# ./azcopy copy "https://psbdlstoragegen2acct.blob.core.windows.net/population/population_by_age.tsv?sv=2020-08-04&se=2021-11-23T03%3A00%3A00Z&sr=c&sp=rl&sig=q3bpIh%2FRN5rb7wYvojPX3xI%2FMnYoPdm2oLuhzgT2uGQ%3D" "/Users/psb/Downloads/population_by_age.tsv" --overwrite=prompt --check-md5 FailIfDifferent --from-to=BlobLocal --recursive --trusted-microsoft-suffixes= --log-level=INFO;
# unset AZCOPY_CRED_TYPE;

# Its always a good idea to create linked services from terraform .
# Anything that uses credentials should be mapped using variables . 
# This makes sure that if you delete and recreate resources they are not reffering to old credentials in the arm template.
