within Buildings.Fluid.FMI.Examples.FMUs;
block Humidifier_u "FMU declaration for an ideal humidifier"
   extends Buildings.Fluid.FMI.TwoPortComponent(
     redeclare replaceable package Medium = Buildings.Media.Air,
     redeclare final Buildings.Fluid.MassExchangers.Humidifier_u com(
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=if use_p_in then dp_nominal else 0,
      final mWat_flow_nominal=mWat_flow_nominal,
      final T=T,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=0
    "Pressure";

  parameter Modelica.SIunits.Temperature T = 293.15
    "Temperature of water that is added to the fluid stream (used if use_T_in=false)";

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal=0.01*0.005
    "Water mass flow rate at u=1, positive for humidification";

  Modelica.Blocks.Interfaces.RealInput u(min=0, max=1, unit="1")
    "Control input"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
equation
  connect(com.u, u) annotation (Line(
      points={{-12,6},{-40,6},{-40,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a humidifier
that takes as an input signal the normalized mass flow rate of water that
will be added to the medium.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.MassExchangers.Humidifier_u\">
Buildings.Fluid.MassExchangers.Humidifier_u</a>.
</p>
<p>
The mass dynamics has been set to
<code>massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState</code>.
See the
<a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">user's guide</a>
for the rationale.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Humidifier_u.mos"
        "Export FMU"),
    Icon(graphics={
        Polygon(
          points={{22,-75},{52,-85},{22,-95},{22,-75}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal),
        Rectangle(
          extent={{-68,60},{72,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,6},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-4},{102,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,80},{72,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-12},{56,-72}},
          lineColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,61},{-68,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,94},{-60,66}},
          lineColor={0,0,255},
          textString="u")}));
end Humidifier_u;
