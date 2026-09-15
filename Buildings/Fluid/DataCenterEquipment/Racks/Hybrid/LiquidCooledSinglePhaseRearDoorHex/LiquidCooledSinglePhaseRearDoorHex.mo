within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex;
model LiquidCooledSinglePhaseRearDoorHex
  "Hybrid rack model combining liquid-cooled and air-cooled components with a rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase(
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHex.Generic dat);

  replaceable package MediumReaDooHex = Modelica.Media.Interfaces.PartialMedium
    "Medium for rear door heat exchanger coolant loop"
      annotation (choices(
        choice(redeclare package MediumReaDooHex = Buildings.Media.Water "Water"),
        choice(redeclare package MediumReaDooHex =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  Modelica.Fluid.Interfaces.FluidPort_a portReaDooHex_a(
    redeclare final package Medium = MediumReaDooHex)
    "Rear door heat exchanger coolant inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b portReaDooHex_b(
    redeclare final package Medium = MediumReaDooHex)
    "Rear door heat exchanger coolant outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU reaDooHex(
    redeclare final package Medium1 = MediumReaDooHex,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=dat.reaDooHex.mCoo_flow_nominal,
    final m2_flow_nominal=dat.reaDooHex.mAir_flow_nominal,
    final dp1_nominal=dat.reaDooHex.dpCoo_nominal,
    final dp2_nominal=dat.reaDooHex.dpAir_nominal,
    final use_Q_flow_nominal=false,
    final eps_nominal=dat.reaDooHex.eps_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed)
    "Rear door heat exchanger"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(air.port_b, reaDooHex.port_a2)
    annotation (Line(points={{10,-40},{44,-40},{44,-16},{40,-16}}, color={0,127,255}));
  connect(reaDooHex.port_b2, portAir_b)
    annotation (Line(points={{20,-16},{16,-16},{16,-28},{86,-28},{86,-40},{102,
          -40}},                                                    color={0,127,255}));
  connect(portReaDooHex_a, reaDooHex.port_a1)
    annotation (Line(points={{-100,0},{14,0},{14,-4},{20,-4}},   color={0,127,255}));
  connect(reaDooHex.port_b1, portReaDooHex_b)
    annotation (Line(points={{40,-4},{56,-4},{56,-14},{100,-14},{100,0}},
                                                                color={0,127,255}));

annotation (
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components
with a rear door heat exchanger.
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase</a>
and adds a rear door heat exchanger based on
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>.
</p>
<p>
The rear door heat exchanger is connected between the air outlet of the
air-cooled rack component <code>air.port_b</code> and the top-level air outlet
port <code>portAir_b</code>.
It cools the warm rack exhaust air using a liquid coolant loop connected
through <code>portReaDooHex_a</code> (inlet) and <code>portReaDooHex_b</code> (outlet).
</p>
<p>
The medium for the rear door heat exchanger coolant is <code>MediumReaDooHex</code>,
which is separate from the liquid cooling medium <code>MediumLiq</code> used by the
cold plate components.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For liquid cooling, <code>portLiq_a</code> and <code>portLiq_b</code> serve as the inlet and outlet ports.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
For the rear door heat exchanger coolant, <code>portReaDooHex_a</code> and <code>portReaDooHex_b</code>
serve as the inlet and outlet ports. These ports are located in the middle of the icon,
centered between the liquid and air cooling ports.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 12, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
      Rectangle(
        extent={{40,-28},{100,-32}},
        lineColor={0,127,255},
        pattern=LinePattern.None,
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-106,-28},{-40,-32}},
        lineColor={0,127,255},
        pattern=LinePattern.None,
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid)}));
end LiquidCooledSinglePhaseRearDoorHex;
