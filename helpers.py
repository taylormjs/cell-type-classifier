'''
Script containing useful pre-processing functions on matrices prior
to input into ML models. This assumes matrices have already been loaded
from any previous files (e.g. excel, .dat, .m, etc)
'''

# native imports
import os
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
import scipy.io # for plotting .mat files


# third party imports
import pickle
import gzip # for compression/decompression
from tqdm import tqdm
import rampy as rp
from matplotlib.backends.backend_pdf import PdfPages #showing images as PDFs

# local imports


''' Make sure module is imported correctly'''
def module_imported():
    print('preprocess imported')
    print('module name : {} module package: {}'.format(__name__, __package__))
    
module_imported()


##############################################################
############ SAVING AND LOADING PICKLE FILES #################
##############################################################

def write_zipped_pickle(obj, filename, protocol=-1):
    """

    :param obj:
    :param filename:
    :param protocol:
    :return:
    """
    with gzip.open(filename, 'wb') as f:
        pickle.dump(obj, f, protocol)


def read_pickle(filename):
    """
    Read pickle file which may be zipped or not
    :param filename:
    :return:
    """
    try:
        with gzip.open(filename, 'rb') as f:
            loaded_object = pickle.load(f)
            return loaded_object
    except OSError:
        with open(filename, 'rb') as f:
            loaded_object = pickle.load(f)
            return loaded_object
    
    
    
#####################################################
####### Basic functions for Dataframe Editing #######
#####################################################
    
    
def split_column(df, col_to_split, delim='_', col1_name='day', col2_name='position',
                    col1_ix=1, col2_ix=2):
    ''' 
        Given a df, splits column col_to_split by delimiter
        and adds to df as two columns
    '''
    assert (col1_name not in df.columns), 'column 1 already exists'
    assert (col2_name not in df.columns), 'columns 2 already exists'
    split_name = [str.split(name, sep=delim) for name in df[col_to_split]]
    col1 = [e[0] for e in split_name]
    col2 = [e[1] for e in split_name]
    df.insert(col1_ix, col1_name, col1, False)
    df.insert(col2_ix, col2_name, col2, False)
    return df


def to_dataframe(matrix, label_df, column_names=None):
    ''' 
        Given a matrix (numpy), converts to pandas DataFrame with given
        labels and column names. Labels are need for easy plotting by day
    '''
    assert matrix.shape[0] == label_df.shape[0], 'matrix and labels are not the same shape, cannot be concatenated'
    if column_names:
        # cast to pandas matrix with column names
        spectra_df = pd.DataFrame(data=matrix, columns=column_names)
    else:
        spectra_df = pd.DataFrame(data=matrix)
    # concatenate labels with matrix along axis=1
    return pd.concat([label_df, spectra_df], axis=1) 



#####################################################
############## Mean substraction ####################
#####################################################

def subtract_mean_horizontal(df):
    '''
        standardizes by subtracting mean horizontally, moving all 
        to around 0
    '''
    return df - np.mean(df, axis=1, keepdims=True)

