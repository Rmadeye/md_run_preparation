#!/usr/bin/env python

import argparse
import os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from typing import Mapping, MutableMapping, Sequence, Iterable

def list_csv_inputs(path: os.path) -> list:
    """Make a list of csvs available from path"""
    return [os.path.join(path, x) for x in os.listdir(path) if x.endswith('.csv')]

def check_sim_length_and_prepare_plotting_inputs(df: pd.DataFrame) -> tuple[int, int, int, int]:
    """returns total amount of frames saved from trajectories and number of repetitions"""
    
    total_length = len(df)
    rep_number = int(str(total_length)[-2:]) -1
    xtickslabels = [str(x) for x in range(1,rep_number+1)]
    axvline_position = [x for x in range(0,total_length, int(total_length/rep_number))]
    return (total_length, rep_number, xtickslabels, axvline_position)


def vertical_lines(color, positions: list) -> plt:
    """Plot vertical lines for figure clarity"""
    for x in positions:
        plt.axvline(x, color = 'w', linewidth=3)
        plt.axvline(x, color = 'black', linestyle=':')  

def prepare_dataframe_for_analysis(csv: str, ligname=None) -> pd.DataFrame:
    """Read a data from csv, add column with ligand identifier """
    df = pd.read_csv(csv, sep = "\s+")
    if not ligname:
        df['ligand'] = csv.split('/')[-1].rstrip('.csv') # If you do not want custom labels, default will be extracted from path
    else:
        df['ligand'] = ligname
    return df

def generate_ca_figues(df: pd.DataFrame, custom_labels = True) -> plt:
    sns.set(font_scale = 1.5, style = 'white') # custom setting of plot style
    df = df[['#Frame','CA','ligand']]
    check_df = df.loc[df.ligand == df.ligand.unique()[0]] # take first ligand from df get info about simulations
    siminfo = check_sim_length_and_prepare_plotting_inputs(check_df)
    g = sns.FacetGrid(df, col='ligand', height = 6, col_wrap=3)
    g.map(sns.lineplot,"#Frame","CA")
    if custom_labels:
        total_length, rep_number, xtickslabels, axvline_position = siminfo
        g.map(vertical_lines, positions=axvline_position)
        g.set(xlabel = 'Simulation', ylabel = 'CA RMSD [A]', xticks=np.arange(
            (total_length/rep_number)/2,
            total_length+(total_length/rep_number/2),
             total_length/rep_number),
        xticklabels=xtickslabels, ylim=(0,df.CA.max()+2)
        )
    else:
        g.set(xlabel = 'Simulation', ylabel = 'CA RMSD [A]')
    g.savefig('ca.png')

def generate_rg_figues(df: pd.DataFrame, custom_labels = True) -> plt:
    sns.set(font_scale = 1.5, style = 'white')
    df = df[['#Frame','radius','ligand']]
    check_df = df.loc[df.ligand == df.ligand.unique()[0]]
    siminfo = check_sim_length_and_prepare_plotting_inputs(check_df)
    g = sns.FacetGrid(df, col='ligand', height = 6, col_wrap=3)
    g.map(sns.lineplot,"#Frame","radius")
    if custom_labels:
        total_length, rep_number, xtickslabels, axvline_position = siminfo
        g.map(vertical_lines, positions=axvline_position)
        g.set(xlabel = 'Simulation', ylabel = 'Rg [A]', xticks=np.arange(
            (total_length/rep_number)/2,
            total_length+(total_length/rep_number/2),
             total_length/rep_number),
        xticklabels=xtickslabels, ylim = (df.radius.min() - 10, df.radius.max() + 10))

    else:
        g.set(xlabel = 'Simulation', ylabel = 'Rg [A]')
    g.savefig('rg.png')


def generate_lig_rmsd_figues(df: pd.DataFrame, custom_labels = True) -> plt:
    sns.set(font_scale = 1.5, style = 'white')
    df = df[['#Frame','ligand_rmsd','ligand']]
    check_df = df.loc[df.ligand == df.ligand.unique()[0]]
    siminfo = check_sim_length_and_prepare_plotting_inputs(check_df)
    g = sns.FacetGrid(df, col='ligand', height = 6, col_wrap=3)
    g.map(sns.lineplot,"#Frame","ligand_rmsd")
    if custom_labels:
        total_length, rep_number, xtickslabels, axvline_position = siminfo
        g.map(vertical_lines, positions=axvline_position)
        g.set(xlabel = 'Simulation', ylabel = 'Ligand RMSD [A]', xticks=np.arange(
            (total_length/rep_number)/2,
            total_length+(total_length/rep_number/2),
             total_length/rep_number), ylim = (0, df.ligand_rmsd.max() + 2),
        xticklabels=xtickslabels)

    else:
        g.set(xlabel = 'Simulation', ylabel = 'Ligand RMSD [A]')
    g.savefig('lig_rmsd.png')


