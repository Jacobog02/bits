# Install R packages for Single-Cell

Jacob Gutierrez 


Installing Seurat, Signac is pretty easy.


ggpubr: SOMETHING DOUBLET CHECK OR SPARK UP A NEW VM TO CONFIRM


## Install ArchR:
This feels like pulling teeth but here we go 

devtools: install.packages("devtools", dependencies = TRUE, INSTALL_opts = '--no-lock')

devtools::install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories(), INSTALL_opts = '--no-lock')
