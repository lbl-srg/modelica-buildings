within Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses;
partial model PartialAirRearDoorHex
  "Partial model for air-cooled rack with a rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.Air(
    redeclare replaceable parameter Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic dat
    constrainedby Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic);

  replaceable package MediumReaDooHex = Modelica.Media.Interfaces.PartialMedium
    "Medium for rear door heat exchanger coolant loop"
      annotation(
        choices(
        choice(redeclare package MediumReaDooHex = Buildings.Media.Water "Water"),
        choice(redeclare package MediumReaDooHex =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  parameter Boolean allowFlowReversalCoo = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for rear door heat exchanger coolant"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a portReaDooHex_a(
    redeclare final package Medium = MediumReaDooHex,
    m_flow(min=if allowFlowReversalCoo then -Modelica.Constants.inf else 0))
    "Rear door heat exchanger coolant inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b portReaDooHex_b(
    redeclare final package Medium = MediumReaDooHex,
    m_flow(max=if allowFlowReversalCoo then +Modelica.Constants.inf else 0))
    "Rear door heat exchanger coolant outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

  replaceable Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger reaDooHex
    constrainedby Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger(
      redeclare package MediumCoo = MediumReaDooHex,
      redeclare package MediumAir = MediumAir,
      final allowFlowReversalCoo=allowFlowReversalCoo,
      final allowFlowReversalAir=allowFlowReversal,
      dat(
        mAir_flow_nominal=dat.reaDooHex.mAir_flow_nominal,
        mCoo_flow_nominal=dat.reaDooHex.mCoo_flow_nominal,
        Q_flow_nominal=dat.reaDooHex.Q_flow_nominal,
        TAirIn_nominal=dat.reaDooHex.TAirIn_nominal,
        TCooIn_nominal=dat.reaDooHex.TCooIn_nominal,
        dpCoo_nominal=dat.reaDooHex.dpCoo_nominal,
        dpAir_nominal=dat.reaDooHex.dpAir_nominal)) "Rear door heat exchanger"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));

equation

  connect(reaDooHex.portAir_a, air.port_b) annotation (Line(points={{40,-12},{
          50,-12},{50,-40},{10,-40}}, color={0,127,255}));
  connect(reaDooHex.portAir_b, portAir_b) annotation (Line(points={{20,-12},{14,
          -12},{14,-26},{92,-26},{92,-40},{102,-40}}, color={0,127,255}));
  connect(reaDooHex.portCoo_b, portReaDooHex_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(reaDooHex.portCoo_a, portReaDooHex_a)
    annotation (Line(points={{20,0},{-100,0}}, color={0,127,255}));
  annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Partial model of an air-cooled IT rack
with a rear door heat exchanger.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.Air\">
Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.Air</a>
and adds a partial model for a rear door heat exchanger.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
      Rectangle(
        extent={{40,2},{100,-2}},
        lineColor={0,127,255},
        pattern=LinePattern.None,
        fillColor={0,140,72},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-106,2},{-40,-2}},
        lineColor={0,127,255},
        pattern=LinePattern.None,
        fillColor={0,140,72},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{40,26},{76,-58}},
        lineColor={0,0,0},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid)}));
end PartialAirRearDoorHex;
