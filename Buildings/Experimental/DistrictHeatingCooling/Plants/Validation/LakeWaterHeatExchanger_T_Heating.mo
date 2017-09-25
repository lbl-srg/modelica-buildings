within Buildings.Experimental.DistrictHeatingCooling.Plants.Validation;
model LakeWaterHeatExchanger_T_Heating
  "Validation model for lake water heat exchanger in which it provides heating"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 100
    "Nominal mass flow rate";

  LakeWaterHeatExchanger_T hex(redeclare package Medium = Medium,
    dpHex_nominal=10000,
    m_flow_nominal=m_flow_nominal) "Heat exchanger for free cooling"
    annotation (Placement(transformation(extent={{-30,-20},{-10,20}})));
  Modelica.Blocks.Sources.Constant TSetH(k=273.15 + 16)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant TSetC(k=273.15 + 8)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    T=277.15) "Boundary condition"
    annotation (Placement(transformation(extent={{52,-10},{32,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T floSou(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));

  replaceable Modelica.Blocks.Sources.Ramp TWatCol(
    height=-10,
    duration=900,
    offset=273.15 + 20) constrainedby Modelica.Blocks.Interfaces.SO
    "Water temperature"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));

  Modelica.Blocks.Sources.Ramp m_flow(
    duration=900,
    height=-2*m_flow_nominal,
    offset=m_flow_nominal,
    startTime=1800 + 900) "Mass flow rate"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort temWar(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Warm water supply leg temperature"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temCol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Cold water supply leg temperature"
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));

  replaceable Modelica.Blocks.Sources.Constant TWatWar(k=273.15 + 4)
    constrainedby Modelica.Blocks.Interfaces.SO "Water temperature"
    annotation (Placement(transformation(extent={{90,12},{70,32}})));

  Modelica.Blocks.Sources.Constant TWatSou(k=273.15 + 15)
    "Ocean water temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant
                               TSouHea(k=273.15 + 20)
    "Ambient temperature used to heat up loop"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant TSouCoo(k=273.15 + 18)
    "Ambient temperature used to cool loop"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(hex.TSetHea, TSetH.y) annotation (Line(points={{-32,6},{-54,6},{-54,
          -30},{-59,-30}},
                     color={0,0,127}));
  connect(TSetC.y, hex.TSetCoo) annotation (Line(points={{-59,-70},{-59,-70},{
          -50,-70},{-50,2},{-32,2}},
                                   color={0,0,127}));
  connect(hex.port_b2, hex.port_a1) annotation (Line(points={{-30,-16},{-36,-16},
          {-36,-4},{-30,-4}}, color={0,127,255}));
  connect(TWatCol.y, floSou.T_in) annotation (Line(points={{69,-60},{60,-60},{
          60,-36},{52,-36}}, color={0,0,127}));
  connect(m_flow.y, floSou.m_flow_in) annotation (Line(points={{69,-20},{60,-20},
          {60,-32},{50,-32}}, color={0,0,127}));
  connect(hex.port_b1, temWar.port_a) annotation (Line(points={{-10,-4},{-6,-4},
          {-6,0},{0,0}}, color={0,127,255}));
  connect(temWar.port_b, bou.ports[1])
    annotation (Line(points={{20,0},{30,0},{32,0}}, color={0,127,255}));
  connect(temCol.port_a, floSou.ports[1])
    annotation (Line(points={{20,-40},{25,-40},{30,-40}}, color={0,127,255}));
  connect(temCol.port_b, hex.port_a2) annotation (Line(points={{0,-40},{-4,-40},
          {-4,-16},{-10,-16}}, color={0,127,255}));
  connect(TWatWar.y, bou.T_in)
    annotation (Line(points={{69,22},{60,22},{60,4},{54,4}}, color={0,0,127}));
  connect(TWatSou.y, hex.TSouWat)
    annotation (Line(points={{-59,80},{-40,80},{-40,18},{-34,18},{-34,18},{-32,
          18},{-32,18}},                                  color={0,0,127}));
  connect(TSouHea.y, hex.TSouHea) annotation (Line(points={{-59,50},{-44,50},{
          -44,14},{-32,14}}, color={0,0,127}));
  connect(TSouCoo.y, hex.TSouCoo) annotation (Line(points={{-59,20},{-48,20},{
          -48,10},{-32,10}}, color={0,0,127}));
  annotation (    experiment(Tolerance=1e-6, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Plants/Validation/LakeWaterHeatExchanger_T_Heating.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model in which the inlet water temperature on the cold side of the
heat exchanger is gradually decreased.
Toward the end of the simulation, the water flow through the heat exchanger
reverses its direction.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2017, by Felix Buenning:<br/>
Corrected offset for temperature from <i>275.15</i> to <i>273.15</i> in <code>TWatSou</code>.
</li>
<li>
January 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LakeWaterHeatExchanger_T_Heating;
