within Buildings.Fluid.Boilers.BaseClasses;
model Combustion "Model for combustion with ideal mixing"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b (outlet)";

  parameter Real ratAirFue = 10
    "Air-to-fuel ratio (by volume)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-60},{80,60}},
          lineColor={244,125,35},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-114},{153,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Combustion;
