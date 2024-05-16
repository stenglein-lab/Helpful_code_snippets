/*
  
  This example nextflow script demonstrates the different behavior of a value channel and a queue channel

  Some nextflow operators, like Channel.fromPath() create a queue channel, which may behave differently than you
  would expect.  For instance, say you have a single reference sequence fasta file and multiple fastq file inputs.
  And you want to do something with the fastq files and the refseq fasta where you use the same refseq file for
  each fastq.  

  You need the refseq fasta to act as a value channel and not a queue channel.  If the refseq fasta
  is provided as a queue channel, it will be consumed the first time it is fed to a process.  On the
  other hand, if it is a value channel, it will be repeatedly passed to as many processes as necessary. 

  For more information, see:

  https://www.nextflow.io/docs/latest/channel.html

  and

  https://stackoverflow.com/questions/70790676/how-to-output-a-value-channel-that-has-paths-using-nextflow

 
 */

// This process does something involving a refseq and a fastq
process process_fastq_A {

 input:
    path refseq
    path fastq

 output:
    path "*.txt"

 script:
 """
    echo "$refseq $fastq" > ${fastq}.${refseq}.txt
 """
 }

// This process does something involving a refseq and a fastq
process process_fastq_B {

 input:
    path refseq
    path fastq

 output:
    path "*.txt"

 script:
 """
    echo "$refseq $fastq" > ${fastq}.${refseq}.txt
 """
}

// we want to process all the fastq files
// passing each fastq plus the same refseq to the downstream process

workflow process_all_fastq {

    fastq_ch        = channel.fromPath("fastq/*.fastq")

    // demonstrate the difference between a value channel and a queue channel
    refseq_queue_ch = channel.fromPath("refseq.fasta")

    // use the collect() operator to turn the queue channel into a value channel
    refseq_value_ch = channel.fromPath("refseq.fasta").collect()

    // run a process with queue channel as input: will only run once
    process_fastq_A(refseq_queue_ch, fastq_ch)

    // run a process with value channel as input: will run once per fastq
    process_fastq_B(refseq_value_ch, fastq_ch)

}


// main entry point: unnamed workflow
workflow {
   process_all_fastq()
}
