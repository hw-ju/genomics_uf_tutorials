#!/bin/sh
#SBATCH --output=array_job_%A_%a.out       
#SBATCH --error=array_job_%A_%a.err
#SBATCH --array=1-151                      
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --partition=gpu
#SBATCH --gpus=a100:4
#SBATCH --time=2:00:00

# bam pairs filename
file="bam_matched.txt"

# declare arrays for genomic, somatic pairs as tab-separated
declare -a column1
declare -a column2

# read the pairs columns file and populate the arrays
while IFS=$'\t' read -r col1 col2; do
    # don't read in empty lines
    if [ -z "$col1" ] || [ -z "$col2" ]; then
        continue
    fi
    column1+=("$col1")
    column2+=("$col2")
done < "$file"

# function to get value from column 1 by index
get_from_col1() {
    local index=$1
    echo "${column1[$index]}"
}

# function to get value from column 2 by index
get_from_col2() {
    local index=$1
    echo "${column2[$index]}"
}

# get pair values
result_genom=$(get_from_col1 "$SLURM_ARRAY_TASK_ID")
result_somat=$(get_from_col2 "$SLURM_ARRAY_TASK_ID")

date;hostname;pwd

module load parabricks/4.3.1

# Set file paths
DATA_DIR="/blue/vendor-nvidia/hju/PB_training_Dungan"
INPUT_TUMOR_BAM="${DATA_DIR}/${result_somat}-WGS_FD_T.bam"
INPUT_NORMAL_BAM="${DATA_DIR}/${result_genom}-WGS_FD_N.bam"
INPUT_TUMOR_RECAL_FILE="${DATA_DIR}/${result_somat}-WGS_FD_T_BQSR_REPORT.txt"
INPUT_NORMAL_RECAL_FILE="${DATA_DIR}/${result_genom}-WGS_FD_N_BQSR_REPORT.txt"
REFERENCE="${DATA_DIR}/GRCh38.d1.vd1.fa"
OUT_VCF="${DATA_DIR}/${result_somat}-${result_genom}-WGS_FD_mutect2.vcf"
TUMOR_NAME="sm_${result_somat}"
NORMAL_NAME="sm_${result_genom}"
NUM_GPUS=4

# run mutect2 (BAM ==> VCF)
pbrun mutectcaller \
--ref ${REFERENCE} \
--in-tumor-bam ${INPUT_TUMOR_BAM} \
--in-normal-bam ${INPUT_NORMAL_BAM} \
--in-tumor-recal-file ${INPUT_TUMOR_RECAL_FILE} \
--in-normal-recal-file ${INPUT_NORMAL_RECAL_FILE} \
--out-vcf ${OUT_VCF} \
--tumor-name ${TUMOR_NAME} \
--normal-name ${NORMAL_NAME} \
--num-gpus ${NUM_GPUS}
