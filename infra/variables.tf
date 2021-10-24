variable "storage_account" {
  type    = string
  default = "psbstorageacc1"
}

variable "resource_group" {
  type    = string
  default = "psb_rg"
}
variable "location" {
  type    = string
  default = "East US"
}

variable "storage_account_tier" {
  type    = string
  default = "Standard" # Premium is other value . Only recommended for prod and high performance req.
}

variable "storage_account_replication_type" {
  type    = string
  default = "LRS"
  #   LRS  - For low cost with basic protection
  #   GRS  - For BackUp scenarios . Failover capacity to secondary region
  #   ZRS  - For high availibility. Capability for datacenter level failure.
  #   GZRS - GRS + ZRS . Used for critical data scenarios
}

variable "azure_data_lake_storage_gen2_acct" {
  type    = string
  default = "psbdlstoragegen2acct"

}

variable "azurerm_mssql_server" {
  type    = string
  default = "psb-covid-azure-sql-server"

}

variable "azurerm_mssql_database" {
  type    = string
  default = "psb-covid-azure-sql-db"

}

variable "collation" {
  type    = string
  default = "SQL_Latin1_General_CP1_CI_AS"

}

variable "license_type" {
  type    = string
  default = "BasePrice"

}
variable "max_size_gb" {
  type    = number
  default = 2

}

variable "read_scale" {
  type    = bool
  default = true

}

variable "sku_name" {
  type        = string
  default     = "Basic"
  description = "Please provide the SKU name for the Azure SQL Database tier. Can be obtained with \"az sql db list-editions -a -l <Azure Region> -o table\""

}
variable "zone_redundant" {
  type    = bool
  default = false

}

variable "my_public_ip" {
  type    = string
  default = "68.9.198.53"

}
variable "administrator_login" {
  type    = string
  default = "psb"

}
variable "administrator_login_password" {
  type    = string
  default = "Od@at#$7"
}

variable "covid_data_factory_pipeline" {
  type    = string
  default = "covid_data_factory_pipeline"
}
variable "ls_ablob_covidreportingsa" {
  type    = string
  default = "ls_ablob_covidreportingsa"
}


variable "ls_adls_covidreportingdl" {
  type    = string
  default = "ls_adls_covidreportingdl"
}
variable "ds_population_raw_gz" {
  type    = string
  default = "ds_population_raw_gz"
}

variable "ds_population_raw_tsv" {
  type    = string
  default = "ds_population_raw_tsv"
}
