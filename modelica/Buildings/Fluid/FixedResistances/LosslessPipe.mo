within Buildings.Fluid.FixedResistances;
model LosslessPipe "Pipe with no flow friction and no heat transfer"
  extends Modelica.Fluid.Interfaces.PartialTwoPortTransport;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{-104,-50},{18,-116}},
          lineColor={0,0,255},
          textString="dp_nominal=0")}),
    Documentation(info="<html>
<p>
Model of a pipe with no flow resistance and no heat loss.
This model can be used to replace a <tt>replaceable</tt> pipe model
in flow legs in which no friction should be modeled, such as
in the outlet port of a three way valve.
</p>
</html>"),
revisions="<html>
<ul>
<li>
June 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
equation
 dp=0;
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
end LosslessPipe;
