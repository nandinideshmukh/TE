# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

n_students = 1000
data = {
    'Student_ID': range(1, n_students + 1),
    'Study_Hours_Per_Week': np.random.normal(15, 5, n_students).round(1),
    'Attendance_Rate': np.random.uniform(60, 100, n_students).round(1),
    'GPA': np.random.normal(3.0, 0.5, n_students).round(2),
    'Final_Exam_Score': np.random.normal(75, 12, n_students).round(1)
}

df_large = pd.DataFrame(data)

# --- Injecting Outliers ---

# 1. Study Hours: Add students who study 0 hours or 80+ hours
df_large.loc[0:4, 'Study_Hours_Per_Week'] = [0.5, 1.0, 85.0, 92.0, 100.0]

# 2. Attendance Rate: Add students with extremely low attendance (below the 60% floor)
df_large.loc[5:9, 'Attendance_Rate'] = [5.0, 12.5, 2.0, 15.0, 8.0]

# 3. GPA: Add impossible or extreme GPAs (e.g., above 4.0 or near 0.0)
df_large.loc[10:14, 'GPA'] = [0.1, 0.25, 4.5, 5.0, 0.05]

# 4. Final Exam Score: Add scores far below the mean or above 100
df_large.loc[15:19, 'Final_Exam_Score'] = [5.0, 8.0, 115.0, 120.0, 10.0]

# Shuffle the dataframe so outliers aren't all at the top
df_large = df_large.sample(frac=1).reset_index(drop=True)

print(df_large.describe())


# %%
fig,axes = plt.subplots(1,4, figsize=(20,5))

sns.boxplot(data=df_large['Study_Hours_Per_Week'],ax=axes[0])
sns.boxplot(data=df_large['Attendance_Rate'],ax=axes[1])
sns.boxplot(data=df_large['GPA'],ax=axes[2])
sns.boxplot(data=df_large['Final_Exam_Score'],ax=axes[3])


# %%
fig,axes = plt.subplots(1,4, figsize=(20,5))

sns.histplot(data=df_large['Study_Hours_Per_Week'],ax=axes[0])
sns.histplot(data=df_large['Attendance_Rate'],ax=axes[1])
sns.histplot(data=df_large['GPA'],ax=axes[2])
sns.histplot(data=df_large['Final_Exam_Score'],ax=axes[3])

# %%
Q1 = df_large.quantile(0.25)
Q3 = df_large.quantile(0.75)
IQR = Q3 - Q1

outliers_iqr = ((df_large < (Q1 - 1.5 * IQR)) | (df_large > (Q3 + 1.5 * IQR)))
print("Number of outliers per column:")
print(outliers_iqr.sum())

# %%
def remove_outliers(feature):
    global df_large
    q3,q1 = np.percentile(df_large[feature], [75,25])
    iqr = q3-q1
    df_large = df_large[ (df_large[feature] <= q3 + 1.5*iqr) & (df_large[feature] >= q1 - 1.5*iqr) ]

# %%
remove_outliers('Study_Hours_Per_Week')
remove_outliers('Attendance_Rate')
remove_outliers('GPA')
remove_outliers('Final_Exam_Score')

# %%
fig,axes = plt.subplots(1,4, figsize=(20,5))

sns.boxplot(data=df_large['Study_Hours_Per_Week'],ax=axes[0])
sns.boxplot(data=df_large['Attendance_Rate'],ax=axes[1])
sns.boxplot(data=df_large['GPA'],ax=axes[2])
sns.boxplot(data=df_large['Final_Exam_Score'],ax=axes[3])


# %%
fig,axes = plt.subplots(1,4, figsize=(20,5))

sns.histplot(data=df_large['Study_Hours_Per_Week'],ax=axes[0])
sns.histplot(data=df_large['Attendance_Rate'],ax=axes[1])
sns.histplot(data=df_large['GPA'],ax=axes[2])
sns.histplot(data=df_large['Final_Exam_Score'],ax=axes[3])

# %%
from sklearn.preprocessing import StandardScaler

mnmx = StandardScaler()

# %%
df_large['Study_Hours_Per_Week'] = mnmx.fit_transform(df_large[['Study_Hours_Per_Week']])

df_large['Final_Exam_Score'] = mnmx.fit_transform(df_large[['Final_Exam_Score']])
df_large['Attendance_Rate'] = mnmx.fit_transform(df_large[['Attendance_Rate']])
df_large['GPA'] = mnmx.fit_transform(df_large[['GPA']])


# %%
fig,axes = plt.subplots(1,4, figsize=(20,5))

sns.histplot(data=df_large['Study_Hours_Per_Week'],ax=axes[0])
sns.histplot(data=df_large['Attendance_Rate'],ax=axes[1])
sns.histplot(data=df_large['GPA'],ax=axes[2])
sns.histplot(data=df_large['Final_Exam_Score'],ax=axes[3])

# %%
Q1 = df_large.quantile(0.25)
Q3 = df_large.quantile(0.75)
IQR = Q3 - Q1

outliers_iqr = ((df_large < (Q1 - 1.5 * IQR)) | (df_large > (Q3 + 1.5 * IQR)))
print("Number of outliers per column:")
print(outliers_iqr.sum())



