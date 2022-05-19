import pandas as pd
import seaborn as sns
import argparse

# timeline = pd.DataFrame([x for x in range(0,int(productiontime*100))]) # adjusted by bash
residues = pd.DataFrame([x for x in range(0,int(rmsfresidues))]) # adjusted by bash


def plot_validation(result_csv: str) -> bool:
    df = pd.read_csv(result_csv, sep='\s+', engine='python')
    # df['Time'] = timeline
    # df['Time'] = df/100
    # df.drop('#Frame', axis=1, inplace=True)

    # Radius of gyration

    plot_rog = sns.lineplot(x='#Frame', y="radius", data=df)
    plot_rog.set_xlabel("Time [ns]")
    plot_rog.set_ylabel("Radius of gyration [A]")
    plot_rog.set(ylim=(20,40))
    fig = plot_rog.get_figure()
    fig.savefig(f"{result_csv}_rog.png")
    fig.clf()
    # Ligand RMSD

    plot_lig = sns.lineplot(x='#Frame', y="ligand_rmsd", data=df)
    plot_lig.set_xlabel("Time [ns]")
    plot_lig.set_ylabel("RMSD [A]")
    plot_lig.set(ylim=(0,5))
    fig_lig = plot_lig.get_figure()
    fig_lig.savefig(f"{result_csv}_ligand_rmsd.png")


    fig.clf()

    # # Protein RMSD
    # plot_prot = sns.distplot(df, x=df['distplot'])
    # plot_prot.set_xlabel("RMSD [A]")
    # plot_prot.set_ylabel("Fraction of simulation")
    # fig = plot_prot.get_figure()
    # fig.savefig(f"{result_csv}_prot_rmsd.png")
    # fig.clf()

    # RMSF

    rmsf_df= pd.DataFrame(residues, columns=[''])
    rmsf_df['RES'] = residues
    rmsf_df['RMSF'] = df['rmsf'][0:543]
    plot = sns.lineplot(x='RES', y="RMSF", data=rmsf_df)
    plot.set_xlabel("Residue")
    plot.set_ylabel("B-factor")
    fig = plot.get_figure()
    fig.savefig(f"{result_csv}out_RMSF.png")
    fig.clf()


    #SASA
    plot_rog = sns.lineplot(x='#Frame', y="SASA", data=df)
    plot_rog.set_xlabel("Time [ns]")
    plot_rog.set_ylabel("SASA [A^2]")
    fig = plot_rog.get_figure()
    fig.savefig(f"{result_csv}_SASA.png")
    fig.clf()

    #C, CA, N, O
    df_cacno = df[['Time', 'CA','C','N','O']]
    newdf = df_cacno.melt('#Frame', var_name="Atom", value_name='vals')
    plot = sns.lineplot(x=newdf['Time'], y="vals", hue='Atom', data=newdf)
    plot.set_xlabel("Time [ns]")
    plot.set_ylabel("RMSD [A]")
    plot.set(ylim =(0,10))
    fig = plot.get_figure()
    fig.savefig(f"{result_csv}_cacno.png")

inputdata = argparse.ArgumentParser(description="Validate")

inputdata.add_argument('-i', '--input-file', nargs='*',
                       help="Input csv", required=True, )

args = inputdata.parse_args()
convert = plot_validation(result_csv=args.input_file[0])

