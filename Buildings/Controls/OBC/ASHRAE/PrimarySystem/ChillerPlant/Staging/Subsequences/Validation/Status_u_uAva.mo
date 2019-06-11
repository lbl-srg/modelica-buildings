within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Status_u_uAva "Validates chiller stage status model"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    nSta=4,
    nChi=3,
    staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}}) "Chiller stage status"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta1(
    nSta=4,
    nChi=3,
    staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}}) "Chiller stage status"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta2(
    nSta=4,
    nChi=3,
    staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}}) "Chiller stage status"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta3(
    nSta=4,
    nChi=3,
    staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}}) "Chiller stage status"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u1(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u2(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u3(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava[4](
    final k={true,true,true,true}) "Stage availability array"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava1[4](
    final k={true,true,true,true}) "Stage availability array"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava2[4](
    final k={true,false,true,false}) "Stage availability array"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava3[4](
    final k={true,false,true,false}) "Stage availability array"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

equation
  connect(ava.y, sta.uAva) annotation (Line(points={{-119,60},{-80,60},{-80,46},
          {-42,46}}, color={255,0,255}));
  connect(u.y, sta.u) annotation (Line(points={{-119,20},{-80,20},{-80,34},{-42,
          34}}, color={255,127,0}));
  connect(ava1.y, sta1.uAva) annotation (Line(points={{-119,-20},{-80,-20},{-80,
          -34},{-42,-34}}, color={255,0,255}));
  connect(u1.y, sta1.u) annotation (Line(points={{-119,-60},{-80,-60},{-80,-46},
          {-42,-46}}, color={255,127,0}));
  connect(ava2.y, sta2.uAva) annotation (Line(points={{41,60},{80,60},{80,46},{118,
          46}}, color={255,0,255}));
  connect(u2.y, sta2.u) annotation (Line(points={{41,20},{80,20},{80,34},{118,34}},
                 color={255,127,0}));
  connect(ava3.y, sta3.uAva) annotation (Line(points={{41,-20},{80,-20},{80,-34},
          {118,-34}}, color={255,0,255}));
  connect(u3.y, sta3.u) annotation (Line(points={{41,-60},{80,-60},{80,-46},{118,
          -46}},color={255,127,0}));
annotation (
 experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Status_u_uAva.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Status</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end Status_u_uAva;
