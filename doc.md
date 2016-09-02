## Data Exploration

No missing data, there is always a signal within 20ms, sometimes it is duplicated and will need to be removed. There is also irrelevant data from before the walk has begun, and after it ended.

Meaning: need to extract 500 signals for each sample. A naïve Preparation will add those as 1500 features. Possible issues: not all algorithms can handle many features, might be computational heavy, not enough samples.


Further observation shows that after cleaning the data it is sometimes easy to count the steps manually based on the plot of either x, y or z. Here we see the plots for session 3, which had 15 steps:

![](https://github.com/ranf/data-science-gait/blob/master/Images/session.3.x.png)
![](https://github.com/ranf/data-science-gait/blob/master/Images/session.3.y.png)
![](https://github.com/ranf/data-science-gait/blob/master/Images/session.3.z.png)

Comparing session 3 with session 2 plot (below), which had a similar number of steps, but lower distance, reveals several extreme observations on session 3 had significant effect on the distance:

![](session.2.z.png)

It is also important to notice that while the number of steps is almost always between 15 and 22, the distance varies between 5 and 20. Considering the final error calculation (MSE, which emphasizes larger errors), it means the distance estimation is much more risky than the step count estimation, and it is crucial to identify edge cases (100 errors of 1 == 11 errors of 3 == 1 error of 10).

## Data Preparation:

As stated the most basic preparation is to eliminate duplicated or irrelevant signals, and add 3 features (x, y and z) for the remaining 500 signals. The decision whether to use them directly or some aggregation/transformation will be done when selecting the model.

Basic aggregations like mean, min and max values for each axis which are easily calculated.

Considering the axis values behave similarly to a signal, which the number of steps corresponds to its rate - possibly interesting features can be the number of changes in its level, or the number of times it crosses a specific level. Both require discretization to eliminate noise.

The number of crossings did not provide good results and was eliminated early on.

## Model Selection

Only 30 sessions are available, and while there is enough data on each session, it may not be enough to build many models. A smart regression model will need to be built, and classification is impossible without accepting very big errors.

`Linear regression` did not provide reasonable results with few aggregation features (and obviously failed with the raw data), `Decision Tree` and `Random Forest` did not have enough observations (30) to build a sufficient model, `kNN` also gave bad results using a few aggregated features (will not work with many features).

`SVM` was the only model which was able to handle both aggregated features and raw data and give meaningful results.

Eventually `SVM` with Gaussian kernel was used on the raw data for estimating the number of steps, and a linear kernel on the min, max values and changes of the y and z axis for the distance (x only indicates the number of steps).

The distance proved to be much harder to estimate than the number of steps, so it is actually possible to add the predicted number of steps as a feature for the distance model - but there were still small errors in its estimation so it was considered an overhead.

Manual tuning of the algorithms sigma/cost/degree did not improve the results obtained by default using the `caret` package and `LOOCV`.

## Model Evaluation

The model was trained on 25 sessions using LOOCV, and tested on the remaining 5 sessions. Once results were good the 5 test samples were changed. The model was also evaluated using 5 edge case sessions to ensure its behavior against any set.

![](https://github.com/ranf/data-science-gait/blob/master/Images/edge_results.png)
