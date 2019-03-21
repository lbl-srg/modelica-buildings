within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model IdentifyStage "Validation sequence for identifying current stage"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage
    noWSEnoPon(
    final nChi=3,
    final haveWSE=false)
    "Identify current stage of plant without waterside economizer and no pony chiller"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage
    noWSEPon(
    final nChi=3,
    final haveWSE=false,
    final havePony=true,
    final nSta=4,
    final ponChiFlg={true,false,false},
    final ponChiCou={0,1,0,0},
    final regChiCou={0,0,1,2})
    "Identify current stage of plant without waterside economizer, with pony chiller"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.IdentifyStage
    WSEPon(
    final nChi=3,
    final haveWSE=true,
    final havePony=true,
    final nSta=4,
    final ponChiFlg={true,false,false},
    final ponChiCou={0,1,0,0},
    final regChiCou={0,0,1,2})
    "Identify current stage of plant with waterside economizer, with pony chiller"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiTwo(
    final width=0.75,
    final period=2,
    final startTime=0.5) "Chiller two status"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiOne(
    final period=2) "Chiller one status"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiThr(
    final k=true) "Chiller three status"
    annotation (Placement(transformation(extent={{-82,90},{-62,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiOne1(
    final width=0.1,
    final period=4) "Chiller one status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiThr1(
    final period=3,
    final startTime=0.5)
    "Chiller three status"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uWSE(
    final width=0.5,
    final period=3)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

equation
  connect(chiOne.y, noWSEnoPon.uChi[1])
    annotation (Line(points={{-59,60},{-30,60},{-30,82.6667},{18,82.6667}},
      color={255,0,255}));
  connect(chiTwo.y, noWSEnoPon.uChi[2])
    annotation (Line(points={{-59,20},{-40,20},{-40,84},{18,84}}, color={255,0,255}));
  connect(chiThr.y, noWSEnoPon.uChi[3])
    annotation (Line(points={{-61,100},{-40,100},{-40,85.3333},{18,85.3333}},
      color={255,0,255}));
  connect(chiTwo.y, noWSEPon.uChi[2])
    annotation (Line(points={{-59,20},{-40,20},{-40,24},{18,24}}, color={255,0,255}));
  connect(chiOne1.y, noWSEPon.uChi[1])
    annotation (Line(points={{-59,-100},{-20,-100},{-20,22.6667},{18,22.6667}},
      color={255,0,255}));
  connect(chiThr1.y, noWSEPon.uChi[3])
    annotation (Line(points={{-59,-60},{-30,-60},{-30,25.3333},{18,25.3333}},
      color={255,0,255}));
  connect(chiTwo.y, WSEPon.uChi[2])
    annotation (Line(points={{-59,20},{-40,20},{-40,-36},{18,-36}}, color={255,0,255}));
  connect(chiThr1.y, WSEPon.uChi[3])
    annotation (Line(points={{-59,-60},{-30,-60},{-30,-34.6667},{18,-34.6667}},
      color={255,0,255}));
  connect(chiOne1.y, WSEPon.uChi[1])
    annotation (Line(points={{-59,-100},{-20,-100},{-20,-37.3333},{18,-37.3333}},
      color={255,0,255}));
  connect(uWSE.y, WSEPon.uWSE)
    annotation (Line(points={{-59,-20},{0,-20},{0,-24},{18,-24}}, color={255,0,255}));

annotation (
  experiment(StopTime=3.0, Tolerance=1e-06),
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
March 20, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}}),
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
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end IdentifyStage;
