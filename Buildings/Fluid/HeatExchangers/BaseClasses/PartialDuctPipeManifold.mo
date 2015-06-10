within Buildings.Fluid.HeatExchangers.BaseClasses;
partial model PartialDuctPipeManifold
  "Partial heat exchanger duct and pipe manifold"
  extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nPipPar(min=1) "Number of parallel pipes in each register";

  parameter Modelica.SIunits.MassFlowRate mStart_flow_a
    "Guess value for mass flow rate at port_a"
    annotation(Dialog(group = "Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare package Medium = Medium,
        m_flow(start=mStart_flow_a, min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-96,2},{0,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,62},{100,58}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,2},{100,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-58},{100,-62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-62},{2,62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,-48},{84,-120}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
            Documentation(info="<html>
<p>
Partial heat exchanger manifold.
This partial model defines ports and parameters that are used
for air-side and water-side heat exchanger manifolds.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
August 22, 2008, by Michael Wetter:<br/>
Added start value for port mass flow rate.
</li>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDuctPipeManifold;
