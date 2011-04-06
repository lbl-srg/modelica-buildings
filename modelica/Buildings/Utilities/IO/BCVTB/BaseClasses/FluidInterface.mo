within Buildings.Utilities.IO.BCVTB.BaseClasses;
partial model FluidInterface
  "Partial class for fluid interface that can be coupled to BCVTB"
  import Buildings;
  extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nPorts=1 "Number of ports" annotation(Dialog(__Dymola_connectorSizing=true));
  Modelica.Blocks.Interfaces.RealInput m_flow_in if     use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}},
          rotation=0), iconTransformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}},
          rotation=0)));

   parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Medium.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Evaluate = true,
                Dialog(enable = not use_m_flow_in));

  Buildings.Fluid.Sensors.EnthalpyFlowRate totEntFloRat[nPorts](redeclare
      package Medium = Medium)
    "Total enthalpy flow rate (sensible plus latent)"
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports[
                                nPorts](
                     redeclare each package Medium = Medium,
                     m_flow(each max=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Leaving then 0 else
                                     +Modelica.Constants.inf,
                            each min=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Entering then 0 else
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
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
protected
  parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=
                   Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Allowed flow direction"               annotation(Evaluate=true, Dialog(tab="Advanced"));
equation
  connect(m_flow_in, bou.m_flow_in);
  if not use_m_flow_in then
    bou.m_flow_in = m_flow;
  end if;

  for i in 1:nPorts loop
  connect(totEntFloRat[i].port_b, bou.ports[i]) annotation (Line(
      points={{-20,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(sumHTot_flow.u, totEntFloRat.H_flow)
                                         annotation (Line(
      points={{-2,80},{-10,80},{-10,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.T_in, T_in) annotation (Line(
      points={{-62,4},{-80,4},{-80,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="bouBCVTB",
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
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
September 11, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end FluidInterface;
