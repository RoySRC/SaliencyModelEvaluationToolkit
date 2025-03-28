# Saliency Model Evaluation Framework

This repository contains code for generating and evaluating binary saliency masks using a collection of saliency models on the Saliency4ASD dataset. It supports automatic mask generation, saving saliency maps, and benchmarking against ground-truth fixation maps.

---

## Files

### `GenerateSaliencyMasks.m`
Generates binary saliency masks for multiple saliency models and saves them in the `scratch/` directory.

#### Supported Saliency Models:
- **Dynamic Visual Attention (DVA)**
- **covSal**
- **FES**

You can extend support to additional models by adding wrapper functions and registering them in the `saliency_models` struct.

#### Output:
- Raw saliency maps → `scratch/raw/<ModelName>/`
- Thresholded binary masks → `scratch/mask/<ModelName>/`

---

### `SaliencyMaskEvaluator.m`
Evaluates the performance of the generated saliency maps against fixation ground truth maps using commonly used saliency metrics.

#### Metrics Implemented:
- AUC_Borji
- AUC_Judd
- CC (Correlation Coefficient)
- KL divergence
- NSS (Normalized Scanpath Saliency)

> Some metrics like `EMD`, `InfoGain`, and `AUC_shuffled` are listed but currently commented out.

#### Ground Truth:
- ASD Fixation Maps → `Saliency4asd/TrainingData/ASD_FixMaps`
- TD Fixation Maps  → `Saliency4asd/TrainingData/TD_FixMaps`

Ground-truth masks are preprocessed using a thresholding function and saved under `scratch/GT/ASD` and `scratch/GT/TD`.

---

## Requirements

- MATLAB R2024 or later (recommended)
- Required folders must be on the MATLAB path:
  - `FES/`
  - `CovSal/`
  - `SMILER/` (for DVA model)
  - `saliency/code_forMetrics/`

---

## Usage

### 1. Generate Saliency Masks
```matlab
>> GenerateSaliencyMasks

make sure to change the following lines to include your model:
```matlab
saliency_models = struct( ...
    'Dynamic_Visual_Attention', @dynamicVisualAttention, ...
    'covSal', @CovSal, ...
    'FES', @FES ...
);
```

### 2. Evaluate Saliency Masks
```matlab
>>> SaliencyMaskEvaluator

make sure to change the following lines:
```matlab
performance_metric_fes = computePerformaneMetric('FES');
performance_metric_dvs = computePerformaneMetric('Dynamic_Visual_Attention');
performance_metric_covsal = computePerformaneMetric('CovSal');

performance_metric_fes_asd = computePerformaneMetricASD('FES');
performance_metric_dvs_asd = computePerformaneMetricASD('Dynamic_Visual_Attention');
performance_metric_covsal_asd = computePerformaneMetricASD('CovSal');
```
to include your model
