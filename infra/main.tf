terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "psb_rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_storage_account" "psb_storage_acct" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.psb_rg.name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = {
    created_by = "Pradeep Singh"
  }
}

resource "azurerm_storage_container" "population" {
  name                  = "population"
  storage_account_name  = azurerm_storage_account.psb_storage_acct.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "azure_data_lake_storage_gen2_acct" {
  name                     = var.azure_data_lake_storage_gen2_acct
  resource_group_name      = azurerm_resource_group.psb_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = {
    created_by = "Pradeep Singh"
  }
}

resource "azurerm_storage_container" "dl_population" {
  name                  = "population"
  storage_account_name  = azurerm_storage_account.azure_data_lake_storage_gen2_acct.name
  container_access_type = "private"
}

resource "azurerm_data_factory" "psb-covid-reporting-adf" {
  name                = "psb-covid-reporting-adf"
  location            = var.location
  resource_group_name = azurerm_resource_group.psb_rg.name

  github_configuration {
    account_name    = "pradeepsingh87"
    branch_name     = "main"
    git_url         = "https://github.com"
    repository_name = "adf-automation"
    root_folder     = "src"
  }
  tags = {
    created_by = "Pradeep Singh"
  }
}

resource "azurerm_data_factory_pipeline" "covid_data_factory_pipeline" {
  name                = var.covid_data_factory_pipeline
  resource_group_name = azurerm_resource_group.psb_rg.name
  data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "ls_ablob_covidreportingsa" {
  name                = var.ls_ablob_covidreportingsa
  resource_group_name = azurerm_resource_group.psb_rg.name
  data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
  connection_string   = azurerm_storage_account.psb_storage_acct.primary_connection_string
}


resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "ls_adls_covidreportingdl" {
  name                = var.ls_adls_covidreportingdl
  resource_group_name = azurerm_resource_group.psb_rg.name
  data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name

  url                 = azurerm_storage_account.azure_data_lake_storage_gen2_acct.primary_dfs_endpoint
  storage_account_key = azurerm_storage_account.azure_data_lake_storage_gen2_acct.primary_access_key
  # storage_account_key is not supported in provider version version = "=2.46.0"
}

resource "azurerm_data_factory_linked_service_web" "ls_https_worldwide_aggregate" {
  name                = "ls_https_worldwide_aggregate"
  resource_group_name = azurerm_resource_group.psb_rg.name
  data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
  authentication_type = "Anonymous"
  url                 = "https://raw.githubusercontent.com/"
  # integration_runtime_name = azurerm_data_factory.psb-covid-reporting-adf.name
}


# resource "azurerm_data_factory_dataset_delimited_text" "ds_population_raw_gz" {
#   name                = var.ds_population_raw_gz
#   resource_group_name = azurerm_resource_group.psb_rg.name
#   data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.ls_ablob_covidreportingsa.name

#   azure_blob_storage_location {
#     container = "population"
#     path      = " "
#     filename  = "population_by_age.tsv.gz"
#   }

#   compression_codec   = "gzip"
#   compression_level   = "Optimal"
#   column_delimiter    = "\t"
#   row_delimiter       = "NEW"
#   encoding            = "UTF-8"
#   escape_character    = "\\"
#   quote_character     = "\""
#   first_row_as_header = true
#   null_value          = "NULL"

# }


# resource "azurerm_data_factory_dataset_delimited_text" "ds_population_raw_tsv" {
#   name                = var.ds_population_raw_tsv
#   resource_group_name = azurerm_resource_group.psb_rg.name
#   data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
#   linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.ls_adls_covidreportingdl.name

#   azure_blob_storage_location {
#     container = "raw"
#     path      = " "
#     filename  = "population_by_age.tsv"
#   }

#   column_delimiter    = "\t"
#   row_delimiter       = "NEW"
#   encoding            = "UTF-8"
#   escape_character    = "\\"
#   quote_character     = "\""
#   first_row_as_header = true
#   null_value          = "NULL"

# }


# resource "azurerm_data_factory_dataset_http" "ds_https_worldwide_aggregate" {
#   name                = "ds_https_worldwide_aggregate"
#   resource_group_name = azurerm_resource_group.psb_rg.name
#   data_factory_name   = azurerm_data_factory.psb-covid-reporting-adf.name
#   linked_service_name = azurerm_data_factory_linked_service_web.ls_https_worldwide_aggregate.name

#   relative_url = "datasets/covid-19/main/data/worldwide-aggregate.csv"
#   request_method = "GET"

# }
