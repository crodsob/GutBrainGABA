# How to recover files that have been accidentally deleted by impatient fingers
 
So, you just deleted some files you weren't meant to... Oops.


### 1. Locate lost files using the snapshot from last hour
```
ls .zfs/snapshot/snapping-2021-10-05-14-00-00-004/2020/gbgaba/pilot_BIDS/derivatives/fMRI/preprocessed/sub-004/ses-01/func/sub-004_ses-01_FEATpreproc*

```

### 2. Copy the deleted file(s) back into the original directory
```
cp -R .zfs/snapshot/snapping-2021-10-05-14-00-00-004/2020/gbgaba/pilot_BIDS/derivatives/fMRI/preprocessed/sub-004/ses-01/func/sub-004_ses-01_FEATpreproc++.feat/ /storage/shared/research/cinn/2020/gbgaba/pilot_BIDS/derivatives/fMRI/preprocessed/sub-004/ses-01/func/

```