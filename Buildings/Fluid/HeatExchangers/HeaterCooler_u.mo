within Buildings.Fluid.HeatExchangers;
model HeaterCooler_u "Heater or cooler with prescribed heat flow rate"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
      prescribedHeatFlowRate=true),
    final showDesignFlowDirection=false);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Math.Gain gai(k=Q_flow_nominal) "Gain"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(u, gai.u) annotation (Line(
      points={{-120,60},{-82,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai.y, preHea.Q_flow) annotation (Line(
      points={{-59,60},{-40,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gai.y, Q_flow) annotation (Line(
      points={{-59,60},{-50,60},{-50,80},{80,80},{80,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,127},
          textString="u"),
        Text(
          extent={{72,96},{116,68}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Rectangle(
          extent={{-100,8},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
</p>
<p>
This model adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> to the medium.
The input signal <code>u</code> and the nominal heat flow rate <code>Q_flow_nominal</code>
can be positive or negative.
</p>
<p>
Optionally, this model can have a flow resistance.
If no flow resistance is requested, set <code>dp_nominal=0</code>.
</p>
<p>
For a model that uses as an input the fluid temperature leaving at
<code>port_b</code>, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_T\">
Buildings.Fluid.HeatExchangers.HeaterCooler_T</a>
</p>
<h4>Limitations</h4>
<p>
This model does not affect the humidity of the air. Therefore,
if used to cool air below the dew point temperature, the water mass fraction
will not change.
</p>
<h4>Validation</h4>
<p>
The model has been validated against the analytical solution in
the example
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_u</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 6, 2015, by Michael Wetter:<br/>
Set <code>prescribedHeatFlowRate=true</code>.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/412\">
#412</a>.
</li>
<li>
May 1, 2015, by Marcus Fuchs:<br/>
Corrected typo in documentation.
</li>
<li>
November 12, 2014, by Michael Wetter:<br/>
Added output signal <code>Q_flow</code> so that it has
the same output ports as
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T\">
Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T</a>.
</li>
<li>
September 11, 2014, by Christoph Nytsch-Geusen:<br/>
Renaming class to <code>HeaterCooler_u</code>.
</li>
<li>
October 15, 2013, by Michael Wetter:<br/>
Redeclared the control volume to be final so that it does not show
anymore in the parameter window.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Redeclared fluid volume as final. This prevents the fluid volume model
to appear in the dialog window.
</li>
<li>
May 24, 2011, by Michael Wetter:<br/>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeaterCooler_u;
