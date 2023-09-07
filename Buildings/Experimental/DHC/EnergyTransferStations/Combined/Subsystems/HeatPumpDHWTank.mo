within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems;
model HeatPumpDHWTank
  "Base subsystem with water-to-water heat pump with storage tank for domestic hot waterr"
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
  parameter Boolean have_varFloEva = true
    "Set to true for a variable evaporator flow"
    annotation(Evaluate=true);
  parameter Real COP_nominal(final unit="1")
    "Heat pump COP"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Condenser outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Evaporator outlet temperature used to compute COP_nominal"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean allowFlowReversal1=false
    "Set to true to allow flow reversal on condenser side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2=false
    "Set to true to allow flow reversal on evaporator side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal(min=0) "Mass flow rate of domestic hot water leaving tank"
    annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna(start=false)
    "Enable signal"
    annotation (
      Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
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
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=heaPumTan.mDH_flow_nominal,
    final allowFlowReversal=allowFlowReversal2,
    dp_nominal=datWatHea.dp2_nominal)
    "Heat pump evaporator water pump"
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant floEvaNom(final k=heaPumTan.mDH_flow_nominal)
    if not have_varFloEva "Nominal flow rate"
    annotation (Placement(transformation(extent={{0,80},{-20,100}})));
  Fluid.Sensors.TemperatureTwoPort senTHotSup(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=mHw_flow_nominal)
    "Temperature of water leaving the domestic hot water storage tank"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,20})));
  Fluid.Sensors.TemperatureTwoPort senTColSou(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=mHw_flow_nominal)
    "Temperature of water entering domestic hot water tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-20})));
  Buildings.Controls.OBC.CDL.Reals.Switch enaHeaPum(
    u2(start=false))
    "Enable heat pump by switching to actual set point"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold staPum(
    y(each start=false),
    t=1e-2*heaPumTan.mDH_flow_nominal,
    h=0.5e-2*heaPumTan.mDH_flow_nominal)
                              "Pump return status"
    annotation (Placement(transformation(extent={{-80,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floEva
    "Zero flow rate if not enabled"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Loads.HotWater.HeatPumpWithTank heaPumTan(
    mHw_flow_nominal=mHw_flow_nominal,
    datWatHea=datWatHea,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal)
    "Heat pump with storage tank for domestic hot water"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  parameter Loads.HotWater.Data.GenericHeatPumpWaterHeater datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{4,-36},{16,-24}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{140,-18},{160,2}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetHw(k=datWatHea.THex_nominal)
    "Set point of water leaving heat pump and in tank"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(final unit="kg/s")
    "Actual heat pump heating heat flow rate added to fluid" annotation (
      Placement(transformation(extent={{200,-120},{240,-80}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
equation
  connect(senTColSou.T,enaHeaPum. u3) annotation (Line(points={{-51,-20},{-150,-20},
          {-150,12},{-142,12}},            color={0,0,127}));
  connect(uEna, booToRea.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={255,0,255}));
  connect(senTHotSup.port_b, port_b1)
    annotation (Line(points={{40,30},{40,60},{-200,60}}, color={0,127,255}));
  connect(pumEva.m_flow_actual, mEva_flow) annotation (Line(points={{49,-55},{
          44,-55},{44,-40},{220,-40}}, color={0,0,127}));
  connect(port_a2, pumEva.port_a)
    annotation (Line(points={{200,-60},{70,-60}}, color={0,127,255}));
  connect(booToRea.y, floEva.u1) annotation (Line(points={{-158,120},{-140,120},
          {-140,134},{-40,134},{-40,126},{-22,126}}, color={0,0,127}));
  connect(m2_flow, floEva.u2) annotation (Line(points={{-220,40},{-40,40},{-40,114},
          {-22,114}}, color={0,0,127}));
  connect(floEvaNom.y, floEva.u2) annotation (Line(points={{-22,90},{-30,90},{-30,
          114},{-22,114}}, color={0,0,127}));
  connect(floEva.y, pumEva.m_flow_in)
    annotation (Line(points={{2,120},{60,120},{60,-48}}, color={0,0,127}));
  connect(port_a1,senTColSou. port_a) annotation (Line(points={{-200,-60},{-40,-60},
          {-40,-30}}, color={0,127,255}));
  connect(heaPumTan.port_a1,senTColSou. port_b)
    annotation (Line(points={{0,-4},{-40,-4},{-40,-10}}, color={0,127,255}));
  connect(heaPumTan.port_b1,senTHotSup. port_a)
    annotation (Line(points={{20,-4},{40,-4},{40,10}}, color={0,127,255}));
  connect(pumEva.port_b, heaPumTan.port_a2) annotation (Line(points={{50,-60},{40,
          -60},{40,-16},{20,-16}}, color={0,127,255}));
  connect(heaPumTan.port_b2, port_b2) annotation (Line(points={{0,-16},{-20,-16},
          {-20,40},{160,40},{160,60},{200,60}}, color={0,127,255}));
  connect(enaHeaPum.y, heaPumTan.TSetHw) annotation (Line(points={{-118,20},{-10,
          20},{-10,-10},{-1,-10}}, color={0,0,127}));
  connect(heaPumTan.PHea, PHea) annotation (Line(points={{21,-10},{80,-10},{80,20},
          {180,20},{180,40},{220,40}}, color={0,0,127}));
  connect(staPum.y, enaHeaPum.u2) annotation (Line(points={{-102,-100},{-160,-100},
          {-160,20},{-142,20}}, color={255,0,255}));
  connect(pumEva.m_flow_actual, staPum.u) annotation (Line(points={{49,-55},{0,-55},
          {0,-100},{-78,-100}}, color={0,0,127}));
  connect(add.y, PPum) annotation (Line(points={{161,-8},{180,-8},{180,0},{220,0}},
        color={0,0,127}));
  connect(add.u2, pumEva.P) annotation (Line(points={{138,-14},{120,-14},{120,-20},
          {49,-20},{49,-51}}, color={0,0,127}));
  connect(heaPumTan.PPum, add.u1) annotation (Line(points={{21,-12},{120,-12},{120,
          -2},{138,-2}}, color={0,0,127}));
  connect(heaPumTan.QCon_flow, QCon_flow) annotation (Line(points={{21,-8},{82,-8},
          {82,-100},{220,-100}}, color={0,0,127}));
  connect(TSetHw.y, enaHeaPum.u1) annotation (Line(points={{-178,10},{-166,10},{
          -166,28},{-142,28}}, color={0,0,127}));
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
November 16, 2022, by Michael Wetter:<br/>
Set <code>pumEva.dp_nominal</code> to correct value.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPumpDHWTank;
