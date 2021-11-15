within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems;
model HeatExchanger
  "Base subsystem with district heat exchanger"
  extends Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal=abs(
      QHex_flow_nominal/4200/(T_b1Hex_nominal-T_a1Hex_nominal)),
    final m2_flow_nominal=abs(
      QHex_flow_nominal/4200/(T_b2Hex_nominal-T_a2Hex_nominal)));
  parameter Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration conCon
    "District connection configuration"
    annotation (Evaluate=true);
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum1(
    motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for primary pump"
    annotation (Dialog(enable=not have_val1Hex),choicesAllMatching=true,
    Placement(transformation(extent={{-40,-140},{-20,-120}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum2(
    motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for secondary pump"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{20,-140},{40,-120}})));
  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal(
    displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal(
    displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpVal1Hex_nominal(
    displayUnit="Pa")=dp1Hex_nominal/2
    "Nominal pressure drop of primary control valve"
    annotation (Dialog(enable=have_val1Hex,group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpVal2Hex_nominal(
    displayUnit="Pa")=dp2Hex_nominal/2
    "Nominal pressure drop of secondary control valve"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate (from district to building)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real spePum1HexMin(
    final unit="1",
    min=0)=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls",enable=not have_val1Hex));
  parameter Real yVal1HexMin(
    final unit="1",
    min=0.01)=0.1
    "Minimum valve opening for temperature measurement (fractional)"
    annotation (Dialog(group="Controls",enable=have_val1Hex));
  parameter Real spePum2HexMin(
    final unit="1",
    min=0.01)=0.1
    "Heat exchanger secondary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.TemperatureDifference dT1HexSet[2]
    "Primary side deltaT set point schedule (index 1 for heat rejection)"
    annotation (Dialog(group="Controls"));
  parameter Real k[2]={0.05,0.1}
    "Gain schedule for controller (index 1 for heat rejection)"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.Time Ti=120
    "Time constant of integrator block"
    annotation (Dialog(group="Controls"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso_actual[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal for secondary side (from supervisory)"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  // COMPONENTS
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.HeatExchanger con(
    final conCon=conCon,
    final spePum1HexMin=spePum1HexMin,
    final spePum2HexMin=spePum2HexMin,
    final dT1HexSet=dT1HexSet,
    final k=k,
    final Ti=Ti)
    "District heat exchanger loop controller"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final dp1_nominal=
      if have_val1Hex then
        0
      else
        dp1Hex_nominal,
    final dp2_nominal=0,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=QHex_flow_nominal,
    final T_a1_nominal=T_a1Hex_nominal,
    final T_a2_nominal=T_a2Hex_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=180,origin={0,0})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum1Hex(
    redeclare final package Medium=Medium1,
    final per=perPum1,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1Hex_nominal,
    final allowFlowReversal=allowFlowReversal1) if not have_val1Hex
    "District heat exchanger primary pump"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=180,origin={-60,80})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum2Hex(
    redeclare final package Medium=Medium2,
    final per=perPum2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2Hex_nominal+dpVal2Hex_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Secondary pump"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=180,origin={40,-60})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatEnt(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={20,-40})));
  Fluid.Sensors.TemperatureTwoPort senT2HexWatLvg(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=m2_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={40,118})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1Hex(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal,
    from_dp=true,
    final dpValve_nominal=dpVal1Hex_nominal,
    use_inputFilter=false,
    final dpFixed_nominal=dp1Hex_nominal) if have_val1Hex
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatEnt(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water entering temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-20,40})));
  Fluid.Sensors.TemperatureTwoPort senT1HexWatLvg(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Heat exchanger primary water leaving temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={20,20})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=m1_flow_nominal) if not have_val1Hex
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-12,110},{-32,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=
      if have_val1Hex then
        1
      else
        2)
    "Total pump power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val2Hex(
    redeclare final package Medium=Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_inputFilter=false,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpVal2Hex_nominal,
    final dpFixed_nominal=fill(
      dp2Hex_nominal,
      2))
    "Control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={80,-60})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction spl(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1})
    "Flow splitter"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-60,-60})));
protected
  parameter Boolean have_val1Hex=conCon == Buildings.Experimental.DHC.EnergyTransferStations.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  if not have_val1Hex then
    connect(senT1HexWatLvg.port_b,port_b1)
      annotation (Line(points={{20,30},{20,60},{100,60}},color={0,127,255}));
  else
    connect(port_a1,senT1HexWatEnt.port_a)
      annotation (Line(points={{-100,60},{-20,60},{-20,50}},color={0,127,255}));
  end if;
  connect(gai2.y,pum2Hex.m_flow_in)
    annotation (Line(points={{40,106},{40,-48}},color={0,0,127}));
  connect(port_a1,pum1Hex.port_a)
    annotation (Line(points={{-100,60},{-90,60},{-90,80},{-70,80}},color={0,127,255}));
  connect(val1Hex.port_b,port_b1)
    annotation (Line(points={{90,80},{94,80},{94,60},{100,60}},color={0,127,255}));
  connect(hex.port_b1,senT1HexWatLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,10}},color={0,127,255}));
  connect(pum2Hex.port_b,senT2HexWatEnt.port_a)
    annotation (Line(points={{30,-60},{20,-60},{20,-50}},color={0,127,255}));
  connect(senT2HexWatEnt.port_b,hex.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}},color={0,127,255}));
  connect(senT1HexWatEnt.port_b,hex.port_a1)
    annotation (Line(points={{-20,30},{-20,6},{-10,6}},color={0,127,255}));
  connect(pum1Hex.port_b,senT1HexWatEnt.port_a)
    annotation (Line(points={{-50,80},{-20,80},{-20,50}},color={0,127,255}));
  connect(val1Hex.port_a,senT1HexWatLvg.port_b)
    annotation (Line(points={{70,80},{20,80},{20,30}},color={0,127,255}));
  connect(con.y1Hex,val1Hex.y)
    annotation (Line(points={{-48,166},{80,166},{80,92}},color={0,0,127}));
  connect(con.y1Hex,gai1.u)
    annotation (Line(points={{-48,166},{0,166},{0,120},{-10,120}},color={0,0,127}));
  connect(gai1.y,pum1Hex.m_flow_in)
    annotation (Line(points={{-34,120},{-60,120},{-60,92}},color={0,0,127}));
  connect(pum1Hex.P,totPPum.u[2])
    annotation (Line(points={{-49,89},{60,89},{60,0},{68,0}},color={0,0,127}));
  connect(pum2Hex.P,totPPum.u[1])
    annotation (Line(points={{29,-51},{28,-51},{28,0},{68,0}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(yValIso_actual,con.yValIso)
    annotation (Line(points={{-120,100},{-92,100},{-92,163},{-72,163}},color={0,0,127}));
  connect(con.yPum2Hex,gai2.u)
    annotation (Line(points={{-48,160},{40,160},{40,130}},color={0,0,127}));
  connect(u,con.u)
    annotation (Line(points={{-120,140},{-96,140},{-96,168},{-72,168}},color={0,0,127}));
  connect(hex.port_b2,senT2HexWatLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-10}},color={0,127,255}));
  connect(val2Hex.port_2,pum2Hex.port_a)
    annotation (Line(points={{70,-60},{50,-60}},color={0,127,255}));
  connect(port_a2,val2Hex.port_1)
    annotation (Line(points={{100,-60},{90,-60}},color={0,127,255}));
  connect(spl.port_1,senT2HexWatLvg.port_b)
    annotation (Line(points={{-50,-60},{-20,-60},{-20,-30}},color={0,127,255}));
  connect(spl.port_2,port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}},color={0,127,255}));
  connect(spl.port_3,val2Hex.port_3)
    annotation (Line(points={{-60,-70},{-60,-80},{80,-80},{80,-70}},color={0,127,255}));
  connect(con.yVal2Hex,val2Hex.y)
    annotation (Line(points={{-48,154},{64,154},{64,-40},{80,-40},{80,-48}},color={0,0,127}));
  connect(senT1HexWatLvg.T,con.T1HexWatLvg)
    annotation (Line(points={{9,20},{-76,20},{-76,152},{-72,152}},color={0,0,127}));
  connect(senT1HexWatEnt.T,con.T1HexWatEnt)
    annotation (Line(points={{-31,40},{-80,40},{-80,157},{-72,157}},color={0,0,127}));
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
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for a district heat exchanger system with a variable speed
pump on the secondary side, and a variable speed pump (in case of a passive
network) or a two-way modulating valve (in case of an active network)
on the primary side.
</p>
<p>
The system is controlled based on the logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.HeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.HeatExchanger</a>.
The pump flow rate is considered proportional to the pump speed
under the assumption of a constant flow resistance in both the primary and
the secondary loops.
</p>
</html>"));
end HeatExchanger;
