within Buildings.Experimental.DHC.Loads.HotWater.Examples.BaseClasses;
partial model PartialHeaterAndFixture
  "Partial base class for hot water source, thermostatic mixing, and fixture load examples."
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature THotSouSet=273.15 + 50
    "Temperature setpoint of hot water supply source from heater";
  parameter Modelica.Units.SI.Temperature TDis = 273.15+30 "Temperature of water supply from district";
  parameter Modelica.Units.SI.Temperature TMixSet=273.15 + 43
    "Temperature setpoint of hot water supply to fixture";
  parameter Modelica.Units.SI.Temperature TCol = 273.15+10 "Temperature of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHotSou_flow_nominal = 0.1 "Nominal mass flow rate of hot water source supply";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal = 1 "Nominal mass flow rate of district water";
  parameter Modelica.Units.SI.MassFlowRate mMix_flow_nominal=1
    "Nominal mass flow rate of hot water supplied to fixture";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") = 1000 "Pressure difference";

  Buildings.Fluid.Sources.Boundary_pT souCol(
    redeclare package Medium = Medium,
    T(displayUnit="degC") = TCol,
    nPorts=1) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
  ThermostaticMixingValve theMixVal(redeclare package Medium = Medium,
      mMix_flow_nominal=mMix_flow_nominal) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{0,-12},{20,8}})));
  Fluid.Sources.MassFlowSource_T souDis(
    redeclare package Medium = Medium,
    m_flow=mDis_flow_nominal,
    T(displayUnit="degC") = TDis) "Source of district network water" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-50})));
  Modelica.Blocks.Sources.Constant conTHotSouSet(k=THotSouSet)
    "Temperature setpoint for domestic hot water source supplied from heater"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

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
  Modelica.Blocks.Sources.Constant conTSetHot(k(final unit="K")=TMixSet)
    "Temperature setpoint for hot water supply to fixture"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
equation
  connect(conTSetHot.y, theMixVal.TMixSet) annotation (Line(points={{-69,30},{-10,
          30},{-10,0},{-1,0}}, color={0,0,127}));
  connect(theMixVal.port_col, souCol.ports[1]) annotation (Line(points={{0,-10},
          {-10,-10},{-10,-30},{10,-30},{10,-40}}, color={0,127,255}));
  connect(theMixVal.yMixSet, sch.y[1]) annotation (Line(points={{-1,6},{-4,6},{
          -4,60},{-69,60}}, color={0,0,127}));
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
