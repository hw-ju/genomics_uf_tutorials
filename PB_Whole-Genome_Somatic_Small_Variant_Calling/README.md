# **Run [How-To](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html) for Whole-Genome Somatic Small Variant Calling on HiperGator**

## **Notes and scripts for each corresponding section in the original [How-To](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html).**

- ### **Download Example FASTQ Files**
    - Option 1: follow the command snippet in How-To's [Download Example FASTQ Files](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html#download-example-fastq-files), i.e., first download the SRAs, then convert them to FASTQs. Note, the `fastq-dump` command is obsolete, I recommend you to use `fasterq-dump` for faster conversion, see scripts [`convert.sh`](convert.sh) and [`convert_2.sh`](convert_2.sh); then compress FASTQs using `gzip FASTQ_file`.
    - Option 2: You can download sample compressed FASTQs directly instead of SRAs and converting to FASTQs. The EU provides direct downloads for some SRAs: https://www.ebi.ac.uk/ena/browser/view/SRR7890827, https://www.ebi.ac.uk/ena/browser/view/SRR7890824. Click on "Download All" to get the `wget` commands.
    - HiperGator documentation for [downloading/transferring data](https://help.rc.ufl.edu/doc/Transfer_Data).

- ### **Step1: Aligning the Fastq Files to the Reference Genome**
    - In the `pbrun fq2bam` command, change `--knownSites /workdir/GCF_000001405.39.gz` to `--knownSites /workdir/GCF_000001405.39.vcf.gz`. You can use the command:
        ```
        mv GCF_000001405.39.gz GCF_000001405.39.vcf.gz
        ```
    - Use scripts [`fq2bam.sh`](fq2bam.sh) and [`fq2bam_sample2.sh`](fq2bam_sample2.sh).

- ### **Step2: Generating a Set of Small Variant Calls Using Parabricks Mutect2**
    - To use Mutect2 as in How-To, see scripts [`mutect2.sh`](mutect2.sh).
    - To use DeepSomatic, see scripts [`deepsomatic.sh`](deepsomatic.sh)

- ### **Step3: For Validating the SNV and MNV Variants with truth set**
    - Note the `java -jar gatk-4.2.0.0/gatk-package-4.2.0.0-local.jar` gatk command is obsolete, use script [`extract_non-indel.sh`](extract_non-indel.sh).

- ### **Use GATK4 FilterMutectCalls to Apply Filters to the Raw Output of Mutect2**
    - Use script [`apply_filter.sh`](apply_filter.sh) for the gatk command and [`intersect.sh`](intersect.sh) for the bedtools command.

    - The [UpSetplot](Rplots.pdf) I got here is slightly different from the one in the HOW-TO, because the plot in the HOW-TO is based on a previous version of both Parabricks and GATK.

    - You can submit a support ticket for HiperGator to have a specific R environment with all the packages you want built for you.


# **How to run scripts and check results**
Submit a job
```
sbatch xyz.sh
```

Check the output
```
cat xyz_jobID.out
```
