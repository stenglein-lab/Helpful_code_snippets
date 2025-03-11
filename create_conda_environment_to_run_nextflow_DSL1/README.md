At the end of 2022, [nextflow](https://www.nextflow.io/) [switched](https://www.nextflow.io/docs/latest/dsl1.html) from its original DSL1 syntax to DSL2 syntax.  New versions of nextflow no longer run old DSL1 nextflow pipelines.  If you need to run an older DSL1 nextflow pipeline, you can create a conda environment containing nextflow version 22.10.6, using this command:

```
conda create -n nextflow_v22 bioconda::nextflow=22.10.6
```

Then, to activate this environment prior to running your nextflow pipeline, you'd run:
```
conda activate nextflow_v22
```

Confirm it worked:
```
nextflow -version
```

