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
