#!/usr/bin/env python
# coding: utf-8

# Script that runs simulations of
# Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop
# and generates the plots used in the documentation of that model.

import os
import shutil
from multiprocessing import Pool

import numpy as np
import pandas as pd
import plotly.express as px
import plotly.graph_objs as go
import plotly.io as pio
from buildingspy.io.outputfile import Reader
from buildingspy.simulate.Dymola import Simulator

# Configuration commands
pio.templates["local_template"] = go.layout.Template(layout=go.Layout(
    font=dict(color='#000000', size=16),
    margin=dict(l=20, r=20, t=40, b=40),
    # yaxis=dict(tickformat='.1e'),
))
pio.templates.default = "plotly_white+local_template"


def simulateCase(s):
    """Set common parameters and run a simulation with buildingspy.

    Args:
        s (buildingspy.simulate.Dymola.Simulator): simulator object
    """
    s.setSolver("Cvode")
    s.setTolerance(1e-6)
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate()


def read_mat(mat_path, var_names):
    """Read result file.mat and returns a data frame.

    Args:
        mat_path (str): path of mat file
        var_names (list): list of variables names

    Returns:
        pandas.core.frame.DataFrame: data frame with variable values
    """
    r = Reader(mat_path, "dymola")
    df = pd.DataFrame()
    for var in var_names:
        tmp = dict()
        (tmp['time'], tmp['val']) = r.values(var)
        tmp = pd.DataFrame(tmp)
        tmp['variable'] = var
        df = pd.concat([df, tmp])
    return df


def main(dirname, asy=True):
    case_list = []
    case_param = pd.DataFrame()
    for valve in ['EL', 'LL']:
        for is_bal in (False, True):
            for psi in psi_rge:
                for beta in beta_rge:
                    kSizPum = round(3 / 7 / psi, 2)  # kSizPum = 1 => psi = 3/7
                    dpValve = round(beta * dpTer / (1 - beta))
                    out_dir = os.path.join(dirname, 'results', f'{valve}_{is_bal}_{psi}_{beta}')
                    case_param = pd.concat([
                        case_param,
                        pd.DataFrame(
                            dict(
                                valve=[valve],
                                is_bal=[is_bal],
                                psi=[psi],
                                beta=[beta],
                                kSizPum=[kSizPum],
                                dpValve=[dpValve],
                                out_dir=[out_dir],
                            ))
                    ])
                    s = Simulator(class_name, packagePath=package_path, outputDirectory=out_dir)
                    if valve == 'EL':
                        typCha = 'Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage'
                    elif valve == 'LL':
                        typCha = 'Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Linear'
                    else:
                        typCha = None
                    modif = (f'typCha={typCha}, '
                             f'is_bal={str(is_bal).lower()}, '
                             f'dpValve_nominal={dpValve}, '
                             f'kSizPum={kSizPum}')
                    s.addModelModifier(modif)
                    s.setStopTime(stop_time)
                    case_list.append(s)

    # Run all cases in parallel
    po = Pool()
    if asy:
        po.map_async(simulateCase, case_list)
    else:
        po.map(simulateCase, case_list)

    return case_param


