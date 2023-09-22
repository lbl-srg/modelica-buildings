within Buildings.Fluid.HeatExchangers;
model HeaterCooler_u "Heater or cooler with prescribed heat flow rate"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u(unit="1") "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-68,74},{-56,86}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(
    final alpha=0)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Math.Gain gai(
    k(final unit="W")=Q_flow_nominal,
    y(final unit="W"))
    "Gain"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
protected
  Modelica.Blocks.Logical.Hysteresis deaBanDam(final uLow=0.05, final uHigh=0.1)
    "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-88,74},{-76,86}})));
equation
  connect(u, gai.u) annotation (Line(
      points={{-120,60},{-82,60}},
      color={0,0,127}));
  connect(gai.y, preHea.Q_flow) annotation (Line(
      points={{-59,60},{-40,60}},
      color={0,0,127}));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0}));
  connect(gai.y, Q_flow) annotation (Line(
      points={{-59,60},{-50,60},{-50,80},{80,80},{80,60},{110,60}},
      color={0,0,127}));
  connect(u, deaBanDam.u) annotation (Line(points={{-120,60},{-94,60},{-94,80},
          {-89.2,80}}, color={0,0,127}));
  connect(deaBanDam.y, booToRea.u)
    annotation (Line(points={{-75.4,80},{-69.2,80}}, color={255,0,255}));
  connect(booToRea.y, damPreInd.y) annotation (Line(points={{-54.8,80},{-54.8,
          82},{-48,82},{-48,18},{-78,18},{-78,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,8},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,-60},{70,60},{-70,60},{-70,-60}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,-60},{70,60},{70,-60},{-70,-60}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          textColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          textColor={0,0,127},
          textString="u"),
        Text(
          extent={{72,96},{116,68}},
          textColor={0,0,127},
          textString="Q_flow")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
</p>
<p>
This model adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> to the medium.
The input signal <code>u</code> and the nominal heat flow rate <code>Q_flow_nominal</code>
can be positive or negative. A positive value of <code>Q_flow</code> means
heating, and negative means cooling.
</p>
<p>
The outlet conditions at <code>port_a</code> are not affected by this model,
other than for a possible pressure difference due to flow friction.
</p>
<p>
Optionally, this model can have a flow resistance.
Set <code>dp_nominal = 0</code> to disable the flow friction calculation.
</p>
<p>
For a model that uses as an input the fluid temperature leaving at
<code>port_b</code>, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.PrescribedOutlet</a>
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
October 13, 2022, by Fabian Wuellhorst:<br/>
Added unit to instance <code>gai</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1642\">#1642</a>.
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Set <code>preHea(final alpha=0)</code> as this allows to simplify the
system of equations.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/570\">#570</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">#349</a>.
</li>
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet</a>.
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
