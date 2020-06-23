within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
model Down
  "Validate model for stage down conditions sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow(
    final primaryOnly=false,
    final nSta=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapNonConBoi=600,
    final delDesCapConBoi=300,
    final sigDif=0.01,
    final bypValClo=0,
    final TCirDif=3,
    final delTRetDif=300,
    final dTemp=0.1,
    final TDif=10,
    final delFaiCon=900)
    "Scenario testing sequence for condensing-type stage"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow1(
    final primaryOnly=false,
    final nSta=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapNonConBoi=600,
    final delDesCapConBoi=300,
    final sigDif=0.01,
    final bypValClo=0,
    final TCirDif=3,
    final delTRetDif=300,
    final dTemp=0.1,
    final TDif=10,
    final delFaiCon=900)
    "Scenario testing sequence for non-condensing-type stage"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow2(
    final primaryOnly=true,
    final nSta=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapConBoi=300,
    final sigDif=0.01,
    final delBypVal=300,
    final bypValClo=0,
    final TCirDif=3,
    final dTemp=0.1,
    final TDif=10,
    final delFaiCon=900)
    "Scenario testing primary-only, condensing-type boiler plant"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-170,170},{-150,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[1](
    final k={1})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul2(
    final amplitude=4,
    final period=16000,
    final offset=79.8)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-170,-110},{-150,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul3(
    final amplitude=0.3,
    final period=8000,
    final offset=0)
    "Pulse source"
    annotation (Placement(transformation(extent={{-196,-10},{-176,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul4(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,130},{-10,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[1](
    final k={2})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{-30,-150},{-10,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-30,-190},{-10,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul5(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul6(
    final amplitude=4,
    final period=16000,
    final offset=79.8)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul7(
    final amplitude=0.3,
    final period=8000,
    final offset=0)
    "Pulse source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con10(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{110,170},{130,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul8(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[1](
    final k={1})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{110,-150},{130,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{110,-190},{130,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul9(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,90},{130,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con13(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul11(
    final amplitude=0.3,
    final period=8000,
    final offset=-0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{84,-10},{104,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul10(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul12(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul13(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));

equation
  connect(con.y, staDow.THotWatSupSet) annotation (Line(points={{-148,180},{-126,
          180},{-126,9},{-122,9}}, color={0,0,127}));
  connect(pul.y, staDow.THotWatSup) annotation (Line(points={{-148,140},{-128,140},
          {-128,7},{-122,7}}, color={0,0,127}));
  connect(pul1.y, staDow.uCapReq) annotation (Line(points={{-148,100},{-130,100},
          {-130,5},{-122,5}}, color={0,0,127}));
  connect(con2.y, staDow.uCapMin) annotation (Line(points={{-148,60},{-132,60},{
          -132,3},{-122,3}}, color={0,0,127}));
  connect(pul3.y, staDow.uPumSpe) annotation (Line(points={{-174,0},{-136,0},{-136,
          -3},{-122,-3}}, color={0,0,127}));
  connect(pul2.y, staDow.TPriHotWatRet) annotation (Line(points={{-148,-60},{-134,
          -60},{-134,-7},{-122,-7}}, color={0,0,127}));
  connect(con1.y, staDow.TSecHotWatRet) annotation (Line(points={{-148,-100},{-128,
          -100},{-128,-9},{-122,-9}}, color={0,0,127}));
  connect(con5.y, staDow1.THotWatSupSet) annotation (Line(points={{-8,180},{14,180},
          {14,9},{18,9}}, color={0,0,127}));
  connect(pul4.y, staDow1.THotWatSup) annotation (Line(points={{-8,140},{12,140},
          {12,7},{18,7}}, color={0,0,127}));
  connect(pul5.y, staDow1.uCapReq) annotation (Line(points={{-8,100},{10,100},{10,
          5},{18,5}}, color={0,0,127}));
  connect(con7.y, staDow1.uCapMin)
    annotation (Line(points={{-8,60},{8,60},{8,3},{18,3}}, color={0,0,127}));
  connect(pul7.y, staDow1.uPumSpe)
    annotation (Line(points={{-38,0},{4,0},{4,-3},{18,-3}}, color={0,0,127}));
  connect(pul6.y, staDow1.TPriHotWatRet) annotation (Line(points={{-8,-60},{6,-60},
          {6,-7},{18,-7}}, color={0,0,127}));
  connect(con6.y, staDow1.TSecHotWatRet) annotation (Line(points={{-8,-100},{12,
          -100},{12,-9},{18,-9}}, color={0,0,127}));
  connect(con10.y, staDow2.THotWatSupSet) annotation (Line(points={{132,180},{154,
          180},{154,9},{158,9}}, color={0,0,127}));
  connect(pul8.y, staDow2.THotWatSup) annotation (Line(points={{132,140},{152,140},
          {152,7},{158,7}}, color={0,0,127}));
  connect(pul9.y, staDow2.uCapReq) annotation (Line(points={{132,100},{150,100},
          {150,5},{158,5}}, color={0,0,127}));
  connect(pul11.y, staDow2.uBypValPos) annotation (Line(points={{106,0},{132,0},
          {132,1},{158,1}}, color={0,0,127}));
  connect(pul10.y, staDow.uCapDowDes) annotation (Line(points={{-148,30},{-134,30},
          {-134,-1},{-122,-1}}, color={0,0,127}));
  connect(pul12.y, staDow1.uCapDowDes)
    annotation (Line(points={{-8,30},{6,30},{6,-1},{18,-1}}, color={0,0,127}));
  connect(pul13.y, staDow2.uCapDowDes) annotation (Line(points={{132,-40},{146,-40},
          {146,-1},{158,-1}}, color={0,0,127}));
  connect(con13.y, staDow2.uCapMin) annotation (Line(points={{132,60},{146,60},{
          146,3},{158,3}}, color={0,0,127}));
  connect(conInt1.y, staDow.uCur) annotation (Line(points={{-148,-180},{-117,
          -180},{-117,-12}}, color={255,127,0}));
  connect(conInt.y, staDow.uTyp) annotation (Line(points={{-148,-140},{-119,
          -140},{-119,-12}}, color={255,127,0}));
  connect(conInt2.y, staDow1.uTyp) annotation (Line(points={{-8,-140},{21,-140},
          {21,-12}}, color={255,127,0}));
  connect(conInt3.y, staDow1.uCur) annotation (Line(points={{-8,-180},{23,-180},
          {23,-12}}, color={255,127,0}));
  connect(conInt4.y, staDow2.uTyp) annotation (Line(points={{132,-140},{161,
          -140},{161,-12}}, color={255,127,0}));
  connect(conInt5.y, staDow2.uCur) annotation (Line(points={{132,-180},{163,
          -180},{163,-12}}, color={255,127,0}));
annotation (
  experiment(
      StopTime=16000,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/Down.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    May 28, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
    extent={{-200,-200},{200,200}})));
end Down;
