---
layout: default
title: 'Overview'
---


Multimodal single-cell datasets are a recent development that provide numerous opportunities for the application of advanced machine learning techniques. In this work we evaluate the informative value of unimodal and multimodal single-cell datasets in a cell-state classification task on the scRNA-seq and scATAC-seq output of the sci-CAR method applied to dexamethasone treated lung adenocarcinoma-derived A549 cells. We developed a neural net classifier and tested its accuracy on unimodal, Early Fusion Bimodal and scAI Bimodal integrations of the single-cell datasets to evaluate their informative content. This study also performs a novel application of Sufficient Input Subsets to determine modality informativeness as well as identify differentially-expressed genes. While we conclude that multimodal inputs do not provide additional informative content over unimodal scRNA-seq data, SIS was found to be a promising novel method of marker gene identification.
\end{abstract}

\begin{IEEEkeywords}
single-cell genomics, multimodal learning, cell-type classification, sufficient input subsets
\end{IEEEkeywords}

\section{Introduction}
% Here we have the typical use of a "W" for an initial drop letter
% and "RITE" in caps to complete the first word.
% You must have at least 2 lines in the paragraph with the drop letter
% (should never be an issue)

The past decade has seen the development of numerous experimental methods to generate data at single-cell resolution. Single-cell datasets have made it possible to better characterize individual cells by their cell type and cell state \cite{integrative-singe-cell, abdelaal}. Similarly, improved understanding in differences between single-cells has allowed researchers to better define the features inherent to each cell type \cite{eleven-challenges}. Finding these single-cell molecular profiles for cell-type identification has been the main goal of creating a Human Cell Atlas, an international collaborative effort to characterize every cell in the human body. \cite{regev_human_cell_atlas}. While most of the characterization has relied on scRNA-seq data to measure transcriptional differences, other data types have measured chromatin accessibility, methylation levels, protein levels, spatial information, and other data modalities. \cite{eleven-challenges}.  \\

Only recently have efforts been made to generate multimodal single-cell datasets in which multiple data types are produced for the same cell (e.g. mRNA + DNA methylation data) \cite{integrative-single-cell} \cite{sci-CAR}. Much work remains for understanding the power of using multimodal data for cell-type and cell-state classification.  It's also unclear how features from multimodal single-cell inform a cell's molecular profile. For example, a bimodal single-cell dataset containing information on gene expression and chromatin accessibility may better characterize a cell, but it's unclear whether features from gene expression or chromatin accessibility are more informative for its identification. \\

Beyond genomics, multimodal machine learning is a blossoming field vying to understand how to best represent multimodal inputs and fuse multiple modalities to bolster predictive power. \cite{multimodal-ml}. Numerous multimodal studies have been done in other fields such as speech recognition, event detection, emotion recognition, and media description. \cite{multimodal-ml}. However, multimodal learning is still very new to the world of single-cell genomics \cite{integrative-singe-cell}, allowing for many new potential applications. \\

Deep learning has also just entered the world of single-cell genomics, specifically in identifying cell types and cell states. Other deep learning approaches for cell-type classification such as  \cite{ma_actinn_2020} and \cite{lopez_deep_2018} do exist and ought to be leveraged, yet these use only one modality as input. Multimodal classification has been used in healthcare such as in \cite{pancancer} as well as analyzing PATCH-seq data such as in \cite{patch-seq} \cite{coupled-autoencoders}, yet none of these methods use deep learning for analyzing high-dimensional multi-modal genomics data. \\

In this work, we show how multimodal single-cell data can be combined to improve cell-state classification in a deep learning framework. We focus on classifying lung adenocarcinoma-derived A549 cells that have been treated with dexamethasone (DEX), a synthetic compound similar to cortisol, for varying amounts of time \cite{sci-CAR}. This dataset contains gene expression (sc-RNA-seq) and chromatin accessibility (sc-ATAC-seq) data from the same 4,825 cells. We show that both modalities together improve classification of cells by DEX-treatment time. We show how a variety of preprocessing and early-fusion modality integration methods change classification performance; regardless of the preprocessing method applied, bimodal inputs do not outperform unimodal inputs on cell-state identification, instead they tended to perform on-par with sc-RNA-seq unimodal inputs. \\

