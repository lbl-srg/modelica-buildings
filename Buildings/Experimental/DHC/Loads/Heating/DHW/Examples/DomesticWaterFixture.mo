within Buildings.Experimental.DHC.Loads.Heating.DHW.Examples;
model DomesticWaterFixture
  "Thermostatic mixing valve and hot water fixture with representative annual load profile"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
  parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = 0.1 "Design domestic hot water supply flow rate of system";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") = 85000 "Pressure difference for thermostatic mixing valve with nominal flow of 6.5gpm";
  parameter Real kCon(min=0) = 2 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));

  DomesticWaterMixer tmv(
    redeclare package Medium = Medium,
    TSet=TSetTw,
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
  DailyPeriodicDHWLoad loaDHW(mDhw_flow_nominal=mDhw_flow_nominal)
    "load for DHW"
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
equation
  connect(tmv.TTw, TTw) annotation (Line(points={{-19,6},{14,6},{14,60},{110,60}},
        color={0,0,127}));
  connect(tmv.port_tw, loaDHW.port_tw)
    annotation (Line(points={{-20,0},{20,0}}, color={0,127,255}));
  connect(loaDHW.mDhw, mDhw) annotation (Line(points={{41,-5},{60,-5},{60,-60},
          {110,-60}}, color={0,0,127}));
  connect(souDcw.ports[1], tmv.port_cw) annotation (Line(points={{-80,-50},{-60,
          -50},{-60,-6},{-40,-6}}, color={0,127,255}));
  connect(souHw.ports[1], tmv.port_hw) annotation (Line(points={{-80,50},{-46,50},
          {-46,6},{-40,6}}, color={0,127,255}));
annotation (Documentation(info="<html>
<p>
This is a single zone model based on the envelope of the BESTEST Case 600
building, though it has some modifications.  Supply and return air ports are
included for simulation with air-based HVAC systems.  Heating and cooling
setpoints and internal loads are time-varying according to an assumed
occupancy schedule.
</p>
<p>
This zone model utilizes schedules and constructions from
the <code>Schedules</code> and <code>Constructions</code> packages.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end DomesticWaterFixture;
