within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model RealValueSelectionByMode "Real value selection by mode"

  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode reaValSelByModWitPre(
    use_pre=true)
    "Block for the real value selection by mode, including the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uModHou(
    table=[0,0; 14,-1; 16,1; 18,3; 19,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    "Demand flexibility mode by hour"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conPre(k=-10)
    "Constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode reaValSelByModNoPre(
    use_pre=false)
    "Block for the real value selection by mode, without the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDef(k=0)
    "Constant for the default mode"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conShe(k=10)
    "Constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conReb(k=20)
    "Constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(uModHou.y[1], reaValSelByModWitPre.uMod)
    annotation (Line(points={{-58,70},{-20,70},{-20,38},{58,38}},
      color={255,127,0}));
  connect(conPre.y, reaValSelByModWitPre.uPre)
    annotation (Line(points={{-38,30},{-10,30},{-10,34},{58,34}}, color={0,0,127}));
  connect(conDef.y, reaValSelByModWitPre.uDef)
    annotation (Line(points={{-58,-10},{0,-10},{0,30},{58,30}}, color={0,0,127}));
  connect(conShe.y, reaValSelByModWitPre.uShe)
    annotation (Line(points={{-18,-30},{20,-30},{20,26},{58,26}}, color={0,0,127}));
  connect(conReb.y, reaValSelByModWitPre.uReb)
    annotation (Line(points={{-38,-70},{40,-70},{40,22},{58,22}}, color={0,0,127}));
  connect(conDef.y, reaValSelByModNoPre.uDef)
    annotation (Line(points={{-58,-10},{58,-10}}, color={0,0,127}));
  connect(conShe.y, reaValSelByModNoPre.uShe)
    annotation (Line(points={{-18,-30},{20,-30},{20,-14},{58,-14}},
      color={0,0,127}));
  connect(conReb.y, reaValSelByModNoPre.uReb)
    annotation (Line(points={{-38,-70},{40,-70},{40,-18},{58,-18}},
      color={0,0,127}));
  connect(uModHou.y[1], reaValSelByModNoPre.uMod)
    annotation (Line(points={{-58,70},{-20,70},{-20,-2},{58,-2}},
      color={255,127,0}));
annotation (experiment(StopTime=172800,Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/RealValueSelectionByMode.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode\">
Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end RealValueSelectionByMode;
