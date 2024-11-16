# sEMG Hand Gesture Classifier

This is an SVM and feature extraction based classifier for the EMAHA-DB1 dataset. This dataset consists of sEMG signals from 25 intact subjects performing 22 different hand movements. 

## Dataset

The full dataset can be found [here](https://www.kaggle.com/datasets/anishturlapaty/emaha-db1) on Kaggle. 

## Publication

The methods are based on the publication "EMAHA-DB1: A New Upper Limb sEMG Dataset for Classification of Activities of Daily Living", along which the dataset was published. This publication is not mine.

## Features

The following features are extracted from the sEMG signal:
- RMS
- Slope sign changes
- Normalized waveform length
- Kurtosis
- AR coefficients (2 lags)

## Improvements

The following improvements in performance were made compared to the best-performing benchmark model in classifying the individual hand activities, averaged across all subjects:
- 80.08% (+2.66%) cross-validation accuracy
- 91.62% (+16.23%) test accuracy
- 93.59% (+27.59%) precision
- 91.62% (+20.62%) recall
- 92.59% (+24.59%) F1 score


## Authors

- [@crystalzhu215](https://github.com/CrystalZhu215)


## Acknowledgements

 - [EMAHA-DB1: A New Upper Limb sEMG Dataset for Classification of Activities of Daily Living](https://ieeexplore.ieee.org/document/10135136/)
