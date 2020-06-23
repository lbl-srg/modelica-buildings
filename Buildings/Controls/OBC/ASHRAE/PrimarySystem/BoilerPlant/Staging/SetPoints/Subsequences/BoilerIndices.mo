within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Validation;
model BoilerIndices
  "Validates extraction of boiler indices in a given stage"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd(
    final nSta=3,
    final nBoi=2,
    final staMat={{1,0},{0,1},{1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd1(
    final nSta=3,
    final nBoi=2,
    final staMat={{1,0},{0,1},{1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd2(
    final nSta=3,
    final nBoi=2,
    final staMat={{1,0},{0,1},{1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd3(
    final nSta=3,
    final nBoi=2,
    final staMat={{1,0},{0,1},{1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd4(
    final nSta=5,
    final nBoi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd5(
    final nSta=5,
    final nBoi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd6(
    final nSta=5,
    final nBoi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices
    boiInd7(
    final nSta=5,
    final nBoi=3,
    final staMat={{1,0,0},{1,1,0},{1,0,1},{0,1,1},{1,1,1}})
    "Boiler index generator"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u(
    final k=0)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u1(
    final k=1)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u2(
    final k=2)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u3(
    final k=3)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u4(
    final k=5)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(u.y, boiInd.u)
    annotation (Line(points={{-38,90},{-2,90}}, color={255,127,0}));
  connect(u1.y, boiInd1.u)
    annotation (Line(points={{-38,50},{-2,50}}, color={255,127,0}));
  connect(u2.y, boiInd2.u)
    annotation (Line(points={{-38,10},{-2,10}}, color={255,127,0}));
  connect(u3.y, boiInd3.u)
    annotation (Line(points={{-38,-30},{-2,-30}}, color={255,127,0}));
  connect(boiInd4.u, u.y) annotation (Line(points={{38,70},{-20,70},{-20,90},{-38,
          90}}, color={255,127,0}));
  connect(boiInd5.u, u1.y) annotation (Line(points={{38,30},{-20,30},{-20,50},{-38,
          50}}, color={255,127,0}));
  connect(boiInd6.u, u3.y) annotation (Line(points={{38,-50},{-20,-50},{-20,-30},
          {-38,-30}}, color={255,127,0}));
  connect(boiInd7.u, u4.y) annotation (Line(points={{38,-90},{-20,-90},{-20,-70},
          {-38,-70}}, color={255,127,0}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Subsequences/Validation/BoilerIndices.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.BoilerIndices</a>.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 31, 2020, by Karthik Devaprasad:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-80,-120},{80,120}})));
end BoilerIndices;
