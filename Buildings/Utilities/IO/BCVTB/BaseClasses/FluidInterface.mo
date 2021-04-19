within Buildings.Utilities.IO.BCVTB.BaseClasses;
partial model FluidInterface
  "Partial class for fluid interface that can be coupled to BCVTB"
  extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
  Modelica.Blocks.Interfaces.RealInput m_flow_in if use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}), iconTransformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

   parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable = not use_m_flow_in));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(group="Advanced"));

  Buildings.Fluid.Sensors.EnthalpyFlowRate totEntFloRat[nPorts](
    redeclare final package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal)
    "Total enthalpy flow rate (sensible plus latent)"
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports[
                                nPorts](
                     redeclare each package Medium = Medium,
                     each m_flow(max=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Leaving then 0 else
                                     +Modelica.Constants.inf,
                                 min=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Entering then 0 else
                                     -Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{88,40},{108,-40}})));

  Modelica.Blocks.Math.Sum sumHTot_flow(nin=nPorts)
    "Sum of total enthalpy flow rates"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Interfaces.RealOutput HSen_flow(unit="W")
    "Sensible enthalpy flow rate, positive if flow into the component"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    final use_T_in=true,
    final nPorts=nPorts,
    use_X_in=false,
    use_C_in=false,
    final use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
protected
  parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=
                   Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Allowed flow direction"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Sources.Constant m_flow_par(final k=m_flow)
    "Mass flow rate if set as a parameter"
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
equation
  if use_m_flow_in then
    connect(m_flow_in, bou.m_flow_in) annotation (Line(points={{-100,80},{-86,80},
            {-74,80},{-74,8},{-52,8}},
                                     color={0,0,127}));

  else
    connect(m_flow_par.y, bou.m_flow_in) annotation (Line(points={{-67,-20},{
            -60,-20},{-60,8},{-52,8}},
                                color={0,0,127}));
  end if;

  connect(totEntFloRat.port_b, bou.ports) annotation (Line(
      points={{-20,0},{-32,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sumHTot_flow.u, totEntFloRat.H_flow)
                                         annotation (Line(
      points={{-2,80},{-10,80},{-10,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.T_in, T_in) annotation (Line(
      points={{-54,4},{-80,4},{-80,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (defaultComponentName="bouBCVTB",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{-100,40},{-92,40}}, color={0,0,255}),
        Line(points={{-100,-40},{-92,-40}}, color={0,0,255}),
        Text(
          extent={{-168,50},{-66,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Rectangle(
          extent={{35,45},{100,-45}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
Documentation(
info="<html>
<p>
This is a partial model that is used to construct models for
interfacing fluid flow systems with the BCVTB interface.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 27, 2016, by Michael Wetter:<br/>
Refactored mass flow rate assignment to avoid using conditional connector
in a variable assignment.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
April 5, 2011, by Michael Wetter:<br/>
Added nominal values that are needed by the sensor.
</li>
<li>
September 11, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FluidInterface;
