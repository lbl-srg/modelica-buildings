within Buildings.Fluid.HeatExchangers.BaseClasses;
model PipeManifoldFixedResistance
  "Pipe manifold for a heat exchanger connection"
  extends PartialPipeManifold;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate at port_a"                                 annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0) "Pressure"
                                              annotation(Dialog(group = "Nominal Condition"));

  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.SIunits.Length dh=0.025 "Hydraulic diameter for each pipe"
        annotation(Dialog(enable = use_dh and not linearized));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
   annotation(Dialog(enable = use_dh and not linearized));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Dialog(enable = not use_dh and not linearized));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  Fluid.FixedResistances.FixedResistanceDpM[nPipPar] fixRes(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal/nPipPar,
    each m_flow(start=mStart_flow_a),
    each dp_nominal=dp_nominal,
    each dh=dh,
    each from_dp=from_dp,
    each deltaM=deltaM,
    each ReC=ReC,
    each use_dh=use_dh,
    each linearized=linearized) "Fixed resistance for each duct"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));
equation
  for i in 1:nPipPar loop
    connect(port_a, fixRes[i].port_a) annotation (Line(points={{-100,
            5.55112e-016},{-56,5.55112e-016},{-56,6.10623e-016},{-10,
            6.10623e-016}}, color={0,127,255}));
    connect(fixRes[i].port_b, port_b[i]) annotation (Line(points={{10,
            6.10623e-016},{52,6.10623e-016},{52,5.55112e-016},{100,5.55112e-016}},
          color={0,127,255}));
  end for;
annotation (Diagram(graphics),
Documentation(info="<html>
<p>
Pipe manifold with a fixed flow resistance.
</p>
<p>
This model causes the flow to be distributed equally
into each flow path by using a fixed flow resistance
for each flow path.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 10, 2008, by Michael Wetter:<br/>
Added additional parameters.
</li>
<li>
August 22, 2008, by Michael Wetter:<br/>
Added start value for resistance mass flow rate.
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
          extent={{30,68},{74,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,8},{76,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-52},{76,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end PipeManifoldFixedResistance;
