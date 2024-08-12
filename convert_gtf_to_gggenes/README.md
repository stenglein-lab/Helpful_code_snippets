This directory contains a perl script to convert a [gtf format file](https://useast.ensembl.org/info/website/upload/gff.html) into a tabular tab-delimited file with the columns needed by the [gggenes R package](https://wilkox.org/gggenes/index.html).

It only outputs information for gene annotations.

I tested this on the dmel-all-r6.58.gtf file for the D. melanogaster annotation from FlyBase: [FTP directory here](http://ftp.flybase.net/releases/current/dmel_r6.58/gtf/).

Example usage of the script on command-line:

```
chmod +x gtf_to_gggenes
./gtf_to_gggenes_table dmel-all-r6.58.gtf > dmel-all-r6.58.gggenes.txt
```

Example usage of resulting file in R:
```
library(tidyverse)
library(gggenes)

# import data
genes <- read.delim("dmel-all-r6.58.gggenes.txt", sep="\t", header=T)

# filter out genes from a window on chrom 2L
genes_subset <- filter(genes, molecule == "2L" & start > 3e6 & start < 3.02e6)

# plot genes in that window
ggplot(genes_subset, aes(xmin = start, xmax = end,  y = 0,
                         label=gene, fill = gene)) +
  geom_gene_arrow() +
  scale_fill_brewer(palette = "Set3") +
  geom_gene_label(align = "left") +
  theme_genes() +
  theme(legend.position = "none",
        axis.text.y = element_blank(),
        panel.grid.major.y = element_blank()) +
  ylab("") 
```
