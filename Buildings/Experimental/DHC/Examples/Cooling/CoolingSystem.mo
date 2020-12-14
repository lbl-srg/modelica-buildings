within Buildings.Experimental.DHC.Examples.Cooling;
model CoolingSystem
  "Example to test the district cooling network model"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model for water";
  parameter Integer nBui=1
    "Number of buildings connected to each distribution branch, excluding the most remote one";
  parameter Boolean allowFlowReversal=false
    "Set to true to allow flow reversal in the distribution and connections";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy dynamics: fixed initial";
  // chiller and cooling tower
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes perChi
    "Chiller performance data";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=18.3
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=34.7
    "Nominal condenser water mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal=44.8*1000
    "Nominal chilled water side pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal=46.2*1000
    "Nominal condenser water side pressure";
  parameter Modelica.SIunits.HeatFlowRate QEva_nominal=mCHW_flow_nominal*cp*(7-16)
    "Nominal cooling capaciaty (negative means cooling)";
  parameter Modelica.SIunits.MassFlowRate mMin_flow=0.03
    "Minimum mass flow rate of single chiller";
  // control settings
  parameter Modelica.SIunits.PressureDifference dpSetPoi=68900
    "Differential pressure setpoint";
  parameter Modelica.SIunits.Temperature TCHWSet=273.15 + 7
    "Chilled water supply temperature setpoint";
  parameter Modelica.SIunits.Time tWai=0
    "Waiting time";
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
  parameter Modelica.SIunits.PressureDifference dpCHWPum_nominal=6000
    "Nominal pressure drop of chilled water pumps";
  parameter Modelica.SIunits.PressureDifference dpCWPum_nominal=6000
    "Nominal pressure drop of condenser water pumps";
  // buildings
  parameter String filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Examples/Cooling/Loads.txt"
    "Library path of the file with thermal loads as time series";
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)Nominal heat flow rate, negative";
  final parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)=Q_flow_nominal/(cp*(bld[1].TChiWatSup_nominal-bld[1].TChiWatRet_nominal))
    "Nominal mass flow rate of building cooling side";
  Buildings.Experimental.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesWithETSCooling bld[nBui](
    redeclare each package Medium=Medium,
    each filNam=filNam,
    each mDis_flow_nominal=mBui_flow_nominal,
    each mBui_flow_nominal=mBui_flow_nominal,
    each mByp_flow_nominal=0.01,
    each energyDynamics=energyDynamics)
    "Building with cooling load"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Plant pla(
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
    energyDynamics=energyDynamics,
    pumCHW(
      yValve_start=fill(
        1,
        pla.numChi)))
    "District cooling plant"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.BooleanConstant on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(
    k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Experimental.DHC.Loads.Validation.BaseClasses.Distribution2Pipe dis(
    redeclare package Medium=Media.Water,
    nCon=nBui,
    mDis_flow_nominal=nBui*mBui_flow_nominal,
    mCon_flow_nominal=fill(
      mBui_flow_nominal,
      nBui),
    dpDis_nominal(
      displayUnit="Pa")=fill(
      1000,
      nBui))
    "Distribution pipes"
    annotation (Placement(transformation(extent={{0,0},{40,20}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In "+getInstanceName()+": This model is a beta version and is not fully validated yet.");
equation
  connect(weaDat.weaBus,weaBus)
    annotation (Line(points={{-60,-50},{-50,-50}},color={255,204,51},thickness=0.5));
  connect(weaBus.TWetBul,pla.TWetBul)
    annotation (Line(points={{-50,-50},{-40,-50},{-40,2},{-32,2}},color={255,204,51},thickness=0.5));
  connect(on.y,pla.on)
    annotation (Line(points={{-59,50},{-40,50},{-40,18},{-32,18}},color={255,0,255}));
  connect(TCHWSupSet.y,pla.TCHWSupSet)
    annotation (Line(points={{-59,20},{-50,20},{-50,13},{-32,13}},color={0,0,127}));
  connect(pla.port_b,dis.port_aDisSup)
    annotation (Line(points={{-10,5},{-6,5},{-6,10},{0,10}},color={0,127,255}));
  connect(dis.port_bDisRet,pla.port_a)
    annotation (Line(points={{0,4},{-6,4},{-6,15},{-10,15}},color={0,127,255}));
  connect(dis.ports_bCon,bld.port_a)
    annotation (Line(points={{8,20},{8,50},{10,50}},color={0,127,255}));
  connect(bld.port_b,dis.ports_aCon)
    annotation (Line(points={{30,50},{32,50},{32,20}},color={0,127,255}));
  connect(bld[nBui].p_rel,pla.dpMea)
    annotation (Line(points={{31,53},{40,53},{40,70},{-90,70},{-90,-20},{-50,-20},{-50,7},{-32,7}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Experimental/DHC/Examples/Cooling/CoolingSystem.mos" "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
December 13, 2020 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>",
      info="<html>
<p>
This model demonstrates the modeling of a generic district cooling system with the central plant model
<a href=\"modelica://Buildings.Experimental.DHC.CentralPlants.Cooling.Plant\">
Buildings.Experimental.DHC.CentralPlants.Cooling.Plant</a>.
</p>
</html>"));
end CoolingSystem;
