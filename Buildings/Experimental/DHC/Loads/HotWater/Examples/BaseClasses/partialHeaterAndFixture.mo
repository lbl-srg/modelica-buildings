within Buildings.Experimental.DHC.Loads.HotWater.Examples.BaseClasses;
model partialHeaterAndFixture
  "Partial base class for heater and fixture examples"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHot = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TDis = 273.15+30 "Temperature of water supply from district";
  parameter Modelica.Units.SI.Temperature TSetTem = 273.15+43 "Temperature setpoint of tempered water supply to fixture";
  parameter Modelica.Units.SI.Temperature TCol = 273.15+10 "Temperature of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal = 1 "Nominal mass flow rate of district water";
  parameter Modelica.Units.SI.MassFlowRate mTem_flow_nominal = 1 "Nominal mass flow rate of tempered water to fixture";
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
    mTem_flow_nominal=mTem_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Interfaces.RealOutput TTem(final unit="K", displayUnit="degC")
    "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Fluid.Sources.MassFlowSource_T souDis(
    redeclare package Medium = Medium,
    m_flow=mDis_flow_nominal,
    T(displayUnit="degC") = TDis)
                                 "Source of district network water" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-50})));
  Modelica.Blocks.Sources.Constant conTSetHot(k=TSetHot)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  WaterDraw loa(redeclare package Medium = Medium, mTem_flow_nominal=
        mTem_flow_nominal) "Tempered water draw"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));

  Fluid.Sources.Boundary_pT sinDis(redeclare package Medium = Medium, T(
        displayUnit="degC")) "Sink of district network water" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-50})));
  Modelica.Blocks.Interfaces.RealOutput PEle
    "Electric power required for generation equipment"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.Constant conTSetTem(k=TSetTem)
    "Temperature setpoint for tempered water supply"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(tmv.TTem, TTem) annotation (Line(points={{21,6},{30,6},{30,60},{110,60}},
        color={0,0,127}));
  connect(souCol.ports[1], tmv.port_col) annotation (Line(points={{10,-40},{10,-20},
          {-10,-20},{-10,-4},{0,-4}},
                                    color={0,127,255}));
  connect(tmv.port_tem, loa.port_tw)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(loa.sch, sch.y[1])
    annotation (Line(points={{61,3},{74,3},{74,30},{79,30}}, color={0,0,127}));
  connect(conTSetTem.y, tmv.TSet)
    annotation (Line(points={{-79,30},{-2,30},{-2,8}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This is an example of a domestic water heater and fixture.
</p>
</html>", revisions="<html>
<ul>
<li>
October 20, 2022 by Dre Helmns:<br/>
Created example.
</li>
</ul>
</html>"),experiment(
      StopTime=864000,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end partialHeaterAndFixture;
