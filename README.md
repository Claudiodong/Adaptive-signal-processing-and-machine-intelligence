# Adaptive Signal Processing and Machine Intelligence

This repository contains source code for coursework and experiments in adaptive signal processing and machine intelligence. The code covers classical spectral estimation, adaptive filtering, complex-valued adaptive signal processing, nonlinear adaptive prediction, and neural-network based classification.

Source code, supporting datasets, and generated result images are included. Coursework reports, submitted PDFs, Word documents, and personal submission artifacts have been excluded from this public repository.

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
| `coursework/cw1` | Periodograms, correlograms, AR modelling, Yule-Walker estimation, MUSIC, ECG/RRI processing, data files, and result images. | MATLAB `.m`, MATLAB `.p`, `.mat`, `.csv`, `.jpg` |
| `coursework/cw2` | LMS, leaky LMS, GASS/GNGD, ALE, ANC, EEG-related adaptive filtering scripts, supporting EEG data, and result plots. | MATLAB `.m`, `.mat`, `.png` |
| `coursework/cw3` | CLMS, ACLMS, widely linear modelling, DFT-CLMS, complex-valued signal processing experiments, wind data, EEG data, and result plots. | MATLAB `.m`, `.mat`, `.png` |
| `coursework/cw4` | Nonlinear activation LMS, biased activation LMS, time-series prediction, CNN data-generation/training scripts, datasets, and result plots. | MATLAB `.m`, `.mat`, `.png` |
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

The datasets used by the MATLAB scripts are included beside the relevant coursework files, including EEG assignment data, RRI data, wind data, time-series data, and CNN training data.

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
- Generated result images and relevant datasets are included for reproducibility.
- The CNN dataset in `coursework/cw4/Task2/Task4_CNN_data.mat` is large and may take time to clone.
- Author labels in code headers have been normalized to `Claudio Dong`.

## Author

Claudio Dong
