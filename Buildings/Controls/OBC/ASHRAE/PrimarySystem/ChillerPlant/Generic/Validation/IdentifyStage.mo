within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model IdentifyStage "Validation identifying stage index"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage ideSta
    "Idendify stage index"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage ideSta1(
    nChi=3,
    staMat=[1,0,0; 1,1,0; 1,1,1]) "Idendify stage index"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi1(
    final width=0.5,
    final period=5)
    "Chiller one status"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi2(
    final width=0.7,
    final period=5)
    "Chiller two status"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chi3(
    final width=0.9,
    final period=5) "Chiller three status"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(chi1.y, ideSta.uChi[1]) annotation (Line(points={{-38,60},{-20,60},{-20,
          40},{38,40}}, color={255,0,255}));
  connect(chi2.y, ideSta.uChi[2]) annotation (Line(points={{-38,20},{-10,20},{-10,
          40},{38,40}}, color={255,0,255}));
  connect(chi3.y, not1.u)
    annotation (Line(points={{-38,-60},{-2,-60}}, color={255,0,255}));
  connect(chi1.y, not3.u) annotation (Line(points={{-38,60},{-20,60},{-20,0},{-2,
          0}}, color={255,0,255}));
  connect(chi2.y, not2.u) annotation (Line(points={{-38,20},{-10,20},{-10,-30},{
          -2,-30}}, color={255,0,255}));
  connect(not3.y, ideSta1.uChi[1]) annotation (Line(points={{22,0},{30,0},{30,
          -30.6667},{38,-30.6667}},
                          color={255,0,255}));
  connect(not2.y, ideSta1.uChi[2])
    annotation (Line(points={{22,-30},{38,-30}}, color={255,0,255}));
  connect(not1.y, ideSta1.uChi[3]) annotation (Line(points={{22,-60},{30,-60},{
          30,-29.3333},{38,-29.3333}},
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
</p>
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
