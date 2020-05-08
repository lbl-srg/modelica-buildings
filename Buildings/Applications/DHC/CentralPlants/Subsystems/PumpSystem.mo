within Buildings.Applications.DHC.CentralPlants.Subsystems;
model PumpSystem
  "Pumps for condenser water and chilled water systems"
    replaceable package Medium =
      Buildings.Media.Water "Medium water";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate ";
    parameter Real Motor_eta "Motor efficiency";
    parameter Real Hydra_eta "Hydraulic efficiency";
  WaterSide.BaseClasses.Components.PumpConstantSpeed pumConSpeC(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    m_flow_nominal=m_flow_nominal) "Constant Speed pump C"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  WaterSide.BaseClasses.Components.PumpConstantSpeed pumConSpeA(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    m_flow_nominal=m_flow_nominal) "Constant Speed pump A"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput On[3] "On signal"    annotation (Placement(transformation(extent={{-118,51},
            {-100,69}})));
  Modelica.Blocks.Interfaces.RealOutput P[3]
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(pumConSpeA.port_a, port_a)
    annotation (Line(
      points={{-10,-30},{-40,-30},{-40,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumConSpeC.port_a, port_a)
    annotation (Line(
      points={{-10,30},{-40,30},{-40,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumConSpeA.port_b, port_b)
    annotation (Line(
      points={{10,-30},{40,-30},{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumConSpeC.port_b, port_b)
    annotation (Line(
      points={{10,30},{40,30},{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumConSpeC.On, On[3])
    annotation (Line(
      points={{-10.9,36},{-40,36},{-40,66},{-109,66}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumConSpeA.On, On[1]) annotation (Line(
      points={{-10.9,-24},{-26,-24},{-26,36},{-40,36},{-40,54},{-109,54}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumConSpeC.P, P[3])
    annotation (Line(
      points={{11,36},{40,36},{40,66.6667},{110,66.6667}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumConSpeA.P, P[1])
    annotation (Line(
      points={{11,-24},{28,-24},{28,36},{40,36},{40,53.3333},{110,53.3333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-40,-102},{46,-156}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-20,80},{20,40}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,60},{-8,48},{-8,70},{16,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-40,0},{-40,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-40,60},{-20,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{-16,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{-40,-60},{-16,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{20,60},{40,60},{40,-60},{14,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,0},{14,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,0},{90,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,-40},{20,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,0},{-8,-12},{-8,10},{16,0}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{16,-60},{-8,-72},{-8,-50},{16,-60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
March 30, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PumpSystem;
