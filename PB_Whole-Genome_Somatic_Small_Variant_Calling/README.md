# **run [HOW-TO](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html) for Whole-Genome Somatic Small Variant Calling on HiperGator**

- This repo hosts scripts for running the [HOW-TO](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html) on HiperGator.

- Download data according to the [HOW-TO](https://docs.nvidia.com/clara/parabricks/latest/how-tos/somaticcalling.html). 
    - You can download sample FASTQs directly instead of SRAs and converting to FASTQs. The EU provides direct downloads for some SRAs: https://www.ebi.ac.uk/ena/browser/view/SRR7890827, https://www.ebi.ac.uk/ena/browser/view/SRR7890824. Click on "Download All" to get the `wget` commands.

- In the `pbrun fq2bam` command, change `--knownSites /workdir/GCF_000001405.39.gz` to `--knownSites /workdir/GCF_000001405.39.vcf.gz`. You can use the command:
    ```
    mv GCF_000001405.39.gz GCF_000001405.39.vcf.gz
    ```

- The [UpSetplot](Rplots.pdf) I got here is slightly different from the one in the HOW-TO, because the plot in the HOW-TO is based on a previous version of both Parabricks and GATK.

# **How to run**
Submit a job
```
sbatch xyz.sh
```

Check the SLURM output
```
cat xyz_jobID.out
```
