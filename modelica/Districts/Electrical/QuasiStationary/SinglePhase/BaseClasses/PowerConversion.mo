within Districts.Electrical.QuasiStationary.SinglePhase.BaseClasses;
block PowerConversion "Block for power conversion"

  Interfaces.PowerOutput P "Power output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u
    "Input connector for complex power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));

equation
  P.real = u.re;
  P.apparent=(u.re^2 + u.im^2)^0.5;
  P.phi=Modelica.Math.atan2(u.im,u.re);
  P.cosPhi=Modelica.Math.cos(P.phi);
  annotation (
  defaultComponentName = "con",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,60},{-22,-60}},
          lineColor={0,128,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Polygon(
          points={{64,0},{44,20},{44,10},{14,10},{14,-10},{44,-10},{44,-20},{64,
              0}},
          lineColor={0,128,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PowerConversion;
