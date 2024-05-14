within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model UpEndWithOff
  "Validate sequence of end staging up process which requires chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp1(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexEnaChi1(final k=2)
    "Next enable chiller"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Stage up command"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev1 "Upstream device status"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.20,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta1(final pre_u_start=true)
    "Chiller one status"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta1(final pre_u_start=false)
    "Chiller two status"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer4(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexDisChi2(final k=1)
    "Next disable chiller"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe(final k=1)
    "Full open"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiIsoVal1
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaHeaCon(final k=true)
    "Enable head pressure control"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneHeaCon
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea1(final pre_u_start=true)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo1(final k=1)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo2(final k=1.667)
    "Minimum chilled water flow setpoint calculated from upstream process"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));

equation
  connect(booPul3.y, staUp1.u)
    annotation (Line(points={{-158,90},{-142,90}}, color={255,0,255}));
  connect(booPul4.y, upStrDev1.u)
    annotation (Line(points={{-158,50},{-142,50}}, color={255,0,255}));
  connect(nexEnaChi1.y, swi1.u1)
    annotation (Line(points={{-158,180},{-140,180},{-140,168},{-102,168}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-158,140},{-140,140},{-140,152},{-102,152}},
      color={0,0,127}));
  connect(swi1.y, reaToInt1.u)
    annotation (Line(points={{-78,160},{-62,160}}, color={0,0,127}));
  connect(staUp1.y, swi1.u2)
    annotation (Line(points={{-118,90},{-110,90},{-110,160},{-102,160}},
      color={255,0,255}));
  connect(reaToInt1.y, endUp1.nexEnaChi)
    annotation (Line(points={{-38,160},{-20,160},{-20,172},{58,172}},
      color={255,127,0}));
  connect(staUp1.y, endUp1.uStaUp)
    annotation (Line(points={{-118,90},{-16,90},{-16,170},{58,170}},
      color={255,0,255}));
  connect(upStrDev1.y, endUp1.uEnaChiWatIsoVal)
    annotation (Line(points={{-118,50},{-12,50},{-12,168},{58,168}},
      color={255,0,255}));
  connect(endUp1.yChi[1], chiOneSta1.u)
    annotation (Line(points={{82,168.5},{128,168.5},{128,130},{138,130}},
      color={255,0,255}));
  connect(endUp1.yChi[2], chiTwoSta1.u)
    annotation (Line(points={{82,169.5},{130,169.5},{130,90},{138,90}},
      color={255,0,255}));
  connect(chiTwoSta1.y, endUp1.uChi[2])
    annotation (Line(points={{162,90},{176,90},{176,60},{-8,60},{-8,166.5},{58,166.5}},
      color={255,0,255}));
  connect(chiOneSta1.y, endUp1.uChi[1])
    annotation (Line(points={{162,130},{180,130},{180,40},{-4,40},{-4,165.5},{58,
          165.5}},
      color={255,0,255}));
  connect(staUp1.y, endUp1.uOnOff)
    annotation (Line(points={{-118,90},{0,90},{0,164},{58,164}},
      color={255,0,255}));
  connect(nexDisChi2.y, swi3.u1)
    annotation (Line(points={{-158,10},{-140,10},{-140,-2},{-102,-2}},
      color={0,0,127}));
  connect(zer4.y, swi3.u3)
    annotation (Line(points={{-158,-30},{-140,-30},{-140,-18},{-102,-18}},
      color={0,0,127}));
  connect(staUp1.y, swi3.u2)
    annotation (Line(points={{-118,90},{-110,90},{-110,-10},{-102,-10}},
      color={255,0,255}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={0,0,127}));
  connect(reaToInt2.y, endUp1.nexDisChi)
    annotation (Line(points={{-38,-10},{4,-10},{4,162},{58,162}},
      color={255,127,0}));
  connect(chiTwoSta1.y, endUp1.uChiWatReq[2])
    annotation (Line(points={{162,90},{176,90},{176,60},{8,60},{8,160.5},{58,160.5}},
      color={255,0,255}));
  connect(chiOneSta1.y, endUp1.uChiWatReq[1])
    annotation (Line(points={{162,130},{180,130},{180,40},{12,40},{12,159.5},{58,
          159.5}},
      color={255,0,255}));
  connect(fulOpe.y, chiIsoVal1.u3)
    annotation (Line(points={{-158,-70},{-140,-70},{-140,-78},{-102,-78}},
      color={0,0,127}));
  connect(staUp1.y, chiIsoVal1.u2)
    annotation (Line(points={{-118,90},{-110,90},{-110,-70},{-102,-70}},
      color={255,0,255}));
  connect(endUp1.yChiWatIsoVal, zerOrdHol1.u)
    annotation (Line(points={{82,165},{124,165},{124,-10},{138,-10}},
      color={0,0,127}));
  connect(zerOrdHol1[1].y, chiIsoVal1.u1)
    annotation (Line(points={{162,-10},{166,-10},{166,-40},{-120,-40},{-120,-62},
      {-102,-62}}, color={0,0,127}));
  connect(chiIsoVal1.y, endUp1.uChiWatIsoVal[1])
    annotation (Line(points={{-78,-70},{16,-70},{16,157.5},{58,157.5}},
      color={0,0,127}));
  connect(chiOneSta1.y, endUp1.uConWatReq[1])
    annotation (Line(points={{162,130},{180,130},{180,40},{24,40},{24,155.5},{58,
          155.5}},
      color={255,0,255}));
  connect(chiTwoSta1.y, endUp1.uConWatReq[2])
    annotation (Line(points={{162,90},{176,90},{176,60},{28,60},{28,156.5},{58,156.5}},
      color={255,0,255}));
  connect(enaHeaCon.y, chiOneHeaCon.u3)
    annotation (Line(points={{-158,-160},{-140,-160},{-140,-168},{-102,-168}},
      color={255,0,255}));
  connect(staUp1.y, chiOneHeaCon.u2)
    annotation (Line(points={{-118,90},{-110,90},{-110,-160},{-102,-160}},
      color={255,0,255}));
  connect(endUp1.yChiHeaCon[1], chiOneHea1.u)
    annotation (Line(points={{82,160.5},{120,160.5},{120,-120},{138,-120}},
      color={255,0,255}));
  connect(chiOneHea1.y, chiOneHeaCon.u1)
    annotation (Line(points={{162,-120},{170,-120},{170,-140},{-120,-140},
      {-120,-152},{-102,-152}}, color={255,0,255}));
  connect(chiOneHeaCon.y, endUp1.uChiHeaCon[1])
    annotation (Line(points={{-78,-160},{32,-160},{32,153.5},{58,153.5}},
      color={255,0,255}));
  connect(chiWatFlo1.y, endUp1.VChiWat_flow)
    annotation (Line(points={{-158,-200},{40,-200},{40,152},{58,152}},
      color={0,0,127}));
  connect(fulOpe.y, endUp1.uChiWatIsoVal[2])
    annotation (Line(points={{-158,-70},{-140,-70},{-140,-100},{20,-100},{20,158.5},
          {58,158.5}},
                 color={0,0,127}));
  connect(enaHeaCon.y, endUp1.uChiHeaCon[2])
    annotation (Line(points={{-158,-160},{-140,-160},{-140,-180},{36,-180},{36,154.5},
          {58,154.5}},
                 color={255,0,255}));
  connect(chiWatFlo2.y, endUp1.VMinChiWat_setpoint)
    annotation (Line(points={{-158,-240},{44,-240},{44,150},{58,150}},
      color={0,0,127}));

annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/UpEndWithOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 30, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}}),
        graphics={
        Text(
          extent={{-182,250},{-150,242}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-176,236},{-16,226}},
          textColor={0,0,127},
          textString="from stage 1 which has small chiller 1 being enabled, "),
        Text(
          extent={{-180,224},{82,210}},
          textColor={0,0,127},
          textString="to stage 2 which has small chiller 1 being disabled and large chiller 2 being enabled.")}));
end UpEndWithOff;
