import rpy2.robjects as robjects
from rpy2.robjects.packages import importr

ape = importr('ape')
phangorn = importr('phangorn')
r = robjects.r

def load_data(path):
    d = ape.read_nexus_data(path)
    return d
    # phy = phangorn.phyDat(d, type = "USER", levels = r.c("0","1","2","3","4","5","6","7","8","9","-"), ambiguity = r.c("?"))
    # tree = phangorn.dist_ml(phy)
    # nj_data = phangorn.NJ(tree)
    # return r.plot(nj_data, main = "Neighbour Join - Type: Unrooted", type = "unrooted", sub = "unrooted tree")

def make_trees(d):
    phy = phangorn.phyDat(d, type = "USER", levels = r.c("0","1","2","3","4","5","6","7","8","9","-"), ambiguity = r.c("?"))
    tree = phangorn.dist_ml(phy)
    nj_data = phangorn.NJ(tree)
    # return r.plot(nj_data, main = "Neighbour Join - Type: Unrooted", type = "unrooted", sub = "unrooted tree")
