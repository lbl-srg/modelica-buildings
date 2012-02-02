within Buildings.Examples.Tutorial.Boiler;
model System1
  "1st part of the system model, consisting of the room with heat transfer"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T=263.15)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      table=[      0, 0;
              8*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, QRooInt_flow;
             18*3600, 0;
             24*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
equation
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{5.55112e-16,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This part of the system model implements the room with a heat gain.
The room is simplified as a volume of air, a prescribed heat source for
the internal convective heat gain, and a heat conductor for steady-state
heat conduction to the outside.
To increase the heat capacity of the room, such as due to heat stored
in furniture and in building constructions, the heat capacity
of the room air was increased by a factor of three.
The convective heat transfer coefficient is lumped into the heat conductor
model.
</p>
<h4>Implementation</h4>
<p>
This model is based on the model 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a> which implements the same
model, except for the following changes:
<ul>
<li>
The heat loss of the room is <i>20</i> kW at a temperature difference of <i>30</i> Kelvin.
</li>
<li>
The internal heat gain is <i>4</i> kW between 8am and 6pm, and zero otherwise.
</i>
</ul>
<p>
We now describe step by step how we implemented the model.
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a>
into the package
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler\">
Buildings.Examples.Tutorial.Boiler</a>.
(To see how the model was constructed, check the documentation of 
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler\">
Buildings.Examples.Tutorial.Boiler</a>.)
Copying the model can be done either using a graphical user interface of a modeling environment,
or by manually copying the file <code>System1.mo</code> on the harddisk.
If the file is copied manually, then the package name needs to be changed. This can be
done by changing the line
<pre>
within Buildings.Examples.Tutorial.SpaceCooling;
</pre>
to 
<pre>
within Buildings.Examples.Tutorial.Boiler;
</pre>
</p>
</li>
<li>
<p>
Next, we updated the parameters of the model by changing
</p>
<pre>
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30) 
    \"Thermal conductance with the ambient\";
</pre>
<p>
to 
</p>
<pre>
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30) 
    \"Thermal conductance with the ambient\";
</pre>
<p>
and by changing 
</p>
<pre>
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 1000
    \"Internal heat gains of the room\";
</pre>
<p>
to 
</p>
<pre>
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
    \"Internal heat gains of the room\";
</pre>
</p>
</li>
<li>
<p>
To make the heat gain time dependent, we changed the class of the instance
<code>preHea</code> from the model
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a>
to the model
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>.
</p>
<p>
Changing the class can be done either in the textual editor, 
or by deleting the existing and adding the new component in the graphical editor, or in Dymola
by left-clicking on the component and selecting \"Change Class...\", as shown in the figure below.
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/replaceHeatFlow.png\" border=\"1\">
</p>
<p>
<b>Note:</b>
If the class is changed as shown in the image above, then Dymola 2012 FD01 does <i>not</i> delete
the parameter assignment <code>Q_flow=QRooInt_flow</code>. 
Since <code>Q_flow</code> is an input to 
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>,
the parameter assignment needs to be deleted manually in the text editor.
</p>
</li>
<li>
<p>
To define a time-dependent heat gain, we instantiated the block
<a href=\"modelica://Modelica.Blocks.Sources.CombiTimeTable\">
Modelica.Blocks.Sources.CombiTimeTable</a>
and set its name to <code>timTab</code>.
We set the table parameters to
</p>
<pre>
Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, 
      table=[      0, 0; 
              8*3600, 0; 
              8*3600, QRooInt_flow; 
             18*3600, QRooInt_flow; 
             18*3600, 0; 
             24*3600, 0]) \"Time table for internal heat gain\";
</pre>
<p>
Note that we configured the parameters in such a way that the output is a periodic signal.
The documentation of <a href=\"modelica://Modelica.Blocks.Sources.CombiTimeTable\">
Modelica.Blocks.Sources.CombiTimeTable</a>
explains why we added two values for 8am and 6pm.
</p>
</li>
<li>
<p>
Next, we connected its output to the input of the instance <code>preHea</code>.
</p>
</li>
</ol>
<p>
This completes the initial version of the model. When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System1Temperatures.png\" border=\"1\">
</p>
<p>
To verify the correctness of the model, we can compare the simulated results to the
following analytical solutions:
</p>
<p>
<ol>
<li>
<p>
When the internal heat gain is zero, the room temperature should be equal 
to the outside temperature.
</p>
</li>
<li>
<p>
At steady-state when the internal heat gain is <i>4000</i> Watts,
the temperature difference to the outside should be
<i>&Delta; T = Q&#775; &frasl; UA = 4000/(20000/30) = 6</i> Kelvin, which 
corresponds to a room temperature of <i>-4</i>&deg;C.
</p>
</li>
</ol>
</p>
<p>
Both analytical values agree with the simulation results shown in the above figure.
</p>
<p>
An alternative validation can be done by fixing the temperature of the volume to
<i>20</i>&deg;C and plotting the heat flow rate that is needed to maintain
this temperature.
This can be implemented by connecting an instance of
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.FixedTemperature</a>
as shown below.
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System1PrescribedTemperature.png\" border=\"1\">
</p>
<p>
When plotting the heat flow rate <code>fixTemp.port.Q_flow</code>, one can see
that the required heat flow rate to keep the temperature at 
<i>20</i>&deg;C is 
<i>20</i> kW during night, and 
<i>16</i> kW during day when the heat gain is active.
</p>
<!-- Notes -->
<h4>Notes</h4>
<p>
For a more realistic model of a room, the model 
<a href=\"modelica://Buildings.Rooms.MixedAir\">
Buildings.Rooms.MixedAir</a>
could have been used.
For transient heat conduction, models from the
package
<a href=\"modelica://Buildings.HeatTransfer.Conduction\">
Buildings.HeatTransfer.Conduction</a>
could have been used.
</p>
</html>", revisions="<html>
<ul>
<li>
January 27, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System1.mos"
        "Simulate and plot"),
    experiment(StopTime=172800));
end System1;
