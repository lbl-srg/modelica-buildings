within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model ChillerIndices_u
  "Validates extraction of chiller indices in a given stage"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd(
    final nSta=3,
    final nChi=2,
    staMat={{1,0},{0,1},{1,1}})
    "Setup with two chillers and three stages"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd1(
    final nSta=3,
    final nChi=2,
    staMat={{1,0},{0,1},{1,1}})
    "Setup with two chillers and three stages"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd2(
    final nSta=3,
    final nChi=2,
    staMat={{1,0},{0,1},{1,1}})
    "Setup with two chillers and three stages"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd4(
    final nSta=5,
    final nChi=3,
    staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Setup with three chillers and five stages"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd5(
    final nSta=5,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Setup with three chillers and five stages"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd6(
    final nSta=5,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Setup with three chillers and five stages"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd7(
    final nSta=5,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Setup with three chillers and five stages"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices chiInd3
    "Setup with default settings that is two chillers and three stages"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u3(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u4(final k=5)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(u.y, chiInd.u)
    annotation (Line(points={{-38,90},{-2,90}}, color={255,127,0}));
  connect(u1.y, chiInd1.u)
    annotation (Line(points={{-38,50},{-2,50}}, color={255,127,0}));
  connect(u2.y, chiInd2.u)
    annotation (Line(points={{-38,10},{-2,10}}, color={255,127,0}));
  connect(u3.y, chiInd3.u)
    annotation (Line(points={{-38,-30},{-2,-30}}, color={255,127,0}));
  connect(u.y, chiInd4.u) annotation (Line(points={{-38,90},{-20,90},{-20,70},{
          38,70}}, color={255,127,0}));
  connect(u1.y, chiInd5.u) annotation (Line(points={{-38,50},{-20,50},{-20,30},
          {38,30}}, color={255,127,0}));
  connect(u3.y, chiInd6.u) annotation (Line(points={{-38,-30},{-20,-30},{-20,-50},
          {38,-50}}, color={255,127,0}));
  connect(u4.y,chiInd7. u) annotation (Line(points={{-38,-70},{0,-70},{0,-90},{38,
          -90}}, color={255,127,0}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/ChillerIndices_u.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.ChillerIndices</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-80,-120},{80,120}})));
end ChillerIndices_u;