Additionally, we aimed to know how informative each modality is in classification. While both modalities play roles in improving classification, features from sc-RNA-seq are more informative than features from sc-ATAC-seq in cell-state classification. We show the first use of Sufficient Input Subsets (SIS) \cite{SIS} identifying sc genomic features -- unimodal and bimodal -- that lead to classification of cells classified with high confidence (HC).  We investigate how SIS might be useful in determining which modality is the most informative. Lastly, we use SIS on sc-RNA-seq data to understand whether SIS can be used for identifying marker genes and differentially-expressed genes, validating our findings using the original paper that developed sci-CAR \cite{sci-CAR}. \\


\section{Results}
%insert accuracy table here, name it as 'accuracy_table'
This work compared the accuracy of using several different unimodal and bimodal representations of RNA-seq and ATAC-seq data for a single-cell as inputs into a neural net classifier of cell-type. The accuracies of the neural net on the classification task in terms of the input data are presented below in Table \ref{accuracy_table}. We also output a series of confusion matrices corresponding to the classification of the neural net executed with the following datasets: Unimodal and Bimodal Raw Data without Feature Selection (Figure \ref{rawData_noFS_Confusion}), Unimodal and Bimodal Raw Data (Figure \ref{rawData_Confusion}), Unimodal and Bimodal Low-Dimensional Data (Figure \ref{LowDim_Confusion}), scAI Integration (Figure \ref{scAi_Confusion}), Unimodal and Bimodal Class-Balanced Data (Figure \ref{RawData_cb_Confusion}), Unimodal and Bimodal Class-Balanced Low-Dimensional Data (Figure \ref{LowDim_cb_Confusion}) and scAI Integration on Class-Balanced Data (Figure \ref{scAi_cb_Confusion}). Based on the results from the analyses of these datasets, we were able to make the findings presented in the following sections. \\

\begin{table}[h]
\caption{MultiClass Accuray on Datasets Analyzed: pp = pre-processed, st = stratified sampling to form test set, fs = feature-selected, cb = classes balanced using upsampling}
\label{accuracy_table}
\centering
\begin{tabular}{|l|l|}
\hline
\rowcolor[HTML]{EFEFEF} 
\multicolumn{1}{|c|}{\cellcolor[HTML]{EFEFEF}Dataset} & \multicolumn{1}{c|}{\cellcolor[HTML]{EFEFEF}\begin{tabular}[c]{@{}c@{}}Accuracy\end{tabular}} &
\hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq raw\\ pp, st\end{tabular} & 74.3\%\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq raw\\ pp, st\end{tabular} & 77.6\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, st\end{tabular} & 80\%\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq raw\\ pp, st, fs\end{tabular} & 75.5\%\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq raw\\ pp, st, fs\end{tabular} & 96.4\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, st, fs\end{tabular} & 96.0\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ 2 Factor\end{tabular} & 60.5\%\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, st, fs\end{tabular} & 69.8\%\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, st, fs\end{tabular} & 93.7\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal SVD-PCA\\ pp, st, fs\end{tabular} & 95.2\%\\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq\\ pp, fs, cb\end{tabular} & 84.7\%\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq\\ pp, fs, cb\end{tabular} & 96.9\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal\\ pp, fs, cb\end{tabular} & 96.5\%\\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal scAI\\ pp, fs, cb\end{tabular} & 55.6\% \\ \hline
\begin{tabular}[c]{@{}l@{}}ATAC-seq SVD\\ pp, fs, cb\end{tabular} & 77.1\%\\ \hline
\begin{tabular}[c]{@{}l@{}}RNA-seq PCA\\ pp, fs, cb\end{tabular} & 95.6\% \\ \hline
\begin{tabular}[c]{@{}l@{}}Bimodal concat\\ pp, fs, cb\end{tabular} & 95.5\% \\ \hline
\end{tabular}
\end{table}

\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=13cm]{Raw_Data_noFS_Confusion.png}
\caption{Confusion Matrices for the Unimodal and Bimodal Raw ATAC-seq and RNA-seq Data after Pre-Processing, Stratified Sampling A) Confusion Matrix for raw ATAC-seq data B) Confusion Matrix for raw RNA-seq data C) Confusion Matrix for Early Fusion, Bimodal concatenation of ATAC-seq and RNA-seq data}
\label{rawData_noFS_Confusion}
\end{center}
\end{figure*}


