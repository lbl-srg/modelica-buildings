within Buildings.Fluid.Chillers.Examples.BaseClasses;
partial model PartialElectric_AirCooled
  "Base class for test model of chiller electric EIR with air-cooled condenser"
 package Medium1 = Buildings.Media.Air "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.Power P_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate at condenser";

  Sources.MassFlowSource_WeatherData sou1(
    redeclare package Medium = Medium1,
    m_flow=mCon_flow_nominal)
    "Weather data"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=mEva_flow_nominal,
    T=291.15) "Mass flow source"
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,40})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2,
    nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-20})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=3600*6,
    startTime=197.25*24*3600,
    offset=273.15 + 5,
    height=5) "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    offset=273.15 + 10,
    height=6,
    startTime=197*24*3600,
    duration=12*3600)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600/2)
    "Pulse signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.5)
    "Greater threshold"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{32,30},{52,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    dp_nominal=6000,
    redeclare package Medium = Medium2,
    m_flow_nominal=mEva_flow_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(TEva_in.y, sou2.T_in) annotation (Line(
      points={{71,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greaterThreshold.u, pulse.y) annotation (Line(
      points={{-42,90},{-59,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res1.port_b, sin1.ports[1]) annotation (Line(
      points={{52,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, sin2.ports[1]) annotation (Line(
      points={{-40,-20},{-60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, sou1.weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,16.2},{-60,16.2}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,120}})), Icon(
        coordinateSystem(extent={{-120,-100},{100,120}})));
end PartialElectric_AirCooled;
