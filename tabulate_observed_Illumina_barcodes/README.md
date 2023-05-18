The [what_bc](./what_bc) script tabulates observed barcodes in an Illumina fastq file.  This can be useful to determine if there are sample sheet issues by tabulating the index sequences that appear in the Undetermined fastq file produced by [bcl2fastq](https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html).

For example:
```
$ zcat Undetermined_S0_R1_001.fastq.gz | head -1000000 | ./what_bc | head -20
GGGGGGGG+AGATCTCG	48566
GGGGGGGG+CTTCCTTC	4705
GGGGGGGG+ATCATGCG	3018
GGGGGGGG+TTGCAACG	2383
GGGGGGGG+TCGATGAC	2190
GGGGGGGG+GAACGGTT	2185
GGGGGGGG+GCTACTCT	2014
GGGGGGGG+ACTCCTAC	1725
GGGGGGGG+GAAGTGCT	1709
ATGACGTC+GGGGGGGG	1700
ATGACGTC+GAAGTGCT	1631
GGGGGGGG+GTCAACAG	1609
GGGGGGGG+AGTCGAAG	1598
GGGGGGGG+CCACATTG	1561
GGGGGGGG+CAGTGCTT	1557
GGGGGGGG+AGATTGCG	1477
ATGACGTC+CTTCTTCG	1424
TACGCTAC+AGTCGAAG	1414
GGGGGGGG+TGAGCTGT	1403
CGCTCTAT+GGGGGGGG	1399
```
