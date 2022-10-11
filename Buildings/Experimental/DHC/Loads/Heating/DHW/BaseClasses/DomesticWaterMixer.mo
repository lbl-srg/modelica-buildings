within Buildings.Experimental.DHC.Loads.Heating.DHW.BaseClasses;
model DomesticWaterMixer "A model for a domestic water mixer"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSet = 273.15+40 "Temperature setpoint of tempered hot water outlet";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal "Nominal doemstic hot water flow rate";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
  parameter Real k(min=0) = 2 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  Modelica.Fluid.Interfaces.FluidPort_b port_tw(redeclare package Medium =
        Medium) "Port for tempered water outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{40,40},{20,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTw(redeclare package
      Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Tempered water temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant conTSetCon(k=TSet) "Temperature setpoint for domestic tempered water supply to consumer"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Fluid.Actuators.Valves.ThreeWayLinear
             ideValHea(redeclare package Medium = Medium, final m_flow_nominal=
        mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal)
                           "Ideal valve" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Modelica.Fluid.Interfaces.FluidPort_a port_hw(redeclare package Medium =
        Medium) "Port for hot water supply"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium =
        Medium) "Port for domestic cold water supply"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHw(redeclare package
      Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Hot water temperature sensor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemCw(redeclare package
      Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Cold water temperature sensor"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate senFloDhw(redeclare package Medium =
        Medium) "Mass flow rate of domestic hot water"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{54,22},{44,32}})));
equation
  connect(conTSetCon.y, conPID.u_s)
    annotation (Line(points={{59,50},{42,50}}, color={0,0,127}));
  connect(senTemTw.T, conPID.u_m)
    annotation (Line(points={{30,11},{30,38}}, color={0,0,127}));
  connect(ideValHea.port_2, senTemTw.port_a) annotation (Line(points={{10,-6.66134e-16},
          {20,-6.66134e-16},{20,0}}, color={0,127,255}));
  connect(conPID.y, ideValHea.y) annotation (Line(points={{19,50},{8.88178e-16,50},
          {8.88178e-16,12}},color={0,0,127}));
  connect(senTemTw.T, TTw) annotation (Line(points={{30,11},{30,20},{90,20},{90,
          80},{110,80}}, color={0,0,127}));
  connect(ideValHea.port_1, senTemHw.port_b)
    annotation (Line(points={{-10,1.77636e-15},{-10,0},{-20,0}},
                                                color={0,127,255}));
  connect(senTemHw.port_a, port_hw) annotation (Line(points={{-40,0},{-54,0},{-54,
          60},{-100,60}}, color={0,127,255}));
  connect(ideValHea.port_3, senTemCw.port_b)
    annotation (Line(points={{-1.77636e-15,-10},{-1.77636e-15,-60},{-20,-60}},
                                                        color={0,127,255}));
  connect(senTemCw.port_a, port_cw)
    annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
  connect(senTemTw.port_b, senFloDhw.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(senFloDhw.port_b, port_tw)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(greaterThreshold.u, senFloDhw.m_flow)
    annotation (Line(points={{55,27},{60,27},{60,11}}, color={0,0,127}));
  connect(greaterThreshold.y, conPID.trigger)
    annotation (Line(points={{43.5,27},{38,27},{38,38}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,72},{-64,50}},
          textColor={238,46,47},
          textString="hot",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-86,-44},{-52,-74}},
          textColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="cold"),
        Text(
          extent={{10,36},{86,-34}},
          textColor={102,44,145},
          textStyle={TextStyle.Bold},
          textString="tempered")}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DomesticWaterMixer;
