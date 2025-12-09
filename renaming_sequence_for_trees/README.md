[This script](https://github.com/stenglein-lab/stenglein_lab_scripts/blob/master/rename_genbank_seqs_using_metadata.py) renames sequences in a genbank formatted file using the sequences' metadata.

This is designed to create more useful sequence names for use in building phylogenetic trees. We use this for making trees of virus sequences, but in theory it could be used for non-virus sequences too. 
 
The extent to which this works for individual sequences depends on the availability of the particular metadata fields described below.  Not all sequences contain these fields.

The new name will consist of:

[optional_prefix]_[country_if_present]_[host_if_present]_[year_if_present]_accession

Metadata is parsed from:
- year: from the collection_data field 
- country: from the country field (preferred) or the geo_loc_name field
- host: from the host field 

These metadata fields are part of the source feature in genbank records.  

This script depends on Biopython packages, which can be made available [via a conda environment](https://anaconda.org/channels/conda-forge/packages/biopython/overview).

#### Usage examples:

create a bioconda environment:
```
conda create -n biopython conda-forge::biopython
```

Rename some sequences:
```
./rename_genbank_sequences_using_metadata.py -y -c -o my_sequences.gb > my_sequences.renamed.gb
```
