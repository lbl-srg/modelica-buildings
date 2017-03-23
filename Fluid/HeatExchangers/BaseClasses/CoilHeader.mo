within Buildings.Fluid.HeatExchangers.BaseClasses;
model CoilHeader "Header for a heat exchanger register"
  extends Buildings.BaseClasses.BaseIcon;

  outer Modelica.Fluid.System system "System wide properties";

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean allowFlowReversal = system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nPipPar(min=1) "Number of parallel pipes in each register";
  parameter Modelica.SIunits.MassFlowRate mStart_flow_a
    "Guess value for mass flow rate at port_a"
    annotation(Dialog(group = "Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a[nPipPar](
        redeclare each final package Medium = Medium,
        each m_flow(start=mStart_flow_a/nPipPar, min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));

  Modelica.Fluid.Interfaces.FluidPort_b port_b[nPipPar](
        redeclare each final package Medium = Medium,
        each m_flow(start=-mStart_flow_a/nPipPar, max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0)));

equation
  connect(port_a, port_b) annotation (Line(points={{-100,0},{-50,0},{-50,0},{
          100,0},{100,0}},                                   color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
Documentation(info="<html>
<p>
Header for a heat exchanger coil.
</p>
<p>
This model connects the flow between its ports without
modeling flow friction.
Currently, the ports are connected without redistributing
the flow. In latter versions, the model may be changed to define
different flow reroutings in the coil header.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 22, 2008, by Michael Wetter:<br/>
Added start value for port mass flow rate.
</li>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,-58},{100,-62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,2},{100,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,62},{100,58}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end CoilHeader;
