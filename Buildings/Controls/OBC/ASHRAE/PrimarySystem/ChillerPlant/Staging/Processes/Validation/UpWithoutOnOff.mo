within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model UpWithoutOnOff
  "Validate sequence of staging up process which does not require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up upProCon(
    final nChi=2,
    final totChiSta=3,
    final totSta=4,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Stage up process when does not require chiller off"
    annotation (Placement(transformation(extent={{40,120},{60,160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=1,
    final duration=300,
    final offset=1,
    final startTime=500) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant iniChiIsoVal[2](
    final k={1,0}) "Initial chilled water solation valve"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start={true,false}) "Break algebraic loop"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[2](final k={1,2})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta "Logical switch"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-118,130},{-102,130}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-118,80},{-100,80},{-100,68},{-62,68}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-118,40},{-100,40},{-100,52},{-62,52}},
      color={0,0,127}));
  connect(chiSta.y, reaToInt1.u)
    annotation (Line(points={{-38,-60},{-22,-60}},   color={0,0,127}));
  connect(iniChiIsoVal.y, IsoVal.u3)
    annotation (Line(points={{-118,-210},{-100,-210},{-100,-218},{-22,-218}},
      color={0,0,127}));
  connect(enaPri.y, upProCon.uChiPri) annotation (Line(points={{-118,170},{-60,170},
          {-60,159},{38,159}}, color={255,127,0}));
  connect(staUp.y, upProCon.uStaUp) annotation (Line(points={{-78,130},{-70,130},
          {-70,157},{38,157}}, color={255,0,255}));
  connect(upProCon.yChi, pre2.u) annotation (Line(points={{62,121},{94,121},{94,
          110},{98,110}}, color={255,0,255}));
  connect(pre2.y, swi1.u2) annotation (Line(points={{122,110},{140,110},{140,80},
          {-80,80},{-80,60},{-62,60}}, color={255,0,255}));
  connect(swi1.y, upProCon.uChiLoa) annotation (Line(points={{-38,60},{-30,60},{
          -30,154},{38,154}}, color={0,0,127}));
  connect(pre2.y, upProCon.uChi) annotation (Line(points={{122,110},{140,110},{140,
          80},{-28,80},{-28,151},{38,151}}, color={255,0,255}));
  connect(chiWatFlo.y, upProCon.VChiWat_flow) annotation (Line(points={{-118,0},
          {-26,0},{-26,147.6},{38,147.6}}, color={0,0,127}));
  connect(pre2.y, upProCon.uChiConIsoVal) annotation (Line(points={{122,110},{140,
          110},{140,80},{-24,80},{-24,145},{38,145}}, color={255,0,255}));
  connect(staOne.y, chiSta.u3) annotation (Line(points={{-118,-80},{-100,-80},{-100,
          -68},{-62,-68}}, color={0,0,127}));
  connect(staTwo.y, chiSta.u1) annotation (Line(points={{-118,-40},{-100,-40},{-100,
          -52},{-62,-52}}, color={0,0,127}));
  connect(staUp.y, chiSta.u2) annotation (Line(points={{-78,130},{-70,130},{-70,
          -60},{-62,-60}}, color={255,0,255}));
  connect(reaToInt1.y, upProCon.uChiSta) annotation (Line(points={{2,-60},{10,-60},
          {10,142},{38,142}}, color={255,127,0}));
  connect(pre2.y, upProCon.uConWatReq) annotation (Line(points={{122,110},{140,110},
          {140,80},{12,80},{12,138},{38,138}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uWSE) annotation (Line(points={{-118,-130},{14,-130},
          {14,135},{38,135}}, color={255,0,255}));
  connect(upProCon.yDesConWatPumSpe, zerOrdHol1.u) annotation (Line(points={{62,
          139},{80,139},{80,-30},{98,-30}}, color={0,0,127}));
  connect(zerOrdHol1.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{122,
          -30},{140,-30},{140,-100},{16,-100},{16,132},{38,132}}, color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u) annotation (Line(points={{122,-30},{140,-30},
          {140,-50},{80,-50},{80,-70},{98,-70}}, color={0,0,127}));
  connect(zerOrdHol2.y, upProCon.uConWatPumSpe) annotation (Line(points={{122,-70},
          {130,-70},{130,-94},{18,-94},{18,129},{38,129}}, color={0,0,127}));
  connect(pre2.y, upProCon.uChiHeaCon) annotation (Line(points={{122,110},{140,110},
          {140,80},{20,80},{20,126},{38,126}}, color={255,0,255}));
  connect(staUp.y, booRep.u) annotation (Line(points={{-78,130},{-70,130},{-70,-180},
          {-62,-180}}, color={255,0,255}));
  connect(booRep.y, IsoVal.u2) annotation (Line(points={{-38,-180},{-30,-180},{-30,
          -210},{-22,-210}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, zerOrdHol.u) annotation (Line(points={{62,126},
          {88,126},{88,20},{98,20}}, color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1) annotation (Line(points={{122,20},{150,20},{150,
          -150},{-80,-150},{-80,-202},{-22,-202}}, color={0,0,127}));
  connect(IsoVal.y, upProCon.uChiWatIsoVal) annotation (Line(points={{2,-210},{22,
          -210},{22,123},{38,123}}, color={0,0,127}));
  connect(pre2.y, upProCon.uChiWatReq) annotation (Line(points={{122,110},{140,110},
          {140,80},{24,80},{24,121},{38,121}}, color={255,0,255}));

annotation (
 experiment(StopTime=1500, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/UpWithoutOnOff.mos"
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
October 12, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-260},{160,260}}),
        graphics={
        Text(
          extent={{-150,238},{-102,230}},
          lineColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-136,226},{-6,216}},
          lineColor={0,0,127},
          textString="from stage 1 which has chiller 1 enabled, "),
        Text(
          extent={{-136,214},{-10,200}},
          lineColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 enabled.")}));
end UpWithoutOnOff;
