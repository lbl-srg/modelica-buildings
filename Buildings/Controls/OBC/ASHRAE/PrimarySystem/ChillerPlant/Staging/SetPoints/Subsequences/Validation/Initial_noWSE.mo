within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Initial_noWSE
  "Validate initial stage sequence in case of no WSE"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial iniSta(
    final have_WSE=false)
    "Tests if initial stage is the lowest available stage"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial iniSta1(
    final have_WSE=false)
    "Tests if initial stage is the lowest available stage"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant lowAvaSta(
    final k=2)
    "Lowest chiller stage that is available"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant lowAvaSta1(
    final k=2)
    "Lowest chiller stage that is available"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10,
    final delayOnInit=true)
    "True signal delay"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta(
    final k=true) "Plant status"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(lowAvaSta.y, iniSta.uUp)
    annotation (Line(points={{-18,30},{18,30}},color={255,127,0}));
  connect(lowAvaSta1.y, iniSta1.uUp)
    annotation (Line(points={{-18,-40},{18,-40}}, color={255,127,0}));
  connect(plaSta.y, truDel.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={255,0,255}));
  connect(truDel.y, iniSta.uPla) annotation (Line(points={{2,0},{10,0},{10,24},{
          18,24}}, color={255,0,255}));
  connect(plaSta.y, iniSta1.uPla) annotation (Line(points={{-38,0},{-30,0},{-30,
          -20},{0,-20},{0,-46},{18,-46}}, color={255,0,255}));
annotation (
 experiment(StopTime=100.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/Initial_noWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial</a>
 for chiller plants without WSE.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2020, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{80,60}})));
end Initial_noWSE;
