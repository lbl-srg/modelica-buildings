within Buildings.Experimental.DHC.Examples.Cooling;
model ElectricChillersDirectETS "Example model for district cooling system with 
  an electric chiller plant and a direct controlled ETS at each building"
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
  parameter Modelica.Units.SI.Pressure dpDis=30000
    "Total pressure drop in the district pipes";
  parameter Modelica.Units.SI.Power QChi_nominal=mCHW_flow_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty (Negative means cooling)"
    annotation (Dialog(group="Chiller and cooling tower"));
  // Pumps
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCHW_flow_nominal/1000*{0.2,0.6,0.8,1.0},
      dp=(dpCHW_nominal+dpDis+20000+6000*3)*{1,0.8,0.6,0.2}))
    "Performance data for chilled water pumps"
    annotation (Dialog(group="Pumps"));
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCW_flow_nominal/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCW_nominal+6000*2)*{1,0.8,0.6,0.2}))
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
    mMin_flow=mCHW_flow_nominal*0.25,
    mCW_flow_nominal=mCW_flow_nominal,
    dpCW_nominal=dpCW_nominal,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    dT_nominal=5.56,
    TMin=288.15,
    PFan_nominal=5000,
    tau=60,
    yCHWP_start=fill(0, 2),
    yCWP_start=fill(0, 2),
    dpCooTowVal_nominal=6000,
    dpCHWPumVal_nominal=6000,
    dpCWPumVal_nominal=6000,
    tWai=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District cooling plant"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=273.15+7)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Experimental.DHC.Networks.Distribution2PipePlugFlow dis(
    redeclare final package Medium=Medium,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=sum(dis.mCon_flow_nominal),
    mCon_flow_nominal=mBui_flow_nominal,
    mEnd_flow_nominal=mBui_flow_nominal[nLoa],
    length=fill(30, nLoa))
    "Distribution network for district cooling system"
    annotation (Placement(transformation(extent={{100,-20},{140,0}})));
  Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS buiETS[nLoa](
    each yMin=0.05,
    each use_inputFilter=true,
    filNam=filNam,
    mBui_flow_nominal=mBui_flow_nominal,
    each bui(w_aLoaCoo_nominal=0.015))
    "Vectorized time series building load model connected with ETS for cooling"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Sources.Constant TDisRetSet(k=273.15 + 16)
    "Setpoint for district return temperature"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
  Modelica.Blocks.Math.Sum QTotCoo_flow(nin=nLoa)
    "Total cooling flow rate for all buildings "
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold offCoo(t=1e-4)
    "Threshold comparison to disable the plant"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain norQFlo(k=1/sum(QCoo_flow_nominal))
    "Normalized Q_flow"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  HeatTransfer.Sources.FixedTemperature gnd(T=285.15) "Ground"
    annotation (Placement(transformation(extent={{140,-60},{120,-40}})));
  Controls.OBC.CDL.Logical.Timer tim(t=3600)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Controls.OBC.CDL.Logical.Not onPla "On signal for the plant"
    annotation (Placement(transformation(extent={{0,-18},{20,2}})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
equation
  connect(weaDat.weaBus, pla.weaBus) annotation (Line(
      points={{20,70},{60,70},{60,-1.13333},{60.0333,-1.13333}},
      color={255,204,51},
      thickness=0.5));
  connect(TCHWSupSet.y, pla.TCHWSupSet) annotation (Line(points={{21,-50},{32,
          -50},{32,-4.73333},{49.3333,-4.73333}},   color={0,0,127}));
  connect(pla.port_aSerCoo, dis.port_bDisRet) annotation (Line(points={{50,
          -11.3333},{36,-11.3333},{36,-60},{88,-60},{88,-16},{100,-16}},color={
          0,127,255}));
  connect(dis.port_aDisSup, pla.port_bSerCoo) annotation (Line(points={{100,-10},
          {100,-11.3333},{70,-11.3333}},        color={0,127,255}));
  connect(dis.ports_bCon, buiETS.port_aSerCoo)
    annotation (Line(points={{108,0},{80,0},{80,42},{120,42}},
                                                           color={0,127,255}));
  connect(buiETS.port_bSerCoo, dis.ports_aCon) annotation (Line(points={{140,42},
          {160,42},{160,0},{132,0}},
                                  color={0,127,255}));
  for i in 1:nLoa loop
    connect(TDisRetSet.y, buiETS[i].TSetDisRet)
     annotation (Line(points={{91,70},{100,70},{100,57},{119,57}},
                                                               color={0,0,127}));
  end for;
  connect(buiETS.QCoo_flow, QTotCoo_flow.u) annotation (Line(points={{137,38},{136,
          38},{136,24},{-170,24},{-170,0},{-162,0}},
                                   color={0,0,127}));
  connect(QTotCoo_flow.y, norQFlo.u)
    annotation (Line(points={{-139,0},{-122,0}},
                                               color={0,0,127}));
  connect(norQFlo.y, offCoo.u)
    annotation (Line(points={{-99,0},{-82,0}}, color={0,0,127}));
  connect(gnd.port, dis.heatPort)
    annotation (Line(points={{120,-50},{107,-50},{107,-20}},
                                                          color={191,0,0}));
  connect(offCoo.y, tim.u)
    annotation (Line(points={{-58,0},{-42,0}},   color={255,0,255}));
  connect(tim.passed, onPla.u) annotation (Line(points={{-18,-8},{-2,-8}},
                           color={255,0,255}));
  connect(onPla.y, pla.on) annotation (Line(points={{22,-8},{26,-8},{26,-2.6},{
          49.2667,-2.6}},         color={255,0,255}));
    annotation (
    Diagram(
      coordinateSystem(
      preserveAspectRatio=false, extent={{-180,-100},{180,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Cooling/ElectricChillersDirectETS.mos" "Simulate and plot"),
    experiment(
      StartTime=15724800,
      StopTime=16329600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model illustrates an example of district cooling system, 
consisting of a cooling plant with parallel electric chillers 
(<a href=\"modelica://Buildings/Experimental/DHC/Plants/Cooling/ElectricChillerParallel.mo\">
Buildings.Experimental.DHC.Plants.Cooling.ElectricChillerParallel</a>), 
a two-pipe distribution network with plug flow pipes (<a href=\"modelica://Buildings/Experimental/DHC/Networks/Distribution2PipePlugFlow.mo\">
Buildings.Experimental.DHC.Networks.Distribution2PipePlugFlow</a>), 
and time series building load that have directly connected ETS 
with the chilled water return temperatures controlled above a minimum 
threshold
(<a href=\"modelica://Buildings/Experimental/DHC/Loads/Cooling/BuildingTimeSeriesWithETS.mo\">
Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS</a>).
This configuration is illustrated in the schematic below.
</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Examples/Cooling/ElectricChillersDirectETS.png\" alt=\"DC Schematic\"/></p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Revised chilled water pump controls to be constant speed and running 1-and-1 with the chillers.<br>
Changed building-side ets from direct uncontrolled to controlled.<br>
Revised distribution network from fixed resistance pipes to plug flow pipes. 
</li>
<li>
December 21, 2022, by Kathryn Hinkelman:<br/>
Corrected <code>dpMea</code> location to be at the terminal building.
Removed in-building pumping for direct uncontrolled ETS example.<br> 
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>
December 18, 2022, by Kathryn Hinkelman:<br/>
Relocated dp sensor for CHW pump control to most distal building.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>March 20, 2022, by Chengnan Shi:<br>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ElectricChillersDirectETS;
