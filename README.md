# Adaptive Signal Processing and Machine Intelligence

This repository contains source code for coursework and experiments in adaptive signal processing and machine intelligence. The code covers classical spectral estimation, adaptive filtering, complex-valued adaptive signal processing, nonlinear adaptive prediction, and neural-network based classification.

Only source code is included. Coursework reports, submitted PDFs, Word documents, datasets, generated plots, and other non-code artifacts have been excluded from this public repository.

## Repository Structure

```text
.
|-- coursework/
|   |-- cw1/
|   |-- cw2/
|   |-- cw3/
|   |-- cw4/
|   `-- cw5/
|-- scripts/
|   `-- cnn_neural_network.py
`-- README.md
```

## Coursework Overview

| Folder | Topics | Main file types |
| --- | --- | --- |
| `coursework/cw1` | Periodograms, correlograms, AR modelling, Yule-Walker estimation, MUSIC, ECG/RRI processing, and supporting MATLAB functions. | MATLAB `.m`, MATLAB `.p` |
| `coursework/cw2` | LMS, leaky LMS, GASS/GNGD, ALE, ANC, and EEG-related adaptive filtering scripts. | MATLAB `.m` |
| `coursework/cw3` | CLMS, ACLMS, widely linear modelling, DFT-CLMS, and complex-valued signal processing experiments. | MATLAB `.m` |
| `coursework/cw4` | Nonlinear activation LMS, biased activation LMS, time-series prediction, and CNN data-generation/training scripts. | MATLAB `.m` |
| `coursework/cw5` | Notebook-based machine-intelligence tasks. | Jupyter `.ipynb` |
| `scripts` | Standalone Python CNN script. | Python `.py` |

## How to Run

### MATLAB Scripts

Open MATLAB from the repository root or from the relevant coursework folder. Add helper folders to the MATLAB path when needed.

Example:

```matlab
cd coursework/cw2/task2
addpath("function_task2")
Task2_2_a
```

Some scripts originally used external datasets such as EEG recordings, wind data, time-series data, or CNN training data. Those datasets are intentionally not included in this public code-only repository.

### Python Script

Use a Python environment with the deep-learning dependencies required by `scripts/cnn_neural_network.py`.

```bash
python scripts/cnn_neural_network.py
```

### Jupyter Notebooks

Open the notebooks in `coursework/cw5` with JupyterLab, VS Code, or another notebook environment.

```bash
jupyter lab coursework/cw5
```

## Notes

- Public reports and personal submission files are intentionally excluded.
- Generated figures and intermediate data files are intentionally excluded.
- Some scripts may require re-creating or supplying the original datasets locally.
- Author labels in code headers have been normalized to `Claudio Dong`.

## Author

Claudio Dong
