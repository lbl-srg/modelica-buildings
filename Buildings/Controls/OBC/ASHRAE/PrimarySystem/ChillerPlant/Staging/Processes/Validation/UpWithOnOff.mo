within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model UpWithOnOff
  "Validate sequence of staging up process which does require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up upProCon(
    final nChi=2,
    final totChiSta=3,
    final totSta=4,
    havePonyChiller=true,
    upOnOffSta={false,false,true},
    dowOnOffSta={false,true,false},
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "Stage up process when does not require chiller off"
    annotation (Placement(transformation(extent={{20,120},{40,160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=5/3 - 0.5,
    final duration=300,
    final offset=0.5,
    final startTime=500) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.075,
    final period=2000) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulLoa(final k=1000)
    "Full load"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerLoa(final k=0)
    "Zero load"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch loaOne "Chiller load one"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[2](final k={1,2})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta "Logical switch"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold conPumSpeSet(final
      samplePeriod=10) "Design condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold conPumSpe(final
      samplePeriod=20) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch loaTwo "Chiller load two"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold chiTwoDem(final samplePeriod=10)
    "Chiller two limited demand"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa3(final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiLoa[2] "Limited chiller load"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold chiTwoDem1(
    final samplePeriod=10) "Limited chiller two demand"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(final pre_u_start=false) "Chiller two status"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOpe(final k=0) "Closed isolation valve"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe(final k=1) "Full open isolation valve"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValOne "Logical switch"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValTwo "Logical switch"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(final pre_u_start=true)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(final pre_u_start=false)
    "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatFlo1 "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre  chiOneHea1(final pre_u_start=false)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-178,130},{-162,130}}, color={255,0,255}));
  connect(chiSta.y, reaToInt1.u)
    annotation (Line(points={{-98,-80},{-82,-80}}, color={0,0,127}));
  connect(staOne.y, chiSta.u3) annotation (Line(points={{-178,-100},{-160,-100},
          {-160,-88},{-122,-88}}, color={0,0,127}));
  connect(staTwo.y, chiSta.u1) annotation (Line(points={{-178,-60},{-160,-60},{-160,
          -72},{-122,-72}},color={0,0,127}));
  connect(enaPri.y, upProCon.uChiPri) annotation (Line(points={{-178,170},{-120,
          170},{-120,159},{18,159}}, color={255,127,0}));
  connect(staUp.y, upProCon.uStaUp) annotation (Line(points={{-138,130},{-130,130},
          {-130,157},{18,157}}, color={255,0,255}));
  connect(fulLoa.y, loaOne.u3) annotation (Line(points={{-178,60},{-160,60},{-160,
          52},{-122,52}}, color={0,0,127}));
  connect(zerLoa.y, loaTwo.u3) annotation (Line(points={{-178,20},{-160,20},{-160,
          12},{-122,12}}, color={0,0,127}));
  connect(staUp.y, loaOne.u2) annotation (Line(points={{-138,130},{-130,130},{-130,
          60},{-122,60}}, color={255,0,255}));
  connect(staUp.y, loaTwo.u2) annotation (Line(points={{-138,130},{-130,130},{-130,
          20},{-122,20}}, color={255,0,255}));
  connect(upProCon.yChi[1], chiOneSta.u) annotation (Line(points={{42,120},{60,120},
          {60,110},{78,110}}, color={255,0,255}));
  connect(upProCon.yChi[2], chiTwoSta.u) annotation (Line(points={{42,122},{58,122},
          {58,70},{78,70}}, color={255,0,255}));
  connect(chiOneSta.y, chiLoa[1].u2) annotation (Line(points={{102,110},{130,
          110},{130,180},{138,180}}, color={255,0,255}));
  connect(chiTwoSta.y, chiLoa[2].u2) annotation (Line(points={{102,70},{132,70},
          {132,180},{138,180}}, color={255,0,255}));
  connect(upProCon.yChiDem[2], chiTwoDem.u) annotation (Line(points={{42,156},{60,
          156},{60,180},{78,180}}, color={0,0,127}));
  connect(chiTwoDem.y, chiLoa[2].u1) annotation (Line(points={{102,180},{120,
          180},{120,188},{138,188}}, color={0,0,127}));
  connect(chiLoa3.y, chiLoa[1].u1) annotation (Line(points={{62,200},{120,200},
          {120,188},{138,188}}, color={0,0,127}));
  connect(zer3.y, chiLoa.u3) annotation (Line(points={{102,150},{120,150},{120,
          172},{138,172}}, color={0,0,127}));
  connect(chiLoa[2].y, chiTwoDem1.u)
    annotation (Line(points={{162,180},{178,180}}, color={0,0,127}));
  connect(chiLoa[1].y, loaOne.u1) annotation (Line(points={{162,180},{170,180},
          {170,86},{-140,86},{-140,68},{-122,68}}, color={0,0,127}));
  connect(chiTwoDem1.y, loaTwo.u1) annotation (Line(points={{202,180},{210,180},
          {210,40},{-140,40},{-140,28},{-122,28}}, color={0,0,127}));
  connect(loaOne.y, upProCon.uChiLoa[1]) annotation (Line(points={{-98,60},{-60,
          60},{-60,153},{18,153}}, color={0,0,127}));
  connect(loaTwo.y, upProCon.uChiLoa[2]) annotation (Line(points={{-98,20},{-58,
          20},{-58,155},{18,155}}, color={0,0,127}));
  connect(chiOneSta.y, upProCon.uChi[1]) annotation (Line(points={{102,110},{130,
          110},{130,90},{-56,90},{-56,150},{18,150}}, color={255,0,255}));
  connect(chiTwoSta.y, upProCon.uChi[2]) annotation (Line(points={{102,70},{132,
          70},{132,50},{-54,50},{-54,152},{18,152}}, color={255,0,255}));
  connect(zerOpe.y, IsoValTwo.u3) annotation (Line(points={{-178,-220},{-160,-220},
          {-160,-228},{-122,-228}}, color={0,0,127}));
  connect(fulOpe.y, IsoValOne.u3) annotation (Line(points={{-178,-180},{-160,-180},
          {-160,-188},{-122,-188}}, color={0,0,127}));
  connect(staUp.y, IsoValOne.u2) annotation (Line(points={{-138,130},{-130,130},
          {-130,-180},{-122,-180}}, color={255,0,255}));
  connect(staUp.y, IsoValTwo.u2) annotation (Line(points={{-138,130},{-130,130},
          {-130,-220},{-122,-220}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, zerOrdHol.u) annotation (Line(points={{42,126},
          {56,126},{56,-140},{78,-140}}, color={0,0,127}));
  connect(zerOrdHol[1].y, IsoValOne.u1) annotation (Line(points={{102,-140},{120,
          -140},{120,-160},{-140,-160},{-140,-172},{-122,-172}}, color={0,0,127}));
  connect(zerOrdHol[2].y, IsoValTwo.u1) annotation (Line(points={{102,-140},{120,
          -140},{120,-160},{-140,-160},{-140,-212},{-122,-212}}, color={0,0,127}));
  connect(chiOneSta.y, upProCon.uChiConIsoVal[1]) annotation (Line(points={{102,
          110},{130,110},{130,90},{-50,90},{-50,144},{18,144}}, color={255,0,255}));
  connect(chiTwoSta.y, upProCon.uChiConIsoVal[2]) annotation (Line(points={{102,
          70},{132,70},{132,50},{-48,50},{-48,146},{18,146}}, color={255,0,255}));
  connect(staUp.y, chiSta.u2) annotation (Line(points={{-138,130},{-130,130},{-130,
          -80},{-122,-80}}, color={255,0,255}));
  connect(reaToInt1.y, upProCon.uChiSta) annotation (Line(points={{-58,-80},{-46,
          -80},{-46,142},{18,142}}, color={255,127,0}));
  connect(chiOneSta.y, upProCon.uConWatReq[1]) annotation (Line(points={{102,110},
          {130,110},{130,90},{-44,90},{-44,137},{18,137}}, color={255,0,255}));
  connect(chiTwoSta.y, upProCon.uConWatReq[2]) annotation (Line(points={{102,70},
          {132,70},{132,50},{-42,50},{-42,139},{18,139}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uWSE) annotation (Line(points={{-178,-140},{-40,-140},
          {-40,135},{18,135}}, color={255,0,255}));
  connect(upProCon.yDesConWatPumSpe, conPumSpeSet.u) annotation (Line(points={{
          42,139},{54,139},{54,20},{78,20}}, color={0,0,127}));
  connect(conPumSpeSet.y, conPumSpe.u) annotation (Line(points={{102,20},{120,
          20},{120,0},{60,0},{60,-20},{78,-20}}, color={0,0,127}));
  connect(conPumSpeSet.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{
          102,20},{120,20},{120,0},{-38,0},{-38,132},{18,132}}, color={0,0,127}));
  connect(conPumSpe.y, upProCon.uConWatPumSpe) annotation (Line(points={{102,-20},
          {120,-20},{120,-40},{-36,-40},{-36,129},{18,129}}, color={0,0,127}));
  connect(upProCon.yChiHeaCon[1], chiOneHea.u) annotation (Line(points={{42,130},
          {52,130},{52,-60},{78,-60}}, color={255,0,255}));
  connect(upProCon.yChiHeaCon[2], chiTwoHea.u) annotation (Line(points={{42,132},
          {50,132},{50,-100},{78,-100}}, color={255,0,255}));
  connect(chiOneHea.y, upProCon.uChiHeaCon[1]) annotation (Line(points={{102,-60},
          {120,-60},{120,-80},{-34,-80},{-34,125},{18,125}}, color={255,0,255}));
  connect(chiTwoHea.y, upProCon.uChiHeaCon[2]) annotation (Line(points={{102,-100},
          {120,-100},{120,-120},{-32,-120},{-32,127},{18,127}}, color={255,0,255}));
  connect(IsoValOne.y, upProCon.uChiWatIsoVal[1]) annotation (Line(points={{-98,
          -180},{-30,-180},{-30,122},{18,122}}, color={0,0,127}));
  connect(IsoValTwo.y, upProCon.uChiWatIsoVal[2]) annotation (Line(points={{-98,
          -220},{-28,-220},{-28,124},{18,124}}, color={0,0,127}));
  connect(chiOneSta.y, upProCon.uChiWatReq[1]) annotation (Line(points={{102,110},
          {130,110},{130,90},{-26,90},{-26,120},{18,120}}, color={255,0,255}));
  connect(chiTwoSta.y, upProCon.uChiWatReq[2]) annotation (Line(points={{102,70},
          {132,70},{132,50},{-24,50},{-24,122},{18,122}}, color={255,0,255}));
  connect(upProCon.yChiWatMinFloSet, zerOrdHol3.u) annotation (Line(points={{42,
          151},{48,151},{48,-180},{78,-180}}, color={0,0,127}));
  connect(chiWatFlo.y, chiWatFlo1.u3) annotation (Line(points={{-178,-20},{-160,
          -20},{-160,-28},{-122,-28}}, color={0,0,127}));
  connect(zerOrdHol3.y, chiWatFlo1.u1) annotation (Line(points={{102,-180},{120,
          -180},{120,-200},{-90,-200},{-90,0},{-140,0},{-140,-12},{-122,-12}},
        color={0,0,127}));
  connect(chiWatFlo1.y, upProCon.VChiWat_flow) annotation (Line(points={{-98,-20},
          {-52,-20},{-52,147.6},{18,147.6}}, color={0,0,127}));
  connect(upProCon.yTowStaUp, chiOneHea1.u) annotation (Line(points={{42,147},{46,
          147},{46,32},{-20,32},{-20,20},{-2,20}}, color={255,0,255}));
  connect(chiOneHea1.y, chiWatFlo1.u2) annotation (Line(points={{22,20},{40,20},
          {40,6},{-150,6},{-150,-20},{-122,-20}}, color={255,0,255}));

annotation (
 experiment(StopTime=2000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/UpWithOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 14, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,260}}),
        graphics={
        Text(
          extent={{-208,240},{-160,232}},
          lineColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-196,226},{-50,218}},
          lineColor={0,0,127},
          textString="from stage 1 which has small chiller one been enabled, "),
        Text(
          extent={{-196,214},{-70,200}},
          lineColor={0,0,127},
          textString="to stage 2 which has large chiller 2 been enabled.")}));
end UpWithOnOff;
