

\section{Methods}
The diagram of the project pipeline is described in Figure \ref{pipeline}, consisting of data pre-processing, preparing the bimodal inputs using early fusion, classification using neural networks, and feature interpretation using sufficient input subsets. The next sections describe this pipeline in more detail. \\

\begin{figure*}[t]
\centering
\includegraphics[width=15cm]{pipeline_diagram2.png}
\caption{Diagram of the pipeline used for this project}
\label{pipeline}
\end{figure*}


\subsection{Dataset}
This work analyzed the output of a multimodal single-cell omics technique presented by Cao et al. named sci-CAR, a single-cell combinatorial indexing method (sci) which jointly profiles chromatin accessiblity and mRNA (CAR) \cite{sci-CAR}. This method allows for the performance of single-cell mRNA sequencing and single-cell Assay for Transposase-Acessible Chromatin (ATAC) sequencing to be performed on individual cells in a high-throughput manner. In brief, the cell nuclei are extracted and loaded into wells where well-specific barcodes are introduced into the RNA sequence via reverse transcription and amplification primers. The ATAC sequences are also associated with well-specific barcodes via in-situ tagmentation with Tn5 transposase and amplification primers. As nuclei pass through a unique combination of wells, they are imbued with a unique combination of barcodes. These are then used to link mRNA sequences and ATAC sequences to individual cells and thus each other. Cao et al. applied this method to human lung adenocarcinoma-derived A549 cells, cultures of which were applied to 0, 1 or 3 hours of 100nM desamethasone. This resulted in an overall dataset of 4825 cells that produced both transcriptome and chromatin accessibility data for the AD549 cells. \\

\subsection{Data Preparation}

\subsubsection{Data Preprocessing and Feature Selection}
Quality control was performed on the A549 dataset in order to ensure the suitability of the RNA-seq and ATAC-seq for further analysis, as in the study performed by Jin et al \cite{scAI}. For the RNA-seq data, genes that were expressed in fewer than 10 cells were removed from the dataset. Additionally the cells that had cell expression counts less than 500 or more than 9100 were also removed from the dataset. For the ATAC-seq data, loci that were present in fewer than 5 cells were removed and cells with fewer than 200 accessible loci were removed from the dataset. \\

The dataset was also exposed to feature selection methods to determine the most informative genes and loci, as in the Jin et al. study \cite{scAI}. The Wilcoxon rank-sum test was performed to compare candidate genes in different cell groups. Candidate genes were considered informative if the p values were less than 0.05 and log fold-changes were higher than 0.25. After these quality control and feature selection processes were performed only the cells that were still present in both the RNA-seq and ATAC-seq datasets were retained. This resulted in the an RNA-seq dataset with 2641 cells and 1185 genes and an ATAC-seq dataset with 2641 cells and 52,761 loci. These preprocessed datasets were accessed from a github repository created by Jin et al. \cite{scAI_github}. \\

\subsubsection{Data Upsampling}
After the pre-processing and feature selection steps were completed, the dataset showed a significant amount of class imbalance between the different time durations of dexamethasone treatment, 583 cells for 0 hours, 983 cells for 1 hour, 1075 cells for 3 hours. In order to address this class imbalance, upsampling was used to increase the sample number of minority classes. The decision was made to pursue upsampling over downsampling since neural network architectures benefit from training on larger datasets. Minority classes were randomly sampled to create repeated samples until they matched the sample number of the majority class. This was implemented using the \textit{groupdata2} package in \textit{R} \cite{olsen_groupdata2_2020}. This resulted in the raw RNA-seq and ATAC-seq datasets with balanced cell sample counts of 1075 across the 0, 1 and 3 hour classes with a total cell count of 3225 for each dataset. \\

\subsection{Multimodal Integration}
\subsubsection{Raw Data Early Fusion Representation}
A joint representation of the two raw RNA-seq and ATAC-seq datasets were created for downstream analysis. This followed the methodology of early fusion \cite{multimodal-ml} which involved the concatenation of the ATAC-seq dataset to the RNA-seq dataset along the feature axis, resulting in a Bimodal concatenation dataset composed of 3225 cells and 53,946 features for the upsampled case and 2641 cells and 53,946 features for the base case. \\

\subsubsection{Dimensionality Reduction and Low Dimension Early Fusion Representation}
Lower dimensional representations of the Raw Data datasets were created for early fusion as well as downstream analysis. The methods used in the Jin et al. study \cite{scAI} were followed to perform dimensionality reduction on each dataset. For the RNA-seq data, this study used the \textit{Seurat} toolkit \cite{butler_integrating_2018} to perform dimensionality reduction, which involved performing Principal Component Analysis (PCA) to extract 30 principal components of the dataset \cite{noauthor_satija_nodate}. This work replicated this dimensionality reduction using the \textit{scikitlearn.decomposition.PCA} library in \textit{Python} \cite{noauthor_sklearndecompositionpca_nodate}. This resulted in a lower dimensional RCA-seq dataset of 3225 cells and 30 principal component features. This study used the \textit{Signac} toolkit \cite{noauthor_analysis_nodate} in order to perform dimensionality reduction on the ATAC-seq dataset, due to the sparsity and almost binary nature of the data, this was performed via Singular Value Decomposition (SVD) where the dataset was reduced to 50 components \cite{noauthor_analyzing_nodate}. This work replicated this dimensionality reduction with the \textit{scikitlearn.decomposition.TruncatedSVD} library in \texit{Python} \cite{noauthor_sklearndecompositiontruncatedsvd_nodate}.  This resulted in a lower dimensional ATAC-seq dataset of 3225 cells and 50 SVD components. \\

