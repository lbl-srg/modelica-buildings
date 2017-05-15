within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
block Heater_T
  "Declaration of an FMU that exports an ideal heater or cooler with prescribed outlet temperature"
   extends Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort(
     redeclare replaceable package Medium = Buildings.Media.Air,
     redeclare final Buildings.Fluid.HeatExchangers.Heater_T com(
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=if use_p_in then dp_nominal else 0,
      final QMax_flow=QMax_flow,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState));

  parameter Modelica.SIunits.HeatFlowRate QMax_flow=Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate QMin_flow=-Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=0
    "Pressure";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

equation
  connect(com.TSet, TSet) annotation (Line(
      points={{-12,8},{-40,8},{-40,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(com.Q_flow, Q_flow) annotation (Line(
      points={{11,8},{40,8},{40,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a heater
that takes as an input signal the leaving fluid temperature.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.PrescribedOutlet</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/Heater_T.mos"
        "Export FMU"),
    Icon(graphics={
        Rectangle(
          extent={{70,63},{102,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
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
          extent={{-56,74},{54,14}},
          lineColor={255,255,255},
          textString="TSet"),
        Rectangle(
          extent={{-100,61},{-68,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,94},{-60,66}},
          lineColor={0,0,127},
          textString="T"),
        Text(
          extent={{64,92},{108,64}},
          lineColor={0,0,127},
          textString="Q"),
                   Text(
          extent={{26,-28},{70,-74}},
          lineColor={255,255,255},
          textString="+")}));
end Heater_T;
