# Network features - No dataset


import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd


#  create graph
G = nx.erdos_renyi_graph(15,0.2,21)


degree_dict = dict(G.degree())


# assign colors
node_colors = [
    "green" if degree_dict[node] > 1 else "grey" for node in G.nodes()
]


pos = nx.spring_layout(G,k=1.5)


plt.figure(figsize=(12,10))


nx.draw(G,pos,
        node_color=node_colors,
        edge_color="grey",
        with_labels=True,
        node_size=[500 + 100 * degree_dict[node] for node in G.nodes()],
        font_size=13
        )
plt.show()


# calculate the features
degree_centrality = nx.degree_centrality(G)
closeness_centrality = nx.closeness_centrality(G)
betweeness_centrality = nx.betweenness_centrality(G)
eigenvector_centrality = nx.eigenvector_centrality(G)
clustering = nx.clustering(G)
bridges = list(nx.bridges(G))
hubs = sorted(degree_dict.items(),reverse=True,key= lambda x:x[1])


df = pd.DataFrame({
    "Node":list(G.nodes()),
    "degree_centrality":[degree_centrality[node] for node in G.nodes()],
    "closeness_centrality":[closeness_centrality[node] for node in G.nodes()],
    "betweeness_centrality":[betweeness_centrality[node] for node in G.nodes()],
    "eigenvector_centrality":[eigenvector_centrality[node] for node in G.nodes()],
    "clustering coeeficient":[clustering[node] for node in G.nodes()],
})


df


# finding top node for each metric


metric = pd.DataFrame({
  "degree_centrality_node" : df.loc[df['degree_centrality'].idxmax()],
  "eigenvector_centrality_node" : df.loc[df['eigenvector_centrality'].idxmax()],
  "closeness_centrality_node" : df.loc[df['closeness_centrality'].idxmax()],
  "betweeness_centrality_node" : df.loc[df['betweeness_centrality'].idxmax()],
  "clustering_node" : df.loc[df['clustering coeeficient'].idxmax()]
})


metric



# clustering
from networkx.algorithms.community import greedy_modularity_communities


communities = greedy_modularity_communities(G)


colors = ["red","blue","green","yellow","pink","orange","black","cyan","magenta","purple"]


node_to_cluster = {}


for idx,community in enumerate(communities):
  for node in community:
    node_to_cluster[node] = idx


node_colors = [
    colors[node_to_cluster[node]] for node in G.nodes()
]


plt.figure(figsize=(12,8))
nx.draw(G,pos,
        node_color=node_colors,
        edge_color="grey",
        with_labels=True,
        node_size=500,
        font_size=12
        )
plt.show()

