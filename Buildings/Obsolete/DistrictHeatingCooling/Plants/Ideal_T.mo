within Buildings.Obsolete.DistrictHeatingCooling.Plants;
model Ideal_T
  "Ideal heating and cooling plant with leaving temperature as set point"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow(start=0),
    final allowFlowReversal = true,
    final dp(start=0));

  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa") = 30000
    "Pressure difference at nominal flow rate"
    annotation (Dialog(group="Design parameter"));

  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealOutput QHea_flow(unit="W")
    "Heat input into fluid"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(unit="W")
    "Heat extracted from fluid"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Buildings.Fluid.HeatExchangers.PrescribedOutlet coo(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    QMax_flow=0,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=60,
    use_X_wSet=false)
            "Cooling supply"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));

  Buildings.Fluid.HeatExchangers.PrescribedOutlet hea(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    show_T=true,
    QMin_flow=0,
    dp_nominal=dp_nominal,
    linearizeFlowResistance=linearizeFlowResistance,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=60,
    use_X_wSet=false)
            "Heat supply"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
public
  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
equation
  connect(QHea_flow, hea.Q_flow) annotation (Line(points={{110,60},{-10,60},{
          -10,8},{-19,8}},  color={0,0,127}));
  connect(coo.Q_flow, QCoo_flow) annotation (Line(points={{19,8},{10,8},{10,20},
          {10,40},{110,40}},             color={0,0,127}));
  connect(port_a, hea.port_a)
    annotation (Line(points={{-100,0},{-40,0}},         color={0,127,255}));
  connect(coo.port_a, port_b)
    annotation (Line(points={{40,0},{100,0}},         color={0,127,255}));
  connect(hea.port_b, senTem.port_a)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, coo.port_b)
    annotation (Line(points={{10,0},{15,0},{20,0}}, color={0,127,255}));
  connect(hea.TSet, TSetHea) annotation (Line(points={{-42,8},{-58,8},{-58,80},
          {-120,80}}, color={0,0,127}));
  connect(TSetCoo, coo.TSet) annotation (Line(points={{-120,40},{-102,40},{-80,
          40},{-80,20},{52,20},{52,8},{42,8}}, color={0,0,127}));
  annotation ( Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,70},{70,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,6},{98,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-4},{98,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model of an ideal heating and cooling plant that takes as a parameter the set point
for the leaving fluid temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2016, by Michael Wetter:<br/>
Set energy balance of heater and cooler to be dynamic and added
a temperature sensor.
This is due to a potential bug in Dymola 2016, Dassault SR00312338.
</li>
<li>
December 23, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ideal_T;
