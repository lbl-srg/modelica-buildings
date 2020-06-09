within Buildings.Applications.DHC.CentralPlants.Cooling.Examples;
model CoolingPlantOpenLoop
  "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  // chiller and cooling tower
  redeclare parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
    perChi;
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=18.3
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=34.7
    "Nominal condenser water mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal=44.8*1000
    "Nominal chilled water side pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal=46.2*1000
    "Nominal condenser water side pressure";
  parameter Modelica.SIunits.Power QEva_nominal = mCHW_flow_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty (Negative means cooling)";
  parameter Modelica.SIunits.MassFlowRate mMin_flow = 0.03
    "Minimum mass flow rate of single chiller";

  // control settings
  parameter Modelica.SIunits.Pressure dpSetPoi=68900
    "Differential pressure setpoint";
  parameter Modelica.SIunits.Temperature TCHWSet = 273.15 + 8
    "Chilled water temperature setpoint";
  parameter Modelica.SIunits.Time tWai=30 "Waiting time";

  // pumps
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCHW_flow_nominal/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCHW_nominal+dpSetPoi+18000+30000)*{1.5,1.3,1.0,0.6}))
    "Performance data for chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCW_flow_nominal/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCW_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.SIunits.Pressure dpCHWPum_nominal=6000
    "Nominal pressure drop of chilled water pumps";
  parameter Modelica.SIunits.Pressure dpCWPum_nominal=6000
    "Nominal pressure drop of chilled water pumps";

  Buildings.Applications.DHC.CentralPlants.Cooling.Plant pla(
    perChi=perChi,
    perCHWPum=perCHWPum,
    perCWPum=perCWPum,
    mCHW_flow_nominal=mCHW_flow_nominal,
    dpCHW_nominal=dpCHW_nominal,
    QEva_nominal=QEva_nominal,
    mMin_flow=mMin_flow,
    mCW_flow_nominal=mCW_flow_nominal,
    dpCW_nominal=dpCW_nominal,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    dT_nominal=5.56,
    TMin=288.15,
    PFan_nominal=5000,
    dpCHWPum_nominal=dpCHWPum_nominal,
    dpCWPum_nominal=dpCWPum_nominal,
    tWai=tWai,
    dpSetPoi=dpSetPoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District cooling plant"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Sources.Boundary_pT watSin(redeclare package Medium=Medium,
      nPorts=1)
    "Water sink"
    annotation (Placement(transformation(extent={{62,-30},{42,-10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Ramp dpMea(
    offset=0.5*dpSetPoi,
    height=0.4*dpSetPoi,
    startTime=21600,
    duration=21600) "Measured pressure difference"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T watSou(
    redeclare package Medium = Medium,
    m_flow=pla.numChi*mCHW_flow_nominal,
    T=291.15,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    dp_nominal=6000,
    redeclare package Medium = Medium,
    m_flow_nominal=pla.numChi*mCHW_flow_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,-50},{-50,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(dpMea.y, pla.dpMea) annotation (Line(points={{-39,-10},{-32,-10},{-32,
          7},{-22,7}},                                                     color={0,0,127}));
  connect(weaBus.TWetBul, pla.TWetBul) annotation (Line(
      points={{-50,-50},{-30,-50},{-30,2},{-22,2}},
      color={255,204,51},
      thickness=0.5));
  connect(on.y, pla.on) annotation (Line(points={{-39,50},{-30,50},{-30,18},{-22,
          18}}, color={255,0,255}));
  connect(watSou.ports[1], pla.port_a) annotation (Line(points={{40,20},{8,20},{
          8,15},{0,15}}, color={0,127,255}));
  connect(pla.port_b, res.port_a) annotation (Line(points={{0,5},{8,5},{8,-20},{
          12,-20}}, color={0,127,255}));
  connect(res.port_b, watSin.ports[1]) annotation (Line(points={{32,-20},{42,-20}}, color={0,127,255}));
  connect(TCHWSupSet.y, pla.TCHWSupSet) annotation (Line(points={{-39,20},{-32,20},
          {-32,13},{-22,13}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Tolerance=1e-06),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Examples/CoolingPlantOpenLoop.mos"
        "Simulate and Plot"));
end CoolingPlantOpenLoop;
