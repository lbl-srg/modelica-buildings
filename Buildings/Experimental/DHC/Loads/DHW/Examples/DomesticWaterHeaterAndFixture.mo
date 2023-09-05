within Buildings.Experimental.DHC.Loads.DHW.Examples;
model DomesticWaterHeaterAndFixture
  "Example implementation of direct district heat exchange and auxiliary line heater for DHW"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TDHw = 273.15+30 "Temperature setpoint of hot water supply from district";
  parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
  parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = mHw_flow_nominal "Nominal mass flow rate of tempered water";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") = 1000 "Pressure difference";

  Buildings.Fluid.Sources.Boundary_pT souDcw(
    redeclare package Medium = Medium,
    T(displayUnit = "degC") = TDcw,
    nPorts=2) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-50})));
  HeatPumpWaterHeaterWithTank genDHW(
    redeclare package Medium = Medium,
    mHw_flow_nominal=mHw_flow_nominal,
    mDH_flow_nominal=mDH_flow_nominal)       "Generation of DHW"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ThermostaticMixingValve tmv(
    redeclare package Medium = Medium,
    mDhw_flow_nominal=mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Interfaces.RealOutput TTw(final unit="K",displayUnit = "degC") "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Fluid.Sources.MassFlowSource_T
                            souDHw(
    redeclare package Medium = Medium,
    m_flow=mDH_flow_nominal,
    T(displayUnit = "degC") = TDHw,
    nPorts=1) "Source of district hot water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
  Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  DHWLoad loaDHW(redeclare package Medium = Medium, mDhw_flow_nominal=
        mDhw_flow_nominal) "load for DHW"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable schDhw(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Heating/DHW/DHW_SingleApartment.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));

  Fluid.Sources.Boundary_pT sinDHw(
    redeclare package Medium = Medium,
    T(displayUnit="degC"),
    nPorts=1) "Sink of district hot water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-50})));
  Modelica.Blocks.Interfaces.RealOutput PEle
    "Electric power required for generation equipment"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.Constant conTSetTw(k=TSetTw)
    "Temperature setpoint for tempered water supply"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(tmv.TTw, TTw)
    annotation (Line(points={{21,6},{30,6},{30,60},{110,60}},color={0,0,127}));
  connect(conTSetHw.y, genDHW.TSetHw)
    annotation (Line(points={{-79,0},{-41,0}}, color={0,0,127}));
  connect(genDHW.port_b1, tmv.port_hw)
    annotation (Line(points={{-20,6},{0,6}}, color={0,127,255}));
  connect(souDHw.ports[1], genDHW.port_a2) annotation (Line(points={{10,-40},{
          10,-20},{-14,-20},{-14,-6},{-20,-6}}, color={0,127,255}));
  connect(souDcw.ports[1], tmv.port_cw) annotation (Line(points={{-29,-40},{-29,
          -30},{-6,-30},{-6,-6},{0,-6}}, color={0,127,255}));
  connect(souDcw.ports[2], genDHW.port_a1) annotation (Line(points={{-31,-40},{
          -31,-30},{-50,-30},{-50,6},{-40,6}}, color={0,127,255}));
  connect(tmv.port_tw, loaDHW.port_tw)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(loaDHW.mDhw, mDhw) annotation (Line(points={{61,-7.2},{80,-7.2},{80,
          -60},{110,-60}},
                      color={0,0,127}));
  connect(loaDHW.schDhw, schDhw.y[1])
    annotation (Line(points={{61,3},{74,3},{74,30},{79,30}}, color={0,0,127}));
  connect(genDHW.port_b2, sinDHw.ports[1])
    annotation (Line(points={{-40,-6},{-70,-6},{-70,-40}}, color={0,127,255}));
  connect(genDHW.PHea, PEle) annotation (Line(points={{-19,0},{-10,0},{-10,80},{
          110,80}}, color={0,0,127}));
  connect(conTSetTw.y, tmv.TSet)
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
end DomesticWaterHeaterAndFixture;
