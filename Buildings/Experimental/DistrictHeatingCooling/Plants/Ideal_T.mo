within Buildings.Experimental.DistrictHeatingCooling.Plants;
model Ideal_T
  "Ideal heating and cooling plant with leaving temperature as set point"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal = Q_flow_nominal/4200/dT_nominal,
    final m_flow(start=0),
    final allowFlowReversal = true,
    final dp(start=0));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Nominal capacity (either heating or cooling), used to compute nominal mass flow rate";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+8
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+14
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe, used to compute nominal mass flow rate"
    annotation(Dialog(group="Design parameter"));

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
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Buildings.Fluid.HeatExchangers.HeaterCooler_T coo(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    Q_flow_maxHeat=0,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=60) "Cooling supply"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    show_T=true,
    Q_flow_maxCool=0,
    dp_nominal=dp_nominal,
    linearizeFlowResistance=linearizeFlowResistance,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=60) "Heat supply"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{80,12},{60,32}})));

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(TSetH.y, hea.TSet) annotation (Line(points={{-69,30},{-60,30},{-60,6},
          {-42,6}},           color={0,0,127}));
  connect(QHea_flow, hea.Q_flow) annotation (Line(points={{110,60},{-10,60},{
          -10,6},{-19,6}},  color={0,0,127}));
  connect(coo.Q_flow, QCoo_flow) annotation (Line(points={{19,6},{10,6},{10,20},
          {10,40},{110,40}},             color={0,0,127}));
  connect(TSetC.y, coo.TSet) annotation (Line(points={{59,22},{54,22},{50,22},{
          50,6},{42,6}},         color={0,0,127}));
  connect(port_a, hea.port_a)
    annotation (Line(points={{-100,0},{-40,0}},         color={0,127,255}));
  connect(coo.port_a, port_b)
    annotation (Line(points={{40,0},{100,0}},         color={0,127,255}));
  connect(hea.port_b, senTem.port_a)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, coo.port_b)
    annotation (Line(points={{10,0},{15,0},{20,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
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
