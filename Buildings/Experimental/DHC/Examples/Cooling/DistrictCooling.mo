within Buildings.Experimental.DHC.Examples.Cooling;
model DistrictCooling "Example model for district cooling system"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model for water";
  // Chiller and cooling tower
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=18.3
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=34.7
    "Nominal condenser water mass flow rate"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.PressureDifference dpCHW_nominal=44.8*1000
    "Nominal chilled water side pressure"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.PressureDifference dpCW_nominal=46.2*1000
    "Nominal condenser water side pressure"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.Power QChi_nominal=mCHW_flow_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty (Negative means cooling)"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.MassFlowRate mMin_flow=0.03
    "Minimum mass flow rate of single chiller"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.TemperatureDifference dTApp=3
    "Approach temperature"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.Power PFan_nominal=5000
    "Fan power"
    annotation (Dialog(group="Chiller and cooling tower"));
  parameter Modelica.Units.SI.PressureDifference dpCooTowVal_nominal=6000
   "Nominal pressure difference of the cooling tower valve"
   annotation (Dialog(group="Chiller and cooling tower"));
  // Control settings
  parameter Modelica.Units.SI.Pressure dpSetPoi=24500
    "Differential pressure setpoint"
    annotation (Dialog(group="Control settings"));
  parameter Modelica.Units.SI.Temperature TCHWSet=273.15+7
    "Chilled water temperature setpoint"
    annotation (Dialog(group="Control settings"));
  parameter Modelica.Units.SI.Time tWai=30
    "Waiting time"
    annotation (Dialog(group="Control settings"));
  // Pumps
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCHW_flow_nominal/1000*{0.2,0.6,0.8,1.0},
      dp=(dpCHW_nominal+dpSetPoi+18000+30000)*{1.5,1.3,1.0,0.6}))
    "Performance data for chilled water pumps"
    annotation (Dialog(group="Pumps"));
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCW_flow_nominal/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCW_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps"
    annotation (Dialog(group="Pumps"));
  parameter Modelica.Units.SI.Pressure dpCHWPumVal_nominal=6000
    "Nominal pressure drop of chilled water pump valve"
    annotation (Dialog(group="Pumps"));
  parameter Modelica.Units.SI.Pressure dpCWPumVal_nominal=6000
    "Nominal pressure drop of chilled water pump valve"
    annotation (Dialog(group="Pumps"));
  // Network
  parameter Integer nLoa=3
    "Number of served loads"
    annotation (Dialog(group="Network"));
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal=10
    "Nominal mass flow rate in each load"
    annotation (Dialog(group="Network"));
  parameter Modelica.Units.SI.PressureDifference dpDis_sr_nominal=1500
    "Nominal pressure drop for supply/return resistance"
    annotation (Dialog(group="Network"));
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal[nLoa]=fill(mLoa_flow_nominal,nLoa)
    "Nominal mass flow rate in each connection line";
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(
    mCon_flow_nominal)
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal=sum(
    dis.con.pipDisSup.dp_nominal)+sum(
    dis.con.pipDisRet.dp_nominal)
    "Nominal pressure drop in the distribution line";
  // Buildings
  parameter String filNam[nLoa]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos"}
    "Library path of the file with thermal loads as time series"
    annotation (Dialog(group="Buildings"));
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal[nLoa](
    max=-Modelica.Constants.eps)={Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam[i])) for i in 1:nLoa}
    "Design cooling heat flow rate (<=0)Nominal heat flow rate, negative";
  final parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal[nLoa](
    each final min=0,
    each final start=0.5)={-QCoo_flow_nominal[i]/(cp*buiETS[i].dT_nominal) for i in 1:nLoa}
    "Nominal mass flow rate of building cooling side";
  Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel pla(
    perChi=perChi,
    dTApp=dTApp,
    perCHWPum=perCHWPum,
    perCWPum=perCWPum,
    mCHW_flow_nominal=mCHW_flow_nominal,
    dpCHW_nominal=dpCHW_nominal,
    QChi_nominal=QChi_nominal,
    mMin_flow=mMin_flow,
    mCW_flow_nominal=mCW_flow_nominal,
    dpCW_nominal=dpCW_nominal,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    dT_nominal=5.56,
    TMin=288.15,
    PFan_nominal=PFan_nominal,
    dpCooTowVal_nominal=dpCooTowVal_nominal,
    dpCHWPumVal_nominal=dpCHWPumVal_nominal,
    dpCWPumVal_nominal=dpCWPumVal_nominal,
    tWai=tWai,
    dpSetPoi=dpSetPoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District cooling plant"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
  final computeWetBulbTemperature=true,
  filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.BooleanConstant on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Experimental.DHC.Networks.Distribution2Pipe dis(
    redeclare final package Medium=Medium,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=sum(dis.mCon_flow_nominal),
    mCon_flow_nominal=mBui_flow_nominal,
    mEnd_flow_nominal=mBui_flow_nominal[nLoa],
    dpDis_nominal=fill(dpDis_sr_nominal,nLoa))
    "Distribution network for district cooling system"
    annotation (Placement(transformation(extent={{20,-20},{60,0}})));
  Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS buiETS[nLoa](
    redeclare each package Medium = Medium,
    filNam=filNam,
    mBui_flow_nominal=mBui_flow_nominal)
    "Vectorized time series building load model connected with ETS for cooling."
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Relative pressure drop sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-8,-36})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
equation
  connect(weaDat.weaBus, pla.weaBus) annotation (Line(
      points={{-60,30},{-30,30},{-30,-1.13333},{-29.9667,-1.13333}},
      color={255,204,51},
      thickness=0.5));
  connect(on.y, pla.on) annotation (Line(points={{-59,-10},{-50,-10},{-50,-2.6},
          {-40.7333,-2.6}}, color={255,0,255}));
  connect(TCHWSupSet.y, pla.TCHWSupSet) annotation (Line(points={{-59,-50},{-48,
          -50},{-48,-4.73333},{-40.6667,-4.73333}}, color={0,0,127}));
  connect(senRelPre.p_rel, pla.dpMea) annotation (Line(points={{-17,-36},{-46,
          -36},{-46,-6.73333},{-40.6667,-6.73333}},
                                               color={0,0,127}));
  connect(dis.port_bDisSup, dis.port_aDisRet) annotation (Line(points={{60,-10},
          {80,-10},{80,-16},{60,-16}}, color={0,127,255}));
  connect(pla.port_aSerCoo, dis.port_bDisRet) annotation (Line(points={{-40,
          -11.3333},{-44,-11.3333},{-44,-60},{8,-60},{8,-16},{20,-16}}, color={
          0,127,255}));
  connect(dis.port_aDisSup, pla.port_bSerCoo) annotation (Line(points={{20,-10},
          {0,-10},{0,-11.3333},{-20,-11.3333}}, color={0,127,255}));
  connect(senRelPre.port_b, dis.port_bDisRet) annotation (Line(points={{-8,-46},
          {-8,-60},{8,-60},{8,-16},{20,-16}}, color={0,127,255}));
  connect(senRelPre.port_a, pla.port_bSerCoo) annotation (Line(points={{-8,-26},
          {-8,-11.3333},{-20,-11.3333}}, color={0,127,255}));
  connect(dis.ports_bCon, buiETS.port_aSerCoo)
    annotation (Line(points={{28,0},{0,0},{0,42},{30,42}}, color={0,127,255}));
  connect(buiETS.port_bSerCoo, dis.ports_aCon) annotation (Line(points={{50,42},
          {80,42},{80,0},{52,0}}, color={0,127,255}));
    annotation (Dialog(group="Network"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
      preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Cooling/DistrictCooling.mos" "Simulate and plot"),
    experiment(
      StartTime=12960000,
      StopTime=13564800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>
This model illustrates an example of integral district cooling system, consisted 
by a cooling plant of parallel electric chillers 
<a href=\"modelica://Buildings/Experimental/DHC/Plants/Cooling/ElectricChillerParallel.mo\">
Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel</a>, 
a two-pipe distribution network <a href=\"modelica://Buildings/Experimental/DHC/Networks/Distribution2Pipe.mo\">
Buildings.Experimental.DHC.Networks.Distribution2Pipe</a>, and a time series building load 
connected to a direct uncontrolled ETS for cooling 
<a href=\"modelica://Buildings/Experimental/DHC/Loads/Cooling/BuildingTimeSeriesWithETS.mo\">
Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS</a>. </p>
</html>", revisions="<html>
<ul>
<li>
January 1, 2022, by Chengnan Shi:<br/>
First implementation.
</li>
</ul>
</html>"));
end DistrictCooling;
