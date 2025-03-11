This directory contains bash code to load a [kraken2](https://ccb.jhu.edu/software/kraken2/) [database](https://benlangmead.github.io/aws-indexes/k2) into shared memory.  This can greatly increase the speed with which kraken2 runs, by removing the need for each kraken2 process to load a database into it's own memory.  Instead, the database is already loaded, and all processes share the same memory database instance.  

This is described in additional detail in the [kraken2 manual](https://github.com/DerrickWood/kraken2/wiki/Manual#system-requirements). [See also here](https://github.com/DerrickWood/kraken2/issues/451)

Note that this requires a computing environment with sufficient memory (RAM) to hold the database.  

To allocate sufficient shared memory and copy the database into shared memory:

```{bash}
#!/bin/bash -x

# this script copies the kraken2 core_nt database to shared memory to allow
# kraken2 run much faster, epecially when processing multiple datasets.
#
# BEWARE: this dedicates a lot of memory (384Gb) to shared memory.  You must be on a 
#         computer with enough RAM to do this.
# 
# Smaller kraken2 databases wouldn't need this much memory
#
# MDS 3/11/2025

# make shared memory bigger for copying kraken2 core_nt database
sudo mount -o remount,size=384G /dev/shm

# copy db files needed by kraken2 and bracken to shared memory
# assumes you are in the directory where you have unpacked the 
# kraken2 db files
mkdir /dev/shm/core_nt
cp *k2d /dev/shm/core_nt/
cp *kmer_distrib /dev/shm/core_nt/
```

After copying the files into shared memory they will be available 
for use by a kraken2 command, for example:

```{bash}
kraken2 \
    --db /dev/shm/core_nt \
    --threads 12 \
    --report sample.kraken2.report.txt \
    --gzip-compressed \
    --output sample.kraken2.classifiedreads.txt \
    --paired \
    --memory-mapping \
    --use-names \
    sample_1.fastq.gz sample_2.fastq.gz
```

Note that `--db` points to `/dev/shm/` and that the `--memory-mapping` option is set.

