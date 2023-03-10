#!/usr/bin/env python
# coding: utf-8

# Script that runs simulations of
# Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop
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

from DiversionOpenLoop import simulateCase, read_mat

# Configuration commands
pio.templates["local_template"] = go.layout.Template(layout=go.Layout(
    font=dict(color='#000000', size=16),
    margin=dict(l=20, r=20, t=40, b=40),
    # yaxis=dict(tickformat='.1e'),
))
pio.templates.default = "plotly_white+local_template"


def main(dirname, asy=True):
    case_list = []
    case_param = pd.DataFrame()
    for is_bal in (False, True):
        for psi in psi_rge:
            for beta in beta_rge:
                dpValve1 = round(beta * dpTer / (1 - beta))  # Based on dp2_nominal, no balancing valve
                dpSet = dpTer / (1 - beta)
                dpPip1 = round(dpTer / psi - dpPip - dpSet)
                # Approximation: the practical authority depends on actual flow rate through res1b.
                dpValve = round(beta * (dpSet + dpPip1))  # Based on dp1_nominal
                out_dir = os.path.join(dirname, 'results', f'{is_bal}_{psi}_{beta}')
                case_param = pd.concat([
                    case_param,
                    pd.DataFrame(
                        dict(
                            is_bal=[is_bal],
                            psi=[psi],
                            beta=[beta],
                            dpValve=[dpValve],
                            dpValve1=[dpValve1],
                            dpPip1=[dpPip1],
                            out_dir=[out_dir],
                        ))
                ])
                s = Simulator(class_name, packagePath=package_path, outputDirectory=out_dir)
                modif = (f'is_bal={str(is_bal).lower()}, '
                         f'dpValve_nominal={dpValve}, '
                         f'dpValve1_nominal={dpValve1}, '
                         f'dpPip1_nominal={dpPip1}')
                s.addModelModifier(modif)
                s.setStopTime(stop_time)
                case_list.append(s)

    # # Run all cases in parallel
    po = Pool()
    if asy:
        po.map_async(simulateCase, case_list)
    else:
        po.map(simulateCase, case_list)

    return case_param


if __name__ == '__main__':
    # Configure and run simulations
    dpTer = 3e4
    dpPip = 0.5e4

    psi_rge = np.linspace(0.1, 0.4, num=7).round(2)  # dpCoil / dpPump at design
    beta_rge = np.linspace(0.1, 0.7, num=7).round(2)  # valve authority

    class_name = 'Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop'
    stop_time = 300
    dirname = os.path.realpath(os.path.dirname(__file__))
    package_path = os.path.abspath(os.path.join(dirname, *[
        os.pardir,
    ] * 7, 'Buildings'))


    case_param = main(dirname=dirname, asy=False)

    # Process results

    df = pd.DataFrame()
    var_names = [
        'con.val.dp',
        'con1.val.dp',
        'ope.y[1]',
        'ope.y[2]',
        'con.val.m_flow',
        'con1.val.m_flow',
        'pum.m_flow',
        'pum.dpMachine',
        'loa.Q_flow',
        'loa.Q_flow_nominal',
        'loa1.Q_flow',
        'loa1.Q_flow_nominal',
        'dT1.y',
        'mPum_flow_nominal',
        'dp.p_rel',
        'dp1.p_rel',
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

        # Compute actual authority for first connection valve


        df = pd.concat([df, tmp])

    # Direct flow for valve open
    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 1), 'time'].values
    time1_values = df.loc[(df.variable == 'ope.y[2]') & (df.val == 1), 'time'].values

    toplot = pd.concat([
        df.loc[(df.variable == 'con.val.m_flow') & df.time.isin(time_values)],
        df.loc[(df.variable == 'con1.val.m_flow') & df.time.isin(time1_values)],
    ])

    fig = px.scatter(toplot,
                     labels=dict(psi=r'$\psi \text{ (-)}$',
                                 val=r'$ \dot{m}(y=100\%) / \dot{m}_{design} \text{ (-)}$',
                                 beta=r'<i>β</i> (-)'),
                     x='psi',
                     y='val',
                     color='beta',
                     facet_col='is_bal')
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_m.svg'))
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_m.png'))

    # Heat flow rate (fractional) at 100% valve opening
    for c in pd.unique(df.case):
        tmp = df.loc[(df.case == c) & (df.variable == 'loa.Q_flow')].copy()
        tmp['variable'] = 'loa.Q_flow/Q_flow_nominal'
        tmp['val'] = tmp['val'] / df.loc[(df.case == c) & (df.variable == 'loa.Q_flow_nominal')].loc[0, 'val']
        df = pd.concat([df, tmp])
        tmp = df.loc[(df.case == c) & (df.variable == 'loa1.Q_flow')].copy()
        tmp['variable'] = 'loa1.Q_flow/Q_flow_nominal'
        tmp['val'] = tmp['val'] / df.loc[(df.case == c) & (df.variable == 'loa1.Q_flow_nominal')].loc[0, 'val']
        df = pd.concat([df, tmp])

    time_values = df.loc[(df.variable == 'ope.y[1]') & (df.val == 1.0), 'time'].values
    time1_values = df.loc[(df.variable == 'ope.y[2]') & (df.val == 1), 'time'].values

    toplot = pd.concat([
        df.loc[(df.variable == 'loa.Q_flow/Q_flow_nominal') & df.time.isin(time_values)],
        df.loc[(df.variable == 'loa1.Q_flow/Q_flow_nominal') & df.time.isin(time1_values)],
    ])

    fig = px.scatter(
        toplot,
        labels=dict(psi=r'$\psi \text{ (-)}$',
                    val=r'$\dot{Q}(y=100\%)/\dot{Q}_{design} \text{ (-)}$',
                    beta=r'<i>β</i> (-)'),
        x='psi',
        y='val',
        color='beta',
        facet_col='is_bal'
    )
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_Q100.svg'))
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_Q100.png'))


    # Primary pump flow

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
                 points=False)
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_mPump.svg'))
    fig.write_image(os.path.join(dirname, 'ThrottleOpenLoop_mPump.png'))

    # Clean

    shutil.rmtree(os.path.join(dirname, 'results'))