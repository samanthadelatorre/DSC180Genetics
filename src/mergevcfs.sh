#bcftools command to merge .gz files after filtered/recoded
bcftools index chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz --tbi
bcftools concat chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz  --output-type z --output mergedchromosomes.vcf
