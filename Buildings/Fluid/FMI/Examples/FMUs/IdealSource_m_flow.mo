within Buildings.Fluid.FMI.Examples.FMUs;
block IdealSource_m_flow "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPort(
     redeclare replaceable package Medium = Buildings.Media.Air);

  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s")
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}), iconTransformation(extent={{-120,70},{-100,90}})));

equation
  assert(abs(inlet.m_flow-outlet.m_flow) < 1E-2,
  "The mass flow rate of port_a and port_b is not conserved.
  This indicates a wrong configuration of your system model.");
  outlet.m_flow = m_flow_in;
  outlet.p = inlet.p;

  // We use connect statements, in particular
  // because outlet.backward and inlet.backward
  // is removed if allowFlowReversal=false
  connect(inlet.forward, outlet.forward);
  connect(outlet.backward, inlet.backward);

  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU that sets the mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/IdealSource_m_flow.mos"
        "Export FMU"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
                              Text(
          extent={{-94,110},{-50,52}},
          lineColor={0,0,127},
          textString="m_flow"),
        Ellipse(
          extent={{-16,18},{24,-22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-8,14},{-8,-16},{22,-2},{-8,14}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}));
end IdealSource_m_flow;
