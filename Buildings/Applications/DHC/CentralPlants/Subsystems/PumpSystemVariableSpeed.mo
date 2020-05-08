within Buildings.Applications.DHC.CentralPlants.Subsystems;
model PumpSystemVariableSpeed "Variable speed pumps for chilled water loop"
  import ChillerPlantSystem = WaterSide;
    replaceable package Medium =
      Buildings.Media.Water "Medium water";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate ";
    parameter Modelica.SIunits.Pressure dP_nominal
    "Nominal Pressure difference";
    parameter Modelica.SIunits.Pressure dPFrihealos_nominal
    "Frictional head loss";
    parameter Real v_flow_ratio[:] "volume flow rate ratio";
    parameter Real v_flow_rate[:] "volume flow rate rate";
    parameter Real Motor_eta[:] "Motor efficiency";
    parameter Real Hydra_eta[:] "Hydraulic efficiency";
    parameter Real Pressure[:] "Pressure at different flow rate";
    parameter Real N_nominal "Nominal speed";
  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed pum1(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    m_flow_nominal=m_flow_nominal,
    dP_nominal=dP_nominal,
    dPFrihealos_nominal=dPFrihealos_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Pressure=Pressure,
    N_nominal=N_nominal)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed pum2(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    m_flow_nominal=m_flow_nominal,
    dP_nominal=dP_nominal,
    dPFrihealos_nominal=dPFrihealos_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Pressure=Pressure,
    N_nominal=N_nominal)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Spe[2] "Speed signal" annotation (Placement(transformation(extent={{-118,51},
            {-100,69}})));
  Modelica.Blocks.Interfaces.RealOutput SpeRat[2]
    "Speed of the pump divided by the nominal value"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(pum2.port_a, port_a) annotation (Line(
      points={{-10,-30},{-40,-30},{-40,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pum1.port_a, port_a) annotation (Line(
      points={{-10,30},{-40,30},{-40,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pum2.port_b, port_b) annotation (Line(
      points={{10,-30},{40,-30},{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pum1.port_b, port_b) annotation (Line(
      points={{10,30},{40,30},{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(Spe[1], pum1.Spe) annotation (Line(
      points={{-109,55.5},{-66,55.5},{-22,55.5},{-22,36},{-12,36}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pum2.Spe, Spe[2]) annotation (Line(
      points={{-12,-24},{-38,-24},{-58,-24},{-58,64.5},{-109,64.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pum1.SpeRat, SpeRat[1]) annotation (Line(
      points={{11,38},{60,38},{60,55},{110,55}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pum2.SpeRat, SpeRat[2]) annotation (Line(
      points={{11,-22},{54,-22},{54,65},{110,65}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                               Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-38,-102},{48,-156}},
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
          points={{-40,0},{-40,-60},{-16,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{20,60},{40,60},{40,-60},{14,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,0},{90,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-20,-40},{20,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
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
end PumpSystemVariableSpeed;