\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=13cm]{Raw_Data_Confusion.png}
\caption{Confusion Matrices for the Unimodal and Bimodal Raw ATAC-seq and RNA-seq Data after Pre-Processing, Stratified Sampling and Feature-Selection A) Confusion Matrix for raw ATAC-seq data B) Confusion Matrix for raw RNA-seq data C) Confusion Matrix for Early Fusion, Bimodal concatenation of ATAC-seq and RNA-seq data}
\label{rawData_Confusion}
\end{center}
\end{figure*}


\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=13cm]{LowDim_Data_Confusion.png}
\caption{Confusion Matrices for the Unimodal and Bimodal Low-Dimensional ATAC-seq and RNA-seq Data after Pre-Processing, Stratified Sampling and Feature-Selection A) Confusion Matrix for 50 SVD components of the ATAC-seq data B) Confusion Matrix for 30 PCA components of the RNA-seq data C) Confusion Matrix for Early Fusion, Bimodal concatenation of low dimensional ATAC-seq and RNA-seq data}
\label{LowDim_Confusion}
\end{center}
\end{figure*}


\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=9cm]{scAi_Confusion.png}
\caption{Confusion Matrices for the outputs of the scAI integration of the RNA-seq and ATAC-seq Data after Pre-Processing, Stratified Sampling and Feature-Selection A) Confusion Matrix for scAI Integration with 2 Factors B) Confusion Matrix for scAI Integration with 20 Factors}
\label{scAi_Confusion}
\end{center}
\end{figure*}


\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=13cm]{Raw_Data_CB_Confusion.png}
\caption{Confusion Matrices for the Unimodal and Bimodal ATAC-seq and RNA-seq Data after Pre-Processing, Stratified Sampling, Feature-Selection and Class Balancing A) Confusion Matrix for the class-balanced ATAC-seq data B) Confusion Matrix for the class-balanced RNA-seq data C) Confusion Matrix for Early Fusion, Bimodal concatenation of class-balanced ATAC-seq and RNA-seq data}
\label{RawData_cb_Confusion}
\end{center}
\end{figure*}

\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=13cm]{LowDim_cb_Confusion.png}
\caption{Confusion Matrices for the Unimodal and Bimodal Low-Dimensional ATAC-seq and RNA-seq Data after Pre-Processing, Stratified Sampling, Feature-Selection and Class Balancing A) Confusion Matrix for 50 SVD components of the class-balanced ATAC-seq data B) Confusion Matrix for 30 PCA components of the class-balanced RNA-seq data C) Confusion Matrix for Early Fusion, Bimodal concatenation of low dimensional class-balanced ATAC-seq and RNA-seq data}
\label{LowDim_cb_Confusion}
\end{center}
\end{figure*}

\begin{figure*}[t]
\centering
\begin{center}
\includegraphics[width=5cm]{scAi_cb_Confusion.png}
\caption{Confusion Matrices for the outputs of the scAI integration of the RNA-seq and ATAC-seq Data after Pre-Processing, Stratified Sampling, Feature-Selection and Class-Balancing}
\label{scAi_cb_Confusion}
\end{center}
\end{figure*}

\subsection{Feature selection and class balancing improve classification performance}

One aim of this study was to determine the effect on the classifier accuracy of the feature selection methodology applied to the dataset in a previous study \cite{scAI} as well as the class-balancing this work implemented. From Table \ref{accuracy_table} we can determine that both Feature Selection and Class Balancing improved the classifier accuracy. \\

The classifier accuracy on cell-type identification on the raw ATAC-seq improved from 74.3\% to 75.5\% with feature selection. With RNA-seq the accuracy improved from 77.6\% to 96.4\%. Early Fusion, concatenated Bimodal data saw similar levels of accuracy improvement, from 80\% to 96.0\%. These results show the efficacy of feature selection in driving neural net classifier accuracy. This is an expected outcome as the feature selection method was designed select the genes and loci that are differentially expressed between the cell groups. However it is interesting that the feature selection seems to drive larger accuracy improvements in the analyses involving RNA-seq data. One possible explanation is that the mRNA expression is more differentially expressed between hours of DEX treatment than chromatin accessibility loci, another is that the sparsity of ATAC-seq data affects the ability of the feature selection method to identify significantly differentiated loci. \\

