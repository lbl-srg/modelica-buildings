within Buildings.Fluid.MassExchangers;
model Humidifier_u
  "Ideal humidifier or dehumidifier with prescribed water mass flow rate addition or subtraction"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    final prescribedHeatFlowRate=true));

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Water mass flow rate at u=1, positive for humidification";

  Modelica.Blocks.Interfaces.RealInput u "Control input"
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}})));
protected
  Modelica.Blocks.Math.Gain gai(final k=mWat_flow_nominal) "Gain"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port for total heat exchange with the control volume"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
equation
  connect(u, gai.u) annotation (Line(
      points={{-120,60},{-82,60}},
      color={0,0,127}));
  connect(gai.y, vol.mWat_flow) annotation (Line(
      points={{-59,60},{-30,60},{-30,-18},{-11,-18}},
      color={0,0,127}));
  connect(vol.heatPort, heatPort) annotation (Line(points={{-9,-10},{-20,-10},{-20,
          -60},{-100,-60}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={0,0,255},
          textString="m=%m_flow_nominal"),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,114},{-100,86}},
          lineColor={0,0,255},
          textString="u"),
        Rectangle(
          visible=use_T_in,
          extent={{-100,-59},{-70,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="hum",
Documentation(info="<html>
<p>
Model for an air humidifier or dehumidifier.
</p>
<p>
This model adds (or removes) moisture from the air stream.
The amount of exchanged moisture is equal to
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775;<sub>wat</sub> = u  m&#775;<sub>wat,nom</sub>,
</p>
<p>
where <i>u</i> is the control input signal and
<i>m&#775;<sub>wat,nom</sub></i> is equal to the parameter <code>mWat_flow_nominal</code>.
The parameter <code>mWat_flow_nominal</code> can be positive or negative.
If <i>m&#775;<sub>wat</sub></i> is positive, then moisture is added
to the air stream, otherwise it is removed.
</p>
<p>
This model can only be used with medium models that define the integer constant
<code>Water</code> which needs to be equal to the index of the water mass fraction
in the species vector.
</p>
<p>
If the heat port <code>heatPort</code> is unconnected, then the enthalpy of the
air that flows through the device remains unchanged, e.g., the humidification
is adiabatic. To change the enthalpy of the air, add heat flow to the connector
<code>heatPort</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed parameters <code>use_T_in</code> and <code>T</code>.
This removes the optional specification of temperature through the parameter <code>T</code>
or the input connector <code>T_in</code>.
Exposed the heat port of the control volume to allow adding heat,
for example, to use the model as a steam humidifier.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">
Buildings #704</a>.
<li>
May 6, 2015, by Michael Wetter:<br/>
Set <code>prescribedHeatFlowRate=true</code>.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/412\">
#412</a>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Corrected issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>
which led to twice the amount of latent heat being added to the fluid stream.
</li>
<li>
October 14, 2013 by Michael Wetter:<br/>
Constrained medium to be a subclass of
<code>Modelica.Media.Interfaces.PartialCondensingGases</code>,
as this base class declares the function
<code>enthalpyOfCondensingGas</code>.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Updated model to use new variable <code>mWat_flow</code>
in the base class.
</li>
<li>
May 24, 2011, by Michael Wetter:<br/>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 14, 2010, by Michael Wetter:<br/>
Converted temperature input to a conditional connector.
</li>
<li>
April 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Humidifier_u;
