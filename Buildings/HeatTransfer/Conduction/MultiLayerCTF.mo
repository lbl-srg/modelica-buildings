within Buildings.HeatTransfer.Conduction;
model MultiLayerCTF
  "Model for heat conductance through a solid with multiple material layers using the CTF method"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=999);
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

  parameter Modelica.SIunits.Time samplePeriod(displayUnit="h") "CTF time step";

  BaseClasses.ConductionTransferFunction ctf(
    final layers = layers,
    final samplePeriod=samplePeriod)
    "Block that implements the CTF method"
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));

protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature T_a
    "Temperature at port a"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor Q_a_flow
    "Heat flow rate at port a"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor Q_b_flow
    "Heat flow rate at port b"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature T_b
    "Temperature at port b"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation

  connect(port_b, Q_b_flow.port_a)
    annotation (Line(points={{100,0},{90,0},{80,0}}, color={191,0,0}));
  connect(port_a, Q_a_flow.port_a)
    annotation (Line(points={{-100,0},{-90,0},{-80,0}}, color={191,0,0}));
  connect(T_b.port, Q_b_flow.port_b)
    annotation (Line(points={{40,0},{50,0},{60,0}}, color={191,0,0}));
  connect(T_a.port, Q_a_flow.port_b)
    annotation (Line(points={{-40,0},{-50,0},{-60,0}}, color={191,0,0}));
  connect(ctf.T_a, T_a.T) annotation (Line(points={{11,-36},{20,-36},{20,-20},{-10,
          -20},{-10,0},{-18,0}}, color={0,0,127}));
  connect(ctf.T_b, T_b.T) annotation (Line(points={{11,-48},{22,-48},{22,-18},{8,
          -18},{8,0},{18,0}}, color={0,0,127}));
  connect(Q_a_flow.Q_flow, ctf.Q_a_flow) annotation (Line(points={{-70,-10},{-70,
          -10},{-70,-36},{-12,-36}}, color={0,0,127}));
  connect(Q_b_flow.Q_flow, ctf.Q_b_flow) annotation (Line(points={{70,-10},{70,-10},
          {70,-54},{70,-60},{-20,-60},{-20,-50},{-20,-48},{-12,-48}}, color={0,0,
          127}));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
   Rectangle(
    extent={{0,80},{80,-80}},       fillColor={175,175,175},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Rectangle(
    extent={{-80,80},{0,-80}},      fillColor={215,215,215},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
        Text(
          extent={{-56,32},{50,-38}},
          lineColor={0,0,0},
          textString="CTF")}),
    defaultComponentName="heaCon",
    Documentation(info="<html>
<p>
This is a model of a heat conductor with multiple material layers and energy storage.
The construction has at least one material layer, and each layer has
at least one temperature node. The layers are modeled using an instance of
<a href=\"Buildings.HeatTransfer.Conduction.SingleLayer\">
Buildings.HeatTransfer.Conduction.SingleLayer</a>.
See this model for an explanation of the equations that are applied to
each material layer.
</p>
<h4>Important parameters</h4>
<p>
The construction material is defined by a record of the package
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>.
This record allows specifying materials that store energy, and material
that are a thermal conductor only with no heat storage.
To assign the material properties to this model, do the following:
</p>
<ol>
<li>
Create an instance of a record of
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>, for example
by dragging the record into the schematic model editor.
</li>
<li>
Make sure the instance has the attribute <code>parameter</code>, which may not be
assigned automatically when you drop the model in a graphical editor. For
example, an instanciation may look like
<pre>
 parameter Data.OpaqueConstructions.Insulation100Concrete200 layers
   \"Material layers of construction\"
   annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
</pre>
</li>
<li>
Assign the instance of the material to the instance of the heat transfer
model as shown in
<a href=\"modelica://Buildings.HeatTransfer.Examples.ConductorMultiLayer\">
Buildings.HeatTransfer.Examples.ConductorMultiLayer</a>.
</li>
</ol>
<p>
xxx
See the examples in
<a href=\"modelica://Buildings.HeatTransfer.Examples\">
Buildings.HeatTransfer.Examples</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2016, by Michael Wetter:<br/>
First implementation of the interfaces and parameters.
</li>
</ul>
</html>"),
    Diagram(graphics={Text(
          extent={{-60,-62},{2,-76}},
          lineColor={28,108,200},
          textString="fixme: for higher accuracy, we may want to
use the average heat flow rate as the
input signal (or average it inside the block)")}));
end MultiLayerCTF;
