within Buildings.Experimental.DistrictHeatingCooling.SubStations.BaseClasses;
partial model HeatingOrCooling "Base class for heating or cooling substation"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow(start=0),
    final dp(start=0),
    final allowFlowReversal=false);

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hex(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final from_dp=false,
    final linearizeFlowResistance=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final show_T=false,
    final Q_flow_nominal=-1,
    final dp_nominal=dp_nominal)
    "Component to remove heat from or add heat to fluid"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dynamicBalance=false,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final filteredSpeed=false) "Pump"
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
  connect(mPum_flow.y, pum.m_flow_in) annotation (Line(points={{-39,40},{-30.2,40},
          {-30.2,12}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-19,8},{-10,8},{-10,40},{60,40},
          {60,60},{110,60}}, color={0,0,127}));

  // fixme: add documentation
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics={
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
        fillPattern=FillPattern.Solid)}));
end HeatingOrCooling;
