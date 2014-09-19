within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_nNodes
  "Base class that represents a single feeder with N nodes"
  parameter Boolean linearized = false
    "This boolean flags allow to linearize the models";
  parameter Integer N = 10 "Number of nodes of the feeder";
  parameter Integer Nload = N-1 "Number of loads connected to the feeder";
  parameter Integer Npv = 3 "Number of PVs connected to the feeder";
  parameter Integer connMatrix[Npv, 2]=
    [1,1;
     5,5;
     6,6]
    "Matrix that represents the connections of the PVs to the nodes in the feeder";
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.NetworkN network(
      redeclare
      Buildings.Electrical.Transmission.Benchmarks.Grids.SingleFeeder_10nodes_Al70
      grid)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Resistive_N           load[Nload](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each V_nominal=230,
    PlugPhase1 = Phase1,
    PlugPhase2 = Phase2,
    PlugPhase3 = Phase3,
    each linearized=linearized)
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Resistive_N           pv_loads[Npv](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each V_nominal=230,
    each linearized=linearized,
    PlugPhase1=Phase1_pv,
    PlugPhase2=Phase2_pv,
    PlugPhase3=Phase3_pv)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  AC.ThreePhasesUnbalanced.Interfaces.Terminal4_n terminal
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput pv[39]
    "Power data related to PV power production" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));
  Modelica.Blocks.Interfaces.RealInput bldg[39]
    "Power data related to building power consumption" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-30})));
protected
  parameter Boolean Phase1[Nload]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Nload,
      first=1,
      Mod=3);
  parameter Boolean Phase2[Nload]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Nload,
      first=2,
      Mod=3);
  parameter Boolean Phase3[Nload]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Nload,
      first=3,
      Mod=3);
  parameter Boolean Phase1_pv[Npv]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Npv,
      first=1,
      Mod=3);
  parameter Boolean Phase2_pv[Npv]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Npv,
      first=2,
      Mod=3);
  parameter Boolean Phase3_pv[Npv]=
      Buildings.Electrical.Transmission.Benchmarks.Utilities.pluggedPhaseSequence(
      N=Npv,
      first=3,
      Mod=3);
equation

  // Connections for the buildings loads
  for i in 1:Nload loop

    // Each load is connected to a node of the network
    connect(network.terminal[i+1], load[i].terminal_p) annotation (Line(
      points={{-30,4.44089e-16},{0,4.44089e-16},{0,-30},{10,-30}},
      color={0,120,120},
      smooth=Smooth.None));

    // Each lode is plugged to a specific phase: 1, 2 or 3
    if mod(i,3)==1 then
      connect(load[i].Pow1, bldg[i]) annotation (Line(
      points={{30,-24},{42,-24},{42,-30},{90,-30}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif mod(i,3)==2 then
      connect(load[i].Pow2, bldg[i]) annotation (Line(
      points={{30,-30},{90,-30}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(load[i].Pow3, bldg[i]) annotation (Line(
      points={{30,-36},{42,-36},{42,-30},{90,-30}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  end for;

  // Connect the voltage source to node #1
  connect(terminal, network.terminal[1])  annotation (Line(
      points={{-100,4.44089e-16},{-86,4.44089e-16},{-86,0},{-72,0},{-72,20},{-10,
          20},{-10,0},{-30,0},{-30,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  // Connections for the pv loads
  for i in 1:Npv loop

    // connect the PV load i to the corresponding node of the network
    connect(pv_loads[i].terminal_p, network.terminal[connMatrix[i,1]+1]) annotation (Line(
      points={{10,30},{0,30},{0,0},{-30,0}},
      color={0,120,120},
      smooth=Smooth.None));

    // Each PV lode is plugged to a specific phase: 1, 2 or 3
    // and read the data from a specific data series
    if mod(i,3)==1 then
      connect(pv[connMatrix[i,2]], pv_loads[i].Pow1) annotation (Line(
      points={{90,30},{42,30},{42,36},{30,36}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif mod(i,3)==2 then
      connect(pv[connMatrix[i,2]], pv_loads[i].Pow2) annotation (Line(
      points={{90,30},{30,30}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(pv[connMatrix[i,2]], pv_loads[i].Pow3) annotation (Line(
      points={{90,30},{42,30},{42,24},{30,24}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-90,0},{80,0}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,0},{-80,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-60,0},{-60,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,-40},{-40,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-20,-40},{-20,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-8,0},{-8,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{12,0},{12,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,-40},{40,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{60,-40},{60,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{-84,44},{-76,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,44},{-56,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-12,44},{-4,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{8,44},{16,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-44,-36},{-36,-44}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,-36},{-16,-44}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{36,-36},{44,-44}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{56,-36},{64,-44}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,0},{32,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{50,0},{50,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{28,44},{36,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{46,44},{54,36}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Solid)}));
end singleFeeder_nNodes;
