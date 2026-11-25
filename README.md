<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Corrects B1 bias field in a DWI with MRtrix3 dwibiascorrect using ANTs N4 or FSL FAST, and outputs the debiased DWI.**

Converts the DWI to MRtrix format, uses the given brain mask or computes one with dwi2mask, runs dwibiascorrect with the chosen algorithm and writes the debiased DWI with its bvals and bvecs. Use it as a preprocessing step when intensity inhomogeneity affects the DWI. Needs a DWI with bvals and bvecs; a brain mask is optional.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `mask` | `neuro/mask` (brain, dwi) | no | Optional DWI brain mask; computed with dwi2mask if not given. |

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | The debiased DWI |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | enum | `ants` | The debiasing algorithm to use Options: `fsl`, `ants`. |
| `antsb` | string | `[150,3]` | ANTs N4 -b option (B-spline fitting) passed to dwibiascorrect as -ants.b. |
| `antsc` | string | `[200x200,1e-6]` | ANTs N4 -c option (convergence) passed as -ants.c. |
| `antss` | string | `2` | ANTs N4 -s option (shrink factor) passed as -ants.s. |

Runtime: container `brainlife/mrtrix3:3.0_RC3`; 1 CPUs; 0.5 h walltime.

Please cite:
- Tustison N. et al. N4ITK: Improved N3 Bias Correction. IEEE Trans Med Imaging 29, 1310-1320 (2010).
- Zhang Y., Brady M., Smith S. Segmentation of brain MR images through a hidden Markov random field model and the expectation-maximization algorithm. IEEE Trans Med Imaging 20, 45-57 (2001).

<!-- brainlife-app:end -->

# app-dwi-debias