\begin{table}[t]
\centering
\caption{Comparison of MultiClass Accuracy on Datasets with Feature Selection versus without}
\label{tab:ClassAcc}
\begin{tabular}{|c|c|c|}
\hline
\rowcolor[HTML]{EFEFEF} 
{Dataset}                                                                  & {\begin{tabular}[c]{@{}c@{}}Imbalanced\\ Data\end{tabular}} & {\begin{tabular}[c]{@{}c@{}}Balanced\\ Data\end{tabular}} \\ \hline
Raw ATAC-seq                                                                      & 74.3\%                                                             & 75.5\%                                                           \\ \hline
Raw RNA-seq                                                                       & 77.6\%                                                             & 96.4\%                                                           \\ \hline
\begin{tabular}[c]{@{}c@{}}Bimodal \\ Concatenation\end{tabular}                  & 80.0\%                                                             & 96.0\%                                                           \\ \hline
\end{tabular}
\end{table}

In addition to Feature Selection, correcting the imbalanced classes via upsampling also produced an improvement in classifier accuracy across all datasets. The accuracy between imbalanced and balanced datasets can be seen in Table \ref{tab:ClassAcc}. While performing class balancing produced slight benefits on the datasets that already contained the RNA-seq information, it produced larger increases in accuracy on the ATAC-seq data. One interpretation of this finding is that the differential features between classes are less pronounced in ATAC-sec data. Another is that the class-balancing is better able to express differentiating features in ATAC-sec data than the previous feature selection method. \\

These findings show the value of performing feature selection as well as class balancing on single-cell omics data before use in neural network architectures. According to these findings, the feature selection process was better able to improve the informative content of RNA-seq compared to ATAC-seq. While Class-Balancing was able to produce a larger increase in accuracy for classifiers working with ATAC-seq data compared to datasets with RNA-seq data, it is important to note this was after Feature Selection was already performed. It is possible that the informative content in RNA-seq had already been maximized so that Class-Balancing was unable to add significantly more to it. \\

\begin{table}[t]
\centering
\caption{Comparison of MultiClass Accuracy on Datasets that are Class Imbalanced versus Balanced}
\label{tab:ClassAcc}
\begin{tabular}{|c|c|c|}
\hline
\rowcolor[HTML]{EFEFEF} 
{Dataset}                                                                  & {\begin{tabular}[c]{@{}c@{}}Imbalanced\\ Data\end{tabular}} & {\begin{tabular}[c]{@{}c@{}}Balanced\\ Data\end{tabular}} \\ \hline
Raw ATAC-seq                                                                      & 75.7\%                                                             & 84.7\%                                                           \\ \hline
Raw RNA-seq                                                                       & 96.4\%                                                             & 96.9\%                                                           \\ \hline
\begin{tabular}[c]{@{}c@{}}Bimodal \\ Concatenation\end{tabular}                  & 96.0\%                                                             & 96.9\%                                                           \\ \hline
ATAC-seq SVD                                                                      & 69.8\%                                                             & 77.1\%                                                           \\ \hline
RNA-seq PCA                                                                       & 93.7\%                                                             & 95.6\%                                                           \\ \hline
\begin{tabular}[c]{@{}c@{}}Low Dimensional\\ Bimodal\\ Concatenation\end{tabular} & 95.2\%                                                             & 95.5\%                                                           \\ \hline
\end{tabular}
\end{table}

\subsection{Early Fusion Bimodal inputs outperform scAI Multimodal Integration but perform similarly to RNA-seq inputs}

This study explored the value of creating multimodal representations of single-cell omics data in a neural net classification task. Table \ref{accuracy_table} shows the accuracy of classifier on the different datasets. One method of multimodal integration we evaluated was Early Fusion Bimodal, which involved the concatenation of the unimodal data. We find that Bimodal concatenation fails to consistently outperform the RNA-seq data. The classifier run on the Early Fusion Bimodal datasets outperform the RNA-seq data for the non-feature-selected datasets and the low-dimensional representation of the data, however the improvement is small, 2.6\% and 1.5\% difference, respectively. In all other cases the RNA-seq dataset outperforms the Bimodal concatenation dataset. This seems to imply that the majority of the informative content is present in the mRNA expression and that there is only slightly more information provided by the inclusion of the ATAC-seq data into the Bimodal representation. These results indicate that RNA-seq may be informative enough to use for cell-type identification unimodally rather than leveraging bimodal representations. \\

