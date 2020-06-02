within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Validation;
model Up
  "Validate model for stage up conditions sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Up
    staUp(
    final nSta=2,
    final perNonConBoi=0.9,
    final perConBoi=1.5,
    final sigDif=0.1,
    final samPerEffCon=10*60,
    final samPerFaiCon=900,
    final TDif=10,
    final TDifHys=1)
    "Scenario testing activation by efficiency condition"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Up
    staUp1(
    final nSta=2,
    final perNonConBoi=0.9,
    final perConBoi=1.5,
    final sigDif=0.1,
    final samPerEffCon=600,
    final samPerFaiCon=900,
    final TDif=10,
    final TDifHys=1)
    "Scenario testing activation by failsafe condition"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Up
    staUp2(
    final nSta=2,
    final perNonConBoi=0.9,
    final perConBoi=1.5,
    final sigDif=0.1,
    final samPerEffCon=600,
    final samPerFaiCon=900,
    final TDif=10,
    final TDifHys=1)
    "Scenario testing activation due to current stage unavailability"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6(
    final k=true)
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7(
    final k=true)
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=600)
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul3(
    final amplitude=1.2*0.1,
    final period=5*10*60,
    final offset=1 - 1.1*0.1)
    "Pulse source"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp[2](
    final k={1,1})
    "Constant source"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Constant source"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=1.6)
    "Constant source"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
    final k=82)
    "Constant input"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con10(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp1[2](
    final k={1,1})
    "Constant source"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con12(
    final k=1.3)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,170},{-30,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con15(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con16(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con17(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp2[2](
    final k={1,1})
    "Constant source"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2)
    "Constant source"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con18(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con19(
    final k=1.3)
    "Constant source"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con20(
    final k=82)
    "Constant input"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con21(
    final k=1.1)
    "Constant source"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con13(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final amplitude=-11.2,
    final period=2.5*900,
    final offset=81.1)
    "Pulse input"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con11(
    final k=1.1)
    "Constant source"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

equation
  connect(staUp.uQDes, con.y) annotation (Line(points={{-102,7},{-114,7},{-114,140},
          {-158,140}}, color={0,0,127}));
  connect(con1.y, staUp.uQUpMin) annotation (Line(points={{-158,100},{-120,100},
          {-120,5},{-102,5}}, color={0,0,127}));
  connect(pul3.y, staUp.uHotWatFloRat) annotation (Line(points={{-158,60},{-126,
          60},{-126,3},{-102,3}}, color={0,0,127}));
  connect(con4.y, staUp.uUpMinFloSet) annotation (Line(points={{-158,20},{-132,20},
          {-132,1},{-102,1}}, color={0,0,127}));
  connect(conIntp.y, staUp.uTyp) annotation (Line(points={{-158,-20},{-132,-20},
          {-132,-1},{-102,-1}}, color={255,127,0}));
  connect(conInt.y, staUp.uAvaUp) annotation (Line(points={{-158,-60},{-126,-60},
          {-126,-3},{-102,-3}}, color={255,127,0}));
  connect(con2.y, staUp.THotWatSupSet) annotation (Line(points={{-158,-100},{-120,
          -100},{-120,-5},{-102,-5}}, color={0,0,127}));
  connect(con3.y, staUp.uQReq) annotation (Line(points={{-158,180},{-110,180},{-110,
          9},{-102,9}}, color={0,0,127}));
  connect(con5.y, staUp.THotWatSup) annotation (Line(points={{-158,-140},{-114,-140},
          {-114,-7},{-102,-7}}, color={0,0,127}));
  connect(con6.y, staUp.uAvaCur) annotation (Line(points={{-158,-180},{-110,-180},
          {-110,-9},{-102,-9}}, color={255,0,255}));
  connect(staUp1.uQDes, con8.y) annotation (Line(points={{28,7},{16,7},{16,140},
          {-28,140}}, color={0,0,127}));
  connect(con9.y, staUp1.uQUpMin) annotation (Line(points={{-28,100},{10,100},{10,
          5},{28,5}}, color={0,0,127}));
  connect(con10.y, staUp1.uUpMinFloSet) annotation (Line(points={{-28,20},{-2,20},
          {-2,1},{28,1}}, color={0,0,127}));
  connect(conIntp1.y, staUp1.uTyp) annotation (Line(points={{-28,-20},{-2,-20},{
          -2,-1},{28,-1}}, color={255,127,0}));
  connect(conInt1.y, staUp1.uAvaUp) annotation (Line(points={{-28,-60},{4,-60},{
          4,-3},{28,-3}}, color={255,127,0}));
  connect(con12.y, staUp1.uQReq) annotation (Line(points={{-28,180},{20,180},{20,
          9},{28,9}}, color={0,0,127}));
  connect(con7.y, staUp1.uAvaCur) annotation (Line(points={{-28,-180},{20,-180},
          {20,-9},{28,-9}}, color={255,0,255}));
  connect(staUp2.uQDes, con15.y) annotation (Line(points={{158,7},{146,7},{146,140},
          {102,140}}, color={0,0,127}));
  connect(con16.y, staUp2.uQUpMin) annotation (Line(points={{102,100},{140,100},
          {140,5},{158,5}}, color={0,0,127}));
  connect(con17.y, staUp2.uUpMinFloSet) annotation (Line(points={{102,20},{128,20},
          {128,1},{158,1}}, color={0,0,127}));
  connect(conIntp2.y, staUp2.uTyp) annotation (Line(points={{102,-20},{128,-20},
          {128,-1},{158,-1}}, color={255,127,0}));
  connect(conInt2.y, staUp2.uAvaUp) annotation (Line(points={{102,-60},{134,-60},
          {134,-3},{158,-3}}, color={255,127,0}));
  connect(con18.y, staUp2.THotWatSupSet) annotation (Line(points={{102,-100},{140,
          -100},{140,-5},{158,-5}}, color={0,0,127}));
  connect(con19.y, staUp2.uQReq) annotation (Line(points={{102,180},{150,180},{150,
          9},{158,9}}, color={0,0,127}));
  connect(con20.y, staUp2.THotWatSup) annotation (Line(points={{102,-140},{146,-140},
          {146,-7},{158,-7}}, color={0,0,127}));
  connect(con21.y, staUp1.uHotWatFloRat)
    annotation (Line(points={{-28,60},{4,60},{4,3},{28,3}}, color={0,0,127}));
  connect(con13.y, staUp1.THotWatSupSet) annotation (Line(points={{-28,-100},{10,
          -100},{10,-5},{28,-5}}, color={0,0,127}));
  connect(pul.y, staUp1.THotWatSup) annotation (Line(points={{-28,-140},{16,-140},
          {16,-7},{28,-7}}, color={0,0,127}));
  connect(con11.y, staUp2.uHotWatFloRat) annotation (Line(points={{102,60},{134,
          60},{134,3},{158,3}}, color={0,0,127}));
  connect(booPul.y, staUp2.uAvaCur) annotation (Line(points={{102,-180},{150,-180},
          {150,-9},{158,-9}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Up\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Up</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    May 26, 2020, by Karthik Devaprasad:<br/>
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
end Up;
