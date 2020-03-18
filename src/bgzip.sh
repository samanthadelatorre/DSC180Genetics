#bgzip vcfs before merging them
bgzip -c chr20.vcf > chr20.vcf.gz
bgzip -c chr21.vcf > chr21.vcf.gz
bgzip -c chr22.vcf > chr22.vcf.gz
