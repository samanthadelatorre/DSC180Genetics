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
