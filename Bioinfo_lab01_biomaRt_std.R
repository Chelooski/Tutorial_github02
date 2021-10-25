# https://bioconductor.org/packages/release/bioc/html/biomaRt.html
# this step is not necessary if the package is already installed
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("biomaRt")
# BioMart is an easy-to-use web-based tool that allows extraction of data without
# any programming knowledge or understanding of the underlying database structure

# Step1: Identifying the database you need
# Our first step is to find the names of the BioMart services Ensembl is
# currently providing. 
# We can do this using the function listEnsembl(), which will display
# all available Ensembl BioMart web services.
library(biomaRt)
listEnsembl()
##         biomart                version
## 1         genes      Ensembl Genes 104
## 2 mouse_strains      Mouse strains 104
## 3          snps  Ensembl Variation 104
## 4    regulation Ensembl Regulation 104

# useEnsembl() can be used to connect to the desired BioMart database
# useEnsembl(biomart = ARGUMENT)
# The biomart argument should be given a valid name from the output of listEnsembl()
# We will use "genes", the main Ensembl mart
ensembl <- useEnsembl(biomart = "genes")
# let's see what happens
ensembl

## Object of class 'Mart':
##   Using the ENSEMBL_MART_ENSEMBL BioMart database
##   No dataset selected.

# so, the ENSEMBL_MART_ENSEMBL database has been selected, 
# but no dataset has been chosen... we need to do that
# BioMart databases can contain several datasets
# For example, within the Ensembl genes mart every species is a different dataset
datasets <- listDatasets(ensembl)
head(datasets)
str(datasets)

##                        dataset                           description     version
## 1 abrachyrhynchus_gene_ensembl Pink-footed goose genes (ASM259213v1) ASM259213v1
## 2     acalliptera_gene_ensembl      Eastern happy genes (fAstCal1.2)  fAstCal1.2

# as a table
library(pander)
pander(head(datasets))

# The listDatasets() function will return every available option,
# however this can be too much and difficult to access

# the functions searchDatasets() can be used to try
# to find any entries matching a specific term or pattern
searchDatasets(mart = ensembl, pattern = "hsapiens")
##                  dataset              description    version
## 80 hsapiens_gene_ensembl Human genes (GRCh38.p13) GRCh38.p13

# To use a dataset we can update our Mart object using the function
# useDataset(). In the example below we choose to use the hsapiens dataset.
ensembl <- useDataset(dataset = "hsapiens_gene_ensembl", mart = ensembl)

# Finally, all could have been done in one step if
# both the database and dataset were known from the beggining
ensembl2 <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")

# Using Ensembl Genomes
# we can list the available Ensembl Genomes marts using
listEnsemblGenomes()
# We can the select the Ensembl Plants database, and search for the dataset name for Zea mays.
ensembl_plants <- useEnsemblGenomes(biomart = "plants_mart")
searchDatasets(ensembl_plants, pattern = "Prunus")# Prunus persica
# dataset                                  description               version
# 68   pavium_eg_gene                Prunus avium genes (PAV_r1.0)              PAV_r1.0
# 69  pdulcis_eg_gene               Prunus dulcis genes (ALMONDv2)              ALMONDv2
# 73 ppersica_eg_gene Prunus persica genes (Prunus_persica_NCBIv2) Prunus_persica_NCBIv2
# We can then use this information to create our Mart object that will access the correct database and dataset.
ensembl_Ppersica <- useEnsemblGenomes(biomart = "plants_mart", dataset = "ppersica_eg_gene")

# Building a biomaRt query
# Once we’ve selected a dataset to get data from, we need to create a query
# and send it to the Ensembl BioMart server

# We do this using the getBM() function, which has 3 mandatory arguments:
# filters, values (to define restrictions on the query) and attributes
filters = listFilters(ensembl) # shows you all available filters in the selected dataset
filters[1:5,]
# Attributes define the data we are interested in retrieving (=output)
attributes = listAttributes(ensembl)
attributes[1:6,]
# A forth argument is mart (an object of class Mart)

# let's build a biomaRt query
# We have a list of Affymetrix identifiers from the u133plus2 platform and
# we want to retrieve the corresponding EntrezGene identifiers using the Ensembl mappings.
# The u133plus2 platform will be the filter for this query and as values for this filter
# we use our list of Affymetrix identifiers. 
# As output (attributes) for the query we want to retrieve the EntrezGene and
# u133plus2 identifiers so we get a mapping of these two identifiers as a result.
  
affyids <- c("202763_at","209310_s_at","207500_at")
getBM(attributes = c('affy_hg_u133_plus_2', 'entrezgene_id'),
      filters = 'affy_hg_u133_plus_2',
      values = affyids, 
      mart = ensembl)

####EJERCICIO 6####
# 6A
# Indique el nombre y versión de la base de datos de ensembl asociada al león

# 6B
# Indique cuantas especies del género Saccharomyces tienen una base de datos presente en ensembl

# 6C
# Para el mismo dataset de la plataforma de afimetrix u133plus2, despliegue los
# nombres de las proteínas asociadas a esos genes, con anotación de péptidos de refseq
# Pista, use la función searchAttributes()
