within Buildings.Experimental.DHC.Loads.Heating.DHW;
model HeatPumpWaterHeaterWithTank
  "A model for domestic water heating served by heat pump water heater and local storage tank"
  extends Buildings.Experimental.DHC.Loads.Heating.DHW.BaseClasses.PartialFourPortDHW;

  parameter Modelica.Units.SI.Volume VTan = VTan "Tank volume";
  parameter Modelica.Units.SI.Length hTan = hTan "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns = dIns "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns = kIns "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal = dpHex_nominal "Pressure drop across the heat exchanger at nominal conditions";
  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal = mHex_flow_nominal "Mass flow rate of heat exchanger";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_max(min=0) = QCon_flow_max "Maximum heating flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = QCon_flow_nominal "Nominal heating flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QTan_flow_nominal = QTan_flow_nominal "Nominal heating flow rate";
  parameter Modelica.Units.SI.Height hHex_a = hHex_a "Height of portHex_a of the heat exchanger, measured from tank bottom";
  parameter Modelica.Units.SI.Height hHex_b = hHex_b "Height of portHex_b of the heat exchanger, measured from tank bottom";
  parameter Modelica.Units.SI.Temperature TTan_nominal = TTan_nominal "Temperature of fluid inside the tank at nominal heat transfer conditions";
  parameter Modelica.Units.SI.Temperature THex_nominal = THex_nominal "Temperature of fluid inside the heat exchanger at nominal heat transfer conditions";
  parameter Integer nSeg(min=2) = nSeg "Number of volume segments";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTankOut(redeclare package
      Medium = Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mDH_flow_nominal,
    QCon_flow_max = QCon_flow_max,
    QCon_flow_nominal=QCon_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
              "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = Medium,
    m_flow_nominal=mHw_flow_nominal,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=nSeg,
    redeclare package MediumHex = Medium,
    Q_flow_nominal = QTan_flow_nominal,
    hHex_a = hHex_a,
    hHex_b = hHex_b,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsHex = Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal = true,
    allowFlowReversalHex = false,
    mHex_flow_nominal = mHex_flow_nominal,
    TTan_nominal = TTan_nominal,
    THex_nominal = THex_nominal,
    dpHex_nominal = dpHex_nominal)
                                  "Hot water tank with heat exchanger configured as steady state, deleted CHex = 40"
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));
  Fluid.Sensors.TemperatureTwoPort senTemHPOut(redeclare package Medium =
        Medium, m_flow_nominal=mHex_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,6})));
  Modelica.Blocks.Math.Gain gai(k=mHex_flow_nominal)
    "Gain for control signal controlling source pump"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Fluid.Movers.FlowControlled_m_flow pumHw(
    redeclare package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=0) "Pump to move water through the heat exchanger to the tank"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,40})));
  Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan
    "Temeprature of water in top of tank"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Add add
    "Gain for control signal controlling source pump"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Sources.Constant dTTanHex(k=5)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(tan.port_a, senTemTankOut.port_a)
    annotation (Line(points={{-40,50},{-20,50},{-20,60},{0,60}},
                                             color={0,127,255}));
  connect(tan.portHex_b, heaPum.port_a1) annotation (Line(points={{-40,42},{-40,
          6},{-10,6}},                                color={0,127,255}));
  connect(heaPum.port_b1, senTemHPOut.port_a)
    annotation (Line(points={{10,6},{40,6}},              color={0,127,255}));
  connect(tan.port_b, port_a1)
    annotation (Line(points={{-60,50},{-80,50},{-80,60},{-100,60}},
                                                  color={0,127,255}));
  connect(senTemTankOut.port_b, port_b1)
    annotation (Line(points={{20,60},{100,60}}, color={0,127,255}));
  connect(port_a2, heaPum.port_a2) annotation (Line(points={{100,-60},{20,
          -60},{20,-6},{10,-6}}, color={0,127,255}));
  connect(port_b2, heaPum.port_b2) annotation (Line(points={{-100,-60},{
          -20,-60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(heaPum.P, PEle) annotation (Line(points={{11,0},{30,0},{30,-20},{70,
          -20},{70,0},{110,0}},     color={0,0,127}));
  connect(senTemHPOut.port_b, pumHw.port_a) annotation (Line(points={{60,6},{80,
          6},{80,40},{60,40}}, color={0,127,255}));
  connect(pumHw.port_b, tan.portHex_a) annotation (Line(points={{40,40},{-20,40},
          {-20,46.2},{-40,46.2}}, color={0,127,255}));
  connect(gai.y, pumHw.m_flow_in) annotation (Line(points={{41,90},{50,90},{50,52}},
                            color={0,0,127}));
  connect(tan.heaPorVol[nSeg-1], TTan.port) annotation (Line(points={{-50,50},{-44,
          50},{-44,70},{-40,70}},    color={191,0,0}));
  connect(TTan.T, conPI.u_m)
    annotation (Line(points={{-19,70},{-10,70},{-10,78}}, color={0,0,127}));
  connect(TSetHw, conPI.u_s) annotation (Line(points={{-110,0},{-90,0},{-90,90},
          {-22,90}}, color={0,0,127}));
  connect(conPI.y, gai.u)
    annotation (Line(points={{1,90},{18,90}}, color={0,0,127}));
  connect(TSetHw, add.u1) annotation (Line(points={{-110,0},{-80,0},{-80,6},{-72,
          6}}, color={0,0,127}));
  connect(dTTanHex.y, add.u2) annotation (Line(points={{-79,-30},{-76,-30},{-76,
          -6},{-72,-6}}, color={0,0,127}));
  connect(heaPum.TSet, add.y) annotation (Line(points={{-12,9},{-20,9},{-20,0},{
          -49,0}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model is an example of a domestic hot water (DHW) substation for an  
ultra-low-temperature district heating (ULTDH) network. It includes a micro heat 
pump and storage tank with direct thermostatic mixing rather than heat exchange.
</p>
<p>
For more info, please see Fig. 3 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=https:/doi.org/10.1016/j.energy.2016.04.109> 
doi.org/10.1016/j.energy.2016.04.109</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2022 by Dre Helmns:<br/>
Created substation model.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,-60},{20,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,22},{20,-48}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,10},{20,30}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,50},{20,20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,40},{20,60}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,50},{-20,-50}},
          color={95,95,95},
          thickness=1),
        Line(
          points={{20,50},{20,-50}},
          color={95,95,95},
          thickness=1),
        Polygon(
          points={{-140,86},{-140,86}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag),
        Polygon(
          points={{20,40},{18,38},{14,36},{8,34},{8,26},{14,28},{18,30},{20,32},
              {20,40}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag)}),                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterWithTank;
