within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model IdentifyStage "Validation identifying stage index"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage ideSta
    "Idendify stage index"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage ideSta1(
    nChi=3,
    staMat={{1,0,0},{1,1,0},{1,1,1}})
    "Idendify stage index"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi1(
    final width=0.5,
    final period=5)
    "Chiller one status"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi2(
    final width=0.7,
    final period=5)
    "Chiller two status"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi3(
    final width=0.9,
    final period=5) "Chiller three status"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(chi1.y, ideSta.uChi[1]) annotation (Line(points={{-58,60},{-40,60},{-40,
          40},{58,40}}, color={255,0,255}));
  connect(chi2.y, ideSta.uChi[2]) annotation (Line(points={{-58,20},{-30,20},{-30,
          40},{58,40}}, color={255,0,255}));
  connect(chi3.y, not1.u)
    annotation (Line(points={{-58,-70},{-2,-70}}, color={255,0,255}));
  connect(chi1.y, not3.u) annotation (Line(points={{-58,60},{-40,60},{-40,10},{-2,
          10}},color={255,0,255}));
  connect(chi2.y, not2.u) annotation (Line(points={{-58,20},{-30,20},{-30,-30},{
          -2,-30}}, color={255,0,255}));
  connect(not3.y, ideSta1.uChi[1]) annotation (Line(points={{22,10},{30,10},{30,
          -30.6667},{58,-30.6667}}, color={255,0,255}));
  connect(not2.y, ideSta1.uChi[2])
    annotation (Line(points={{22,-30},{58,-30}}, color={255,0,255}));
  connect(not1.y, ideSta1.uChi[3]) annotation (Line(points={{22,-70},{40,-70},{
          40,-29.3333},{58,-29.3333}},
                                    color={255,0,255}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/Validation/IdentifyStage.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage</a>.
It shows how to identify current chiller stage.
</p>
<ul>
<li>
For instance <code>ideSta</code>, the staging matrix <code>staMat</code> is
specified as <code>{{1,0}, {0,1}, {1,1}}</code> which means that in stage 1
chiller 1 is enabled, in stage 2 chiller 2 is enabled and in stage 3 both
chillers are enabled.
<ul>
<li>
Before 2.5 seconds, since chiller 1 and 2 are enabled, current stage is 3.
</li>
<li>
From 2.5 seconds to 3.5 seconds, chiller 2 is enabled and chiller 1 is
disabled, current stage is 2.
</li>
<li>
After 3.5 seconds, both chillers are disabled, thus current stage is 0.
</li>
</ul>
</li>
<li>
For instance <code>ideSta1</code>, the staging matrix <code>staMat</code> is
specified as <code>{{1,0,0},{1,1,0},{1,1,1}}</code> which means that in stage 1
chiller 1 is enabled, in stage 2 chiller 1 and 2 is enabled and in stage 3 all
3 chillers are enabled.
<ul>
<li>
Before 2.5 seconds, no chiller is enabled. The current chiller stage
is 0.
</li>
<li>
From 2.5 seconds to 3.5 seconds, only chiller 1 is enabled. Thus the
current chiller stage is 1.
</li>
<li>
From 3.5 seconds to 4.5 seconds, chiller 1 and 2 are enabled. Thus
the current chiller stage is 2.
</li>
<li>
After 4.5 seconds, all the three chillers are enabled. Thus the
current chiller stage is 3.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 3, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end IdentifyStage;
