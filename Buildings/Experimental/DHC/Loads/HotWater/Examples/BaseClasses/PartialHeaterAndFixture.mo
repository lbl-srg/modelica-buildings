within Buildings.Experimental.DHC.Loads.HotWater.Examples.BaseClasses;
model PartialHeaterAndFixture
  "Partial base class for hot water source, thermostatic mixing, and fixture load examples."
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHotSou = 273.15+50 "Temperature setpoint of hot water supply source from heater";
  parameter Modelica.Units.SI.Temperature TDis = 273.15+30 "Temperature of water supply from district";
  parameter Modelica.Units.SI.Temperature TSetHot = 273.15+43 "Temperature setpoint of hot water supply to fixture";
  parameter Modelica.Units.SI.Temperature TCol = 273.15+10 "Temperature of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHotSou_flow_nominal = 0.1 "Nominal mass flow rate of hot water source supply";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal = 1 "Nominal mass flow rate of district water";
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal = 1 "Nominal mass flow rate of hot water supplied to fixture";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") = 1000 "Pressure difference";

  Buildings.Fluid.Sources.Boundary_pT souCol(
    redeclare package Medium = Medium,
    T(displayUnit="degC") = TCol,
    nPorts=1) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
  ThermostaticMixingValve tmv(
    redeclare package Medium = Medium,
    mHot_flow_nominal=mHot_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Interfaces.RealOutput THot(final unit="K", displayUnit="degC")
    "Temperature of the outlet hot water"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Fluid.Sources.MassFlowSource_T souDis(
    redeclare package Medium = Medium,
    m_flow=mDis_flow_nominal,
    T(displayUnit="degC") = TDis) "Source of district network water" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-50})));
  Modelica.Blocks.Sources.Constant conTSetHotSou(k=TSetHotSou)
    "Temperature setpoint for domestic hot water source supplied from heater"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  WaterDraw loa(
    redeclare package Medium = Medium,
    mHot_flow_nominal=mHot_flow_nominal) "Tempered water draw"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    T(displayUnit="degC")) "Sink of district network water" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-50})));
  Modelica.Blocks.Interfaces.RealOutput PEle(final unit="W")
    "Electric power required for generation equipment"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.Constant conTSetHot(k(final unit="K")=TSetHot)
    "Temperature setpoint for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
equation
  connect(tmv.THot,THot)  annotation (Line(points={{21,6},{30,6},{30,60},{110,60}},
        color={0,0,127}));
  connect(conTSetHot.y, tmv.TSet)
    annotation (Line(points={{-69,30},{-10,30},{-10,8},{-2,8}},
                                                       color={0,0,127}));
  connect(tmv.port_hot, loa.port_hot)
    annotation (Line(points={{20,0},{40,0}},   color={0,127,255}));
  connect(tmv.port_col, souCol.ports[1]) annotation (Line(points={{0,-4},{-10,-4},
          {-10,-26},{10,-26},{10,-40}},     color={0,127,255}));
  connect(sch.y[1], loa.yHotWat) annotation (Line(points={{61,30},{72,30},{72,
          16},{36,16},{36,6},{39,6}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
Partial base class for hot water source, thermostatic mixing, and fixture load examples.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Made as base class.
</li>
<li>
October 20, 2022 by Dre Helmns:<br/>
Initial implementation.
</li>
</ul>
</html>"),experiment(
      StopTime=864000,
      Interval=1,
      Tolerance=1e-06));
end PartialHeaterAndFixture;
