#ssh into dsmlp server using 2-step login
ssh sddelato@dsmlp-login.ucsd.edu

#launch container w/ genetic software
launch-scipy-ml.sh -i ucsdets/dsc180a-genetics "latest"

#plink2 command on chr22 to filter/recode-if filtered enough, no removing of outliers needed
plink2 \
  --vcf  /datasets/dsc180a-wi20-public/Genome/vcf/ALL.chr22.shapeit2_integrated_v1a.GRCh38.20181129.phased.vcf.gz \
  --make-bed \
  --snps-only \
  --maf 0.3 \
  --geno 0.3 \
  --mind 0.3 \
  --recode vcf \
  --out chr22

#plink2 command on chr21 to filter/recode-if filtered enough, no removing of outliers needed
plink2 \
  --vcf  /datasets/dsc180a-wi20-public/Genome/vcf/ALL.chr21.shapeit2_integrated_v1a.GRCh38.20181129.phased.vcf.gz \
  --make-bed \
  --snps-only \
  --maf 0.3 \
  --geno 0.3 \
  --mind 0.3 \
  --recode vcf \
  --out chr21

#plink2 command on chr20 to filter/recode-if filtered enough, no removing of outliers needed
plink2 \
  --vcf  /datasets/dsc180a-wi20-public/Genome/vcf/ALL.chr20.shapeit2_integrated_v1a.GRCh38.20181129.phased.vcf.gz \
  --make-bed \
  --snps-only \
  --maf 0.3 \
  --geno 0.3 \
  --mind 0.3 \
  --recode vcf \
  --out chr20

#bgzip vcfs before merging them
bgzip -c chr20.vcf > chr20.vcf.gz
bgzip -c chr21.vcf > chr21.vcf.gz
bgzip -c chr22.vcf > chr22.vcf.gz

#bcftools command to merge .gz files after filtered/recoded
bcftools index chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz --tbi
bcftools concat chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz  --output-type z --output mergedchromosomes.vcf

#plink2 command to add bfiles to mergedchromosomes.vcf so can run PCA
plink2 \
  --vcf  mergedchromosomes.vcf \
  --make-bed \
  --out mergedchromosomes

#plink2 command to run PCA
plink2 \
    --bfile mergedchromosomes \
    --pca  10 \
    --out mergedchromosomesPCA

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
