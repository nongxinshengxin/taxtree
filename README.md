# taxtree <img src="image/TAXTREE.png" align="right" alt="taxtree logo" style="height: 140px;">
## Overview
The **Taxonomy Database** is a curated classification and nomenclature for all of the organisms in the public sequence databases. This currently represents about 10% of the described species of life on the planet. The official address for the NCBI Taxonomy database is https://www.ncbi.nlm.nih.gov/taxonomy and the public data download address is https://ftp.ncbi.nih.gov/pub/taxonomy/. `taxtree` is used to generate a a phylogenetic topology of taxonomic units (taxa) based on the Taxonomy database by processing **names.dmp** and **nodes.dmp** and drawing simple evolutionary trees based on the hierarchy of taxa. The implementation of `taxtree` function relies on `tidyverse` and `ggtree`. Currently, `taxtree` allows **768,430** taxa from the taxonomy database to be used to construct the topology of a phylogenetic tree.
| Ranks | higher taxa | genus | species | lower taxa | total |
|--|--|--|--|--|--|
| Archaea | 610 | 264 | 878 | 0 | 1,752|
| Bacteria | 5,897 | 5,005 | 24,761 | 952 | 36,615 |
| Eukaryota | 67,028 | 98,600 | 515,880 | 36,640 | 718,148 |
| Fungi | 6,009 | 7,437 | 55,840 | 1,571 | 70,857 |
| Metazoa | 48,564 | 70,320 | 270,261 | 18,292 | 407,437 |
| Viruses | 2,064 | 2,587 | 7,180 | 65 | 11,896 |
| Bacteria | 5,897 | 5,005 | 24,761 | 952 | 36,615 |
| All taxa | 75,630 | 106,458 | 548,685 | 37,657 | **768,430** |
## Installation
Before installing, you will need to download the `taxtree` dependency package `ggtree` by `BiocManager`.
```{r}
if (!require("BiocManager"))
  install.packages("BiocManager")
library(BiocManager)
if (!require("ggtree"))
  BiocManager::install("ggtree")
```
Install `devtools`, which is used to install R packages from GitHub.
```{r}
if (!require("devtools"))
  install.packages("devtools")
```
Once you have completed the above steps, start the installation.
```{r}
devtools::install_github("nongxinshengxin/taxtree")
```
## Function
`taxtree` has six **core functions**.
- **make_Taxtree()**  If you have some definite taxa names (either Kingdom Phylum Class Order Family Genus Species or any other taxonomic node), you can use this function to construct their taxonomic topology from a list of taxa names.
- **find_Lineage()**  By an explicit taxon name, all taxonomic lineages under that taxno are found.
- **name2rank()**  If you have some definite taxa names (either Kingdom Phylum Class Order Family Genus Species or any other taxonomic node), you can use this function to get the taxonomy rank name (and taxid) based on the name of the taxa.
- **name2rank_str()** If you have some definite taxa names (either Kingdom Phylum Class Order Family Genus Species or any other taxonomic node), you can use this function to get the taxonomy rank name (and taxid) based on the name of the taxa. You can input a single string or a vector containing multiple strings in this function.
- **plot_taxTree()**  Drawing a simple Taxonomy tree based on the `ggtree` package.
- **write_taxTree()**  This function writes in a file a tree in parenthetic format using the Newick format, based on `ape` packages.

## Application
- Species annotation based on OTUs, allowing the construction of their phylogenetic topology based on the names of taxa obtained from the annotation, using the make_Taxtree() function;
- Conducting taxonomic studies. Curious about the close relatives of humans under the order Primates? find_Lineage("Primates") is a one-line command that will give you the answer;
- Border Phylum Order Family Genus Species, classification is just too complicated. name2rank(), name2rank_str(), just provide the name of the taxa and it will tell you its taxonomic rank;
- Super linkage. `taxtree` is based on the Taxonomy database and can be linked to **TaxonKit software**; also, taxtree generates S3 phylo classes, which are commonly used to store phylogenetic trees in R. The tree can be easily embellished in depth using the `ggtree` package. The tree can also be output via write_taxTree(), combined with the <a href="https://github.com/TongZhou2017/itol.toolkit">**itol.toolkit package**</a> and embellished with iTOL.

## Reference
Hadley Wickham. https://github.com/tidyverse/tidyverse

G Yu, DK Smith, H Zhu, Y Guan, TTY Lam (2017). ggtree: an R package for visualization and annotation of phylogenetic trees with their covariates and other associated data. Methods in Ecology and Evolution, 8(1):28-36. https://doi.org/10.1111/2041-210X.12628

## Documentation
The English documentation is available in - https://github.com/nongxinshengxin/taxtree

The Chinese documentation is available in - 微信公众号农心生信工作室

## Citation
Please, when using `taxtree`, cite us using the reference: https://github.com/nongxinshengxin/taxtree

## Contact us
- Email: nongxinshengxin@163.com
- Wechat Official Account：
![](/image/wx.png)
