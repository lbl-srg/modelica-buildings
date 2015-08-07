within Buildings.Fluid.FMI.Examples.FMUs;
block Fan "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPortComponent(
     redeclare replaceable package Medium =  Buildings.Media.Air,
     redeclare final Movers.FlowControlled_dp com(
      final m_flow_nominal=m_flow_nominal,
      final dynamicBalance=false,
      final filteredSpeed=false));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=500
    "Pressure drop at nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealInput dp_in(min=0, final unit="Pa")
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,68}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,68})));

equation
  connect(dp_in, com.dp_in) annotation (Line(
      points={{-120,68},{-0.2,68},{-0.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.FlowMachine_dp\">
Buildings.Fluid.FixedResistances.FlowMachine_dp</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">
Buildings.Fluid.FMI.UsersGuide</a> for why there is no model that exports
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Fan.mos"
        "Export FMU"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,48},{54,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,48},{0,-58},{54,0},{0,48}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}));
end Fan;
