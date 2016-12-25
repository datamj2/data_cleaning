Notes for run_analysis.R


The UCI HAR Dataset should be unzipped to the working directory.

The script loads the dplyr package (the stats package should already be loaded).

X_train, Y_train and subject_train are loaded, followed by X_test, Y_test and subject_test. X_train and X_test have columns with generic names: the data appear to contain analyses (aka measures or measurements) made from the data in the Inertial Signals folders. Because of this, there seems to be no reason to re-analyze the data in the Inertial Signals folders. The column names appear to found in features.txt. Subject_train and subject_test seem to identify the rows by subject in the X data sets, and Y_train and Y_test seem to carry the activities for each row.

[Subject_train and Y_train], and [subject_test and Y_test] are first bound to the left sides of X_train and X_test, respectively. This is done in order to carry these identifiers throughout the tidying process. Next, the train and test data sets are bound together vertically to form data_all.

At the next step, the columns containing the mean and std measures are subsetted. However, while there is only one type of std measure, std(), there are multiple mean measures, including mean(), meanFreq(), tBodyGyroMean, and gravityMean. Since the instructions do not distinguish between these measures, I will include all of them, along with the first two columns. The subsetted data set is called data_select. Also, while there are duplicate entries in features.txt, there are no duplicate entries among names containing “mean” or “std”.

At this point, the activity labels are loaded (from activity_labels). This file contains descriptive labels for the activities, and replace the numeric values found in the activity column (the second column) of data_select.

Next, descriptive names are assigned to the data_select variables (columns), using the information from features.txt. The feature names are extracted from features.txt, “subject” and “activity” are bound to the left side, and the resulting vector is subsetted using the same index used to select the columns in data_select. These names seem to be abbreviated but completely descriptive labels, without duplicates. The only change I make is to expand ?t? to ?time? and ?f? to ?fft? to make the column names less reliant on the codebook. 

In the last step, data_select is filtered to provide the mean of each measurement column by each combination of subject and activity. This data set is called data_final and is returned by run_Analysis.

Data_final is a tidy data set because it meets the three requirements for tidy data:
1) each variable is a column
2) each observation is as row
3) each observational unit forms a table

The following code will load “data.final” from the text file:
data_final<-read.table("data_final.txt",header=TRUE,sep="\t",check.names=FALSE)
