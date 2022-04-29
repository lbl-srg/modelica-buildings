within Buildings.Obsolete.DistrictHeatingCooling.SubStations.BaseClasses;
partial model HeatingOrCooling "Base class for heating or cooling substation"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow(start=0),
    final dp(start=0),
    final allowFlowReversal=false);

  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa") = 30000
    "Pressure difference at nominal flow rate"
    annotation (Dialog(group="Design parameter"));

  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance"));
  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));

protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hex(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final from_dp=false,
    final linearizeFlowResistance=true,
    final show_T=false,
    final Q_flow_nominal=-1,
    final dp_nominal=dp_nominal,
    final deltaM=deltaM,
    final tau=tau,
    final energyDynamics=energyDynamics)
    "Component to remove heat from or add heat to fluid"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final use_inputFilter=false) "Pump"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Math.Gain mPum_flow "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-70,0},{-40,0}}, color={0,127,255}));
  connect(pum.port_b,hex. port_a)
    annotation (Line(points={{-20,0},{0,0},{20,0}}, color={0,127,255}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{40,0},{40,0},{100,0}}, color={0,127,255}));
  connect(mPum_flow.y, pum.m_flow_in) annotation (Line(points={{-39,40},{-30,40},
          {-30,12}},   color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-19,9},{-10,9},{-10,40},{60,40},
          {60,60},{110,60}}, color={0,0,127}));

  annotation ( Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                     graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-78,38},{80,38},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{52,70},{96,50}},
          textColor={0,0,127},
          textString="PPum")}),
    Documentation(info="<html>
<p>
Base class for a heating or cooling substation that draws
as much water as needed to maintain the prescribed temperature
difference <code>dTHex</code> over the heat exchanger.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li><li>
January 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingOrCooling;
