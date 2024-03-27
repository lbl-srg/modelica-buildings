within Buildings.DHC.EnergyTransferStations.Combined.Subsystems;
model WatersideEconomizer
  "Base subsystem with waterside economizer"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal=abs(Q_flow_nominal/4200/(T_b1_nominal - T_a1_nominal)),
    final m2_flow_nominal=abs(Q_flow_nominal/4200/(T_b2_nominal - T_a2_nominal)));
  parameter DHC.EnergyTransferStations.Types.ConnectionConfiguration conCon
    "District connection configuration" annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dp1Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpVal1_nominal(displayUnit=
        "Pa") = if have_val1 then dp1Hex_nominal/2 else 0
    "Nominal pressure drop of primary control valve"
    annotation (Dialog(enable=have_val1, group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpVal2_nominal(displayUnit=
        "Pa") = dp2Hex_nominal/10
    "Nominal pressure drop of heat exchanger bypass valve"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal heat flow rate (from district to building)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_b1_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_b2_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real y1Min(final unit="1")=0.05
    "Minimum pump flow rate or valve opening for temperature measurement (fractional)"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.TemperatureDifference dTEna=1
    "Minimum delta-T above predicted heat exchanger leaving water temperature to enable WSE"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.TemperatureDifference dTDis=0.5
    "Minimum delta-T across heat exchanger before disabling WSE"
    annotation (Dialog(group="Controls"));
  parameter Real k(
    min=0)=1
    "Gain of controller"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.Time Ti(min=Buildings.Controls.OBC.CDL.Constants.small)=
       60 "Time constant of integrator block"
    annotation (Dialog(group="Controls"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if not have_val1
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  // COMPONENTS
  Buildings.DHC.EnergyTransferStations.Combined.Controls.WatersideEconomizer conWSE(
    final m2_flow_nominal=m2_flow_nominal,
    final y1Min=y1Min,
    final T_a1_nominal=T_a1_nominal,
    final T_b2_nominal=T_b2_nominal,
    final dTEna=dTEna,
    final dTDis=dTDis)
    "District heat exchanger loop controller"
    annotation (Placement(transformation(extent={{30,150},{50,170}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final dp1_nominal=if have_val1 then 0 else dp1Hex_nominal,
    final dp2_nominal=0,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
    "Heat exchanger" annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=180)));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1Hex_nominal,
    final allowFlowReversal=allowFlowReversal1) if not have_val1
    "District heat exchanger primary pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent val1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    from_dp=true,
    final dpValve_nominal=dpVal1_nominal,
    final dpFixed_nominal=dp1Hex_nominal,
    use_inputFilter=false) if have_val1
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=
        m1_flow_nominal) if not have_val1 "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{10,100},{-10,120}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val2(
    redeclare final package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpVal2_nominal,
    final dpFixed_nominal={dp2Hex_nominal,0},
    fraK=1) "Heat exchanger secondary control valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1WatEnt(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,40})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(final unit="1")
    "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
    iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo2(redeclare final package
      Medium = Medium2, final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary mass flow rate" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,-60})));
protected
  parameter Boolean have_val1=
    conCon ==Buildings.DHC.EnergyTransferStations.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  if not have_val1 then
    connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},
            {100,60}}, color={0,127,255}));
  else
    connect(port_a1, senT1WatEnt.port_a) annotation (Line(points={{-100,60},{-20,60},{-20,50}}, color={0,127,255}));
  end if;
  connect(port_a1,pum1.port_a)
    annotation (Line(points={{-100,60},{-90,60},{-90,80},{-70,80}},color={0,127,255}));
  connect(val1.port_b,port_b1)
    annotation (Line(points={{90,80},{94,80},{94,60},{100,60}},color={0,127,255}));
  connect(conWSE.y1, val1.y) annotation (Line(points={{52,165},{80,165},{80,92}},  color={0,0,127}));
  connect(conWSE.y1, gai1.u) annotation (Line(points={{52,165},{80,165},{80,110},
          {12,110}},                                                                           color={0,0,127}));
  connect(gai1.y,pum1.m_flow_in)
    annotation (Line(points={{-12,110},{-60,110},{-60,92}},color={0,0,127}));
  connect(PPum, pum1.P) annotation (Line(points={{120,0},{44,0},{44,89},{-49,89}}, color={0,0,127}));
  connect(conWSE.yVal2, val2.y)
    annotation (Line(points={{52,155},{60,155},{60,-40},{32,-40}},        color={0,0,127}));
  connect(port_a2, senT2WatEnt.port_a) annotation (Line(points={{100,-60},{50,-60}}, color={0,127,255}));
  connect(hex.port_b2, senT2WatLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-60},{-30,-60}}, color={0,127,255}));
  connect(senT1WatEnt.port_b, hex.port_a1) annotation (Line(points={{-20,30},
          {-20,6},{-10,6}},                                                                       color={0,127,255}));
  connect(senT1WatEnt.port_a, pum1.port_b)
    annotation (Line(points={{-20,50},{-20,80},{-50,80}}, color={0,127,255}));
  connect(hex.port_b1, val1.port_a) annotation (Line(points={{10,6},{20,6},{
          20,80},{70,80}},                                                                      color={0,127,255}));
  connect(uCoo, conWSE.uCoo) annotation (Line(points={{-120,160},{-40,160},{-40,168},{28,168}}, color={255,0,255}));
  connect(senT1WatEnt.T, conWSE.T1WatEnt)
    annotation (Line(points={{-31,40},{-38,40},{-38,162},{28,162}}, color={0,0,127}));
  connect(conWSE.T2WatEnt, senT2WatEnt.T)
    annotation (Line(points={{28,159},{20,159},{20,140},{40,140},{40,-49},{40,-49}}, color={0,0,127}));
  connect(senT2WatLvg.T, conWSE.T2WatLvg)
    annotation (Line(points={{-40,-49},{-40,156},{28,156}}, color={0,0,127}));
  connect(yValIsoEva_actual, conWSE.yValIsoEva_actual)
    annotation (Line(points={{-120,130},{24,130},{24,153},{28,153}}, color={0,0,127}));
  connect(val2.port_3, senT2WatLvg.port_a)
    annotation (Line(points={{10,-40},{-20,-40},{-20,-60},{-30,-60}}, color={0,127,255}));
  connect(val2.port_1, hex.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}}, color={0,127,255}));
  connect(val2.port_2, senT2WatEnt.port_b)
    annotation (Line(points={{20,-50},{20,-60},{30,-60}}, color={0,127,255}));
  connect(port_b2, senMasFlo2.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(senMasFlo2.port_a, senT2WatLvg.port_b)
    annotation (Line(points={{-70,-60},{-50,-60}}, color={0,127,255}));
  connect(senMasFlo2.m_flow, conWSE.m2_flow)
    annotation (Line(points={{-80,-49},{-80,165},{28,165}}, color={0,0,127}));
  annotation (
    defaultComponentName="hex",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-160},{100,180}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 14, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for a waterside economizer for sidestream integration (in
series with the chillers).
The primary side is typically connected to the service line.
The primary flow rate is modulated either with a variable speed pump or
with a two-way valve.
The secondary side is typically connected to the chilled water return,
using a three-port two-position directional control valve.
</p>
<p>
The system is controlled based on the logic described in
<a href=\"modelica://Buildings.DHC.EnergyTransferStations.Combined.Controls.WatersideEconomizer\">
Buildings.DHC.EnergyTransferStations.Combined.Controls.WatersideEconomizer</a>.
</p>
</html>"));
end WatersideEconomizer;
