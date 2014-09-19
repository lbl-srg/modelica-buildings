within Buildings.Electrical.Examples.Benchmarks;
model IEEE34_balanced
  extends Modelica.Icons.Example;
  parameter Boolean linearized = false
    "This boolean flags allow to linearize the models";
  parameter Modelica.SIunits.Voltage V_nominal = 230;
  parameter Real Vth = 0.05;
  parameter Modelica.SIunits.Voltage Vmin = V_nominal*(1-Vth);
  parameter Modelica.SIunits.Voltage Vmax = V_nominal*(1+Vth);
  Modelica.SIunits.Power P;
  Modelica.SIunits.Power Q;
  AC.ThreePhasesBalanced.Lines.Network                         network(
      redeclare
      Buildings.Electrical.Transmission.Benchmarks.Grids.IEEE_34_strong grid)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  AC.ThreePhasesBalanced.Loads.Resistive                          load[33](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each linearized=linearized,
    each V_nominal=V_nominal)
    annotation (Placement(transformation(extent={{10,-56},{30,-36}})));
  AC.ThreePhasesBalanced.Loads.Resistive                          pv_loads[11](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each linearized=linearized,
    each V_nominal=V_nominal)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  AC.ThreePhasesBalanced.Sources.FixedVoltage                         source(
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

equation
  P = source.S[1];
  Q = source.S[2];

  // Connections for the buildings loads
  for i in 1:33 loop

    connect(dataSeries.bldg[i], load[i].Pow) annotation (Line(
      points={{61,-4},{46,-4},{46,-46},{30,-46}},
      color={0,0,127},
      smooth=Smooth.None));

    // Each load is connected to a node of the network
    connect(network.terminal[i+1], load[i].terminal) annotation (Line(
      points={{-30,4.44089e-16},{0,4.44089e-16},{0,-46},{10,-46}},
      color={0,120,120},
      smooth=Smooth.None));

  end for;

  // Connect the voltage source to node #1
  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{10,1.77636e-15},{0,1.77636e-15},{0,0},{-30,0}},
      color={0,120,120},
      smooth=Smooth.None));

  // Connections for the pv loads
  for i in 1:11 loop

    connect(dataSeries.pv[i], pv_loads[i].Pow) annotation (Line(
      points={{61,4},{46,4},{46,40},{30,40}},
      color={0,0,127},
      smooth=Smooth.None));

    // connect the PV load i to the corresponding node of the network
    connect(pv_loads[connMatrix[i,1]].terminal, network.terminal[connMatrix[i,2]+1]) annotation (Line(
      points={{10,40},{0,40},{0,0},{-30,0}},
      color={0,120,120},
      smooth=Smooth.None));

  end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end IEEE34_balanced;
