within Buildings.Experimental.DHC.Loads.DHW.Examples;
model DomesticWaterFixture
  "Thermostatic mixing valve and hot water fixture with representative annual load profile"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
  parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = 0.1 "Design domestic hot water supply flow rate of system";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") = 85000 "Pressure difference for thermostatic mixing valve with nominal flow of 6.5gpm";
  parameter Real kCon(min=0) = 0.1 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti = 120 "Time constant of Integrator block";
  parameter Real uLow = 0.1 "low hysteresis threshold";
  parameter Real uHigh = 0.9 "high hysteresis threshold";

  ThermostaticMixingValve tmv(
    redeclare package Medium = Medium,
    mDhw_flow_nominal=mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    k=kCon,
    Ti=Ti) "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  DHWLoad loaDHW(redeclare package Medium = Medium, mDhw_flow_nominal=
        mDhw_flow_nominal) "load for DHW"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Sources.Boundary_pT           souDcw(
    redeclare package Medium = Medium,
    T(displayUnit="degC") = TDcw,
    nPorts=1) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Fluid.Sources.Boundary_pT souHw(
    redeclare package Medium = Medium,
    T(displayUnit="degC") = TSetHw,
    nPorts=1) "Source of heated domestic water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,50})));
  Modelica.Blocks.Sources.CombiTimeTable schDhw(
    tableOnFile=false,
    table=[0,0.1; 3600*1,1e-5; 3600*2,1e-5; 3600*3,1e-5; 3600*4,1e-5; 3600*5,
        0.3; 3600*6,0.9; 3600*7,1; 3600*8,1; 3600*9,0.8; 3600*10,0.8; 3600*11,
        0.6; 3600*12,0.5; 3600*13,0.5; 3600*14,0.4; 3600*15,0.5; 3600*16,0.6;
        3600*17,0.7; 3600*18,0.9; 3600*19,0.8; 3600*20,0.8; 3600*21,0.6; 3600*
        22,0.5; 3600*23,0.3; 3600*24,0.1],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.Constant const(k=TSetTw)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(tmv.TTw, TTw) annotation (Line(points={{-19,6},{14,6},{14,60},{110,60}},
        color={0,0,127}));
  connect(tmv.port_tw, loaDHW.port_tw)
    annotation (Line(points={{-20,0},{20,0}}, color={0,127,255}));
  connect(loaDHW.mDhw, mDhw) annotation (Line(points={{41,-7.2},{60,-7.2},{60,
          -60},{110,-60}},
                      color={0,0,127}));
  connect(souDcw.ports[1], tmv.port_cw) annotation (Line(points={{-80,-50},{-60,
          -50},{-60,-6},{-40,-6}}, color={0,127,255}));
  connect(souHw.ports[1], tmv.port_hw) annotation (Line(points={{-80,50},{-46,50},
          {-46,6},{-40,6}}, color={0,127,255}));
  connect(schDhw.y[1], loaDHW.schDhw)
    annotation (Line(points={{79,30},{60,30},{60,3},{41,3}}, color={0,0,127}));
  connect(const.y, tmv.TSet)
    annotation (Line(points={{-59,10},{-59,8},{-42,8}}, color={0,0,127}));
annotation (preferredView="info",Documentation(info="<html>
<p>
This is an example of a domestic water fixture.
</p>
</html>", revisions="<html>
<ul>
<li>
October 20, 2022 by Dre Helmns:<br/>
Created example.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Heating/DHW/Examples/DomesticWaterFixture.mos"
  "Simulate and plot"),experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end DomesticWaterFixture;
