within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
model Down
  "Validate model for stage down conditions sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow(
    final have_priOnl=false,
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
    final delFaiCon=900,
    final boiMinPriPumSpeSta={0})
    "Scenario testing sequence for condensing-type stage"
    annotation (Placement(transformation(extent={{-120,-16},{-100,19}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow1(
    final have_priOnl=false,
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
    final delFaiCon=900,
    final boiMinPriPumSpeSta={0})
    "Scenario testing sequence for non-condensing-type stage"
    annotation (Placement(transformation(extent={{20,-16},{40,19}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow2(
    final have_priOnl=true,
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
    final delFaiCon=900,
    final boiMinPriPumSpeSta={0})
    "Scenario testing primary-only, condensing-type boiler plant"
    annotation (Placement(transformation(extent={{160,-16},{180,19}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down
    staDow3(
    final have_priOnl=true,
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
    final delFaiCon=900,
    final boiMinPriPumSpeSta={0})
    "Scenario testing primary-only, condensing-type boiler plant"
    annotation (Placement(transformation(extent={{270,-16},{290,19}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[1](
    final k={1})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{-170,160},{-150,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-170,120},{-150,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul2(
    final amplitude=4,
    final period=16000,
    final offset=79.8)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-172,-190},{-152,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{-168,-30},{-148,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul3(
    final amplitude=0.3,
    final period=8000,
    final offset=0)
    "Pulse source"
    annotation (Placement(transformation(extent={{-170,-110},{-150,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con5(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul4(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[1](
    final k={2})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{-30,160},{-10,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-30,120},{-10,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul5(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul6(
    final amplitude=4,
    final period=16000,
    final offset=79.8)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,-150},{-10,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{-30,-190},{-10,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul7(
    final amplitude=0.3,
    final period=8000,
    final offset=0)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con10(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{110,70},{130,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul8(
    final amplitude=12,
    final period=2000,
    final offset=69)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[1](
    final k={1})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{110,150},{130,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{110,110},{130,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul9(
    final amplitude=0.3,
    final period=4000,
    final offset=1.05)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con13(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul11(
    final amplitude=0.3,
    final period=8000,
    final offset=-0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,-190},{130,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul10(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{-168,-70},{-148,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul12(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul13(
    final amplitude=0.6,
    final period=16000,
    final offset=1.4)
    "Pulse source"
    annotation (Placement(transformation(extent={{110,-150},{130,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con11(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[1](
    final k={1})
    "Stage-type vector"
    annotation (Placement(transformation(extent={{220,150},{240,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{220,110},{240,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=1)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,-110},{240,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=1000,
    final shift=960)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{190,190},{210,210}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge detector"
    annotation (Placement(transformation(extent={{220,190},{240,210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    final k=80)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con14(
    final k=1.05)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,-70},{240,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con15(
    final k=1.5)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,-150},{240,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con16(
    final k=0.5)
    "Constant real source"
    annotation (Placement(transformation(extent={{220,-190},{240,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=false)
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(
    final k=false)
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{-30,190},{-10,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8(
    final k=false)
    "Constant Boolean False signal"
    annotation (Placement(transformation(extent={{110,190},{130,210}})));

equation
  connect(con.y, staDow.THotWatSupSet) annotation (Line(points={{-148,100},{-130,
          100},{-130,9},{-122,9}}, color={0,0,127}));
  connect(pul.y, staDow.THotWatSup) annotation (Line(points={{-148,60},{-134,60},
          {-134,6},{-122,6}}, color={0,0,127}));
  connect(pul1.y, staDow.uCapReq) annotation (Line(points={{-148,20},{-138,20},{
          -138,3},{-122,3}},  color={0,0,127}));
  connect(con2.y, staDow.uCapMin) annotation (Line(points={{-146,-20},{-142,-20},
          {-142,0},{-122,0}},color={0,0,127}));
  connect(pul3.y, staDow.uPumSpe) annotation (Line(points={{-148,-100},{-138,-100},
          {-138,-9},{-122,-9}},
                          color={0,0,127}));
  connect(pul2.y, staDow.TPriHotWatRet) annotation (Line(points={{-148,-140},{-134,
          -140},{-134,-12},{-122,-12}},
                                     color={0,0,127}));
  connect(con1.y, staDow.TSecHotWatRet) annotation (Line(points={{-150,-180},{-128,
          -180},{-128,-15},{-122,-15}},
                                      color={0,0,127}));
  connect(con5.y, staDow1.THotWatSupSet) annotation (Line(points={{-8,100},{8,100},
          {8,9},{18,9}},  color={0,0,127}));
  connect(pul4.y, staDow1.THotWatSup) annotation (Line(points={{-8,60},{4,60},{4,
          6},{18,6}},     color={0,0,127}));
  connect(pul5.y, staDow1.uCapReq) annotation (Line(points={{-8,20},{0,20},{0,3},
          {18,3}},    color={0,0,127}));
  connect(con7.y, staDow1.uCapMin)
    annotation (Line(points={{-10,-20},{0,-20},{0,0},{18,0}},
                                                           color={0,0,127}));
  connect(pul7.y, staDow1.uPumSpe)
    annotation (Line(points={{-8,-100},{8,-100},{8,-9},{18,-9}},
                                                            color={0,0,127}));
  connect(pul6.y, staDow1.TPriHotWatRet) annotation (Line(points={{-8,-140},{12,
          -140},{12,-12},{18,-12}},
                           color={0,0,127}));
  connect(con6.y, staDow1.TSecHotWatRet) annotation (Line(points={{-8,-180},{16,
          -180},{16,-15},{18,-15}},
                                  color={0,0,127}));
  connect(con10.y, staDow2.THotWatSupSet) annotation (Line(points={{132,80},{144,
          80},{144,9},{158,9}},  color={0,0,127}));
  connect(pul8.y, staDow2.THotWatSup) annotation (Line(points={{132,40},{140,40},
          {140,6},{158,6}}, color={0,0,127}));
  connect(pul9.y, staDow2.uCapReq) annotation (Line(points={{132,-60},{140,-60},
          {140,3},{158,3}}, color={0,0,127}));
  connect(pul11.y, staDow2.uBypValPos) annotation (Line(points={{132,-180},{154,
          -180},{154,-6},{158,-6}},
                            color={0,0,127}));
  connect(pul10.y, staDow.uCapDowDes) annotation (Line(points={{-146,-60},{-140,
          -60},{-140,-3},{-122,-3}},
                                color={0,0,127}));
  connect(pul12.y, staDow1.uCapDowDes)
    annotation (Line(points={{-8,-60},{4,-60},{4,-3},{18,-3}},
                                                             color={0,0,127}));
  connect(pul13.y, staDow2.uCapDowDes) annotation (Line(points={{132,-140},{150,
          -140},{150,-3},{158,-3}},
                              color={0,0,127}));
  connect(con13.y, staDow2.uCapMin) annotation (Line(points={{132,-100},{146,-100},
          {146,0},{158,0}},color={0,0,127}));
  connect(conInt1.y, staDow.uCur) annotation (Line(points={{-148,130},{-126,130},
          {-126,12},{-122,12}},
                             color={255,127,0}));
  connect(conInt2.y, staDow1.uTyp) annotation (Line(points={{-8,170},{14,170},{14,
          14},{18,14},{18,15}},
                     color={255,127,0}));
  connect(conInt3.y, staDow1.uCur) annotation (Line(points={{-8,130},{12,130},{12,
          12},{18,12}},
                     color={255,127,0}));
  connect(conInt4.y, staDow2.uTyp) annotation (Line(points={{132,160},{152,160},
          {152,14},{158,14},{158,15}},
                            color={255,127,0}));
  connect(conInt5.y, staDow2.uCur) annotation (Line(points={{132,120},{148,120},
          {148,12},{158,12}},
                            color={255,127,0}));
  connect(conInt.y, staDow.uTyp) annotation (Line(points={{-148,170},{-124,170},
          {-124,15},{-122,15}}, color={255,127,0}));
  connect(con3.y, staDow.uStaChaProEnd) annotation (Line(points={{-148,200},{-122,
          200},{-122,18}}, color={255,0,255}));
  connect(con4.y, staDow1.uStaChaProEnd)
    annotation (Line(points={{-8,200},{18,200},{18,18}}, color={255,0,255}));
  connect(con8.y, staDow2.uStaChaProEnd) annotation (Line(points={{132,200},{154,
          200},{154,18},{158,18}}, color={255,0,255}));
  connect(con11.y,staDow3. THotWatSupSet) annotation (Line(points={{242,80},{254,
          80},{254,9},{268,9}},  color={0,0,127}));
  connect(con12.y,staDow3. uCapMin) annotation (Line(points={{242,-100},{256,-100},
          {256,0},{268,0}},color={0,0,127}));
  connect(conInt6.y,staDow3. uTyp) annotation (Line(points={{242,160},{262,160},
          {262,14},{268,14},{268,15}},
                            color={255,127,0}));
  connect(conInt7.y,staDow3. uCur) annotation (Line(points={{242,120},{258,120},
          {258,12},{268,12}},
                            color={255,127,0}));
  connect(booPul.y, edg.u)
    annotation (Line(points={{212,200},{218,200}}, color={255,0,255}));
  connect(edg.y, staDow3.uStaChaProEnd) annotation (Line(points={{242,200},{264,
          200},{264,18},{268,18}}, color={255,0,255}));
  connect(con9.y, staDow3.THotWatSup) annotation (Line(points={{242,40},{248,40},
          {248,6},{268,6}}, color={0,0,127}));
  connect(con14.y, staDow3.uCapReq) annotation (Line(points={{242,-60},{248,-60},
          {248,3},{268,3}}, color={0,0,127}));
  connect(con15.y, staDow3.uCapDowDes) annotation (Line(points={{242,-140},{260,
          -140},{260,-3},{268,-3}}, color={0,0,127}));
  connect(con16.y, staDow3.uBypValPos) annotation (Line(points={{242,-180},{264,
          -180},{264,-6},{268,-6}}, color={0,0,127}));
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
    extent={{-200,-200},{300,220}})));
end Down;
