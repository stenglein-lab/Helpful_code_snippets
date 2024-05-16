This snippet illustrates something in nextflow that was initially confusing to me: the difference between value channels and queue channels.   Queue channels contain a set of values that get used up as they get passed to downstream processes or operators.  In the language of the [nextflow documentation](https://www.nextflow.io/docs/latest/channel.html), a queue channel is a "non-blocking unidirectional FIFO queue".  Value channels contain one or more values and can "be consumed any number of times by a process or an operator".

I've run into this confusion when in the following example scenario:

- I have a set of input files (e.g. fastq files) that I want to process
- I have some other input file (e.g. a fasta file containing a reference sequence) that I want to process *with each* fastq file.

A natural way to create channels to these paths is by using the Channel.fromPath() or Channel.fromFilePairs() operators.  Both of these operators return queue chanennels.

If your refseq fasta file is in a queue channel, it will get used up the first time it is passed to a process.  So a downstream process will be run once - for the first fastq input file. 
 
On the other hand, if your refseq fasta file is in a *value* channel, it will get repeated as many times as necessary as input to processes.  This is a subtle but important difference.
 
To turn a queue channel into a value channel, you need to use an operator that returns a value channel, like collect().
 
This directory contains a simple example nextflow script that illustrates this issue.
