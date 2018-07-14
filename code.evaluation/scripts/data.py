import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from altair import Chart

# alt.renderers.enable('notebook')
import altair as alt

import pandas
import ply
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import re

data = pandas.read_csv("analysis.csv")


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
        m = re.search("cov_(\d+)", item)
        coverage.append(m.groups()[0])
    return coverage


def dataset(list):
    dataset_list = []
    for item in list:
        if "TRA" in item:
            dataset_list.append("TRA")
        elif "IGH" in item:
            dataset_list.append("IGH")
            print ("IGH found.....")
        elif "t1" in item:
            dataset_list.append("T1")
        elif "t3" in item:
            dataset_list.append("T3")
        else:
            dataset_list.append("IGH")

    return dataset_list


data["Tool"] = tool_name(data["Wrapper Name"])
data["Coverage"] = coverage(data["EC Filename"])
data["Length"] = length(data["EC Filename"])
data["Base Sensitivity"] = data["Base - TP"] / (data["Base - TP"] + data["Base - FN"])
data["Base Precision"] = data["Base - TP"] / (data["Base - TP"] + data["Base - FP"] + data["Base - FP INDEL"])
data["Base Gain"] = (data["Base - TP"] - (data["Base - FP"] + data["Base - FP INDEL"])) / \
                    (data["Base - TP"] + data["Base - FN"])

data["Base Accuracy"] = (data["Base - TP"] + data["Base - TN"])/(data["Base - TP"] + data["Base - TN"] + data["Base - FP"] + data["Base - FN"] +
                                                                data["Base - FP INDEL"] + data["Base - FP TRIM"] + data["Base - FN WRONG"])
data["Dataset"] = dataset(data["EC Filename"])

data["Trim Percent"] = (data["Base - TP TRIM"] + data["Base - FP TRIM"])/data["Total Bases"]
                       # (data["Base - TP"] + data["Base - TN"] +
                       #  data["Base - FP"] + data["Base - FN"] +
                       #  data["Base - FP INDEL"] + data["Base - FP TRIM"] +
                       #  data["Base - FN WRONG"] + data["Base - TP TRIM"])

data["Trim Effeciency"] = (data["Base - TP TRIM"]/data["Base - FP TRIM"])


print data.head()

# z = data.groupby(["Tool", "Dataset", "Coverage"])["Base Sensitiviy"].mean()
# y = data.groupby(["Tool", "Dataset", "Coverage"])["Base Precision"].mean()
# x = data.groupby(["Tool", "Dataset", "Coverage"])["Base Gain"].mean()
# y = y.fillna(1)
# n = z.index

tra = data[(data["Dataset"]=="TRA")]
igh = data[(data["Dataset"]=="IGH")]
t1 = data[(data["Dataset"]=="T1")]
t3 = data[(data["Dataset"]=="T3")]

tra.to_csv("tra.csv")
igh.to_csv("igh.csv")
t1.to_csv("t1.csv")
t3.to_csv("t3.csv")

print t1

# alt.Chart(tra).mark_circle().encode(
#     alt.X('Base Sensitiviy', scale=alt.Scale(zero=False)),
#     alt.Y('Base Precision', scale=alt.Scale(zero=False, padding=1)),
#     color='Tool',
#     size='Coverage'
# )

# alt.Chart(igh).mark_circle().encode(
#     alt.X('Base Sensitiviy', scale=alt.Scale(zero=False)),
#     alt.Y('Base Precision', scale=alt.Scale(zero=False, padding=1)),
#     color='Tool',
#     size='Coverage'
# )

# alt.Chart(igh).mark_circle().encode(
#     alt.X('Base Sensitiviy', scale=alt.Scale(zero=False)),
#     alt.Y('Base Gain', scale=alt.Scale(zero=False, padding=1)),
#     color='Tool',
#     size='Coverage'
# )

igh = data[(data["Dataset"]=="IGH") & (data["Base Gain"]>-10)]

tra = data[(data["Dataset"]=="TRA") & (data["Base Gain"]>-0.3)]


# alt.Chart(tra).mark_circle().encode(
#     alt.X('Base Sensitiviy', scale=alt.Scale(zero=False)),
#     alt.Y('Base Gain', scale=alt.Scale(zero=False, padding=1)),
#     color='Tool',
#     size='Coverage'
# )

igh = data[(data["Dataset"]=="IGH") & (data["Base Gain"]>-0.3)]


# alt.Chart(igh).mark_circle().encode(
#     alt.X('Base Precision', scale=alt.Scale(zero=False)),
#     alt.Y('Base Gain', scale=alt.Scale(zero=False, padding=1)),
#     color='Tool',
#     size='Coverage'
# )

# alt.Chart(igh).mark_circle().encode(
#     alt.X(alt.repeat("column"), type='quantitative'),
#     alt.Y(alt.repeat("row"), type='quantitative'),
#     color='Tool',
#     size='Coverage'
# ).properties(
#     width=250,
#     height=250
# ).repeat(
#     row=['Base Sensitiviy', 'Base Gain', 'Base Precision'],
#     column=['Base Sensitiviy', 'Base Gain', 'Base Precision']
# ).interactive()