def generate_sasa_figures(df: pd.DataFrame, custom_labels = True) -> plt:
    sns.set(font_scale = 1.5, style = 'white')
    df = df[['#Frame','SASA','ligand']]
    check_df = df.loc[df.ligand == df.ligand.unique()[0]]
    siminfo = check_sim_length_and_prepare_plotting_inputs(check_df)
    g = sns.FacetGrid(df, col='ligand', height = 6, col_wrap=3)
    g.map(sns.lineplot,"#Frame","SASA")
    if custom_labels:
        total_length, rep_number, xtickslabels, axvline_position = siminfo
        g.map(vertical_lines, positions=axvline_position)
        g.set(xlabel = 'Simulation', ylabel = 'SASA [A2]', xticks=np.arange(
            (total_length/rep_number)/2,
            total_length+(total_length/rep_number/2),
            total_length/rep_number),
        xticklabels=xtickslabels, ylim = (df.SASA.min() - 50, df.SASA.max() + 50))

    else:
        g.set(xlabel = 'Simulation', ylabel = 'SASA [A2]')
    g.savefig('sasa.png')

def generate_ligand_distance(df: pd.DataFrame, custom_labels = True) -> plt:
    sns.set(font_scale = 1.5, style = 'white')
    df = df[['#Frame','SASA','ligand']]
    check_df = df.loc[df.ligand == df.ligand.unique()[0]]
    siminfo = check_sim_length_and_prepare_plotting_inputs(check_df)
    g = sns.FacetGrid(df, col='ligand', height = 6, col_wrap=3)
    g.map(sns.lineplot,"#Frame","ligand_distance")
    if custom_labels:
        total_length, rep_number, xtickslabels, axvline_position = siminfo
        g.map(vertical_lines, positions=axvline_position)
        g.set(xlabel = 'Simulation', ylabel = 'ligand_distance [A]', xticks=np.arange(
            (total_length/rep_number)/2,
            total_length+(total_length/rep_number/2),
            total_length/rep_number),
        xticklabels=xtickslabels, ylim = (df.SASA.min() - 50, df.SASA.max() + 50))

    else:
        g.set(xlabel = 'Simulation', ylabel = 'ligand_distance [A]')
    g.savefig('sasa.png')

def plot_trajectory_analysis_generate_statistics(input_path: str) -> tuple[plt,pd.DataFrame]:

    csv_input = list_csv_inputs(input_path)
    df = pd.concat(
    [
        *[prepare_dataframe_for_analysis(x) for x in csv_input]
    ], axis=0, ignore_index=True
                        )
    try:
        generate_ca_figues(df=df)
        generate_rg_figues(df=df)
        generate_lig_rmsd_figues(df=df)
        generate_sasa_figures(df=df)
        generate_ligand_distance(df=df)
    except Exception as e:
        print(e)
        pass

    out_df = df[['radius','ligand_rmsd','CA','SASA']].groupby(by=df.ligand).agg({'mean','std'}).round(2)

    table_csv = pd.DataFrame(columns=['Rg','lig_rmsd','CA','SASA'])
    table_csv['Rg'] = out_df.radius['mean'].astype(str) + ' +- ' + out_df.radius['std'].astype(str)
    table_csv['lig_rmsd'] = out_df.ligand_rmsd['mean'].astype(str) + ' +- ' + out_df.ligand_rmsd['std'].astype(str)
    table_csv['CA'] = out_df.CA['mean'].astype(str) + ' +- ' + out_df.CA['std'].astype(str)
    table_csv['SASA'] = out_df.SASA['mean'].astype(str) + ' +- ' + out_df.SASA['std'].astype(str)
    table_csv.to_csv("statistics.csv")


plot_trajectory_analysis_generate_statistics('../_3/')


