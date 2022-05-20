#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os

import numpy as np
import pandas as pd
import plotly.express as px


def simulateCase(s):
    """Set common parameters and run a simulation with buildingspy.

    Args:
        s (buildingspy.simulate.Dymola.Simulator): simulator object
    """
    s.setSolver("Cvode")
    s.setTolerance(1e-6)
    s.setStopTime(100)
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate()


def read_mat(mat_path, var_names):
    """Read result file.mat and returns a

    Args:
        mat_path (str): _description_
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


psi_rge = np.linspace(0.1, 0.4, num=7).round(2)  # dpCoil / dpPump at design
beta_rge = np.linspace(0.1, 0.7, num=7).round(2)  # valve authority

class_name = 'Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionCircuitOpenLoop'
package_path = os.path.join(os.environ['MBL'], 'Buildings')
dpTer = 2e4

if __name__ == '__main__':
    case_list = []
    case_param = pd.DataFrame()
    for valve in ['EL', 'LL']:
        for is_bypBal in (False, True):
            for psi in psi_rge:
                for beta in beta_rge:
                    kSizPum = round(0.4 / psi, 2)  # kSizPum = 1 => psi = 0.4
                    dpValve = round(beta * dpTer / (1 - beta))
                    out_dir = os.path.join('results', f'{valve}_{is_bypBal}_{psi}_{beta}')
                    case_param = pd.concat([
                        case_param,
                        pd.DataFrame(
                            dict(
                                valve=[valve],
                                is_bypBal=[is_bypBal],
                                psi=[psi],
                                beta=[beta],
                                kSizPum=[kSizPum],
                                dpValve=[dpValve],
                                out_dir=[out_dir],
                            ))
                    ])
                    s = Simulator(class_name, packagePath=package_path, outputDirectory=out_dir)
                    if valve == 'EL':
                        model = 'Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear'
                    else:
                        model = 'Buildings.Fluid.Actuators.Valves.ThreeWayLinear'
                    modif = (f'redeclare model ThreeWayValve = {model}, '
                             f'is_bypBal={str(is_bypBal).lower()}, '
                             f'dpValve_nominal={dpValve}, '
                             f'kSizPum={kSizPum}')
                    s.addModelModifier(modif)
                    case_list.append(s)

    # Run all cases in parallel
    po = Pool()
    if asy:
        po.map_async(simulateCase, case_list)
    else:
        po.map(simulateCase, case_list)

    # Extract results
    df = pd.DataFrame()
    var_names = [
        'con.val.res1.dp', 'con.val.res3.dp', 'ope.y', 'con.val.res3.m_flow', 'con1.val.res1.m_flow', 'pum.m_flow',
        'pum.dpMachine', 'loa1.Q_flow', 'loa1.Q_flow_nominal'
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

    # Plot valve bypass flow
    valve = 'EL'
    fig = px.scatter(df.loc[(df.valve == valve) & (df.variable == 'con.val.res3.m_flow') & (df.time == 0)],
            labels=dict(psi=r'$\psi \text{ (-)}$',
                        val=r'$ \dot{m}_{bypass}(y=0\%) / \dot{m}_{design} \text{ (-)}$',
                        beta=r'<i>β</i> (-)'),
            x='psi',
            y='val',
            color='beta',
            facet_col='is_bypBal')
    fig.write_image('DiversionCircuitOpenLoop_mBypass.svg')
    fig.write_image('DiversionCircuitOpenLoop_mBypass.png')
