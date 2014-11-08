within Buildings.Fluid.FMI.Examples;
block IdealSource_m_flow "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPort(
     redeclare replaceable package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated);

  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s")
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));

equation
  assert(abs(inlet.m_flow-outlet.m_flow) < 1E-2,
  "The mass flow rate of port_a and port_b is not conserved.
  This indicates a wrong configuration of your system model.");
  outlet.m_flow = m_flow_in;
  outlet.p = inlet.p;

  inlet.forward.h = outlet.forward.h;
  outlet.backward.h = inlet.backward.h;

  inlet.forward.Xi = outlet.forward.Xi;
  outlet.backward.Xi = inlet.backward.Xi;

  inlet.forward.C = outlet.forward.C;
  outlet.backward.C = inlet.backward.C;

  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU that sets the mass flow rate.
</p>
<p>
In Dymola, to export the model as an FMU,
select from the pull down menu <code>Commands - Export FMU</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/IdealSource_m_flow.mos"
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
          extent={{-96,88},{-52,30}},
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
