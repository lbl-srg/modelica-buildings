within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses;
partial model PartialRearDoorHeatExchanger
  "Partial model of a rear door heat exchanger with coolant and air ports"

  replaceable package MediumCoo = Modelica.Media.Interfaces.PartialMedium
    "Medium for rear door heat exchanger coolant loop"
    annotation (
      choices(
      choice(redeclare package MediumCoo = Buildings.Media.Water "Water"),
      choice(redeclare package MediumCoo =
          Buildings.Media.Antifreeze.PropyleneGlycolWater (
            property_T=303.15,
            X_a=0.25)
            "Propylene glycol water, 25% mass fraction")));

  replaceable package MediumAir = Modelica.Media.Interfaces.PartialMedium
    "Medium for air side"
    annotation (choices(
      choice(redeclare package MediumAir = Buildings.Media.Air "Air")));


  parameter Boolean allowFlowReversalCoo = true
    "= false to simplify equations on coolant side, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalAir = true
    "= false to simplify equations on air side, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex dat
    "Heat exchanger performance data"
    annotation (
      Placement(transformation(extent={{40,70},{60,90}})),
      choicesAllMatching=true,
      Dialog(group="Nominal condition"));

  Modelica.Fluid.Interfaces.FluidPort_a portCoo_a(
    redeclare final package Medium = MediumCoo)
    "Coolant inlet port"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
      iconTransformation(extent={{-110,50},{-90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_b portCoo_b(
    redeclare final package Medium = MediumCoo)
    "Coolant outlet port"
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
      iconTransformation(extent={{90,50},{110,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a portAir_a(
    redeclare final package Medium = MediumAir)
    "Air inlet port"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
      iconTransformation(extent={{90,-70},{110,-50}})));

  Modelica.Fluid.Interfaces.FluidPort_b portAir_b(
    redeclare final package Medium = MediumAir)
    "Air outlet port"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-110,-70},{-90,-50}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU reaDooHex(
    redeclare final package Medium1 = MediumCoo,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=dat.mCoo_flow_nominal,
    final m2_flow_nominal=dat.mAir_flow_nominal,
    final dp1_nominal=dat.dpCoo_nominal,
    final dp2_nominal=dat.dpAir_nominal,
    final use_Q_flow_nominal=false,
    final eps_nominal=dat.eps_nominal,
    final allowFlowReversal1 = allowFlowReversalCoo,
    final allowFlowReversal2 = allowFlowReversalAir,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed)
    "Rear door heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Sensors.TemperatureTwoPort senTAirReaDooHexIn(
    redeclare package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    m_flow_nominal=dat.mAir_flow_nominal)
    "Air temperature entering rear door heat exchanger" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-60})));
equation
  connect(portCoo_a, reaDooHex.port_a1)
    annotation (Line(points={{-100,60},{-20,60},{-20,6},{-10,6}}, color={0,127,255}));
  connect(reaDooHex.port_b1, portCoo_b)
    annotation (Line(points={{10,6},{20,6},{20,60},{100,60}}, color={0,127,255}));

  connect(senTAirReaDooHexIn.port_a, portAir_a)
    annotation (Line(points={{60,-60},{100,-60}}, color={0,127,255}));
annotation (
  Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-30,80},{30,-80}},
        lineColor={0,0,0},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-100,64},{-30,56}},
        pattern=LinePattern.None,
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{30,64},{100,56}},
        pattern=LinePattern.None,
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{30,-56},{100,-64}},
        pattern=LinePattern.None,
        fillColor={0,140,72},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-100,-56},{-30,-64}},
        pattern=LinePattern.None,
        fillColor={0,140,72},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-149,-104},{151,-144}},
        textColor={0,0,255},
        textString="%name")}),
  defaultComponentName="reaDooHex",
  Documentation(
    info="<html>
<p>
Partial model of a rear door heat exchanger (RDHx) with four fluid ports:
two for the liquid coolant side and two for the air side.
</p>
<p>
The heat exchanger is modeled using
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
with a cross-flow unmixed configuration.
The performance data are provided through the record <code>dat</code>.
</p>
<p>
The coolant connections (port_a1 to port_b1) are included in this partial model.
The air connections are left to the extending models, because the
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active\">Active</a>
model inserts a fan in the air path while the
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Passive\">Passive</a>
model connects the ports directly.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialRearDoorHeatExchanger;
