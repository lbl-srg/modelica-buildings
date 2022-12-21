within Buildings.Experimental.DHC.Examples.Cooling;
model DirectUncontrolledETS
  "Example model for district cooling system with direct uncontrolled ETS"
  extends Modelica.Icons.Example;
  extends Modelica.Icons.UnderConstruction;
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
  // Control settings
  parameter Modelica.Units.SI.Pressure dpSetPoi=24500
    "Differential pressure setpoint"
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
  // Network
  parameter Integer nLoa=3
    "Number of served loads"
    annotation (Dialog(group="Network"));
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal[nLoa]=fill(10,nLoa)
    "Nominal mass flow rate in each connection line";
  // Buildings
  parameter String filNam[nLoa]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos"}
    "Library path of the file with thermal loads as time series"
    annotation (Dialog(group="Buildings"));
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal[nLoa](
    each max=-Modelica.Constants.eps)={Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam[i])) for i in 1:nLoa}
    "Space cooling design load (<=0)";
  final parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal[nLoa](
    each final min=0,
    each final start=0.5)={-QCoo_flow_nominal[i]/(cp*buiETS[i].dT_nominal) for i in 1:nLoa}
    "Nominal mass flow rate of building cooling side";
  Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel pla(
    perChi=perChi,
    dTApp=3,
    perCHWPum=perCHWPum,
    perCWPum=perCWPum,
    mCHW_flow_nominal=mCHW_flow_nominal,
    dpCHW_nominal=dpCHW_nominal,
    QChi_nominal=QChi_nominal,
    mMin_flow=0.03,
    mCW_flow_nominal=mCW_flow_nominal,
    dpCW_nominal=dpCW_nominal,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    dT_nominal=5.56,
    TMin=288.15,
    PFan_nominal=5000,
    use_inputFilter=true,
    riseTimePump=120,
    yCHWP_start=fill(0.5, 2),
    yCWP_start=fill(0, 2),
    dpCooTowVal_nominal=6000,
    dpCHWPumVal_nominal=6000,
    dpCWPumVal_nominal=6000,
    tWai=30,
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
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=273.15+7)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Experimental.DHC.Networks.Distribution2Pipe dis(
    redeclare final package Medium=Medium,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=sum(dis.mCon_flow_nominal),
    mCon_flow_nominal=mBui_flow_nominal,
    mEnd_flow_nominal=mBui_flow_nominal[nLoa],
    dpDis_nominal=fill(1500,nLoa))
    "Distribution network for district cooling system"
    annotation (Placement(transformation(extent={{20,-20},{60,0}})));
  Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS buiETS[nLoa](
    filNam=filNam,
    mBui_flow_nominal=mBui_flow_nominal,
    each bui(w_aLoaCoo_nominal=0.015))
    "Vectorized time series building load model connected with ETS for cooling"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
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
  connect(pla.port_aSerCoo, dis.port_bDisRet) annotation (Line(points={{-40,
          -11.3333},{-44,-11.3333},{-44,-60},{8,-60},{8,-16},{20,-16}}, color={
          0,127,255}));
  connect(dis.port_aDisSup, pla.port_bSerCoo) annotation (Line(points={{20,-10},
          {20,-11.3333},{-20,-11.3333}},        color={0,127,255}));
  connect(dis.ports_bCon, buiETS.port_aSerCoo)
    annotation (Line(points={{28,0},{0,0},{0,42},{30,42}}, color={0,127,255}));
  connect(buiETS.port_bSerCoo, dis.ports_aCon) annotation (Line(points={{50,42},
          {80,42},{80,0},{52,0}}, color={0,127,255}));
  connect(dis.dp, pla.dpMea) annotation (Line(points={{62,-7},{70,-7},{70,-32},
          {-46,-32},{-46,-6.73333},{-40.6667,-6.73333}}, color={0,0,127}));
    annotation (Dialog(group="Network"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
      preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Cooling/DirectUncontrolledETS.mos" "Simulate and plot"),
    experiment(
      StartTime=15724800,
      StopTime=16329600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>This model illustrates an example of integral district cooling system, 
consisted by a cooling plant of parallel electric chillers 
<a href=\"modelica://Buildings/Experimental/DHC/Plants/Cooling/ElectricChillerParallel.mo\">
Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel</a>, 
a two-pipe distribution network <a href=\"modelica://Buildings/Experimental/DHC/Networks/Distribution2Pipe.mo\">
Buildings.Experimental.DHC.Networks.Distribution2Pipe</a>, 
and a time series building load connected to a direct uncontrolled ETS for cooling 
<a href=\"modelica://Buildings/Experimental/DHC/Loads/Cooling/BuildingTimeSeriesWithETS.mo\">
Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS</a>, as illustrated in the schematic below.</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Examples/Cooling/DirectUncontrolledETS.png\" alt=\"System schematics\"/></p>
</html>", revisions="<html>
<ul>
<li>
December 21, 2022, by Kathryn Hinkelman:<br/>
Corrected <code>dpMea</code> location to be at the terminal building.
Removed in-building pumping for direct uncontrolled ETS example.<br> 
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>
Relocated dp sensor for CHW pump control to most distal building.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>March 20, 2022, by Chengnan Shi:<br>First implementation. </li>
</ul>
</html>"));
end DirectUncontrolledETS;
