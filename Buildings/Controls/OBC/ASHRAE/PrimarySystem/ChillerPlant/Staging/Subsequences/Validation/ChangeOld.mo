within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model ChangeOld "Validate chiller stage change"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    amplitude=6,
    freqHz=1/(24*3600),
    offset=293.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-240,190},{-220,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.ChangeOld
    upZerToOne(
    chiOnHou=5,
    chiOffHou=22,
    TLocChi=288.71) "Stage from zero to one"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp PLR(
    height=1,
    offset=0,
    duration=36000,
    startTime=0)  "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conWatRetTem(
    amplitude=5,
    offset=303.15,
    freqHz=1/14400) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatSupTem(
    amplitude=2,
    offset=280.15,
    freqHz=1/14400) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatPlaRes(
    height=1,
    offset=0,
    duration=28800,
    startTime=18000) "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.ChangeOld
    upOneToTwo(
    chiOffHou=22,
    chiOnHou=0,
    TLocChi=288.71)
    "Stage from one to two: based on accutual partial load ratio greater than staging ratio"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1) "Chiller plant request"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.ChangeOld
    upOneToTwo1(
    chiOffHou=22,
    chiOnHou=0,
    TLocChi=288.71)
    "Stage from one to two: based on full plant reset (=1) and larger partial load ratio"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatPlaRes1(
    height=1,
    offset=0,
    startTime=10000,
    duration=5000)   "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(nin=1)
    "Number of running chiller, current chiller stage"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr
    "No running chiller, stage 0"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[2](
    k={false,false})  "Constant boolean value"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[2]
    "Logical switch: stage 0 or other stages"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=1)
    "One running chiller, stage 1"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Check if it is stage one"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[2]
    "Logical switch: stage 1 or stage 2"
    annotation (Placement(transformation(extent={{98,-160},{118,-140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    k={true,false}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[2](
    k={true,true}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt1(nin=1)
    "Number of running chiller, current chiller stage"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr1
    "No running chiller, stage 0"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[2](
    k={false,false})
    "Constant boolean value"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[2]
    "Logical switch: stage 0 or other stages"
    annotation (Placement(transformation(extent={{180,-30},{200,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=1)
    "One running chiller, stage 1"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Check if it is stage one"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[2]
    "Logical switch: stage 1 or stage 2"
    annotation (Placement(transformation(extent={{98,-30},{118,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[2](
    k={true,false}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7[2](
    k={true,true}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt2(nin=1)
    "Number of running chiller, current chiller stage"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr2
    "No running chiller, stage 0"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[2](
    k={false,false})
    "Constant boolean value"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4[2]
    "Logical switch: stage 0 or other stages"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(k=1)
    "One running chiller, stage 1"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2 "Check if it is stage one"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi5[2]
    "Logical switch: stage 1 or stage 2"
    annotation (Placement(transformation(extent={{98,110},{118,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep5(nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8[2](
    k={true,false}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[2](
    k={true,true}) "Constant boolean value"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    amplitude=0.55,
    width=0.8,
    period=36000,
    offset=0.45)
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(nin=2)
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp PLR1(
    duration=36000,
    startTime=0,
    height=0.35,
    offset=0.65)  "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable  timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0; 21600,1; 25200,2; 28800,3; 32400,4; 36000,5])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));

equation
  connect(outTem.y, upZerToOne.TOut)
          annotation (Line(points={{-219,200},{-108,200},{-108,129},{-101,129}},
          color={0,0,127}));
  connect(PLR.y, upZerToOne.uPLR)
          annotation (Line(points={{-179,180},{-116,180},{-116,126},{-101,126}},
          color={0,0,127}));
  connect(conWatRetTem.y, upZerToOne.TConWatRet)
          annotation (Line(points={{-219,160},{-124,160},{-124,123},{-101,123}},
          color={0,0,127}));
  connect(chiWatSupTem.y, upZerToOne.TChiWatSup)
          annotation (Line(points={{-179,140},{-132,140},{-132,120},{-101,120}},
          color={0,0,127}));
  connect(chiWatPlaRes.y, upZerToOne.uChiWatPlaRes)
          annotation (Line(points={{-219,120},{-140,120},{-140,117},{-101,117}},
          color={0,0,127}));
  connect(reaToInt.y, upZerToOne.TChiWatSupResReq)
          annotation (Line(points={{-179,90},{-148,90},{-148,114},{-101,114}},
          color={255,127,0}));
  connect(outTem.y, upOneToTwo.TOut)
          annotation (Line(points={{-219,200},{-108,200},{-108,-11},{-101,-11}},
          color={0,0,127}));
  connect(conWatRetTem.y, upOneToTwo.TConWatRet)
          annotation (Line(points={{-219,160},{-124,160},{-124,-17},{-101,-17}},
          color={0,0,127}));
  connect(chiWatSupTem.y, upOneToTwo.TChiWatSup)
          annotation (Line(points={{-179,140},{-132,140},{-132,-20},{-101,-20}},
          color={0,0,127}));
  connect(chiWatPlaRes.y, upOneToTwo.uChiWatPlaRes)
          annotation (Line(points={{-219,120},{-140,120},{-140,-23},{-101,-23}},
          color={0,0,127}));
  connect(conInt.y, upOneToTwo.TChiWatSupResReq)
          annotation (Line(points={{-179,-40},{-148,-40},{-148,-26},{-101,-26}},
          color={255,127,0}));
  connect(outTem.y, upOneToTwo1.TOut)
          annotation (Line(points={{-219,200},{-108,200},{-108,-141},{-101,-141}},
          color={0,0,127}));
  connect(conWatRetTem.y, upOneToTwo1.TConWatRet)
          annotation (Line(points={{-219,160},{-124,160},{-124,-147},{-101,-147}},
          color={0,0,127}));
  connect(chiWatSupTem.y, upOneToTwo1.TChiWatSup)
          annotation (Line(points={{-179,140},{-132,140},{-132,-150},{-101,-150}},
          color={0,0,127}));
  connect(chiWatPlaRes1.y, upOneToTwo1.uChiWatPlaRes)
          annotation (Line(points={{-219,-150},{-140,-150},{-140,-153},{-101,-153}},
          color={0,0,127}));
  connect(conInt.y, upOneToTwo1.TChiWatSupResReq)
          annotation (Line(points={{-179,-40},{-148,-40},{-148,-156},{-101,-156}},
          color={255,127,0}));
  connect(upOneToTwo1.yChiSta, mulSumInt.u[1])
          annotation (Line(points={{-79,-150},{-62,-150}}, color={255,127,0}));
  connect(mulSumInt.y, intLesEquThr.u)
          annotation (Line(points={{-38.3,-150},{-20,-150},{-20,-200},{78,-200}},
          color={255,127,0}));
  connect(con2.y, logSwi.u1)
          annotation (Line(points={{141,-120},{160,-120},{160,-142},{178,-142}},
          color={255,0,255}));
  connect(mulSumInt.y, intEqu.u1)
          annotation (Line(points={{-38.3,-150},{-2,-150}}, color={255,127,0}));
  connect(conInt1.y, intEqu.u2)
          annotation (Line(points={{-39,-120},{-10,-120},{-10,-158},{-2,-158}},
          color={255,127,0}));
  connect(intLesEquThr.y, booRep.u)
          annotation (Line(points={{101,-200},{118,-200}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2)
          annotation (Line(points={{141,-200},{160,-200},{160,-150},{178,-150}},
          color={255,0,255}));
  connect(intEqu.y, booRep1.u)
          annotation (Line(points={{21,-150},{38,-150}}, color={255,0,255}));
  connect(booRep1.y, logSwi1.u2)
          annotation (Line(points={{61,-150},{96,-150}}, color={255,0,255}));
  connect(con3.y, logSwi1.u1)
          annotation (Line(points={{41,-120},{80,-120},{80,-142},{96,-142}},
          color={255,0,255}));
  connect(con4.y, logSwi1.u3)
          annotation (Line(points={{41,-180},{80,-180},{80,-158},{96,-158}},
          color={255,0,255}));
  connect(logSwi1.y, logSwi.u3)
          annotation (Line(points={{119,-150},{140,-150},{140,-158},{178,-158}},
          color={255,0,255}));
  connect(logSwi.y, upOneToTwo1.uChi)
          annotation (Line(points={{201,-150},{220,-150},{220,-220},{-160,-220},
          {-160,-159},{-101,-159}}, color={255,0,255}));
  connect(mulSumInt1.y, intLesEquThr1.u)
          annotation (Line(points={{-38.3,-20},{-20,-20},{-20,-70},{78,-70}},
          color={255,127,0}));
  connect(con5.y, logSwi2.u1)
          annotation (Line(points={{141,10},{160,10},{160,-12},{178,-12}},
          color={255,0,255}));
  connect(mulSumInt1.y, intEqu1.u1)
          annotation (Line(points={{-38.3,-20},{-2,-20}}, color={255,127,0}));
  connect(conInt2.y, intEqu1.u2)
          annotation (Line(points={{-39,10},{-10,10},{-10,-28},{-2,-28}},
          color={255,127,0}));
  connect(intLesEquThr1.y, booRep2.u)
          annotation (Line(points={{101,-70},{118,-70}}, color={255,0,255}));
  connect(booRep2.y, logSwi2.u2)
          annotation (Line(points={{141,-70},{160,-70},{160,-20},{178,-20}},
          color={255,0,255}));
  connect(intEqu1.y, booRep3.u)
          annotation (Line(points={{21,-20},{38,-20}}, color={255,0,255}));
  connect(booRep3.y, logSwi3.u2)
          annotation (Line(points={{61,-20},{96,-20}}, color={255,0,255}));
  connect(con6.y, logSwi3.u1)
          annotation (Line(points={{41,10},{80,10},{80,-12},{96,-12}},
          color={255,0,255}));
  connect(con7.y, logSwi3.u3)
          annotation (Line(points={{41,-50},{80,-50},{80,-28},{96,-28}},
          color={255,0,255}));
  connect(logSwi3.y, logSwi2.u3)
          annotation (Line(points={{119,-20},{140,-20},{140,-28},{178,-28}},
          color={255,0,255}));
  connect(upOneToTwo.yChiSta, mulSumInt1.u[1])
          annotation (Line(points={{-79,-20},{-62,-20}}, color={255,127,0}));
  connect(logSwi2.y, upOneToTwo.uChi)
          annotation (Line(points={{201,-20},{220,-20},{220,-90},{-160,-90},
          {-160,-29},{-101,-29}}, color={255,0,255}));
  connect(mulSumInt2.y, intLesEquThr2.u)
          annotation (Line(points={{-38.3,120},{-20,120},{-20,70},{78,70}},
          color={255,127,0}));
  connect(con1.y, logSwi4.u1)
          annotation (Line(points={{141,150},{160,150},{160,128},{178,128}},
          color={255,0,255}));
  connect(mulSumInt2.y, intEqu2.u1)
          annotation (Line(points={{-38.3,120},{-2,120}}, color={255,127,0}));
  connect(conInt3.y, intEqu2.u2)
          annotation (Line(points={{-39,150},{-10,150},{-10,112},{-2,112}},
          color={255,127,0}));
  connect(intLesEquThr2.y, booRep4.u)
         annotation (Line(points={{101,70},{118,70}}, color={255,0,255}));
  connect(booRep4.y, logSwi4.u2)
          annotation (Line(points={{141,70},{160,70},{160,120},{178,120}},
          color={255,0,255}));
  connect(intEqu2.y, booRep5.u)
          annotation (Line(points={{21,120},{38,120}}, color={255,0,255}));
  connect(booRep5.y, logSwi5.u2)
          annotation (Line(points={{61,120},{96,120}}, color={255,0,255}));
  connect(con8.y, logSwi5.u1)
          annotation (Line(points={{41,150},{80,150},{80,128},{96,128}},
          color={255,0,255}));
  connect(con9.y, logSwi5.u3)
          annotation (Line(points={{41,90},{80,90},{80,112},{96,112}},
          color={255,0,255}));
  connect(logSwi5.y, logSwi4.u3)
          annotation (Line(points={{119,120},{140,120},{140,112},{178,112}},
          color={255,0,255}));
  connect(upZerToOne.yChiSta, mulSumInt2.u[1])
          annotation (Line(points={{-79,120},{-62,120}}, color={255,127,0}));
  connect(logSwi4.y, upZerToOne.uChi)
          annotation (Line(points={{201,120},{220,120},{220,50},{-160,50},
          {-160,111},{-101,111}}, color={255,0,255}));
  connect(pul.y, multiMin.u[1])
          annotation (Line(points={{-219,-10},{-210,-10},{-210,11},{-202,11}},
          color={0,0,127}));
  connect(PLR.y, multiMin.u[2])
          annotation (Line(points={{-179,180},{-116,180},{-116,40},{-210,40},
          {-210,9},{-202,9}}, color={0,0,127}));
  connect(multiMin.yMin, upOneToTwo.uPLR)
          annotation (Line(points={{-179,10},{-160,10},{-160,-14},{-101,-14}},
          color={0,0,127}));
  connect(PLR.y, upOneToTwo1.uPLR)
          annotation (Line(points={{-179,180},{-116,180},{-116,-144},{-101,-144}},
          color={0,0,127}));
  connect(timTabLin.y[1], reaToInt.u)
          annotation (Line(points={{-219,90},{-202,90}}, color={0,0,127}));

annotation (
  experiment(StopTime=36000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Centrifugal.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Centrifugal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Centrifugal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2018, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{260,220}}),
        graphics={                           Rectangle(
          extent={{-158,178},{258,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-158,38},{258,-78}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-158,-102},{258,-218}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{178,174},{252,162}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Stage up from zero to one"),
          Text(
          extent={{84,40},{250,14}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Stage up from one to two: 
when PLR is greater than SPLR for 15 minutes"),
          Text(
          extent={{86,-98},{252,-124}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Stage up from one to two: 
plant reset is 100 and PLR greater than 0.3"),
          Text(
          extent={{86,-36},{252,-62}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Stage down from two to one: 
when PLR is less than SPLR for 15 minutes")}));
end ChangeOld;