Early Fusion was also applied to these lower dimensional datasets for downstream analysis. Again this involved a simple concatenation of the low-dimensional datasets along the feature axis, resulting in a Bimodal SVD-PCA dataset of 3225 cells and 80 features. \\

\subsection{Multimodality Integration via scAI}
This work also explored novel methods of multimodal integration designed to integrate single cell omics modalities, namely single-cell aggregation and integration (scAI). scAI is a method that integrates the transcriptomic profiles generated via mRNA-seq as well as the chromatin accessibility profiles derived by ATAC-seq \cite{scAI}. This process adopts a learning method that computes a unified matrix factorization model incorporating both transcriptomic and aggregated epigenomic data in order to learn a cell-cell similarity matrix. This allows the process to aggregate the epigenomic data into subgroups that are similar in terms of epigenomics and gene expression. This allows for the representation of cell populations in a lower dimensional space in terms of their gene and loci expressions. This work made the use of the scAI toolkit applied to the RNA-seq and ATAC-seq analysis of the A549 cell dataset \cite{scAI_github} in order to develop a lower dimension representation of the cells in terms of 2 and 20 learned factors for downstream analysis. \\

\subsection{Dataset Summary}
All of the above analyses resulted in the following datasets available for downstream analysis in the neural net cell-type identification task, see Table \ref{tab:datasets}

\begin{table}[h]
\caption{Datasets produced: pp = pre-processed, st = stratified sampling to form test set, fs = feature-selected, cb = classes balanced using upsampling}
\label{tab:datasets}
\centering
\begin{tabular}{|l|l|l|}
\hline
\rowcolor[HTML]{EFEFEF} 
\multicolumn{1}{|c|}{\cellcolor[HTML]{EFEFEF}Dataset} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}Cell\\ Number\end{tabular}} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}Feature\\ Number\end{tabular}} \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq raw\\ pp, st, fs\end{tabular} & 2641 & 52,761\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq raw\\ pp, st, fs\end{tabular} & 2641 & 1185\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, st, fs\end{tabular} & 2641 & 53,946\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ 20 Factor\end{tabular} & 2641 & 20\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ 2 Factor\end{tabular} & 2641 & 2\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, st, fs\end{tabular} & 2641 & 50\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, st, fs\end{tabular} & 2641 & 30\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal SVD-PCA\\ pp, st, fs\end{tabular} & 2641 & 80\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq\\ pp, fs, cb\end{tabular} & 3225 & 52,761\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq\\ pp, fs, cb\end{tabular} & 3225 & 1185\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal\\ pp, fs, cb\end{tabular} & 3225 & 53,946\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ pp, fs, cb\end{tabular} & 3225 & 20\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, fs, cb\end{tabular} & 3225 & 50\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, fs, cb\end{tabular} & 3225 & 30\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, fs, cb\end{tabular} & 3225 & 80\\ \hline
\end{tabular}
\end{table}


\subsection{Classification}

\subsubsection{Neural Network Architecture and Optimization} \label{architecture} 
We employed two similar architectures for classifying by cell-type -- one for classifying high-dimensional data after applying various pre-processing methods (see above) and one for classifying low-dimensional data.  Each architecture consisted of three fully-connected layer, three drop-out layers, and an output layer with three activation units. Most other papers we found during literature review used similarly shallow, fully-connected layers such as in \cite{ma_actinn_2020} and \cite{lopez_deep_2018}. \\

ReLu activation was used following each fully-connected layer and softmax activation was used after the output layer to compute probabilities for each class.  L2 regularization was used to improve generalization and mini-batch Gradient Descent was used as an Optimizer. \\

\subsubsection{Training and Testing}
Testing sets were made for each unimodal and bimodal input by holding out 10 $\%$ from the original dataset. Hyper-parameter search was done using grid-search on the training set over 10 epochs per combination of hyper-parameters for high-dimensional datasets and 25 epochs for low-dimensional datasets. Table \ref{hyperparameters} shows which hyper-parameters were found to be optimal for each dataset.  After grid-search and hyper-parameter selection, each model was trained over 100 epochs using a batch size of 64.  \\

