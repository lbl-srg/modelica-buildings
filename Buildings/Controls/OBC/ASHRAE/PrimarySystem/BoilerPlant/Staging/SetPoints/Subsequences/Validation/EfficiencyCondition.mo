within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
block EfficiencyCondition
  "Validation model for EfficiencyCondition"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
    effCon(
    final nSta=1,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final sigDif=0.1,
    final delCapReq=600)
    "Testing efficiency condition for condensing boiler stage type"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
    effCon1(
    final nSta=1,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final sigDif=0.1,
    final delCapReq=600)
    "Testing efficiency condition for non-condensing boiler stage type"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
    effCon2(
    final nSta=1,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final sigDif=0.1,
    final delCapReq=600)
    "Testing efficiency condition for non-condensing boiler stage type with timer reset"
    annotation (Placement(transformation(extent={{250,-10},{270,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=1.2*0.1,
    final period=2.5*600,
    final offset=1.5 - 1.1*0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul3(
    final amplitude=1.2*0.1,
    final period=5*600,
    final offset=1 - 1.1*0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp[1](
    final k={1})
    "Constant source"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final amplitude=1.2*0.1,
    final period=2.5*600,
    final offset=0.9 - 1.1*0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul2(
    final amplitude=1.2*0.1,
    final period=5*600,
    final offset=1 - 1.1*0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp1[1](
    final k={2})
    "Constant source"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{10,-130},{30,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con5(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp2[1](
    final k={2})
    "Constant source"
    annotation (Placement(transformation(extent={{150,-90},{170,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{150,70},{170,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=1000,
    final shift=960)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{150,-170},{170,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge detector"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con11(
    final k=1.6)
    "Constant source"
    annotation (Placement(transformation(extent={{150,110},{170,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=1.1)
    "Constant source"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));

equation
  connect(conIntp.y, effCon.uTyp)
    annotation (Line(points={{-108,-80},{-50,-80},{-50,-6},{-32,-6}},
      color={255,127,0}));
  connect(pul3.y, effCon.VHotWat_flow)
    annotation (Line(points={{-108,0},{-70,0},{-70,0},{-32,0}},
      color={0,0,127}));
  connect(pul.y, effCon.uCapReq)
    annotation (Line(points={{-108,120},{-40,120},{-40,9},{-32,9}},
      color={0,0,127}));
  connect(con.y, effCon.uCapDes)
    annotation (Line(points={{-108,80},{-50,80},{-50,6},{-32,6}},
      color={0,0,127}));
  connect(con1.y, effCon.uCapUpMin)
    annotation (Line(points={{-108,40},{-60,40},{-60,3},{-32,3}},
      color={0,0,127}));
  connect(conIntp1.y, effCon1.uTyp)
    annotation (Line(points={{32,-80},{90,-80},{90,-6},{108,-6}},
      color={255,127,0}));
  connect(pul2.y, effCon1.VHotWat_flow)
    annotation (Line(points={{32,0},{72,0},{72,0},{108,0}},
      color={0,0,127}));
  connect(pul1.y, effCon1.uCapReq)
    annotation (Line(points={{32,120},{100,120},{100,9},{108,9}},
      color={0,0,127}));
  connect(con2.y, effCon1.uCapDes)
    annotation (Line(points={{32,80},{90,80},{90,6},{108,6}},
      color={0,0,127}));
  connect(con3.y, effCon1.uCapUpMin)
    annotation (Line(points={{32,40},{80,40},{80,3},{108,3}},
      color={0,0,127}));
  connect(conInt.y, effCon.uAvaUp)
    annotation (Line(points={{-108,-120},{-40,-120},{-40,-9},{-32,-9}},
      color={255,127,0}));
  connect(conInt1.y, effCon1.uAvaUp)
    annotation (Line(points={{32,-120},{100,-120},{100,-9},{108,-9}},
      color={255,127,0}));
  connect(con4.y, effCon.VUpMinSet_flow)
    annotation (Line(points={{-108,-40},{-60,-40},{-60,-3},{-32,-3}},
      color={0,0,127}));
  connect(con5.y, effCon1.VUpMinSet_flow)
    annotation (Line(points={{32,-40},{80,-40},{80,-3},{108,-3}},
      color={0,0,127}));
  connect(conIntp2.y,effCon2. uTyp)
    annotation (Line(points={{172,-80},{230,-80},{230,-6},{248,-6}},
      color={255,127,0}));
  connect(con6.y,effCon2. uCapDes)
    annotation (Line(points={{172,80},{230,80},{230,6},{248,6}},
      color={0,0,127}));
  connect(con7.y,effCon2. uCapUpMin)
    annotation (Line(points={{172,40},{220,40},{220,3},{248,3}},
      color={0,0,127}));
  connect(conInt2.y,effCon2. uAvaUp)
    annotation (Line(points={{172,-120},{240,-120},{240,-9},{248,-9}},
      color={255,127,0}));
  connect(con8.y,effCon2. VUpMinSet_flow)
    annotation (Line(points={{172,-40},{220,-40},{220,-3},{248,-3}},
      color={0,0,127}));
  connect(con9.y, effCon.uStaChaProEnd) annotation (Line(points={{-108,-160},{-29,
          -160},{-29,-12}}, color={255,0,255}));
  connect(con10.y, effCon1.uStaChaProEnd) annotation (Line(points={{32,-160},{111,
          -160},{111,-12}}, color={255,0,255}));
  connect(booPul.y, edg.u)
    annotation (Line(points={{172,-160},{178,-160}}, color={255,0,255}));
  connect(edg.y, effCon2.uStaChaProEnd) annotation (Line(points={{202,-160},{251,
          -160},{251,-12}}, color={255,0,255}));
  connect(con11.y, effCon2.uCapReq) annotation (Line(points={{172,120},{240,120},
          {240,9},{248,9}}, color={0,0,127}));
  connect(con12.y, effCon2.VHotWat_flow)
    annotation (Line(points={{172,0},{248,0}}, color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false,
                                   extent={{-100,-100},{100,100}}),
             graphics={Ellipse(lineColor = {75,138,73},
                               fillColor={255,255,255},
                               fillPattern = FillPattern.Solid,
                               extent={{-100,-100},{100,100}}),
                       Polygon(lineColor = {0,0,255},
                               fillColor = {75,138,73},
                               pattern = LinePattern.None,
                               fillPattern = FillPattern.Solid,
                               points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
                             extent={{-140,-180},{280,140}})),
    experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-6),
    __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/EfficiencyCondition.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition</a>
      </p>
      </html>",
      revisions="<html>
      <ul>
      <li>
      May 21, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end EfficiencyCondition;
