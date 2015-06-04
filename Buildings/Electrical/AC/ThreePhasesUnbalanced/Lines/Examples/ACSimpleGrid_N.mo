within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples;
model ACSimpleGrid_N
  "Test model for a network model for three-phase unbalanced systems with neutral cable"
  extends Modelica.Icons.Example;
  Network_N network(
    redeclare Buildings.Electrical.Transmission.Grids.TestGrid2Nodes grid,
    V_nominal=480)
    "Network model that represents the connection between the source and the load"
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  Loads.Inductive_N load(
    V_nominal=480,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    plugPhase3=false) "Load connected to the network"
    annotation (Placement(transformation(extent={{-34,10},{-54,30}})));
  Sources.FixedVoltage_N E(
    f=60,
    V=480,
    definiteReference=true) "Voltage source"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-20})));
  Modelica.Blocks.Sources.Ramp load_inputs(
    height=5000,
    offset=-2000,
    duration=0.5,
    startTime=0.25) "Input signal for the power consumption of the loads"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
equation
  connect(E.terminal, network.terminal[1]) annotation (Line(
      points={{-40,-20},{-20,-20},{-20,0},{0,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.terminal, network.terminal[2]) annotation (Line(
      points={{-34,20},{-20,20},{-20,0},{0,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load_inputs.y, load.Pow1) annotation (Line(
      points={{-69,20},{-62,20},{-62,28},{-56,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load_inputs.y, load.Pow2) annotation (Line(
      points={{-69,20},{-56,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Lines/Examples/ACSimpleGrid_N.mos"
        "Simulate and plot"),
Documentation(revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a network model to connect
a source to a load. In this simple case the network has two nodes
that are connected by a commercial cable with neutral line.
</p>
<p>
At the beginning of the simulation the load consumes power while at the
and it produces power. The voltage at the load at the beginning is lower
than the nominal RMS voltage (480 V) while at the end of the simulation it is higher.
The voltage drop and increase are due to the presence of the cable between
the source and the load.
</p>
<p>
The network uses cables of the type <code>LowVoltageCable.Cu35</code> with
a length of <i>200</i> m.
</p>
<p>
The picture below describes the grid topology.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/testGrid2Nodes.png\"/>
</p>
</html>"));
end ACSimpleGrid_N;