\begin{table}[h]
\caption{Hyperparameters for each training set: pp = pre-processed, st = stratified sampling to form test set, fs = feature-selected, cb = classes balanced using upsampling}
\label{tab:hyperparameters}
\centering
\begin{tabular}{|l|l|l|l|}
\hline
\rowcolor[HTML]{EFEFEF} 
\multicolumn{1}{|c|}{\cellcolor[HTML]{EFEFEF}Dataset} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}Learning\\ Rate\end{tabular}} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}Dropout\\ Rate\end{tabular}} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}L2\\ Lambda\end{tabular}} \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq raw\\ pp, st, fs\end{tabular} & 0.1 & 0.2 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq raw\\ pp, st, fs\end{tabular} & 0.1 & 0.1 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, st, fs\end{tabular} & 0.1 & 0.1 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ 20 Factor\end{tabular} & 0.1 & 0.1 & 1e-06 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ 2 Factor\end{tabular} & 0.1 & 0.1 & 1e-06 \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, st, fs\end{tabular} & 0.1 & 0.2 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, st, fs\end{tabular} & 0.01 & 0.1 & 1e-06 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal SVD-PCA\\ pp, st, fs\end{tabular} & 0.01 & 0.1 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq\\ pp, fs, cb\end{tabular} & 0.1 & 0.5 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq\\ pp, fs, cb\end{tabular} & 0.1 & 0.2 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal\\ pp, fs, cb\end{tabular} & 0.01 & 0.2 & 1e-06 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ pp, fs, cb\end{tabular} & 0.1 & 0.5 & 1e-06 \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, fs, cb\end{tabular} & 0.1 & 0.2 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, fs, cb\end{tabular} & 0.1 & 0.2 & 0.001 \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, fs, cb\end{tabular} & 0.1 & 0.1 & 1e-06 \\ \hline
\end{tabular}
\end{table}

\subsubsection{Model Evaluation}
We primarily used accuracy and confusion matrices to measure the performance of our multi-class classifier. Each softmax output was assigned one of the three classes (0hr, 1hr, 3hrs of DEX-treatment) using the argmax. All training and test labels were one-hot encoded prior to training each model to allow for  multi-class accuracy to be easily computed. Confusion matrices were created using Tensorflow's native confusion matrix function.  \\


\section{Sufficient Input Subsets}


Sufficient Input Subsets \cite{SIS} is an interpretability method for understanding why a black-box model reaches a particular decision for examples x $\in$ \textbf{X}. For each example x, the method computes a collection of k disjoint feature subsets $S_1$, ...,.. $S_k$ that meet the following criteria:
\begin{enumerate}
\item $f(x_{S_k}) \geq \tau$ where $f$ is a function mapping the subset $S_k$ of features in x to a decision probability. $\tau$ is a user-specified decision threshold. 
\item Each set is minimal. If any feature was removed from a subset $S'$ , $f(x_{S'})$ < $\tau$ 
\item The set of features R not in any subset $S_K$ cannot meet the decision threshold. In other words $f(x_{R})$ < $\tau$ .  
\end{enumerate}


In this paper, each x represents an A549 cell with feature sets $[p]$ from either sc-ATAC-seq, sc-RNA-seq, or an integration of the two modalities. The function $f$ is one of the neural net classifiers described in \ref{architecture} and the decision threshold $\tau$ is the probability a given cell is classified in cell states 0hr, 1hr, or 3hrs of dexamethasone treatment ($P(treat Time | x_{S_k})$)  \\

We used an SIS tutorial in classifying MNIST digits \href{https://github.com/google-research/google-research/blob/master/sufficient_input_subsets/tutorials/sis_mnist_tutorial.ipynb} as a reference for finding high-confidence (HC) cells that were classified with probability $\geq$  0.7 and for finding SIS-collections of features needed to classify each HC cell. \\

After finding all HC cells assigned to each class for each dataset, we aggregated all features that were found in at least 1 SIS for any HC cell.  We then found the percentage of the HC cells that contain a SIS with each feature to compute feature importance scores.  For example, if there are 100 HC cells classified as DEX-treated for 1hr and the sc-RNA-seq gene SLC35F3 appears in an SIS for 75 of these, then the feature importance for SLC35F3 would be 75 $\%$ for classifying cells as 1hr.  \\

We validated the features we found with the original paper that developed sci-CAR \cite{sci-CAR}. We compared our features with the markers for the glucocorticoid receptor which is activated upon treatment with dexamethasone, a synthetic mimic of cortisol \cite{sci-CAR}. That paper mentions the following as markers: NFKBIA, SCNN1A, CKB, PER1 and CDH16. We then compared our features with the differentially-expressed genes found in the sci-CAR paper. Genes were considered significantly expressed if they met a p-value  of < 0.05 using the Bonferroni correction. The significance threshold was computed as $\frac{0.05}{14142} = 3e-06$. We then found the percent of features from the SIS-collection on the sc-RNA-seq dataset (after feature selection and class-balancing)  that were considered as differentially expressed. \\




% if have a single appendix:
%\appendix[Proof of the Zonklar Equations]
% or
%\appendix  % for no appendix heading
% do not use \section anymore after \appendix, only \section*
% is possibly needed

% use appendices with more than one appendix
% then use \section to start each appendix
% you must declare a \section before using any
% \subsection or using \label (\appendices by itself
% starts a section numbered zero.)
%
