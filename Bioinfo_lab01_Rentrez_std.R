# https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html
# https://github.com/ropensci/rentrez
# fIRST, Install and call the library IF NECESSARY
install.packages("devtools")
library(devtools)
install_github("ropensci/rentrez")

# call rentrez
library(rentrez)
#Print all the databases to which Rentrez has access to
databases<-entrez_dbs()
head(databases, n=10L)
print(databases)

# We have 43, which we can also see with
str(databases)
## chr [1:43] "pubmed" "protein" "nuccore" "ipg" "nucleotide" ...

# There is a set of f() with names starting entrez_db_ that can be used 
# to gather more information about each of these databases

# entrez_db_summary() ->	Brief description of what the database is
# entrez_db_searchable() ->	Set of search terms that can used with this database
# entrez_db_links() ->	Set of databases that might contain linked records

# For instance, we can get a description of the database 'cdd'...
entrez_db_summary("cdd")

## DbName: cdd
## MenuName: Conserved Domains
## Description: Conserved Domain Database
## DbBuild: Build210427-1442.1
## Count: 62852
## LastUpdate: 2021/04/27 19:44

# depict as table using the pander library
# https://mran.microsoft.com/snapshot/2014-10-22/web/packages/pander/README.html
# install.packages('pander')
entrez_cdd <- entrez_db_summary("cdd")
library(pander)
pander(entrez_cdd)

# The set of search terms available varies between databases. You can get a list 
# of available terms or any given data base with entrez_db_searchable()
entrez_db_searchable("sra")

## Searchable fields for database 'sra'
##   ALL     All terms from all searchable fields 
##   UID     Unique number assigned to publication 
##   FILT    Limits the records 
##   ACCN    Accession number of sequence 
##   TITL    Words in definition line 
##   PROP    Classification by source qualifiers and molecule type
##   WORD 	 Free text associated with record 
##   ORGN 	 Scientific and common names of organism, and all higher levels of taxonomy 

# You can search a database against a specific term using the format
# query[SEARCH FIELD], and combine multiple such searches using the
# boolean operators AND, OR and NOT.
stress_PPers <- entrez_search(db="sra", term="(Prunus persica[ORGN] AND stress[TITL]")
stress_PPers$ids

## Entrez search result with 3971 hits (object contains 0 IDs and no web_history object)
## Search term (as translated):  "Prunus persica"[Organism] AND 2015[PDAT] : 2021[P ...
#### ver diapo ####

# rentrez allows searching a given NCBI database to find records that match 
# some keywords. You can do this using the function entrez_search()
r_search <- entrez_search(db="pubmed", term="R Language")
r_search

## Entrez search result with 15158 hits (object contains 20 IDs and no web_history object)
## Search term (as translated):  R[All Fields] AND ("programming languages"[MeSH Te ...
# Let's check some ID's

r_search$ids # Why only 20 terms from the 15154 are shown?

# The optional argument retmax controls the maximum number of returned values has a default value of 20
r_search <- entrez_search(db="pubmed", term="R Language", retmax = 25)
r_search$ids # We have now 25 terms from the 15154
#### ver diapo ####

# We can use these ids in calls and entrez_search / entrez_fetch to get fasta files 
entrez_db_summary("nuccore")
pang_cov_ids <- entrez_search(db="nuccore", term="Pangolin coronavirus")
pang_cov_seqs <- entrez_fetch(db="nuccore", id = pang_cov_ids$ids, rettype = "fasta_cds_na")
write.table(pang_cov_seqs, "Pangolin_coronavirus_seqs_dna.txt") # export fasta files

####EJERCICIO 1####
#Imprimir todos los terminos de buqueda de la base de datos "genome".

####EJERCICIO 2####
#Imprimir ids de secuencias nucleotidicas de la base de datos nucleotide para Arabidopsis thaliana cultivar columbia

####EJERCICIO 3####
#Indicar el nombre de las enzimas, presentes en la base de datos "protein", que tengan el número ([ECNO]) EC 1.1.1.1 

####EJERCICIO 4####
#Identifique cuantos genomas del genero Lactobacillus se encuentran disponibles en la base de datos genome 

####EJERCICIO 5####
#Entregue, en un archivo fasta, las secuencias de genes asociadas a la enzima "catalase", del organismo Arabidopsis thaliana
# Revise, manualmente, que el archivo fasta este bien configurado antes de entregarlo.