This work also compared the relatively simple Early Fusion Bimodal representations with the novel, complex scAI multimodal integration method designed for integrating single cell RNA-seq and ATAC-seq data. However, on the Class-Balanced datasets for both the Raw Data and the Low-Dimensional Data, the classifier accuracy for the Bimodal Datasets, 96.5\% for the Bimodal Raw Data concatenation and 95.5\% for the Bimodal Low-Dimensional concatenation, far outperforms that of the scAI Integration output, 55.6\%. Despite the complex learning methods employed by scAI in order to integrate multiple single cell-omics modalities and represent them lower dimensionally, the outputs seem ill-suited for cell-type classification via neural nets. Instead a computationally simpler method such as Early Fusion may be more optimal for neural net applications. \\

\subsection{RNA-seq is more informative than ATAC-seq in cell-type identification}

% RNA-seq is more informative
We aimed to know which of the two modalities was more informative for classifying cells by cell state (i.e. amt of time treated with DEX). We provide two supporting pieces of evidence that RNA-seq is more informative for this classification task. The first is that models trained only on RNA-seq data performed better under every type of pre-processing, feature selection, and dimensionality-reduction method we applied equally to both modalities.  Table \ref{accuracy_table} shows the test accuracies of each model trained on a variety of data processing methods. In every case, models trained only on RNA-seq performed better than models trained only on ATAC-seq, suggesting that RNA-seq is better equipped to identify A549 cells by their cell state in this experimental context. \\ 

The second supporting evidence comes from analyzing the features that were most important for classification.  We found all Sufficient Input Subsets of features for each cell classified with high confidence ($P(class | data) \geq 0.7$). Given these disjoint subsets, we computed the percent of high-confident (HC) cells  that relied on each feature for each of the three classes (0 hr, 1 hr, & 3 hrs). Table \ref{sis-features} ranks these features and colors the feature name by the modality it came from. It's evident that features from RNA-seq are most needed to classify HC cells treated with DEX for 0 hrs and 3 hrs. Features generated from the ATAC-seq modality were most necessary to classify HC cells treated for 1 hr, yet most subsets also relied on features from RNA-seq as well. Together, this implies that features from both RNA-seq and ATAC-seq are necessary for classifying by cell state, yet RNA-seq is largely more informative than ATAC-seq for this classification task. \\


