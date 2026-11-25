<h1 align="center">DWI Debias</h1>

<p align="center">
  A bias-field-corrected diffusion-weighted image from a raw DWI, with MRtrix3 <code>dwibiascorrect</code> using ANTs N4 or FSL FAST.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.557"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.557-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `v1.1`, is the brainlife.io App DWI Debias** ([doi:10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Corrects B1 bias field in a DWI with MRtrix3 dwibiascorrect using ANTs N4 or FSL FAST, and outputs the debiased DWI.**

Converts the DWI to MRtrix format, uses the given brain mask or computes one with dwi2mask, runs dwibiascorrect with the chosen algorithm and writes the debiased DWI with its bvals and bvecs. Use it as a preprocessing step when intensity inhomogeneity affects the DWI. Needs a DWI with bvals and bvecs; a brain mask is optional.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` · `neuro/mask` (optional) |
| 📤 **Outputs** | `neuro/dwi` |
| 🐳 **Container** | `brainlife/mrtrix3:3.0_RC3` |
| ⚙️ **Resources** | 1 CPUs · 0.5 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `mask` | `neuro/mask` (brain, dwi) | no | Optional DWI brain mask; computed with dwi2mask if not given. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | The debiased DWI |

<details>
<summary><b>⚙️ Parameters</b> (4)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | enum | `ants` | The debiasing algorithm to use Options: `fsl`, `ants`. |
| `antsb` | string | `[150,3]` | ANTs N4 -b option (B-spline fitting) passed to dwibiascorrect as -ants.b. |
| `antsc` | string | `[200x200,1e-6]` | ANTs N4 -c option (convergence) passed as -ants.c. |
| `antss` | string | `2` | ANTs N4 -s option (shrink factor) passed as -ants.s. |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

Each version is a separate App on brainlife.io, built from its own branch of this repository.

| Version | MRtrix3 | Branch | Run it | Status |
|---|---|---|---|---|
| **DWI Debias** (this branch) | 3.0_RC3 | [`v1.1`](https://github.com/brainlife/app-dwi-debias/tree/v1.1) | [doi:10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557) | current |
| DWI Debias - Deprecated | 3.0_RC3 | [`v1.0.0`](https://github.com/brainlife/app-dwi-debias/tree/v1.0.0) | [doi:10.25663/brainlife.app.234](https://doi.org/10.25663/brainlife.app.234) | deprecated |

The current version adds an optional brain mask input and exposes the ANTs N4 options.

## 🔬 How it works

1. The DWI and its bvals/bvecs are converted to MRtrix format.
2. If no brain mask is given, one is computed with `dwi2mask`.
3. `dwibiascorrect` estimates and removes the B1 bias field inside the mask, with ANTs N4 (`type: ants`, the default) or FSL FAST (`type: fsl`). The ANTs B-spline fitting (`antsb`), convergence (`antsc`) and shrink factor (`antss`) options are passed through as `-ants.b`, `-ants.c` and `-ants.s`.
4. The corrected image is written back to NIfTI with its gradient table.

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557), choose a `neuro/dwi` dataset (and optionally a DWI brain mask) from your project, pick the algorithm and press **Execute**. The debiased DWI is archived to your project as a `neuro/dwi` dataset tagged `debiased`.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). `main` runs `run.sh` inside the `brainlife/mrtrix3:3.0_RC3` container, which provides MRtrix3, ANTs and FSL.

1. Clone this repository and check out the App's branch: `git checkout v1.1`.
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "dwi": "/input/dwi/dwi.nii.gz",
       "bvals": "/input/dwi/dwi.bvals",
       "bvecs": "/input/dwi/dwi.bvecs",
       "mask": "/input/mask/mask.nii.gz",
       "type": "ants",
       "antsb": "[150,3]",
       "antsc": "[200x200,1e-6]",
       "antss": "2"
   }
   ```

   Leave out `mask` (or point it to a file that does not exist) to compute the mask with `dwi2mask`.

3. Run the App:

   ```bash
   ./main
   ```

### 🧪 Sample data

Download a DWI from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download <dataset id>
```

## 📦 Outputs

```text
dwi/
├── dwi.nii.gz   the debiased DWI
├── *.bvals      b-values, copied from the input
└── *.bvecs      gradient directions, copied from the input
```

## 🩺 Troubleshooting

- **`output missing`**: the debiased DWI was not written. Check the `dwibiascorrect` error in the log.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Tustison N, Avants B, Cook P, Zheng Y, Egan A, Yushkevich P, Gee J. N4ITK: improved N3 bias correction. *IEEE Transactions on Medical Imaging* 29:1310–1320 (2010). (`type: ants`)
- Zhang Y, Brady M, Smith S. Segmentation of brain MR images through a hidden Markov random field model and the expectation-maximization algorithm. *IEEE Transactions on Medical Imaging* 20:45–57 (2001). (`type: fsl`)
- Smith SM, Jenkinson M, Woolrich MW, Beckmann CF, Behrens TEJ, Johansen-Berg H, Bannister PR, De Luca M, Drobnjak I, Flitney DE, Niazy RK, Saunders J, Vickers J, Zhang Y, De Stefano N, Brady JM, Matthews PM. Advances in functional and structural MR image analysis and implementation as FSL. *NeuroImage* 23:S208–S219 (2004).
- DWI Debias. brainlife.io App. [doi:10.25663/brainlife.app.557](https://doi.org/10.25663/brainlife.app.557)
- Tustison N. et al. N4ITK: Improved N3 Bias Correction. IEEE Trans Med Imaging 29, 1310-1320 (2010).
- Zhang Y., Brady M., Smith S. Segmentation of brain MR images through a hidden Markov random field model and the expectation-maximization algorithm. IEEE Trans Med Imaging 20, 45-57 (2001).
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Avants et al. A reproducible evaluation of ANTs similarity metric performance in brain image registration. *NeuroImage* 54:2033-2044 (2011). [doi:10.1016/j.neuroimage.2010.09.025](https://doi.org/10.1016/j.neuroimage.2010.09.025)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](https://github.com/brainlife/app-dwi-debias/blob/v1.1/LICENSE). MRtrix3, ANTs and FSL are distributed under their own licenses.
