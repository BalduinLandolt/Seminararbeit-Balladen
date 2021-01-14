library(ape)
library(phangorn)


if (!endsWith(getwd(), "coding")) {
    setwd(file.path(getwd(), "git", "Seminararbeit-Balladen", "coding"))
}


d = read.nexus.data("data/nexus.nex")
# print(d)
phy = phyDat(d, type = "USER", levels = c("0","1","2","3","4","5","6","7","8","9","-"), ambiguity = c("?"))


pairwise_tree = dist.ml(phy)
nj = NJ(pairwise_tree)
bs_trees = bootstrap.phyDat(phy, FUN=function(x)NJ(dist.hamming(x)), bs=200)

# if (!dir.exists("./out")) {
#     dir.create("./out")
# }
wd = getwd()
new_wd = file.path(wd, "out")
setwd(new_wd)
nj_tree = plotBS(nj, bs_trees, "phylogram")
dev.copy(png, filename = "nj_bs_phyl.png")
dev.off()
dev.new()
nj_tree = plotBS(nj, bs_trees, "unrooted")
dev.copy(png, filename = "nj_bs_unr.png")
dev.off()
setwd(wd)



# fit = pml(nj_data, phy)
# fit = optim.pml(fit, rearrangement="NNI")
# bs = bootstrap.pml(fit, bs=200, optNni=TRUE)
# treeMP = pratchet(phy)
# treeMP = acctran(treeMP, phy)
# BStrees = bootstrap.phyDat(phy, pratchet, bs = 20)
# cnt = consensusNet(bootstrap.phyDat(phy, FUN = function(x)nj(dist.hamming(x)), bs=20))
# nnt = neighborNet(dist.hamming(phy))

# plot(nj_data, main = "Neighbour Join - Type: Phylogram", sub = trees$name)
# plot(nj_data, main = "Neighbour Join - Type: Unrooted", type = "unrooted", sub = trees$name)
# plot(trees$NJ, main = "Neighbour Join - Type: Radial", type = "radial", sub = trees$name)

# plotBS(trees$NJ, trees$maxLikely, "unrooted", main="Maximum Likelyhood: Unrooted", sub = trees$name)
# plotBS(trees$NJ, trees$maxLikely, "phylogram", main="Maximum Likelyhood: Phylogram", sub = trees$name)

# plotBS(trees$treeMP, trees$maxParsimonyTrees, "unrooted", main="Maximum Parsimony: Unrooted", sub = trees$name)
# plotBS(trees$treeMP, trees$maxParsimonyTrees, "phylogram", main="Maximum Parsimony: Phylogram", sub = trees$name)

# plot(trees$consensusNet, "2D")
# title(main = "Consensus Net\n(2D Rendering)", sub = trees$name)

# plot(trees$neighbourNet, "2D")
# title(main = "Neighbour Net", sub = trees$name)
