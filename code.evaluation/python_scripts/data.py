import pandas
import plotly.plotly as py
import pandas
import ply
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import re


data = pandas.read_csv("prelim_analysis.csv")


def tool_name(list):
    tool_list = []
    for item in list:
        item = item.replace("run.", '')
        item = item.replace(".sh", '')
        tool_list.append(item.capitalize())
    return tool_list


def length(list):
    cover = []
    for item in list:
        if "50" in item:
            cover.append(50)
        elif "75" in item:
            cover.append(75)
        elif "100" in item:
            cover.append(100)
    return cover


def coverage(list):
    coverage = []
    for item in list:
        m = re.search("cov_(\d+)_", item)
        coverage.append(m.groups()[0])
    return coverage


def dataset(list):
    dataset_list = []
    for item in list:
        if "TRA" in item:
            dataset_list.append("TRA")
        else:
            dataset_list.append("IGH")

    return dataset_list


data["Tool"] = tool_name(data["Wrapper Name"])
data["Coverage"] = coverage(data["EC Filename"])
data["Length"] = length(data["EC Filename"])
data["Base Sensitiviy"] = data["Base - TP"] / (data["Base - TP"] + data["Base - FN"])
data["Base Precision"] = data["Base - TP"] / (data["Base - TP"] + data["Base - FP"] + data["Base - FP INDEL"] + data["Base - FN WRONG"])
data["Base Gain"] = (data["Base - TP"] - (data["Base - FP"] + data["Base - FP INDEL"])) / \
                    (data["Base - TP"] + data["Base - FN"])

data["Trim Percent"] = ((data["Base - TP TRIM"] + data["Base - FP TRIM"])/data["Total Bases"])
data["FP Trim Percent"] = ((data["Base - FP TRIM"])/data["Total Bases"])
data["TP Trim Percent"] = ((data["Base - TP TRIM"])/data["Total Bases"])
data["Dataset"] = dataset(data["EC Filename"])


print data[0:20]

# z = data.groupby(["Tool"])["Base Sensitiviy"].mean()
# y = data.groupby(["Tool"])["Base Precision"].mean()
# x = data.groupby(["Tool"])["Base Gain"].mean()
# z = data.groupby(["Tool","Dataset"])["Base Sensitiviy"].mean()
# y = data.groupby(["Tool","Dataset"])["Base Precision"].mean()
# x = data.groupby(["Tool","Dataset"])["Base Gain"].mean()
#
# print z
# print y
z = data.groupby(["Tool", "Dataset", "Coverage"])["Base Sensitiviy"].mean()
y = data.groupby(["Tool", "Dataset", "Coverage"])["Base Precision"].mean()
x = data.groupby(["Tool", "Dataset", "Coverage"])["Base Gain"].mean()
# y = y.fillna(1)
n = z.index


#SCATTER PLOT

# font = {'family': 'normal',
#         'weight': 'bold',
#         'size': 10}
#
# matplotlib.rc('font', **font)
#
# fig, ax = plt.subplots()
# ax.scatter(z, y)
# for i, txt in enumerate(n):
#     ax.annotate(txt, (z[i], y[i]))
#
# plt.show()
# fig.savefig("figure.png")

fig, ax = plt.subplots()
ax.scatter(z, y)
for i, txt in enumerate(n):
    ax.annotate(txt, (z[i], y[i]))
plt.ylabel('Precision')
plt.xlabel('Sensitivity')
plt.show()



#TRIM Map

import numpy as np
import matplotlib.pyplot as plt

m = data.groupby(["Tool"])["Trim Percent"].mean()
print m
f = data.groupby(["Tool"])["FP Trim Percent"].mean()
print f
h = data.groupby(["Tool"])["TP Trim Percent"].mean()
print h


# N = len(m)
# menMeans = h/f
# womenMeans = m
# addAnother = h
#
# ind = np.arange(N)    # the x locations for the groups
# width = 0.2       # the width of the bars: can also be len(x) sequence
#
# p1 = plt.bar(ind, menMeans, width, color='#d62728')
# # p3 = plt.bar(ind, addAnother, width, color='#00FFFF')
# # p2 = plt.bar(ind, womenMeans, width, bottom=menMeans)
#
#
# plt.ylabel('Scores')
# plt.title('Scores by group and gender')
# plt.xticks(ind, (m.index))
# plt.yticks(np.arange(0, 20, 1))
# plt.legend((p1[0], p2[0], p3[0]), ('TP Trimming Percent', 'Trimming Percent', 'FP Trimming Percent'))
#
# plt.show()


N = len(m)
menMeans = h/f
womenMeans = m
addAnother = h

ind = np.arange(N)    # the x locations for the groups
width = 0.2       # the width of the bars: can also be len(x) sequence

p1 = plt.bar(ind, menMeans, width, color='#d62728')
# p3 = plt.bar(ind, addAnother, width, color='#00FFFF')
# p2 = plt.bar(ind, womenMeans, width, bottom=menMeans)


plt.ylabel('Scores')
plt.title('Scores by group and gender')
plt.xticks(ind, (m.index))
plt.yticks(np.arange(0, 0.1, 0.01))
# plt.legend((p1[0]), ('Ratio of TP Trim to FP Trim'))

plt.show()