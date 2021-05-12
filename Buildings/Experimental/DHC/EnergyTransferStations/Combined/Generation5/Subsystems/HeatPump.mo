within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems;
model HeatPump "Base subsystem with water-to-water heat pump"
  replaceable package Medium1=Modelica.Media.Interfaces.PartialMedium
    "Medium model on condenser side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2=Modelica.Media.Interfaces.PartialMedium
    "Medium model on evaporator side"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  parameter Boolean have_pumCon = true
    "Set to true to include a condenser pump (false for external pump)"
    annotation(Evaluate=true);
  parameter Boolean have_varFloCon = true
    "Set to true for a variable condenser flow"
    annotation(Evaluate=true, Dialog(enable=have_pumCon));
  parameter Boolean have_varFloEva = true
    "Set to true for a variable evaporator flow"
    annotation(Evaluate=true);
  parameter Real COP_nominal(final unit="1")
    "Heat pump COP"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TCon_nominal
    "Condenser outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TEva_nominal
    "Evaporator outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q1_flow_nominal(min=0)
    "Heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal(
    final min=0) = 5 "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dT2_nominal(
    final max=0) = -5 "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean allowFlowReversal1=false
    "Set to true to allow flow reversal on condenser side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2=false
    "Set to true to allow flow reversal on evaporator side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  final parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)=
    heaPum.m1_flow_nominal
    "Mass flow rate on condenser side"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)=
    heaPum.m2_flow_nominal
    "Mass flow rate on evaporator side"
    annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna(start=false)
    "Enable signal"
    annotation (
      Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m1_flow(
    final unit="kg/s") if have_varFloCon and have_pumCon
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m2_flow(
    final unit="kg/s") if have_varFloEva
    "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid port for entering evaporator water" annotation (Placement(
        transformation(extent={{190,-70},{210,-50}}), iconTransformation(extent=
           {{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default))
    "Fluid port for leaving evaporator water" annotation (Placement(
        transformation(extent={{190,50},{210,70}}), iconTransformation(extent={{
            90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid port for entering condenser water" annotation (Placement(
        transformation(extent={{-210,-70},{-190,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid port for leaving condenser water" annotation (Placement(
        transformation(extent={{-210,50},{-190,70}}), iconTransformation(extent=
           {{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") "Heat pump power"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
    iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") "Pump power"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEva_flow(final unit="kg/s")
    "Evaporator water mass flow rate"
    annotation (Placement(transformation(
      extent={{200,-60},{240,-20}}), iconTransformation(extent={{100,-50},{
        140,-10}})));
  // COMPONENTS
  Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final dTEva_nominal=dT2_nominal,
    final dTCon_nominal=dT1_nominal,
    final TCon_nominal=TCon_nominal,
    final TEva_nominal=TEva_nominal,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final use_eta_Carnot_nominal=false,
    final COP_nominal=COP_nominal,
    final QCon_flow_nominal=Q1_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal)
    "Heat pump (index 1 for condenser side)"
    annotation (Placement(transformation(extent={{0,-24},{20,-4}})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat pump evaporator water pump"
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final allowFlowReversal=allowFlowReversal1) if have_pumCon
    "Heat pump condenser water pump"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConNom(
    final k=m1_flow_nominal) if not have_varFloCon
    "Nominal flow rate"
    annotation (Placement(transformation(extent={{-100,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floEvaNom(
    final k=m2_flow_nominal) if not have_varFloEva
    "Nominal flow rate"
    annotation (Placement(transformation(extent={{0,80},{-20,100}})));
  Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal)
    "Condenser water leaving temperature"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,20})));
  Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal)
    "Condenser water entering temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-20})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaHeaPum(
    u2(start=false))
    "Enable heat pump by switching to actual set point"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Adder"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) if not have_pumCon
    "Replacement variable"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold staPum[2](
    y(each start=false),
    t=1e-2 .* {m1_flow_nominal,m2_flow_nominal},
    h=0.5e-2 .* {m1_flow_nominal, m2_flow_nominal})
    "Pump return status"
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And ena
    "Enable heat pump if pump return status on"
    annotation (Placement(transformation(extent={{-120,-110},{-140,-90}})));
  Modelica.Blocks.Sources.Constant one(final k=1) if not have_pumCon
    "Replacement variable"
    annotation (Placement(transformation(extent={{60,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Product floCon if have_pumCon
    "Zero flow rate if not enabled"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Product floEva
    "Zero flow rate if not enabled"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
protected
  Fluid.FixedResistances.LosslessPipe pip(
    redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal) if not have_pumCon
    "Dummy connection used if model is configured to have no pump"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
equation
  connect(pumEva.port_b,heaPum. port_a2)
    annotation (Line(points={{50,-60},{40,-60},{40,-20},{20,-20}},
                                                   color={0,127,255}));
  connect(heaPum.port_b1,senTConLvg. port_a) annotation (Line(points={{20,-8},{40,
          -8},{40,10}},                        color={0,127,255}));
  connect(senTConEnt.port_b,heaPum. port_a1) annotation (Line(points={{-40,-10},
          {-40,-8},{0,-8}},            color={0,127,255}));
  connect(senTConEnt.T,enaHeaPum. u3) annotation (Line(points={{-51,-20},{-150,-20},
          {-150,12},{-142,12}},            color={0,0,127}));
  connect(enaHeaPum.y,heaPum. TSet) annotation (Line(points={{-118,20},{-10,20},
          {-10,-5},{-2,-5}},  color={0,0,127}));
  connect(uEna, booToRea.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={255,0,255}));
  connect(TSupSet, enaHeaPum.u1) annotation (Line(points={{-220,-20},{-180,-20},
          {-180,28},{-142,28}},   color={0,0,127}));
  connect(heaPum.port_b2, port_b2) annotation (Line(points={{0,-20},{-20,-20},{-20,
          40},{180,40},{180,60},{200,60}}, color={0,127,255}));
  connect(senTConLvg.port_b, port_b1)
    annotation (Line(points={{40,30},{40,60},{-200,60}}, color={0,127,255}));
  connect(pumEva.m_flow_actual, mEva_flow) annotation (Line(points={{49,-55},{
          44,-55},{44,-40},{220,-40}}, color={0,0,127}));
  connect(port_a2, pumEva.port_a)
    annotation (Line(points={{200,-60},{70,-60}}, color={0,127,255}));
  connect(port_a1, pumCon.port_a)
    annotation (Line(points={{-200,-60},{-140,-60},{-140,-50},{-70,-50}},
                                                    color={0,127,255}));
  connect(add2.y, PPum)
    annotation (Line(points={{162,0},{220,0}}, color={0,0,127}));
  connect(heaPum.P, PHea) annotation (Line(points={{21,-14},{190,-14},{190,40},{
          220,40}}, color={0,0,127}));
  connect(pumCon.P, add2.u2) annotation (Line(points={{-49,-41},{0,-41},{0,-80},
          {120,-80},{120,-6},{138,-6}}, color={0,0,127}));
  connect(pumEva.P, add2.u1) annotation (Line(points={{49,-51},{46,-51},{46,6},{
          138,6}}, color={0,0,127}));
  connect(pumCon.port_b, senTConEnt.port_a) annotation (Line(points={{-50,-50},
          {-40,-50},{-40,-30}},color={0,127,255}));
  connect(zer.y, add2.u2) annotation (Line(points={{101,-100},{120,-100},{120,-6},
          {138,-6}}, color={0,0,127}));
  connect(pumCon.m_flow_actual, staPum[1].u) annotation (Line(points={{-49,-45},
          {-38,-45},{-38,-100},{-78,-100}}, color={0,0,127}));
  connect(pumEva.m_flow_actual, staPum[2].u) annotation (Line(points={{49,-55},{
          20,-55},{20,-100},{-78,-100}}, color={0,0,127}));
  connect(staPum[1].y, ena.u1)
    annotation (Line(points={{-102,-100},{-118,-100}}, color={255,0,255}));
  connect(staPum[2].y, ena.u2) annotation (Line(points={{-102,-100},{-110,-100},
          {-110,-108},{-118,-108}}, color={255,0,255}));
  connect(ena.y, enaHeaPum.u2) annotation (Line(points={{-142,-100},{-160,-100},
          {-160,20},{-142,20}}, color={255,0,255}));
  connect(one.y, staPum[1].u)
    annotation (Line(points={{39,-100},{-78,-100}}, color={0,0,127}));
  connect(booToRea.y, floCon.u1) annotation (Line(points={{-158,120},{-140,120},
          {-140,126},{-122,126}}, color={0,0,127}));
  connect(m1_flow, floCon.u2) annotation (Line(points={{-220,80},{-140,80},{-140,
          114},{-122,114}}, color={0,0,127}));
  connect(booToRea.y, floEva.u1) annotation (Line(points={{-158,120},{-140,120},
          {-140,134},{-40,134},{-40,126},{-22,126}}, color={0,0,127}));
  connect(floConNom.y, floCon.u2) annotation (Line(points={{-122,90},{-130,90},{
          -130,114},{-122,114}}, color={0,0,127}));
  connect(m2_flow, floEva.u2) annotation (Line(points={{-220,40},{-40,40},{-40,114},
          {-22,114}}, color={0,0,127}));
  connect(floEvaNom.y, floEva.u2) annotation (Line(points={{-22,90},{-30,90},{-30,
          114},{-22,114}}, color={0,0,127}));
  connect(floEva.y, pumEva.m_flow_in)
    annotation (Line(points={{2,120},{60,120},{60,-48}}, color={0,0,127}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-98,120},{-60,120},{-60,-38}}, color={0,0,127}));
  connect(port_a1, pip.port_a) annotation (Line(points={{-200,-60},{-140,-60},{
          -140,-80},{-70,-80}}, color={0,127,255}));
  connect(pip.port_b, senTConEnt.port_a) annotation (Line(points={{-50,-80},{
          -40,-80},{-40,-30}}, color={0,127,255}));
  annotation (
  defaultComponentName="heaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,62},{62,-58}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
This model represents a water-to-water heat pump, an evaporator water pump,
and an optional condenser water pump if <code>have_pumCon</code> is set to
<code>true</code>.
The heat pump model is described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_TCon\">
Buildings.Fluid.HeatPumps.Carnot_TCon</a>.
By default variable speed pumps are considered.
Constant speed pumps may also be represented by setting <code>have_varFloEva</code> 
and <code>have_varFloCon</code> to <code>false</code>.
</p>
<h4>Controls</h4>
<p>
The system is enabled when the input control signal <code>uEna</code> switches to 
<code>true</code>. 
When enabled,
</p>
<ul>
<li>
the evaporator and optionally the condenser water pumps are commanded on and supply either
the mass flow rate set point provided as an input in the case of variable speed pumps,
or the nominal mass flow rate in the case of constant speed pumps,
</li>
<li>
the heat pump is commanded on when the evaporator and optionally the condenser water pump
are proven on. When enabled, the heat pump controller—idealized in this model—tracks the
supply temperature set point at the condenser outlet. 
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPump;
