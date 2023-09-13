within Buildings.Experimental.DHC.Loads.DHW;
model ThermostaticMixingValve
  "A model for a thermostatic mixing valve"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal "Nominal doemstic hot water flow rate";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Nominal pressure drop of valve";
  parameter Real k = 0.1 "Proportional gain of valve controller";
  parameter Modelica.Units.SI.Time Ti = 15 "Integrator time constant of valve controller";
  Modelica.Fluid.Interfaces.FluidPort_b port_tw(redeclare package Medium =
        Medium) "Port for tempered water outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTw(redeclare package Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Tempered water temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Actuators.Valves.ThreeWayLinear ValHea(
    redeclare package Medium = Medium,
    riseTime=5,
    final m_flow_nominal=mDhw_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Valve" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Modelica.Fluid.Interfaces.FluidPort_a port_hw(redeclare package Medium =
        Medium) "Port for hot water supply"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium =
        Medium) "Port for domestic cold water supply"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TTw "Temperature of the outlet tempered water"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHw(redeclare package Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Hot water temperature sensor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemCw(redeclare package Medium =
        Medium, m_flow_nominal=mDhw_flow_nominal) "Cold water temperature sensor"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate senFloDhw(redeclare package Medium =
        Medium) "Mass flow rate of domestic hot water"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=uLow, uHigh=uHigh)
    annotation (Placement(transformation(extent={{56,24},{44,36}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Temperature setpoint of tempered hot water outlet"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
protected
  parameter Real uLow = 0.01*mDhw_flow_nominal "Low hysteresis threshold";
  parameter Real uHigh = 0.05*mDhw_flow_nominal "High hysteresis threshold";
equation
  connect(senTemTw.T, conPID.u_m)
    annotation (Line(points={{30,11},{30,58}}, color={0,0,127}));
  connect(ValHea.port_2, senTemTw.port_a) annotation (Line(points={{10,-6.66134e-16},
          {20,-6.66134e-16},{20,0}}, color={0,127,255}));
  connect(conPID.y, ValHea.y) annotation (Line(points={{19,70},{0,70},{0,12},{
          9.99201e-16,12}}, color={0,0,127}));
  connect(senTemTw.T, TTw) annotation (Line(points={{30,11},{30,40},{90,40},{90,
          60},{110,60}}, color={0,0,127}));
  connect(ValHea.port_1, senTemHw.port_b) annotation (Line(points={{-10,
          1.77636e-15},{-10,0},{-20,0}}, color={0,127,255}));
  connect(senTemHw.port_a, port_hw) annotation (Line(points={{-40,0},{-60,0},{-60,
          40},{-100,40}}, color={0,127,255}));
  connect(ValHea.port_3, senTemCw.port_b) annotation (Line(points={{-1.77636e-15,
          -10},{-1.77636e-15,-60},{-20,-60}}, color={0,127,255}));
  connect(senTemCw.port_a, port_cw)
    annotation (Line(points={{-40,-60},{-70,-60},{-70,-40},{-100,-40}},
                                                    color={0,127,255}));
  connect(senTemTw.port_b, senFloDhw.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(senFloDhw.port_b, port_tw)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(hysteresis.u, senFloDhw.m_flow)
    annotation (Line(points={{57.2,30},{60,30},{60,11}},
                                                       color={0,0,127}));
  connect(hysteresis.y, conPID.trigger)
    annotation (Line(points={{43.4,30},{38,30},{38,58}}, color={255,0,255}));
  connect(conPID.u_s, TSet) annotation (Line(points={{42,70},{50,70},{50,92},{-94,
          92},{-94,80},{-120,80}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model is for a domestic water mixer, mixing hot and cold fluid to achieve a specified tempered outlet temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2022 by Dre Helmns:<br/>
Created valve model.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          visible=use_inputFilter,
          extent={{-34,-28},{32,32}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-34,32},{32,-28}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-22,26},{20,-20}},
          textColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-42,58},{-162,8}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(y, format=".2f"))),
    Rectangle(
      extent={{-40,22},{40,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={192,192,192},
          origin={-78,40},
          rotation=90),
    Rectangle(
      extent={{-22,22},{22,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={238,46,47},
          origin={-78,40},
          rotation=90),
    Line(
      visible=use_inputFilter,
      points={{-32,-28},{28,-28}}),
    Rectangle(
      extent={{-40,22},{40,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={192,192,192},
          origin={-78,-42},
          rotation=90),
    Rectangle(
      extent={{-22,22},{22,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={28,108,200},
          origin={-78,-42},
          rotation=90),
    Rectangle(
      extent={{-40,22},{40,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={192,192,192},
          origin={78,0},
          rotation=90),
    Rectangle(
      extent={{-22,22},{22,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={102,44,145},
          origin={78,0},
          rotation=90),
      Text(
          extent={{-153,147},{147,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticMixingValve;