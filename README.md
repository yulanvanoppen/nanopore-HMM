# nanopore-HMM
_MATLAB code package HMM inference, specifically tailored to nanopore ionic current flow data, as analyzed in [1]_

&nbsp;

## Quickstart
To reproduce the model inference results in [1], run `ADP/estimate.m` and `ATP_AMP/estimate.m` for the ADP and the ATP/AMP models, respectively, making sure to uncomment the Q-matrix of interest in `ATP_AMP/Qmat.m`.

Additionally, the predicted closing and opening rates of the LID domain for either model are estimated using `ADP/closing_opening.m` and `ATP_AMP/closing_opening`. 

&nbsp;


## Technical details
This software package contains the functions and scripts used to infer a Hidden Markov Model (HMM) from ionic current flow data of the enzyme adenylate kinase (AdK) [1].

The HMM is determined by transition rates $\mathbf k$ and emmission distribution parameter vectors $\boldsymbol\mu, \boldsymbol\sigma$. The likelihood $L(\mathbf k, \boldsymbol\mu, \boldsymbol\sigma; \mathbf y)$ given a time series $\mathbf y$ is computed as in [2, Section2.5]; see _Materials and Methods_ in [1] for the details specific to this research. For computational efficiency, equation (2.24) was evaluated by normalizing to prevent under or overflow every five time points.

During optimization, all transition rates are initially bound between 1E-1 and 1E6. Exceptions are only implemented to prevent optimization routines ending up at clearly infeasible model configurations in light of the experimental data.

&nbsp;


## References
[1] Galenkamp, Nicole S., Zernia, Sarah, van Oppen, Yulan B., Milias-Argeitis, Andreas & Maglia, Giovanni (2023). Endostery controls the hierarchical domain closure in adenylate kinase catalysis. _Manuscript in preparation_.

[2] MacDonald, Iain L., & Walter Zucchini (1997). _Hidden Markov and other models for discrete-valued time series_. Vol. 110. CRC Press.

&nbsp;


## DISCLAIMER
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
