within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model EquipmentRotationTwo_uDevRol
  "Validate lead/lag and lead/standby switching"

  parameter Boolean initRoles[2] = {true, false}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaLag(
    final stagingRuntime=5*60*60)
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaSta(
    final stagingRuntime=5*60*60,
    final lag=false)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  EquipmentRotationTwo
    leaLag1(final stagingRuntime=5*60*60)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period=2*60*60) "Lead device on/off status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2,
    final period=1*60*60)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  CDL.Logical.Sources.Pulse                        lagLoad1(final width=0.2,
      final period=1.5*60*60)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(leadLoad.y, leaLag.uLeaSta) annotation (Line(points={{-59,70},{-40,70},
          {-40,46},{-22,46}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagSta) annotation (Line(points={{-59,10},{-40,10},
          {-40,34},{-22,34}},       color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaSta) annotation (Line(points={{-59,70},{30,70},
          {30,46},{38,46}}, color={255,0,255}));
  connect(leadLoad.y, leaLag1.uLeaSta) annotation (Line(points={{-59,70},{10,70},
          {10,-24},{18,-24}}, color={255,0,255}));
  connect(lagLoad1.y, leaLag1.uLagSta) annotation (Line(points={{-59,-50},{-40,
          -50},{-40,-36},{18,-36}}, color={255,0,255}));
          annotation (
   experiment(StopTime=10000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/Validation/EquipmentRotationTwo_uDevRol.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EquipmentRotationTwo_uDevRol;
