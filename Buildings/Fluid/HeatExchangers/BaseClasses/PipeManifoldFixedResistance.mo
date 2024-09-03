within Buildings.Fluid.HeatExchangers.BaseClasses;
model PipeManifoldFixedResistance
  "Pipe manifold for a heat exchanger connection"
  extends PartialPipeManifold;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Mass flow rate at port_a" annotation (Dialog(group="Nominal Condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(min=0, displayUnit=
        "Pa") "Pressure drop" annotation (Dialog(group="Nominal Condition"));

  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.Units.SI.Length dh=0.025
    "Hydraulic diameter for each pipe"
    annotation (Dialog(enable=use_dh and not linearized));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts"
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

  Buildings.Fluid.FixedResistances.PressureDrop fixRes(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    from_dp=from_dp,
    deltaM=deltaM,
    linearized=linearized) "Fixed resistance for each duct"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
protected
  PipeManifoldFlowDistributor floDis(
    redeclare package Medium = Medium,
    nPipPar=nPipPar,
    mStart_flow_a=mStart_flow_a,
    allowFlowReversal=allowFlowReversal)
    "Mass flow distributor to the individual pipes"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(fixRes.port_b, floDis.port_a) annotation (Line(
      points={{-20,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floDis.port_b, port_b) annotation (Line(
      points={{60,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixRes.port_a, port_a) annotation (Line(
      points={{-40,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p>
Pipe manifold with a fixed flow resistance.
</p>
<p>
This model is composed of a pressure drop calculation, and
a flow distributor. The flow distributor distributes the
mass flow rate equally to each instance of <code>port_b</code>,
without having to compute a pressure drop in each flow leg.
</p>
<p>
<b>Note:</b> It is important that there is an equal pressure drop
in each flow leg between this model, and the model that collects the flows.
Otherwise, no solution may exist, and therefore the simulation may
stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
June 29, 2014, by Michael Wetter:<br/>
Added model that distributes the mass flow rate equally to each
instance of <code>port_b</code>.
</li>
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