if __name__ == '__main__':
    # Configure and run simulations
    dpTer = 3e4

    psi_rge = np.linspace(0.1, 0.4, num=7).round(2)  # dpCoil / dpPump at design
    beta_rge = np.linspace(0.1, 0.7, num=7).round(2)  # valve authority

    class_name = 'Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop'
    stop_time = 300
    dirname = os.path.realpath(os.path.dirname(__file__))
    package_path = os.path.abspath(os.path.join(dirname, *[
        os.pardir,
    ] * 7, 'Buildings'))

    case_param = main(dirname=dirname, asy=False)

    # Process results

    df = pd.DataFrame()
    var_names = [
        'con.val.dp1',
        'con.val.dp3',
        'ope.y[1]',
        'ope.y[2]',
        'con.val.m1_flow',
        'con.val.m3_flow',
        'pum.m_flow',
        'con1.val.m1_flow',
        'con1.val.m3_flow',
        'pum.dpMachine',
        'loa.Q_flow',
        'loa.Q_flow_nominal',
        'con.m2_flow_nominal',
        'con1.m2_flow_nominal',
        'loa1.Q_flow',
        'loa1.Q_flow_nominal',
        'dT1.y',
        'mPum_flow_nominal',
    ]

    for out_dir in case_param.out_dir:
        mat_path = os.path.join(out_dir, f'{class_name.split(".")[-1]}.mat')
        tmp = read_mat(mat_path, var_names)
        tmp['case'] = os.path.split(out_dir)[-1]
        for k in case_param.columns:
            if k == 'case':
                tmp[k] = os.path.split(out_dir)[-1]
            elif k != 'out_dir':
                tmp[k] = case_param.set_index('out_dir').at[out_dir, k]
        df = pd.concat([df, tmp])

    # Bypass flow for valve closed

    valve = 'EL'
    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 0), 'time'].values

    fig = px.scatter(df.loc[(df.valve == valve) & (df.variable == 'con.val.m3_flow') & df.time.isin(time_values)],
                     labels=dict(psi=r'$\psi \text{ (-)}$',
                                 val=r'$ \dot{m}_{bypass}(y=0\%) / \dot{m}_{design} \text{ (-)}$',
                                 beta=r'<i>β</i> (-)'),
                     x='psi',
                     y='val',
                     color='beta',
                     facet_col='is_bal')
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mBypass.svg'))
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mBypass.png'))

    # Direct flow for valve open

    valve = 'EL'
    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 1), 'time'].values

    fig = px.scatter(df.loc[(df.valve == valve) & (df.variable == 'con.val.m1_flow') & df.time.isin(time_values)],
                     labels=dict(psi=r'$\psi \text{ (-)}$',
                                 val=r'$ \dot{m}_{direct}(y=100\%) / \dot{m}_{design} \text{ (-)}$',
                                 beta=r'<i>β</i> (-)'),
                     x='psi',
                     y='val',
                     color='beta',
                     facet_col='is_bal')
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mDirect.svg'))
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mDirect.png'))

    # Heat flow rate (fractional) at 100% valve opening

    for c in pd.unique(df.case):
        tmp = df.loc[(df.case == c) & (df.variable == 'loa.Q_flow')].copy()
        tmp['variable'] = 'loa.Q_flow/Q_flow_nominal'
        tmp['val'] = tmp['val'] / df.loc[(df.case == c) & (df.variable == 'loa.Q_flow_nominal')].loc[0, 'val']
        df = pd.concat([df, tmp])

    valve = 'EL'
    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 1.0), 'time'].values

    fig = px.scatter(
        df.loc[(df.valve == valve) & (df.variable == 'loa.Q_flow/Q_flow_nominal') & df.time.isin(time_values)],
        labels=dict(psi=r'$\psi \text{ (-)}$',
                    val=r'$\dot{Q}(y=100\%)/\dot{Q}_{design} \text{ (-)}$',
                    beta=r'<i>β</i> (-)'),
        x='psi',
        y='val',
        color='beta',
        facet_col='is_bal',
        facet_row='valve',
    )
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_Q100.svg'))
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_Q100.png'))

    # Heat flow rate (fractional) at 10% valve opening

    valve = 'EL'
    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 0.1), 'time'].values

    fig = px.scatter(df.loc[(df.valve == valve) & (df.variable == 'loa.Q_flow/Q_flow_nominal') &
                            df.time.isin(time_values)],
                     labels=dict(psi=r'$\psi \text{ (-)}$',
                                 val=r'$\dot{Q}(y=10\%)/\dot{Q}_{design} \text{ (-)}$',
                                 beta=r'<i>β</i> (-)'),
                     x='psi',
                     y='val',
                     color='beta',
                     facet_col='is_bal',
                     facet_row='valve')
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_Q10.svg'))
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_Q10.png'))

    # Primary pump flow (including sensitivity to valve characteristic)

    pump_m_flow_nominal = df.loc[df.variable == 'mPum_flow_nominal', 'val'].iloc[0]
    tmp = df.loc[df.variable == 'pum.m_flow'].copy()
    tmp['variable'] = 'pum.m_flow/pum.m_flow_nominal'
    tmp['val'] = tmp['val'] / pump_m_flow_nominal

    fig = px.box(tmp,
                labels=dict(psi=r'$\psi \text{ (-)}$',
                            val=r'$\dot{m}_{pump} / \dot{m}_{pump, design}\text{ (-)}$',
                            beta=r'<i>β</i> (-)'),
                x='psi',
                y='val',
                color='beta',
                facet_col='is_bal',
                facet_row='valve',
                points=False)
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mPump.svg'))
    fig.write_image(os.path.join(dirname, 'DiversionOpenLoop_mPump.png'))

    # Clean

    shutil.rmtree(os.path.join(dirname, 'results'))