% Please add the following required packages to your document preamble:
% \usepackage{graphicx}
% \usepackage[table,xcdraw]{xcolor}
% If you use beamer only pass "xcolor=table" option, i.e. \documentclass[xcolor=table]{beamer}
\begin{table*}[t]
\centering
\resizebox{12cm}{!}{%
\begin{tabular}{|
>{\columncolor[HTML]{FFFFFF}}l |
>{\columncolor[HTML]{FFFFFF}}l |
>{\columncolor[HTML]{FFFFFF}}l |
>{\columncolor[HTML]{FFFFFF}}l |
>{\columncolor[HTML]{FFFFFF}}l |
>{\columncolor[HTML]{FFFFFF}}l |}
\hline
\multicolumn{2}{|c|}{\cellcolor[HTML]{EFEFEF}{\color[HTML]{333333} \textbf{0 hr DEX-treatment}}} & \multicolumn{2}{c|}{\cellcolor[HTML]{C0C0C0}{\color[HTML]{333333} \textbf{1 hr DEX-treatment}}} & \multicolumn{2}{c|}{\cellcolor[HTML]{9B9B9B}{\color[HTML]{333333} \textbf{3 hr DEX-treatment}}} \\ \hline
\textbf{Feature} & \textbf{\begin{tabular}[c]{@{}l@{}}\% HC Cells \\ Relying \\ on Feature\end{tabular}} & \textbf{Feature} & \textbf{\begin{tabular}[c]{@{}l@{}}\% HC Cells \\ Relying \\ on Feature\end{tabular}} & \textbf{Feature} & \textbf{\begin{tabular}[c]{@{}l@{}}\% HC Cells \\ Relying \\ on Feature\end{tabular}} \\ \hline
{\color[HTML]{FE0000} RNA 2} & 97.2 & {\color[HTML]{3531FF} ATAC 1} & 90.8 & {\color[HTML]{FE0000} RNA 2} & 95.2 \\ \hline
{\color[HTML]{FE0000} RNA 4} & 18.2 & {\color[HTML]{FE0000} RNA 7} & 54.0 & {\color[HTML]{FE0000} RNA 7} & 24.7 \\ \hline
{\color[HTML]{FE0000} RNA 1} & 8.2 & {\color[HTML]{3531FF} ATAC 2} & 29.9 & {\color[HTML]{FE0000} RNA 4} & 18.1 \\ \hline
{\color[HTML]{3531FF} ATAC 31} & 5.5 & {\color[HTML]{FE0000} RNA 3} & 27.6 & {\color[HTML]{FE0000} RNA 9} & 11.4 \\ \hline
{\color[HTML]{FE0000} RNA 17} & 4.5 & {\color[HTML]{FE0000} RNA 9} & 20.1 & {\color[HTML]{3531FF} ATAC 1} & 10.5 \\ \hline
{\color[HTML]{3531FF} ATAC 44} & 4.5 & {\color[HTML]{FE0000} RNA 1} & 19.5 & {\color[HTML]{3531FF} ATAC 2} & 6.7 \\ \hline
{\color[HTML]{3531FF} ATAC 34} & 3.6 & {\color[HTML]{FE0000} RNA 11} & 16.1 & {\color[HTML]{FE0000} RNA 11} & 6.7 \\ \hline
{\color[HTML]{3531FF} ATAC 12} & 3.6 & {\color[HTML]{FE0000} RNA 12} & 10.3 & {\color[HTML]{FE0000} RNA 1} & 5.7 \\ \hline
{\color[HTML]{3531FF} ATAC 4} & 3.6 & {\color[HTML]{FE0000} RNA 17} & 8.0 & {\color[HTML]{FE0000} RNA 13} & 3.8 \\ \hline
{\color[HTML]{3531FF} ATAC 38} & 3.6 & {\color[HTML]{FE0000} RNA 4} & 4.6 & {\color[HTML]{FE0000} RNA 16} & 3.8 \\ \hline
\end{tabular}%
}
\\ 
\\
\\
\caption{Importance of features from low-dimensional bimodal input: sufficient input subsets were generated from each cell classified with high confidence (HC) ($P(class|data) \geq 0.7 $).  This table shows the percent of the HC cells from each class that relied on a given feature to maintain high confidence. The bimodal input was built by concatenating the top 30 principal components from RNA-seq and the top 50 singular vectors from ATAC-seq. The integers in each feature name represent the rankings of each feature in explaining variance within each modality. E.g. RNA 1 is the PC that explains the most variance in the RNA-seq modality; ATAC 2 is the singular vector that explains the second most variance in the ATAC-seq modality.}
\label{sis-features}
\end{table*}


% RNA-seq may capture much of the same information important for cell-type classification
It's important to note that these results come from a concatenation of the lower-dimensional versions of two very high-dimensional datasets. Because this dataset relies entirely on the principal components of RNA-seq and the singular vectors from ATAC-seq, it's difficult to know exactly which mRNA and chromatin sites are most needed to determine cell state. It's possible that the most important features from each modalities actually represent the same biological features inside these cells.  However, our computational resources precluded us from using SIS on the high-dimensional versions of these modalities to know this. We leave another SIS analysis on high-dimensional RNA-seq and ATAC-seq for a future work. \\


\subsection{SIS may be a useful alternative method to finding marker or DE genes}

\begin{table}[h]
\caption{Using features in SIS to identify marker and DE genes. Note that no sufficient input subsets were found for the 3hr class, preventing us from finding any additional marker genes or validating the amount of DE genes}
\centering
\begin{tabular}{|l|l|l|l|}
\hline
\rowcolor[HTML]{EFEFEF} 
Class & \begin{tabular}[c]{@{}l@{}}Number of RNA-seq \\ features in  $\geq$ 1 SIS\end{tabular} & \begin{tabular}[c]{@{}l@{}}Marker Genes\\ Found\end{tabular} & \begin{tabular}[c]{@{}l@{}}\% SIS features\\ that were DE\end{tabular} \\ \hline
0 hr & 154 & 0 & 83.7 \\ \hline
1 hr & 101 & 1 (NFKBIA) & 91.1 \\ \hline
\end{tabular} 
\\ 

\label{tab:marker-genes}
\end{table}

Using the SIS method to understand which features most contribute to cell-state classification naturally raised the question of whether SIS could find marker genes and differentially-expressed genes. We found the sufficient input subsets after training our neural network on sc-RNA-seq features only, following feature selection (1185 features in total). Similarly to the previous section, we found the percent of high-confidence cells that rely on each of the features found in at least one subset.  We then compared the expressed genes found using SIS with those found in the original paper that introduced the sci-CAR method. SIS found one gene (NFKBIA) that was named a marker gene in DEX-treated cells. A vast majority of the genes found in SIS were also classified as differentially-expressed genes. \\

