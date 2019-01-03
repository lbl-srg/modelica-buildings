within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model EquipmentRotationTwo_uDevRol
  "Validate lead/lag and lead/standby switching"

  parameter Integer num = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  parameter Boolean initRoles[num] = {true, false}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaLag(
    final stagingRuntime=5*60*60,
    final num=num)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationTwo
    leaSta(
    final stagingRuntime=5*60*60,
    final num=num)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad[num](
    final width=0.8,
    final period=2*60*60)
    "Lead device on/off status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad[num](
    final width=0.2,
    final period=1*60*60)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[num]
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad1[num](
    final width=0.8,
    final period=2*60*60)
    "Lead device on/off status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant standby[num](
    final k=false)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[num]
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[num](
    final pre_u_start=initRoles)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[num](
  final pre_u_start=initRoles)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
equation

  connect(leadLoad.y, logSwi.u1) annotation (Line(points={{-59,80},{-40,80},{-40,
          58},{-22,58}}, color={255,0,255}));
  connect(lagLoad.y, logSwi.u3) annotation (Line(points={{-59,20},{-40,20},{-40,
          42},{-22,42}}, color={255,0,255}));
  connect(logSwi.y, leaLag.uDevRol)
    annotation (Line(points={{1,50},{18,50}}, color={255,0,255}));
  connect(leadLoad1.y, logSwi1.u1) annotation (Line(points={{-59,-20},{-40,-20},
          {-40,-42},{-22,-42}}, color={255,0,255}));
  connect(standby.y, logSwi1.u3) annotation (Line(points={{-59,-80},{-40,-80},{-40,
          -58},{-22,-58}}, color={255,0,255}));
  connect(logSwi1.y, leaSta.uDevRol)
    annotation (Line(points={{1,-50},{18,-50}}, color={255,0,255}));
  connect(leaLag.yDevRol, pre.u)
    annotation (Line(points={{41,50},{58,50}}, color={255,0,255}));
  connect(pre.y, logSwi.u2) annotation (Line(points={{81,50},{90,50},{90,28},{
          -30,28},{-30,50},{-22,50}}, color={255,0,255}));
  connect(leaSta.yDevRol, pre1.u)
    annotation (Line(points={{41,-50},{58,-50}}, color={255,0,255}));
  connect(pre1.y, logSwi1.u2) annotation (Line(points={{81,-50},{88,-50},{88,
          -72},{-32,-72},{-32,-50},{-22,-50}}, color={255,0,255}));
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
