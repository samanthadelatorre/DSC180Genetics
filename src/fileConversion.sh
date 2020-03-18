#bwa command to create index using fasta file
bwa index hg38/Homo_sapiens_assembly38.fasta

#samtools command to create fasta file index
samtools faidx hg38/Homo_sapiens_assembly38.fasta

#gatk command to generate fasta sequence dictionary file
gatk CreateSequenceDictionary -R hg38/Homo_sapiens_assembly38.fasta

#bwa command to map reads to reference genome
bwa mem -M -t 1 -R '@RG\tID:group1\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1' -p hg38/Homo_sapiens_assembly38.fasta /datasets/dsc180a-wi20-public/Genome/fastq/testfile/SP1.fq > aligned_reads.sam

#samtools command to convert sam to bam, sort, and index bam (results in .bai file)
samtools view -S -b aligned_reads.sam > aligned_reads.bam
samtools sort aligned_reads.bam -o aligned_reads.sorted.bam
samtools index aligned_reads.sorted.bam

#samtools command to take care of deduplication, sort and index bam
samtools markdup aligned_reads.sorted.bam aligned_reads.dedup.bam
samtools sort aligned_reads.dedup.bam -o aligned_reads.dedup.sorted.bam
samtools index aligned_reads.dedup.sorted.bam

#gatk command to convert bam file to vcf file
gatk HaplotypeCaller \
-R hg38/Homo_sapiens_assembly38.fasta \
-I aligned_reads.dedup.sorted.bam \
-O aligned_reads.raw.vcf
