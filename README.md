# nanopore-HMM

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13911924.svg)](https://doi.org/10.5281/zenodo.13911924)

_MATLAB code for Hidden Markov Model (HMM) inference from nanopore ionic current recordings of the enzyme adenylate kinase (AdK), as analyzed in [1] ([Nature Communications, 2024](https://doi.org/10.1038/s41467-024-54421-9))._

&nbsp;

## Requirements

- MATLAB R2019b or later
- Optimization Toolbox (`fmincon`)
- Econometrics Toolbox (`dtmc`, `asymptotics`, `simulate`)
- Statistics and Machine Learning Toolbox (`normpdf`, `normrnd`)
- Parallel Computing Toolbox (optional; the multistart loops use `parfor` and run serially without it)

&nbsp;

## Reproducing the results

| Script | Model | What it does |
| --- | --- | --- |
| `ADP/estimate.m` | ADP model (`ADP/Qmat.m`) | Loads the ADP recordings, selects one segment per ADP concentration (seeded), fits the HMM (6 multistarts), plots the optimized parameters and simulated data, and predicts LID closing/opening rates (`closing_opening.m`) |
| `ATP_AMP/estimate.m` | ATP/AMP model (`ATP_AMP/Qmat.m`) | As above for the ATP and ATP+AMP recordings; additionally computes state change distributions (`emitted_transitions.m`) |

Run each script in MATLAB (it changes the current folder to its own folder, as data paths are relative). Random seeds are fixed (`rng('default')`), but parallel multistarts and MATLAB versions may cause small numerical differences.

The ATP/AMP model topology is selected with the variable `Q_variant` at the top of `ATP_AMP/estimate.m` (see `ATP_AMP/Qmat.m`):
- `"candidate"` (default): candidate configuration (same topology as the ADP model), used for the main results in [1];
- `"equal_rates"`: alternative with equal rates Ma ↔ M2a and M2aa ↔ Maa;
- `"additional_transition"`: alternative with an additional transition Ma → Maa.

> **Version note:** in the archived v1.0.0 release ([Zenodo](https://doi.org/10.5281/zenodo.13911924)), the model variant is selected by uncommenting it in `ATP_AMP/Qmat.m`, with the `"additional_transition"` alternative active by default; to reproduce the main results in [1] with that release, select the candidate configuration instead. The `"additional_transition"` alternative in v1.0.0 also contains an outdated transition (M → Maa instead of Ma → Maa), which is corrected here.

&nbsp;

## Files

**Scripts and functions** (identical structure in `ADP/` and `ATP_AMP/`):

- `estimate.m` – main script (see above)
- `load_process.m` – reads the recordings and extracts the manually selected usable segments
- `mu_segments.m` – approximate current levels per recording, used to initialize and bound the emission means
- `fit.m` – multistarted maximum likelihood estimation with `fmincon`
- `likelihood.m` – HMM log-likelihood (forward algorithm)
- `Qmat.m` – transition rate (generator) matrix of the HMM
- `simulate.m`, `closing_opening.m`, `emitted_transitions.m` – simulation and derived quantities from the fitted model
- `showQ.m` – visualization of a rate matrix
- `ATP_AMP/load_single.m` – plots a single raw recording

**Data** (`ADP/ADP/`, `ATP_AMP/ATP/`, `ATP_AMP/AMP/`): CSV exports of the current recordings, named by ligand concentration and replicate (e.g. `1000uMATP+50uMAMP_2.csv`). The first row contains sweep start times (s), the second row column headers; the first column is time within a sweep (sampling interval 20 µs), and each further column contains one sweep of current values (pA). Original Axon `.abf` files are included where available. `ADP/ADP/50uMADP_3_typeII.csv` is not used in the analysis.

`ADP/model.jpg` is a whiteboard sketch of an early version of the model (its notation differs from the code).

&nbsp;

## Technical details

The HMM is determined by transition rates $\mathbf k$ and emission distribution parameter vectors $\boldsymbol\mu, \boldsymbol\sigma$. The likelihood $L(\mathbf k, \boldsymbol\mu, \boldsymbol\sigma; \mathbf y)$ given a time series $\mathbf y$ is computed as in [2, Section 2.5]; see _Materials and Methods_ in [1] for the details specific to this research. For computational efficiency, equation (2.24) is evaluated with rescaling to prevent under- or overflow every five time points.

During optimization, all transition rates are initially bounded between 1E-1 and 1E6 (optimization is carried out on a log10 scale). Exceptions are only implemented to prevent optimization routines ending up at clearly infeasible model configurations in light of the experimental data.

&nbsp;

## References

[1] Galenkamp, Nicole S., Zernia, Sarah, van Oppen, Yulan B., van den Noort, Marco, Milias-Argeitis, Andreas & Maglia, Giovanni (2024). Allostery can convert binding free energies into concerted domain motions in enzymes. _Nature Communications_, 15, 10109. https://doi.org/10.1038/s41467-024-54421-9

[2] MacDonald, Iain L., & Zucchini, Walter (1997). _Hidden Markov and other models for discrete-valued time series_. Vol. 110. CRC Press.

&nbsp;

## License

[MIT](LICENSE). If you use this code, please cite [1]:

```bibtex
@article{galenkamp2024allostery,
  title     = {Allostery can convert binding free energies into concerted domain motions in enzymes},
  author    = {Galenkamp, Nicole St{\'e}phanie and Zernia, Sarah and van Oppen, Yulan B and van den Noort, Marco and Milias-Argeitis, Andreas and Maglia, Giovanni},
  journal   = {Nature Communications},
  volume    = {15},
  number    = {1},
  pages     = {10109},
  year      = {2024},
  doi       = {10.1038/s41467-024-54421-9}
}
```

To refer to the software itself, cite the Zenodo archive (https://doi.org/10.5281/zenodo.13911924; see [CITATION.cff](CITATION.cff)).
