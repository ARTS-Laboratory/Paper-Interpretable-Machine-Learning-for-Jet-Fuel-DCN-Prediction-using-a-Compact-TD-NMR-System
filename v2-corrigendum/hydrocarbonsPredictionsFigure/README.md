# Hydrocarbons Predictions Figure

Code and data behind the corrigendum's Fig. 9.

* `makeHCpredictions.m` reruns the hydrocarbon predictions from scratch: loads the trained model from `models/`, computes features from the raw validation curves in `data/hcData.mat` at the paper's truncation level, and prints the four-sample RMSE.
* `figure-9/` holds the publication figure (`figure9.jpg`) and its plotting script. That script draws from the original saved predictions (`hcOut.mat`, `predictionsOut.mat`), because the model's predictions for the four retained samples are unchanged from the original publication — the dropped sample is simply omitted. Panel (b), the jet fuels, is unchanged from the publication and is drawn here from `predictionsOut.mat`.





