library(ape)
library(phangorn)
library(rgl)


if (!endsWith(getwd(), "coding")) {
    setwd(file.path(getwd(), "git", "Seminararbeit-Balladen", "coding"))
}

# read data from file
d <- read.nexus.data("data/nexus.nex")
phy <- phyDat(d, type = "USER",
             levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8",
                        "9", "a", "b", "c", "d", "e", "f", "-"),
             ambiguity = c("?"))

print("Loaded Nexus data.")

# Build trees
# -----------

pairwise_tree <- dist.hamming(phy)

# Neighbour Join
nj <- NJ(pairwise_tree)
bs_trees_nj <- bootstrap.phyDat(phy, FUN = function(x)NJ(dist.hamming(x)),
                             bs = 200)
consnet_nj <- consensusNet(bs_trees_nj)

# UPGMA
upgma <- upgma(pairwise_tree)
bs_trees_upgma <- bootstrap.phyDat(phy, FUN = function(x)upgma(dist.hamming(x)),
                             bs = 200)
consnet_upgma <- consensusNet(bs_trees_upgma)

# Max. parsimony
maxpars_nj <- optim.parsimony(nj, phy)
maxpars_upgma <- optim.parsimony(upgma, phy)

# Neighbour net
nnet <- neighborNet(pairwise_tree)


print("Built Trees.")


# Plot and save trees
# -----------

wd <- getwd()
new_wd <- file.path(wd, "out")
setwd(new_wd)

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot_nj <- plot(nj, main = "NJ")
dev.copy(png, filename = "nj_phyl.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot_nj_bs <- plotBS(nj, bs_trees_nj, "phylogram", main = "NJ Bootstrap 200")
dev.copy(png, filename = "nj_bs_phyl.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plotBS(nj, bs_trees_nj, "unrooted",
               main = "NJ Bootstrap 200 (Unrooted)")
dev.copy(png, filename = "nj_bs_unr.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(maxpars_nj, main = "NNI-Optimized NJ")
dev.copy(png, filename = "nj_nni.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(upgma, main = "UPGMA")
dev.copy(png, filename = "upgma.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot_nj_bs <- plotBS(upgma, bs_trees_upgma, "phylogram",
                     main = "UPGMA Bootstrap 200")
dev.copy(png, filename = "upgma_bs_phyl.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plotBS(upgma, bs_trees_upgma, "unrooted",
               main = "UPGMA Bootstrap 200 (Unrooted)")
dev.copy(png, filename = "upgma_bs_unr.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(maxpars_upgma, main = "NNI-Optimized UPGMA")
dev.copy(png, filename = "upgma_nni.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(consnet_upgma, "2D")
title(main = "UPGMA - Consensus Net (2D)")
dev.copy(png, filename = "upgma_cnet.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(nnet, "2D")
title(main = "Neighbour Net")
dev.copy(png, filename = "nnet.png", width = 800, height = 800)
dev.off()

dev.new()
par(mar = c(0.5, 0.5, 2.5, 0.5), bg = "#e6e6e6")
plot <- plot(consnet_nj, "2D")
title(main = "NJ - Consensus Net (2D)")
dev.copy(png, filename = "nj_cnet.png", width = 800, height = 800)
dev.off()


print("Plotted and saved trees.")


# save trees
# ----------
write.tree(nj, file = "nj.tre")
write.tree(upgma, file = "upgma.tre")


setwd(wd)
