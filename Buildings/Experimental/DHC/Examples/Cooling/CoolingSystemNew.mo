within Buildings.Applications.DHC.Examples.Cooling;
model CoolingSystemNew
  "Example to test the district cooling network model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  parameter Integer nBui = 3
    "Number of buildings connected to each distribution branch, excluding the most remote one";

  parameter Boolean allowFlowReversal = false
    "Set to true to allow flow reversal in the distribution and connections";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy dynamics: fixed initial";

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

  // buildings
  parameter String filNam="modelica://Buildings/Resources/Data/Applications/DHC/Examples/Cooling/Loads.txt"
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.SIunits.Power Q_flow_nominal(max=-Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)Nominal heat flow rate, negative";
  final parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)=Q_flow_nominal/(cp*(bld4.TChiWatSup_nominal - bld4.TChiWatRet_nominal))
    "Nominal mass flow rate of building cooling side";

  BaseClasses.BuildingTimeSeriesWithETSCooling                                      bld123[nBui](
    redeclare each package Medium = Medium,
    each filNam=filNam,
    each mDis_flow_nominal=mBui_flow_nominal,
    each mBui_flow_nominal=mBui_flow_nominal,
    each mByp_flow_nominal=0.1)
    "Building with cooling load"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks.UnidirectionalParallel disBra1(
    redeclare package Medium = Medium,
    nCon=nBui,
    mDis_flow_nominal=4*mBui_flow_nominal,
    mCon_flow_nominal={mBui_flow_nominal,mBui_flow_nominal,mBui_flow_nominal},
    mEnd_flow_nominal=mBui_flow_nominal,
    lDis={100,100,100},
    lCon={50,50,50},
    lEnd=50,
    dhDis={0.4,0.3,0.2},
    dhCon={0.1,0.1,0.1},
    allowFlowReversal=allowFlowReversal,
    dhEnd=0.1)
    "Distribution branch 1"
    annotation (Placement(transformation(extent={{10,0},{50,20}})));
  BaseClasses.BuildingTimeSeriesWithETSCooling                                      bld4(
    redeclare package Medium = Medium,
    filNam=filNam,
    mDis_flow_nominal=mBui_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=0.1)
    "Building with cooling load"
    annotation (Placement(transformation(extent={{90,0},{70,20}})));
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
    energyDynamics=energyDynamics)
    "District cooling plant"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BaseClasses.BuildingTimeSeriesWithETSCooling                                      bld8(
    redeclare package Medium = Medium,
    filNam=filNam,
    mDis_flow_nominal=mBui_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=0.1)
    "Building 8 with cooling load"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
  Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks.UnidirectionalParallel disBra2(
    redeclare package Medium = Medium,
    nCon=nBui,
    mDis_flow_nominal=4*mBui_flow_nominal,
    mCon_flow_nominal={mBui_flow_nominal,mBui_flow_nominal,mBui_flow_nominal},
    mEnd_flow_nominal=mBui_flow_nominal,
    lDis={100,100,100},
    lCon={50,50,50},
    lEnd=50,
    dhDis={0.4,0.3,0.2},
    dhCon={0.1,0.1,0.1},
    allowFlowReversal=allowFlowReversal,
    dhEnd=0.1)
    "Distribution branch 1"
    annotation (Placement(transformation(extent={{10,-80},{50,-60}})));
  BaseClasses.BuildingTimeSeriesWithETSCooling                                      bld567[nBui](
    redeclare each package Medium = Medium,
    each filNam=filNam,
    each mDis_flow_nominal=mBui_flow_nominal,
    each mBui_flow_nominal=mBui_flow_nominal,
    each mByp_flow_nominal=0.1)
    "Building 5,6,7 with cooling load"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

equation
  connect(disBra1.port_aDisRet,bld4. port_b) annotation (Line(points={{50,4},{58,
          4},{58,10},{70,10}}, color={0,127,255}));
  connect(disBra1.ports_bCon, bld123.port_a) annotation (Line(points={{18,20},{18,
          30},{12,30},{12,50},{20,50}}, color={0,127,255}));
  connect(bld123.port_b, disBra1.ports_aCon) annotation (Line(points={{40,50},{48,
          50},{48,30},{42,30},{42,20}}, color={0,127,255}));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-60,-50},{-50,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul,pla. TWetBul) annotation (Line(
      points={{-50,-50},{-40,-50},{-40,2},{-32,2}},
      color={255,204,51},
      thickness=0.5));
  connect(on.y,pla. on) annotation (Line(points={{-59,50},{-40,50},{-40,18},{-32,
          18}}, color={255,0,255}));
  connect(pla.port_a, disBra1.port_bDisRet)
    annotation (Line(points={{-10,15},{-4,15},{-4,4},{10,4}},
                                                          color={0,127,255}));
  connect(bld123[3].p_rel, pla.dpMea) annotation (Line(points={{41,53},{50,53},{
          50,72},{-90,72},{-90,0},{-50,0},{-50,7},{-32,7}},  color={0,0,127}));
  connect(disBra2.ports_bCon, bld567.port_a) annotation (Line(points={{18,-60},{
          18,-52},{14,-52},{14,-30},{20,-30}},  color={0,127,255}));
  connect(bld567.port_b, disBra2.ports_aCon) annotation (Line(points={{40,-30},{
          46,-30},{46,-52},{42,-52},{42,-60}},  color={0,127,255}));
  connect(disBra2.port_aDisRet, bld8.port_b) annotation (Line(points={{50,-76},{
          60,-76},{60,-70},{70,-70}},  color={0,127,255}));
  connect(pla.port_b, disBra2.port_aDisSup) annotation (Line(points={{-10,5},{4,
          5},{4,-70},{10,-70}},
                             color={0,127,255}));
  connect(disBra2.port_bDisRet, pla.port_a) annotation (Line(points={{10,-76},{-4,
          -76},{-4,15},{-10,15}},color={0,127,255}));
  connect(TCHWSupSet.y, pla.TCHWSupSet) annotation (Line(points={{-59,20},{-50,20},
          {-50,13},{-32,13}}, color={0,0,127}));
  connect(pla.port_b, disBra1.port_aDisSup) annotation (Line(points={{-10,5},{4,
          5},{4,10},{10,10}}, color={0,127,255}));
  connect(bld8.port_a, disBra2.port_bDisSup) annotation (Line(points={{90,-70},{
          96,-70},{96,-52},{58,-52},{58,-70},{50,-70}}, color={0,127,255}));
  connect(bld4.port_a, disBra1.port_bDisSup) annotation (Line(points={{90,10},{96,
          10},{96,26},{56,26},{56,10},{50,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Examples/Cooling/CoolingSystemNew.mos"
        "Simulate and Plot"));
end CoolingSystemNew;
