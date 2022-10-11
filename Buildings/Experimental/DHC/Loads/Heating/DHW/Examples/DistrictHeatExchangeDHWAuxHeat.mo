within Buildings.Experimental.DHC.Loads.Heating.DHW.Examples;
model DistrictHeatExchangeDHWAuxHeat
  "Example implementation of direct district heat exchange and auxiliary line heater for DHW"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.Temperature TDHw = 273.15+45 "Temperature setpoint of hot water supply from district";
  parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
  parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = mHw_flow_nominal "Nominal mass flow rate of tempered water";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
  parameter Real k(min=0) = 2 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Boolean havePEle "Flag that specifies whether electric power is required for water heating";

  Buildings.Fluid.Sources.Boundary_pT souDcw(
    redeclare package Medium = Medium,
    T(displayUnit = "degC") = TDcw,
    nPorts=3) "Source of domestic cold water"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Math.Gain gaiDhw(k=-0.3234)
    "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{64,24},{52,36}})));
  BaseClasses.DirectHeatExchangerWaterHeaterWithAuxHeat disHXAuxHea(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    redeclare package Medium = Medium,
    havePEle=havePEle,
    TSetHw(displayUnit="degC") = TSetHw,
    mHw_flow_nominal=mHw_flow_nominal,
    mDH_flow_nominal=mDH_flow_nominal)
    "Direct district heat exchanger with auxiliary electric heating"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for domestic hot water supply"
    annotation (Placement(transformation(extent={{34,-10},{14,10}})));
  BaseClasses.DomesticWaterMixer tmv(
    redeclare package Medium = Medium,
    TSet(displayUnit = "degC") = TSetTw,
    mDhw_flow_nominal=mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    k=k,
    Ti=Ti)
          "Ideal thermostatic mixing valve"
    annotation (Placement(transformation(extent={{-20,10},{0,-10}})));
  Modelica.Blocks.Sources.Sine sine(f=0.001,
    offset=1)
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Continuous.Integrator watCon(k=-1)
    "Integrated hot water consumption"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TTw(final unit="K",displayUnit = "degC") "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw(displayUnit="kg") "Total hot water consumption"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{80,-60},{120,-20}})));
  Fluid.Sources.Boundary_pT souDHw(
    redeclare package Medium = Medium,
    T(displayUnit = "degC") = TDHw,
    nPorts=1) "Source of district hot water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-50})));
  Fluid.Sources.MassFlowSource_T sinDHw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for district heating water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-74,-50})));
  Modelica.Blocks.Sources.Constant const(k=-1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-90,-90})));
  Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(tmv.port_tw, sinDhw.ports[1])
    annotation (Line(points={{0,0},{14,0}}, color={0,127,255}));
  connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{51.4,30},{44,30},
          {44,8},{36,8}}, color={0,0,127}));
  connect(sine.y, gaiDhw.u)
    annotation (Line(points={{79,30},{65.2,30}},
                                               color={0,0,127}));
  connect(watCon.u, sinDhw.m_flow_in) annotation (Line(points={{58,-30},{44,-30},
          {44,8},{36,8}}, color={0,0,127}));
  connect(souDcw.ports[2], tmv.port_cw) annotation (Line(points={{-80,30},{-30,30},
          {-30,6},{-20,6}},                                color={0,127,255}));
  connect(tmv.TTw, TTw)
    annotation (Line(points={{1,-8},{10,-8},{10,60},{110,60}},
                                                             color={0,0,127}));
  connect(watCon.y, mDhw)
    annotation (Line(points={{81,-30},{110,-30}}, color={0,0,127}));
  connect(const.y, sinDHw.m_flow_in)
    annotation (Line(points={{-90,-79},{-90,-76},{-82,-76},{-82,-62}},
                                                          color={0,0,127}));
  connect(conTSetHw.y, disHXAuxHea.TSetHw)
    annotation (Line(points={{-79,0},{-71,0}}, color={0,0,127}));
  connect(disHXAuxHea.port_a2, souDHw.ports[1]) annotation (Line(points={{-50,-6},
          {-40,-6},{-40,-34},{-20,-34},{-20,-40}}, color={0,127,255}));
  connect(disHXAuxHea.port_b1, tmv.port_hw) annotation (Line(points={{-50,6},{-36,
          6},{-36,-6},{-20,-6}}, color={0,127,255}));
  connect(disHXAuxHea.port_b2, sinDHw.ports[1])
    annotation (Line(points={{-70,-6},{-74,-6},{-74,-40}}, color={0,127,255}));
  connect(disHXAuxHea.port_a1, souDcw.ports[3]) annotation (Line(points={{-70,6},
          {-76,6},{-76,31.3333},{-80,31.3333}}, color={0,127,255}));
  annotation (experiment(StopTime=3600, Interval=1));
end DistrictHeatExchangeDHWAuxHeat;
