within Buildings.Fluids.Actuators.BaseClasses;
partial model PartialThreeWayValve "Partial three way valve"
    extends Buildings.Fluids.BaseClasses.PartialThreeWayResistance(
        redeclare FixedResistances.LosslessPipe res2(
            redeclare package Medium = Medium));
    extends Buildings.Fluids.Actuators.BaseClasses.ValveParameters(
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,44},{100,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,26},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-2,2},{-80,64},{-80,-56},{-2,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,56},{-2,2},{54,44},{74,60},{-70,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,-40},{-2,2},{54,44},{58,-40},{-58,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,2},{80,64},{80,-54},{-2,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-56},{24,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-14,-56},{14,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-2,2},{60,-80},{-60,-80},{-2,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Partial model of a three way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening. The three way valve model consists of a mixer where 
valves are placed in two of the flow legs. The third flow leg
has no friction. 
The flow coefficient <tt>Kv_SI</tt> for flow from <tt>port_1 -> port_2</tt> is
a parameter and the flow coefficient for flow from <tt>port_3 -> port_2</tt>
is computed as<pre>
         Kv_SI(port_1 -> port_2)
  fraK = ----------------------
         Kv_SI(port_3 -> port_2)
</pre> 
where <tt>fraK</tt> is a parameter.
</p><p>
Since this model uses two way valves to construct a three way valve, see 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a> for details regarding the valve implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  parameter Real fraK(min=0, max=1) = 0.7
    "Fraction Kv_SI(port_1->port_2)/Kv_SI(port_3->port_2)";
  parameter Real[2] l(min=0, max=1) = {0, 0} "Valve leakage, l=Cv(y=0)/Cvs";
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1" 
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Medium.MassFlowRate m0_flow(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0 = 6000 "Nominal pressure drop" 
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean[2] linearized = {false, false}
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput y "Damper position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0)));
protected
  Modelica.Blocks.Math.Feedback inv "Inversion of control signal" 
    annotation (Placement(transformation(extent={{-54,62},{-34,82}}, rotation=0)));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for bypass valve" 
    annotation (Placement(transformation(extent={{-84,62},{-64,82}}, rotation=0)));
equation
  connect(uni.y, inv.u1) 
    annotation (Line(points={{-63,72},{-52,72}}, color={0,0,127}));
end PartialThreeWayValve;
