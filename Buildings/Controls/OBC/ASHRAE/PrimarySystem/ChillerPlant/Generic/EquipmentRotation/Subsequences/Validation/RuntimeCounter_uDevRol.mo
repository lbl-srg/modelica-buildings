within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model RuntimeCounter_uDevRol
  "Validate lead/lag and lead/standby switching signal based on device runtime"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter runCou(
    final stagingRuntime=7500)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter runCou1(
    final stagingRuntime = 7200)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter runCou2(
    final stagingRuntime=7200)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[2] "Switch"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[2] "Switch"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[2] "Switch"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

protected
  parameter Boolean initRoles[2] = {true, false}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staSta[2](
    final k=fill(false, 2)) "Standby status"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLag1(final nout=2)
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLag(final nout=2)
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLead(final nout=2)
    "Replicates lead signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8, final period=7200) "Lead device enable status"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2, final period=3600)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(
    final width=0.2, final period=5400)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(leadLoad.y, repLead.u) annotation (Line(points={{-58,90},{-50,90},{-50,
          70},{-42,70}}, color={255,0,255}));
  connect(lagLoad.y, repLag.u) annotation (Line(points={{-58,30},{-50,30},{-50,40},
          {-42,40}}, color={255,0,255}));
  connect(repLead.y, logSwi.u1) annotation (Line(points={{-18,70},{0,70},{0,58},
          {18,58}}, color={255,0,255}));
  connect(repLag.y, logSwi.u3) annotation (Line(points={{-18,40},{10,40},{10,42},
          {18,42}}, color={255,0,255}));
  connect(logSwi.y, runCou.uDevStaSet)
    annotation (Line(points={{42,50},{58,50}}, color={255,0,255}));
  connect(runCou.yPreDevRolSet, logSwi.u2) annotation (Line(points={{81,44},{90,
          44},{90,30},{10,30},{10,50},{18,50}}, color={255,0,255}));
  connect(logSwi1.y, runCou1.uDevStaSet)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));
  connect(runCou1.yPreDevRolSet,logSwi1. u2) annotation (Line(points={{81,-6},{90,
          -6},{90,-20},{12,-20},{12,0},{18,0}},   color={255,0,255}));
  connect(staSta.y,logSwi1. u3) annotation (Line(points={{-58,-10},{-20,-10},{-20,
          -8},{18,-8}}, color={255,0,255}));
  connect(repLead.y,logSwi1. u1) annotation (Line(points={{-18,70},{-10,70},{-10,
          8},{18,8}},   color={255,0,255}));
  connect(lagLoad1.y, repLag1.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={255,0,255}));
  connect(repLead.y,logSwi2. u1) annotation (Line(points={{-18,70},{-10,70},{-10,
          -42},{18,-42}}, color={255,0,255}));
  connect(repLag1.y,logSwi2. u3) annotation (Line(points={{-18,-70},{-10,-70},{-10,
          -58},{18,-58}}, color={255,0,255}));
  connect(logSwi2.y, runCou2.uDevStaSet)
    annotation (Line(points={{42,-50},{58,-50}}, color={255,0,255}));
  connect(runCou2.yPreDevRolSet,logSwi2. u2) annotation (Line(points={{81,-56},{
          90,-56},{90,-70},{10,-70},{10,-50},{18,-50}}, color={255,0,255}));
          annotation (
   experiment(StopTime=10000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/RuntimeCounter_uDevRol.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2019, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end RuntimeCounter_uDevRol;
