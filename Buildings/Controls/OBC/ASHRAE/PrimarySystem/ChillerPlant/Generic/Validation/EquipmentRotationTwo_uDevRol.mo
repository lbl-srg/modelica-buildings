within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model EquipmentRotationTwo_uDevRol
  "Validate lead/lag and lead/standby switching"

  parameter Integer num = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  parameter Boolean initRoles[:] = {if i==1 then true else false for i in 1:num}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaLag(
    final stagingRuntime=5*60*60,
    final num=num)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaSta(
    final stagingRuntime=5*60*60,
    final num=num,
    lag=false)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(final width=0.8,
      final period=2*60*60) "Lead device on/off status"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(final width=0.2,
      final period=1*60*60)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation

  connect(leadLoad.y, leaLag.uLeaSta) annotation (Line(points={{-59,20},{-40,20},
          {-40,-4},{-22,-4}}, color={255,0,255}));
  connect(lagLoad.y, leaLag.uLagSta) annotation (Line(points={{-59,-40},{-40,
          -40},{-40,-16},{-22,-16}},color={255,0,255}));
  connect(leadLoad.y, leaSta.uLeaSta) annotation (Line(points={{-59,20},{30,20},
          {30,-4},{38,-4}}, color={255,0,255}));
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
