within Buildings.DHC.ETS.Combined.Controls;
block TankChargingController
  "Controller to enable or disable storage tank charging"
  parameter Modelica.Units.SI.TemperatureDifference dTOffSet=
    if isHotWat then +1 else -1
    "Offset for set point to have a slightly higher (or lower) temperature than the required supply from the load";

  parameter Boolean isHotWat
    "True if the tank supplies hot water, False for chilled water";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanTop(
    final unit="K",
    displayUnit="degC") "Measured temperature at top of tank"
                                          annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),  iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TTanSet(
    final unit="K",
    displayUnit="degC")
    "Tank temperature set point, top for hot tank and bottom for cold tank"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Outputs true if tank should be charged" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTanBot(final unit="K", displayUnit=
        "degC") "Measured temperature at bottom of tank" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}),  iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch to enable charging and hold it until charged"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negation of charge signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And chaTopBot
    "Outputs true if top and bottom test wants tank to be charged. Used to override latch if tank temperature drops without triggering latch"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Or block to enable charge if one of the inputs request charging"
    annotation (Placement(transformation(extent={{66,16},{86,36}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter dTOffChaOn(
    final p=dTOffSet,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC")) "Offset for charge on signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter dTOffChaOff(
    final p=2*dTOffSet,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC")) "Offset for charge off signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater chaTopHea(
    h=dTOffSet/2,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC")) if isHotWat
    "Charging signal for hot water tank"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Reals.Greater chaTBotHea(
    h=dTOffSet/2,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC")) if isHotWat
    "Charging signal for hot water tank"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Reals.Less chaTBotCoo(
    h=-dTOffSet/2,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC")) if not isHotWat
    "Charging signal for cold water tank"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Less chaTTopCoo(
    h=-dTOffSet/2,
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC")) if not isHotWat
    "Charging signal for cold water tank"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(not1.y, lat.clr) annotation (Line(points={{42,-60},{48,-60},{48,-32},{
          32,-32},{32,-6},{38,-6}},  color={255,0,255}));
  connect(or1.y, charge) annotation (Line(points={{88,26},{94,26},{94,0},{120,0}},
        color={255,0,255}));
  connect(lat.y, or1.u2)
    annotation (Line(points={{62,0},{64,0},{64,18}}, color={255,0,255}));
  connect(or1.u1, chaTopBot.y) annotation (Line(points={{64,26},{58,26},{58,40},
          {52,40}}, color={255,0,255}));
  connect(TTanSet, dTOffChaOn.u)
    annotation (Line(points={{-120,70},{-82,70}}, color={0,0,127}));
  connect(chaTopHea.u1, dTOffChaOn.y)
    annotation (Line(points={{-22,70},{-58,70}}, color={0,0,127}));
  connect(dTOffChaOff.y, chaTBotHea.u1)
    annotation (Line(points={{-58,40},{-22,40}}, color={0,0,127}));
  connect(TTanTop, chaTopHea.u2) annotation (Line(points={{-120,0},{-40,0},{-40,
          62},{-22,62}}, color={0,0,127}));
  connect(chaTopHea.y, chaTopBot.u1) annotation (Line(points={{2,70},{24,70},{24,
          40},{28,40}}, color={255,0,255}));
  connect(chaTBotHea.y, chaTopBot.u2) annotation (Line(points={{2,40},{16,40},{16,
          32},{28,32}}, color={255,0,255}));
  connect(lat.u, chaTopHea.y) annotation (Line(points={{38,0},{24,0},{24,70},{2,
          70}}, color={255,0,255}));
  connect(not1.u, chaTBotHea.y) annotation (Line(points={{18,-60},{16,-60},{16,40},
          {2,40}}, color={255,0,255}));
  connect(chaTTopCoo.u1, dTOffChaOff.y) annotation (Line(points={{-22,-60},{-34,
          -60},{-34,40},{-58,40}}, color={0,0,127}));
  connect(chaTBotCoo.u1, dTOffChaOn.y) annotation (Line(points={{-22,-30},{-50,-30},
          {-50,70},{-58,70}}, color={0,0,127}));
  connect(chaTBotCoo.u2, TTanBot) annotation (Line(points={{-22,-38},{-56,-38},
          {-56,-60},{-120,-60}},color={0,0,127}));
  connect(chaTTopCoo.u2, TTanTop) annotation (Line(points={{-22,-68},{-40,-68},{
          -40,0},{-120,0}}, color={0,0,127}));
  connect(chaTBotCoo.y, chaTopBot.u1) annotation (Line(points={{2,-30},{6,-30},{
          6,40},{28,40}}, color={255,0,255}));
  connect(chaTTopCoo.y, chaTopBot.u2) annotation (Line(points={{2,-60},{8,-60},{
          8,32},{28,32}}, color={255,0,255}));
  connect(not1.u, chaTTopCoo.y)
    annotation (Line(points={{18,-60},{2,-60}}, color={255,0,255}));
  connect(chaTBotCoo.y, lat.u) annotation (Line(points={{2,-30},{24,-30},{24,0},
          {38,0}}, color={255,0,255}));
  connect(dTOffChaOff.u, TTanSet) annotation (Line(points={{-82,40},{-90,40},{-90,
          70},{-120,70}}, color={0,0,127}));
  connect(chaTBotHea.u2, TTanBot) annotation (Line(points={{-22,32},{-56,32},{
          -56,-60},{-120,-60}}, color={0,0,127}));
  annotation (
  defaultComponentName="tanCha",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-96,98},{-46,62}},
          textColor={0,0,127},
          textString="TTanTopSet"),
        Text(
          extent={{-96,18},{-46,-18}},
          textColor={0,0,127},
          textString="TTanTop"),
        Text(
          extent={{42,20},{92,-16}},
          textColor={0,0,127},
          textString="charge"),
        Text(
          extent={{-96,-62},{-46,-98}},
          textColor={0,0,127},
          textString="TTanBot")}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 13, 2025, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
November 15, 2023, by David Blum:<br/>
Add that charging is stopped when bottom temperature reaches set point.
</li>
<li>
October 4, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Adapted fromBuildings.DHC.Loads.HotWater.BaseClasses.TankChargingController.

</p>
<ul>
<li>
The hysteresis parameters are exposed.
</li>
<li>
Added a routing block so that it could be applied to both
hot and cold tanks, i.e. either the top or bottom of the tank
could be the supply side or the return side.
</li>
</ul>
</html>"));
end TankChargingController;
