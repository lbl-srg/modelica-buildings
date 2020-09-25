within Buildings.Applications.DHC.CentralPlants.Cooling.Examples;
model CoolingPlantClosedLoop
  "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
    "Medium model for water";
  parameter Modelica.SIunits.Time perAve = 600
    "Period for time averaged variables";

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
  parameter Modelica.SIunits.Power QEva_nominal = mCHW_flow_nominal*cp*(7-16)
    "Nominal cooling capaciaty (Negative means cooling)";
  parameter Modelica.SIunits.MassFlowRate mMin_flow = 0.03
    "Minimum mass flow rate of single chiller";

  // control settings
  parameter Modelica.SIunits.Pressure dpSetPoi=68900
    "Differential pressure setpoint";
  parameter Modelica.SIunits.Temperature TCHWSet=273.15 + 7
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

  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium=Medium,
    m_flow_nominal=mCHW_flow_nominal,
    nSeg=10,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow(start=mCHW_flow_nominal))
    "Distribution pipe"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true, filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

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
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeriesHE bui(
    deltaTAirCoo=6,
    deltaTAirHea=18,
    loa(
    columns = {2,3}, timeScale=3600, offset={0,0}),
    filNam="modelica://Buildings/Resources/Data/Applications/DHC/CentralPlants/Cooling/Examples/Loads.txt",
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    T_aChiWat_nominal=280.15,
    T_bChiWat_nominal=289.15,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1) "Building model"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium =Medium)
    "Pressure difference measurement"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={30,-30})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUniHea.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium,
    use_T_in=true, nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-10,70})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={60,70})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(y(unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Continuous.Integrator EHeaAct(y(unit="J"))
    "Actual energy used for heating"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaReq_flow(y(unit="W"),
      final delta=perAve)
    "Time average of heating load"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaAct_flow(y(unit="W"),
      final delta=perAve)
    "Time average of heating heat flow rate"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Continuous.Integrator ECooReq(y(unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Modelica.Blocks.Continuous.Integrator ECooAct(y(unit="J"))
    "Actual energy used for cooling"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooReq_flow(y(unit="W"),
      final delta=perAve)
    "Time average of cooling load"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooAct_flow(y(unit="W"),
      final delta=perAve)
    "Time average of cooling heat flow rate"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-100,-30},{-90,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, pla.TWetBul) annotation (Line(
      points={{-90,-30},{-70,-30},{-70,2},{-62,2}},
      color={255,204,51},
      thickness=0.5));
  connect(TCHWSupSet.y, pla.TCHWSupSet) annotation (Line(points={{-79,20},{-74,20},
          {-74,13},{-62,13}}, color={0,0,127}));
  connect(pla.port_b, pip.port_a) annotation (Line(points={{-40,5},{-30,5},{-30,
          -20},{-20,-20}},
                     color={0,127,255}));
  connect(on.y, pla.on) annotation (Line(points={{-79,50},{-70,50},{-70,18},{-62,
          18}},     color={255,0,255}));
  connect(pip.port_b, bui.ports_aChiWat[1]) annotation (Line(points={{0,-20},{10,
          -20},{10,4},{20,4}}, color={0,127,255}));
  connect(bui.ports_bChiWat[1], pla.port_a) annotation (Line(points={{40,4},{50,
          4},{50,26},{-30,26},{-30,15},{-40,15}},
                                              color={0,127,255}));
  connect(pip.port_b, senRelPre.port_a) annotation (Line(points={{0,-20},{10,-20},
          {10,-30},{20,-30}}, color={0,127,255}));
  connect(senRelPre.port_b, bui.ports_bChiWat[1]) annotation (Line(points={{40,-30},
          {50,-30},{50,4},{40,4}},             color={0,127,255}));
  connect(senRelPre.p_rel, pla.dpMea) annotation (Line(points={{30,-39},{30,-48},
          {-74,-48},{-74,7},{-62,7}}, color={0,0,127}));
  connect(supHeaWat.T_in,THeaWatSup. y) annotation (Line(points={{-22,74},{-40,74},
          {-40,70},{-59,70}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_aHeaWat[1]) annotation (Line(points={{0,70},{
          10,70},{10,8},{20,8}},      color={0,127,255}));
  connect(bui.ports_bHeaWat[1], sinHeaWat.ports[1]) annotation (Line(points={{40,8},{
          46,8},{46,70},{50,70}},                     color={0,127,255}));
  connect(bui.QReqHea_flow, QAveHeaReq_flow.u) annotation (Line(points={{36.6667,
          -0.666667},{36.6667,-6},{74,-6},{74,70},{78,70}}, color={0,0,127}));
  connect(bui.QReqHea_flow, EHeaReq.u) annotation (Line(points={{36.6667,
          -0.666667},{36.6667,-6},{74,-6},{74,30},{78,30}},
                                                 color={0,0,127}));
  connect(bui.QHea_flow, QAveHeaAct_flow.u) annotation (Line(points={{40.6667,
          18.6667},{74,18.6667},{74,56},{114,56},{114,70},{118,70}},
                                                            color={0,0,127}));
  connect(bui.QHea_flow, EHeaAct.u) annotation (Line(points={{40.6667,18.6667},
          {74,18.6667},{74,56},{114,56},{114,30},{118,30}},color={0,0,127}));
  connect(bui.QReqCoo_flow, ECooReq.u) annotation (Line(points={{38.6667,
          -0.666667},{38.6667,-6},{74,-6},{74,-30},{78,-30}},
                                                     color={0,0,127}));
  connect(bui.QReqCoo_flow, QAveCooReq_flow.u) annotation (Line(points={{38.6667,
          -0.666667},{38.6667,-6},{74,-6},{74,-70},{78,-70}},   color={0,0,127}));
  connect(bui.QCoo_flow, ECooAct.u) annotation (Line(points={{40.6667,17.3333},
          {74,17.3333},{74,-6},{110,-6},{110,-30},{118,-30}},  color={0,0,127}));
  connect(bui.QCoo_flow, QAveCooAct_flow.u) annotation (Line(points={{40.6667,
          17.3333},{74,17.3333},{74,-6},{110,-6},{110,-70},{118,-70}},
                                                                color={0,0,127}));
  connect(bui.PPum, PPum) annotation (Line(points={{40.6667,12},{74,12},{74,0},
          {150,0}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Examples/CoolingPlantClosedLoop.mos"
        "Simulate and Plot"));
end CoolingPlantClosedLoop;
