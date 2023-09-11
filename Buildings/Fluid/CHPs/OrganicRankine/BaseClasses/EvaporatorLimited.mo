within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model EvaporatorLimited
  "Evaporator that limits the direction of heat flow"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.Units.SI.ThermalConductance UA
    "Thermal conductance of heat exchanger";
  parameter Modelica.Units.SI.Temperature TWorFlu
    "Temperature of the ORC working fluid";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    min=0,
    displayUnit="Pa") "Pressure difference"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final UA=UA,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal) "Evaporator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Math.SmoothMin smoMin(deltaX=0.1) "Smooth maximum"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
protected
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final tau=0,
    final initType=Modelica.Blocks.Types.Init.SteadyState,
    final transferHeat=false)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Constant SouTWorFlu(final k=TWorFlu) "Source block"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(eva.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(eva.Q_flow, Q_flow) annotation (Line(points={{11,4},{80,4},{80,-60},{110,
          -60}}, color={0,0,127}));
  connect(senTem.port_b, eva.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_a, port_a)
    annotation (Line(points={{-60,0},{-100,0}}, color={0,127,255}));
  connect(SouTWorFlu.y, smoMin.u2) annotation (Line(points={{-59,-70},{-50,-70},
          {-50,-56},{-42,-56}}, color={0,0,127}));
  connect(senTem.T, smoMin.u1) annotation (Line(points={{-50,11},{-50,20},{-70,20},
          {-70,-44},{-42,-44}}, color={0,0,127}));
  connect(smoMin.y, preTem.T)
    annotation (Line(points={{-19,-50},{-2,-50}}, color={0,0,127}));
  connect(eva.port_ref, preTem.port) annotation (Line(points={{0,-6},{0,-20},{40,
          -20},{40,-50},{20,-50}}, color={191,0,0}));
annotation (defaultComponentName="eva",
Documentation(info="<html>
<p>
This model is based on
<a href=\"Modelica://Buildings.Fluid.HeatExchangers.EvaporatorCondenser\">
Buildings.Fluid.HeatExchangers.EvaporatorCondenser</a>
and limits the direction of the heat flow.
Namely, when the upstream temperature of the evaporator goes below
the evaporation temperature of the working fluid,
the temperature differential used to compute heat flow will be locked at zero.
This setup is to avoid an unintended negative power generation
(i.e. power consumption) at the Rankine cycle.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 8, 2023, by Hongxiang:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end EvaporatorLimited;
