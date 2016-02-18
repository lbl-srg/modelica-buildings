within Buildings.Experimental.DistrictHeatingCooling.Plants.Validation;
model LakeWaterHeatExchanger_T_Heating
  "Validation model for lake water heat exchanger in which it provides heating"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 100
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+12
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+16
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TLooMax = 273.15+20
    "Maximum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMin = 273.15+8
    "Minimum loop temperature";

  LakeWaterHeatExchanger_T hex(redeclare package Medium = Medium,
    dp_nominal=10000,
    m_flow_nominal=m_flow_nominal,
    TLooMax=TLooMax,
    TLooMin=TLooMin) "Heat exchanger for free cooling"
    annotation (Placement(transformation(extent={{-30,-20},{-10,20}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=true) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
protected
  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
public
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    T=277.15) "Boundary condition"
    annotation (Placement(transformation(extent={{52,-10},{32,10}})));
  Fluid.Sources.MassFlowSource_T floSou(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
protected
  replaceable Modelica.Blocks.Sources.Ramp TWatCol(
    height=-10,
    duration=900,
    offset=273.15 + 20) constrainedby Modelica.Blocks.Interfaces.SO
    "Water temperature"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
protected
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=900,
    height=-2*m_flow_nominal,
    offset=m_flow_nominal,
    startTime=1800 + 900) "Mass flow rate"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
public
  Fluid.Sensors.TemperatureTwoPort temWar(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Warm water supply leg temperature"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sensors.TemperatureTwoPort temCol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Cold water supply leg temperature"
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));
public
  replaceable Modelica.Blocks.Sources.Constant TWatWar(k=273.15 + 4)
    constrainedby Modelica.Blocks.Interfaces.SO "Water temperature"
    annotation (Placement(transformation(extent={{90,12},{70,32}})));
equation
  connect(weaDat.weaBus, hex.weaBus) annotation (Line(
      points={{-40,40},{-20,40},{-20,13.4}},
      color={255,204,51},
      thickness=0.5));
  connect(hex.TSetHea, TSetH.y) annotation (Line(points={{-32,6},{-40,6},{-40,20},
          {-69,20}}, color={0,0,127}));
  connect(TSetC.y, hex.TSetCoo) annotation (Line(points={{-69,-10},{-50,-10},{-40,
          -10},{-40,0},{-32,0}},   color={0,0,127}));
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Plants/Validation/LakeWaterHeatExchanger_T_Heating.mos"
        "Simulate and plot"));
end LakeWaterHeatExchanger_T_Heating;
