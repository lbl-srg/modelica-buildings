within Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples;
model ACSimpleGridMedium "Test model for a network model with medium voltage"
  extends Modelica.Icons.Example;
  ThreePhasesBalanced.Lines.Network network(
      redeclare Buildings.Electrical.Transmission.Grids.TestGrid2NodesMedium grid,
      lines(redeclare
        Buildings.Electrical.Transmission.MediumVoltageCables.Generic
        commercialCable = network.grid.cables,
        each V_nominal = network.V_nominal),
    V_nominal=15000)
    "Network model that represents the connection between the source and the load"
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  ThreePhasesBalanced.Loads.Inductive load(mode=Types.Load.VariableZ_P_input,
    P_nominal=250000,
    V_nominal=15000) "Load connected to the network"
    annotation (Placement(transformation(extent={{-28,10},{-48,30}})));
  ThreePhasesBalanced.Sources.FixedVoltage E(V=15000, f=60) "Voltage source"
                                                              annotation (Placement(
        transformation(
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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Lines/Examples/ACSimpleGridMedium.mos"
        "Simulate and plot"),
Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Documentation and example added.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how to use a network model to connect
a source to a load (using a medium voltage cable). In this simple case the network has two nodes
that are connected by a commercial line cable.
</p>
<p>
At the beginning of the simulation the load consumes power while at the
end it produces power. The voltage at the load at the beginning is lower
than the nominal RMS voltage (15 kV) while at the end of the simulation it is higher.
The voltage drop and increase are due to the presence of the cable between
the source and the load.
</p>
<p>
The network uses cables of the type <code>MediumVoltageCables.Annealed_Al_30</code> with
a length of <i>200</i> m.
</p>
<p>
The picture below describes the grid topology.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/testGrid2Nodes.png\"/>
</p>
<h4>Note:</h4>
<p>
The cables are usually defined using the <code>LowVoltageCable.Generic</code> type. In order to use a
medium voltage cable it is necessary to redeclare the type of the record <code>commercialCable</code>.
</p>

<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">ThreePhasesBalanced.Lines.Network</span>
<span style=\" font-family:'Courier New,courier';\"> network(</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Electrical.Transmission.Grids.TestGrid2NodesMedium</span>
<span style=\" font-family:'Courier New,courier';\"> grid,</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">      lines(</span>
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Electrical.Transmission.MediumVoltageCables.Generic</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">        commercialCable = network.grid.cables,</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span>
<span style=\" font-family:'Courier New,courier';\">V_nominal = network.V_nominal),</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier';\">    V_nominal=15000) </span>
</p>

<p>
The code snippet shows how each line that is part of the vector <code>lines</code> is
redeclared in order to have as type the record
<code>Buildings.Electrical.Transmission.MediumVoltageCables.Generic</code>. The lines are initialized
using the cables of the grid <code>network.grid.cables</code>. All the lines have the same
nominal voltage <code>each V_nominal = network.V_nominal</code>.
</p>
</html>"));
end ACSimpleGridMedium;
