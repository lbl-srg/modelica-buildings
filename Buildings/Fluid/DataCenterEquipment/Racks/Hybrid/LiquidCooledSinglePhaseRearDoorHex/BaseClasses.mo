within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex;
package BaseClasses "Base classes for rear door heat exchanger models"
  extends Modelica.Icons.BasesPackage;

  partial model PartialRack
    "Partial model for hybrid rack combining liquid-cooled and air-cooled components with a rear door heat exchanger"
    extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase;

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

    replaceable Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger reaDooHex
      constrainedby Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger(
      redeclare package MediumCoo = MediumReaDooHex,
      redeclare package MediumAir = MediumAir,
      dat(
        mAir_flow_nominal=dat.reaDooHex.mAir_flow_nominal,
        mCoo_flow_nominal=dat.reaDooHex.mCoo_flow_nominal,
        Q_flow_nominal=dat.reaDooHex.Q_flow_nominal,
        TAirIn_nominal=dat.reaDooHex.TAirIn_nominal,
        TCooIn_nominal=dat.reaDooHex.TCooIn_nominal,
        dTAir_nominal=dat.reaDooHex.dTAir_nominal,
        dpCoo_nominal=dat.reaDooHex.dpCoo_nominal,
        dpAir_nominal=dat.reaDooHex.dpAir_nominal)) "Rear door heat exchanger"
      annotation (Placement(transformation(extent={{20,-16},{40,4}})));

  equation
    connect(reaDooHex.portAir_b, portAir_b)
      annotation (Line(points={{20,-12},{14,-12},{14,-26},{90,-26},{90,-40},{102,-40}},
                                                                      color={0,127,255}));
    connect(portReaDooHex_a, reaDooHex.portCoo_a)
      annotation (Line(points={{-100,0},{20,0}},                 color={0,127,255}));
    connect(reaDooHex.portCoo_b, portReaDooHex_b)
      annotation (Line(points={{40,0},{100,0}},                   color={0,127,255}));

    connect(air.port_b, reaDooHex.portAir_a) annotation (Line(points={{10,-40},
            {52,-40},{52,-12},{40,-12}}, color={0,127,255}));
    annotation (
    defaultComponentName="rac",
    Documentation(
      info="<html>
<p>
Partial model of a hybrid IT rack that combines liquid-cooled and air-cooled components
with a rear door heat exchanger.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase</a>
and adds a partial model for a rear door heat exchanger.
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
  end PartialRack;
annotation (
  Documentation(
    info="<html>
<p>
Package with base classes for racks with rear door heat exchangers.
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
end BaseClasses;
