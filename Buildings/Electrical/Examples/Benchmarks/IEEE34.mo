within Buildings.Electrical.Examples.Benchmarks;
model IEEE34
  extends Modelica.Icons.Example;
  parameter Boolean linearized = false
    "This boolean flags allow to linearize the models";
  parameter Boolean VoltageCTRL = true
    "This flag enables the voltage control for the PV loads";
  parameter Modelica.SIunits.Voltage V_nominal = 230;
  parameter Real Vth = 0.1;
  parameter Modelica.SIunits.Time Tdelay = 600;
  parameter Modelica.SIunits.Voltage Vmin = V_nominal*(1-Vth);
  parameter Modelica.SIunits.Voltage Vmax = V_nominal*(1+Vth);
  Modelica.SIunits.Power P;
  Modelica.SIunits.Power Q;
  Modelica.SIunits.Energy E(start = 0);

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Network_N network(
      redeclare Buildings.Electrical.Transmission.Benchmarks.Grids.IEEE_34_weak
      grid) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Resistive_N load[33](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    PlugPhase1 = Phase1,
    PlugPhase2 = Phase2,
    PlugPhase3 = Phase3,
    each linearized=linearized,
    each V_nominal=V_nominal)
    annotation (Placement(transformation(extent={{10,-56},{30,-36}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Resistive_N pv_loads[11](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    each linearized=linearized,
    PlugPhase1 = Phase1_pv,
    PlugPhase2 = Phase2_pv,
    PlugPhase3 = Phase3_pv,
    each V_nominal = V_nominal,
    each VoltageCTRL = VoltageCTRL,
    each Vthresh=Vth,
    each Tdelay=Tdelay)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage_N source(
    Phi=0,
    V=V_nominal,
    f=50)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,0})));
  Transmission.Benchmarks.DataReader.DataSeries dataSeries
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  /* the connection matrix represents this concept

     Pv profile 1 -> to node 1+1
     Pv profile 2 -> to node 5+1
     ...
     Pv profile 11 -> to node 32+1
  */
  parameter Real vals[11] = 0.33*{0.1, 0.1, 0.1, 0.1, 0.5, 0.5, 0.5, 0.5, 0.9, 0.9, 0.9};
protected
  final parameter Integer connMatrix[11,2]=
    [1,1;
    2,5;
    3,6;
    4,10;
    5,14;
    6,18;
    7,19;
    8,22;
    9,27;
    10,31;
    11,32];

  /* Scheme that shows how the phases are plugged */
  /*                                    1     2     3     4     5     6    7    8     9     10   11    12    13    14   15    16   17    18    19   20   21     22    23    24   25    26   27    28   29    30    31    32    33  */
  final parameter Boolean Phase1[33]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=33,
      first=1,
      Mod=3);
  final parameter Boolean Phase2[33]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=33,
      first=2,
      Mod=3);
  final parameter Boolean Phase3[33]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=33,
      first=3,
      Mod=3);

  /* Scheme that shows how the phases are plugged */
  /*                                        1     2     3     4     5     6    7    8     9     10   11    */
  //parameter Boolean Phase1_pv[11] = Buildings.Electrical.Transmission.Benchmark.Utilities.PluggedPhaseSequence(N=11,first=1,Mod=3);
  //parameter Boolean Phase2_pv[11] = Buildings.Electrical.Transmission.Benchmark.Utilities.PluggedPhaseSequence(N=11,first=2,Mod=3);
  //parameter Boolean Phase3_pv[11] = Buildings.Electrical.Transmission.Benchmark.Utilities.PluggedPhaseSequence(N=11,first=3,Mod=3);

  parameter Boolean Phase1_pv[11]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseFromRndSeq(
      N=11,
      min=0.0,
      max=1/3,
      val=vals);
  parameter Boolean Phase2_pv[11]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseFromRndSeq(
      N=11,
      min=1/3,
      max=2/3,
      val=vals);
  parameter Boolean Phase3_pv[11]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseFromRndSeq(
      N=11,
      min=2/3,
      max=1.0,
      val=vals);

equation
  3600*1000*der(E) = P;
  P = source.Vphase[1].S[1] + source.Vphase[2].S[1] + source.Vphase[3].S[1];
  Q = source.Vphase[1].S[2] + source.Vphase[2].S[2] + source.Vphase[3].S[2];

  // Connections for the buildings loads
  for i in 1:33 loop

    // Each load is connected to a node of the network
    connect(network.terminal[i+1], load[i].terminal_p) annotation (Line(
      points={{-30,4.44089e-16},{0,4.44089e-16},{0,-46},{10,-46}},
      color={0,120,120},
      smooth=Smooth.None));

    // Each lode is plugged to a specific phase: 1, 2 or 3
    if mod(i,3)==1 then
      connect(load[i].Pow1, dataSeries.bldg[i]) annotation (Line(
      points={{30,-40},{42,-40},{42,-4},{61,-4}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif mod(i,3)==2 then
      connect(load[i].Pow2, dataSeries.bldg[i]) annotation (Line(
      points={{30,-46},{42,-46},{42,-4},{61,-4}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(load[i].Pow3, dataSeries.bldg[i]) annotation (Line(
      points={{30,-52},{42,-52},{42,-4},{61,-4}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  end for;

  // Connect the voltage source to node #1
  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{10,1.77636e-15},{0,1.77636e-15},{0,0},{-30,0}},
      color={0,120,120},
      smooth=Smooth.None));

  // Connections for the pv loads
  for i in 1:11 loop
    // connect the PV load i to the corresponding node of the network
    connect(pv_loads[connMatrix[i,1]].terminal_p, network.terminal[connMatrix[i,2]+1]) annotation (Line(
      points={{10,40},{0,40},{0,0},{-30,0}},
      color={0,120,120},
      smooth=Smooth.None));

    // Each PV lode is plugged to a specific phase: 1, 2 or 3
    // and read the data from a specific data series
    if Phase1_pv[i] and not Phase2_pv[i] and not Phase3_pv[i] then
      connect(dataSeries.pv[connMatrix[i,2]], pv_loads[i].Pow1) annotation (Line(
      points={{61,4},{42,4},{42,46},{30,46}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif not Phase1_pv[i] and Phase2_pv[i] and not Phase3_pv[i] then
      connect(dataSeries.pv[connMatrix[i,2]], pv_loads[i].Pow2) annotation (Line(
      points={{61,4},{42,4},{42,40},{30,40}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif not Phase1_pv[i] and not Phase2_pv[i] and Phase3_pv[i] then
      connect(dataSeries.pv[connMatrix[i,2]], pv_loads[i].Pow3) annotation (Line(
      points={{61,4},{42,4},{42,34},{30,34}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  end for;

end IEEE34;
