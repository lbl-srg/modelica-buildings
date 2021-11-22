within Buildings.Experimental.DHC.CentralPlants.Cooling.Examples;
model Plant
  "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model for water";
  // chiller and cooling tower
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes perChi
    "Performance data of chiller";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=18.3
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=34.7
    "Nominal condenser water mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal=44.8*1000
    "Nominal chilled water side pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal=46.2*1000
    "Nominal condenser water side pressure";
  parameter Modelica.SIunits.Power QChi_nominal=mCHW_flow_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty (Negative means cooling)";
  parameter Modelica.SIunits.MassFlowRate mMin_flow=0.03
    "Minimum mass flow rate of single chiller";
  parameter Modelica.SIunits.TemperatureDifference dTApp=3
    "Approach temperature";
  parameter Modelica.SIunits.Power PFan_nominal=5000
    "Fan power";
  // control settings
  parameter Modelica.SIunits.Pressure dpSetPoi=68900
    "Differential pressure setpoint";
  parameter Modelica.SIunits.Temperature TCHWSet=273.15+8
    "Chilled water temperature setpoint";
  parameter Modelica.SIunits.Time tWai=30
    "Waiting time";
  // pumps
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCHW_flow_nominal/1000*{0.2,0.6,0.8,1.0},
      dp=(dpCHW_nominal+dpSetPoi+18000+30000)*{1.5,1.3,1.0,0.6}))
    "Performance data for chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCW_flow_nominal/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCW_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.SIunits.Pressure dpCHWPumVal_nominal=6000
    "Nominal pressure drop of chilled water pump valve";
  parameter Modelica.SIunits.Pressure dpCWPumVal_nominal=6000
    "Nominal pressure drop of chilled water pump valve";
  parameter Modelica.SIunits.PressureDifference dpCooTowVal_nominal=6000
   "Nominal pressure difference of the cooling tower valve";
  replaceable Buildings.Experimental.DHC.CentralPlants.Cooling.Plant pla(
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
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.BooleanConstant on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(
    k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Fluid.MixingVolumes.MixingVolume vol(
    nPorts=3,
    redeclare package Medium=Medium,
    m_flow_nominal=pla.numChi*mCHW_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      fixHeaFlo(
    T_ref=293.15)
    "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium=Medium,
    m_flow_nominal=pla.numChi*mCHW_flow_nominal,
    dp_nominal(displayUnit="kPa") = 1000000)
    "Flow resistance"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  Modelica.Blocks.Sources.Sine loaVar(
    amplitude=913865,
    freqHz=1/126900,
    offset=913865,
    startTime(displayUnit="h") = 21600) "Variable demand load"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-10})));
equation
  connect(TCHWSupSet.y,pla.TCHWSupSet)
    annotation (Line(points={{-39,-50},{-32,-50},{-32,-4.73333},{-10.6667,
          -4.73333}},color={0,0,127}));
  connect(fixHeaFlo.port,vol.heatPort)
    annotation (Line(points={{20,70},{32,70},{32,30},{40,30}},color={191,0,0}));
  connect(pla.port_bSerCoo,vol.ports[1])
    annotation (Line(points={{10,-11.3333},{16,-11.3333},{16,20},{47.3333,20}},
      color={0,127,255}));
  connect(vol.ports[2],res.port_a)
    annotation (Line(points={{50,20},{80,20},{80,-40},{60,-40}},
      color={0,127,255}));
  connect(res.port_b,pla.port_aSerCoo)
    annotation (Line(points={{40,-40},{-14,-40},{-14,-11.3333},{-10,-11.3333}},
      color={0,127,255}));
  connect(on.y,pla.on)
    annotation (Line(points={{-39,-10},{-38,-10},{-38,-2.6},{-10.7333,-2.6}},
      color={255,0,255}));
  connect(weaDat.weaBus,pla.weaBus)
    annotation (Line(points={{-40,30},{0.0333333,30},{0.0333333,-1.13333}},
      color={255,204,51}));
  connect(fixHeaFlo.Q_flow,loaVar. y)
    annotation (Line(points={{0,70},{-39,70}}, color={0,0,127}));
  connect(res.port_b, senRelPre.port_b)
    annotation (Line(points={{40,-40},{30,-40},{30,-20}}, color={0,127,255}));
  connect(vol.ports[3], senRelPre.port_a)
    annotation (Line(points={{52.6667,20},{30,20},{30,0}}, color={0,127,255}));
  connect(senRelPre.p_rel, pla.dpMea) annotation (Line(points={{21,-10},{20,-10},
          {20,-60},{-20,-60},{-20,-6.73333},{-10.6667,-6.73333}}, color={0,0,
          127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>This model validates the district central cooling plant implemented in
<a href=\"modelica://Buildings.Experimental.DHC.CentralPlants.Cooling.Plant\">
Buildings.Experimental.DHC.CentralPlants.Cooling.Plant</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 20, 2021, by Chengnan Shi:<br/>
Revised the model for extensibility. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2749\">issue #2749</a>.
</li>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/CentralPlants/Cooling/Examples/Plant.mos"
      "Simulate and Plot"));
end Plant;
