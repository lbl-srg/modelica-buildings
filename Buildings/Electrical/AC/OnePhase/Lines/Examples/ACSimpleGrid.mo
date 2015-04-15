within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model ACSimpleGrid "Test model for a network model"
  extends Modelica.Icons.Example;
  Network network(
    redeclare Buildings.Electrical.Transmission.Grids.TestGrid2Nodes grid,
    V_nominal=120)
    "Network model that represents the connection between the source and the load"
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  Loads.Inductive load(P_nominal=2500, mode=Types.Load.VariableZ_P_input,
    V_nominal=120) "Load connected to the network"
    annotation (Placement(transformation(extent={{-28,10},{-48,30}})));
  Sources.FixedVoltage E(f=60, V=120) "Voltage source"
                                          annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,0})));
  Modelica.Blocks.Sources.Ramp load_inputs(
    height=5000,
    duration=2,
    offset=-2000,
    startTime=0.5) "Input signal for the power consumption of the loads"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(load.terminal, network.terminal[2]) annotation (Line(
      points={{-28,20},{-20,20},{-20,4.44089e-16},{-4.44089e-16,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, network.terminal[1]) annotation (Line(
      points={{-60,-8.88178e-16},{-56,-8.88178e-16},{-56,4.44089e-16},{-4.44089e-16,
          4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load_inputs.y, load.Pow) annotation (Line(
      points={{-59,30},{-54,30},{-54,20},{-48,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Lines/Examples/ACSimpleGrid.mos"
        "Simulate and plot"),
Documentation(revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Documentation and example revised.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a network model to connect
a source to a load. In this simple case the network has two nodes
that are connected by a commercial line cable.
</p>
<p>
At the beginning of the simulation the load consumes power while at the
and it produces power. The voltage at the load at the beginning is lower
than the nominal RMS voltage (120 V) while at the end of the simulation it is higher.
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
end ACSimpleGrid;