Table \ref{tab:marker-genes} summarizes these results for HC cells classified as treated for 0 hr and 1 hr. No subsets were found for HC cells classified as 3 hr, preventing us from finding any additional marker genes beyond NFKBIA. \\


\section{Discussion and Summary}

In this work we were able to explore a number of novel applications of machine learning to single-cell omics data. We evaluated the application of neural networks to unimodal and multimodal single-cell data as well as the use of Sufficient Input Subsets on the Neural Network Architecture to determine relevant informative single-cell omis data features. \\

We explored the value of Feature-Selection and Class-Balancing of the single-cell omics data for Neural Net Architectures. Both approaches drove accuracy increases on the classification task, but the Feature Selection seemed to drive the informative content of RNA-seq data, while Class Balancing produced significant accuracy increases in only the ATAC-seq Data. This points to a need for better methods of extracting informative content from ATAC-seq data for classification. \\

An important aim of this study was to probe the informative value of integrating multiple single-ell omics modality, either through simpler Early Stage Fusion or a novel single-cell omics method, scAI. In this classification task, neither bimodal structure was able to provide significant increases in accuracy -- the more complex scAI method failed to produce a meaningful level of accuracy (55.6\%). In fact, for this specific task it appears the RNA-seq contained the majority of the informative content required to perform the cell-type classification task. This finding suggests that for cell-type classification, bimodal data inputs may not hold any advantages. \\

The novel application of SIS to lower dimensional multimodal single-cell omics data was able to successfully identify the informative value of RNA-seq data over ATAC-seq data in making the class identifications. This represents a novel method of identifying the informative value of one modality within a joint bimodal data representation in cell-type classification. \\

Finally, SIS was also explored as a novel method of identifying marker or DE genes of cell state. By applying SIS to the network trained on the RNA-seq data, it was possible to identify a known marker gene of DEX-indued cell-state, (NFKBIA) as well as differentially-expressed genes as confirmed by previous research \cite{sci-CAR}. \\

This work explores a novel area of applying deep learning within the rapidly developing field of unimodal and multimodal single-cell omics. We explored the feasibility and logistics around preparing and structuring data for neural networks, while also showing the value of these novel applications. Other multimodal integration methods, such as MOFA, need to be explored to determine their efficacy in leveraging the informative content of multiple single-cell modalities. Additionally, future research should look at the value of integrating modalities in other biomodal datasets (such as CITE-seq) for cell-type identification. Finally, there is promising future work to be done in further developing SIS as a method of identifying differentially-expressed or marker genes. \\

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

\appendices
\section{Division of Labor }
Taylor built, trained, and tested all neural network models for classification; performed the sufficient input subset analysis on features from each dataset; validated results with the sci-CAR paper; and created UMAP and t-SNE plots of each dataset. \\

Oliver wrote the Python and R code for processing and upsampling the pre-processed data as well as performing the various dimensionality reductions on the scRNA-seq and ATAC-seq data; utilization of the scAI toolkit to create multi-modal integration datasets. \\
 

\section{Code}
Taylor wrote the code for extracting data from the Gene Expression Omnibus (GEO), visualizing the data using UMAP/t-SNE, neural network classification and evaluation, computing feature importance by aggregating features from all SIS, and analyzing the important features. \\

Code for computing the sufficient input subsets was modified from: \href{https://github.com/google-research/google-research/blob/master/sufficient_input_subsets/tutorials/sis_mnist_tutorial.ipynb}{Google Research's tutorial (link)} on applying SIS to MNIST digits. \\ 

Oliver wrote the code for extracting the pre-processed A549 dataset from the scAI vignette, upSampling, as well as execution of the scAI toolkit in R, and extraction to Python for dimensionality reduction and processing. \\

Code for utilizing the scAI toolkit as well as the A549 dataset analysis was modified from:
\href{https://github.com/sqjin/scAI}{scAI: a single cell Aggregation and Integration method for analyzing single cell multi-omics data (link)} \\


% use section* for acknowledgment
\section*{Acknowledgment}
We'd like to thank Professors Gifford and Kellis as well as the incredibly helpful teaching assistants Sachit, Tim, and Corban for teaching us many of the concepts needed to complete this project.
