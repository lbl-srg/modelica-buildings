within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model UpEnd "Validate sequence of end staging up process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp1(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{240,150},{260,170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-360,80},{-340,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-320,80},{-300,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexDisChi(
    final k=0) "Next disabling chiller"
    annotation (Placement(transformation(extent={{-360,-40},{-340,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-360,0},{-340,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiHea[2](
    final k=fill(true,2)) "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-360,-160},{-340,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlo(final k=1.667)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-360,-240},{-340,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=true) "Chiller one status"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexEnaChi(
    final k=2) "Next enable chiller"
    annotation (Placement(transformation(extent={{-360,170},{-340,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-360,130},{-340,150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev "Upstream device status"
    annotation (Placement(transformation(extent={{-320,40},{-300,60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=false) "Chiller two status"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatIsoVal[2](
    final k=fill(1, 2))  "Constant one"
    annotation (Placement(transformation(extent={{-360,-80},{-340,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexEnaChi1(final k=2)
    "Next enable chiller"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Stage up command"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev1 "Upstream device status"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.20,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta1(final pre_u_start=true)
    "Chiller one status"
    annotation (Placement(transformation(extent={{320,120},{340,140}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta1(final pre_u_start=false)
    "Chiller two status"
    annotation (Placement(transformation(extent={{320,80},{340,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer4(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexDisChi2(final k=1)
    "Next disable chiller"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe(final k=1)
    "Full open"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiIsoVal1
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaHeaCon(final k=true)
    "Enable head pressure control"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch chiOneHeaCon
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea1(final pre_u_start=true)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{320,-130},{340,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlo1(final k=1)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlo2(final k=1.667)
    "Minimum chilled water flow setpoint calculated from upstream process"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-338,90},{-322,90}}, color={255,0,255}));
  connect(staUp.y, swi2.u2)
    annotation (Line(points={{-298,90},{-290,90},{-290,160},{-282,160}},
      color={255,0,255}));
  connect(nexEnaChi.y, swi2.u1)
    annotation (Line(points={{-338,180},{-320,180},{-320,168},{-282,168}},
      color={0,0,127}));
  connect(zer2.y, swi2.u3)
    annotation (Line(points={{-338,140},{-320,140},{-320,152},{-282,152}},
      color={0,0,127}));
  connect(swi2.y, reaToInt.u)
    annotation (Line(points={{-258,160},{-242,160}}, color={0,0,127}));
  connect(booPul1.y, upStrDev.u)
    annotation (Line(points={{-338,50},{-322,50}}, color={255,0,255}));
  connect(endUp.yChi[1], chiOneSta.u)
    annotation (Line(points={{-98,168},{-90,168},{-90,130},{-82,130}},
      color={255,0,255}));
  connect(endUp.yChi[2], chiTwoSta.u)
    annotation (Line(points={{-98,170},{-90,170},{-90,90},{-82,90}},
      color={255,0,255}));
  connect(reaToInt.y, endUp.nexEnaChi)
    annotation (Line(points={{-218,160},{-200,160},{-200,172},{-122,172}},
      color={255,127,0}));
  connect(staUp.y, endUp.uStaUp)
    annotation (Line(points={{-298,90},{-196,90},{-196,170},{-122,170}},
      color={255,0,255}));
  connect(upStrDev.y, endUp.uEnaChiWatIsoVal)
    annotation (Line(points={{-298,50},{-192,50},{-192,168},{-122,168}},
      color={255,0,255}));
  connect(chiOneSta.y, endUp.uChi[1])
    annotation (Line(points={{-58,130},{-46,130},{-46,110},{-188,110},{-188,165},
      {-122,165}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uChi[2])
    annotation (Line(points={{-58,90},{-50,90},{-50,70},{-184,70},{-184,167},
      {-122,167}}, color={255,0,255}));
  connect(onOff.y, endUp.uOnOff)
    annotation (Line(points={{-338,10},{-180,10},{-180,164},{-122,164}},
      color={255,0,255}));
  connect(nexDisChi.y, endUp.nexDisChi)
    annotation (Line(points={{-338,-30},{-176,-30},{-176,162},{-122,162}},
      color={255,127,0}));
  connect(chiOneSta.y, endUp.uChiWatReq[1])
    annotation (Line(points={{-58,130},{-46,130},{-46,110},{-172,110},{-172,159},
      {-122,159}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uChiWatReq[2])
    annotation (Line(points={{-58,90},{-50,90},{-50,70},{-168,70},{-168,161},
      {-122,161}}, color={255,0,255}));
  connect(chiOneSta.y, endUp.uConWatReq[1])
    annotation (Line(points={{-58,130},{-46,130},{-46,110},{-160,110},{-160,155},
      {-122,155}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uConWatReq[2])
    annotation (Line(points={{-58,90},{-50,90},{-50,70},{-156,70},{-156,157},
      {-122,157}}, color={255,0,255}));
  connect(chiWatFlo.y, endUp.VChiWat_flow)
    annotation (Line(points={{-338,-230},{-148,-230},{-148,152},{-122,152}},
      color={0,0,127}));
  connect(booPul3.y, staUp1.u)
    annotation (Line(points={{22,90},{38,90}}, color={255,0,255}));
  connect(booPul4.y, upStrDev1.u)
    annotation (Line(points={{22,50},{38,50}}, color={255,0,255}));
  connect(nexEnaChi1.y, swi1.u1)
    annotation (Line(points={{22,180},{40,180},{40,168},{78,168}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{22,140},{40,140},{40,152},{78,152}},
      color={0,0,127}));
  connect(swi1.y, reaToInt1.u)
    annotation (Line(points={{102,160},{118,160}}, color={0,0,127}));
  connect(staUp1.y, swi1.u2)
    annotation (Line(points={{62,90},{70,90},{70,160},{78,160}},
      color={255,0,255}));
  connect(reaToInt1.y, endUp1.nexEnaChi)
    annotation (Line(points={{142,160},{160,160},{160,172},{238,172}},
      color={255,127,0}));
  connect(staUp1.y, endUp1.uStaUp)
    annotation (Line(points={{62,90},{164,90},{164,170},{238,170}},
      color={255,0,255}));
  connect(upStrDev1.y, endUp1.uEnaChiWatIsoVal)
    annotation (Line(points={{62,50},{168,50},{168,168},{238,168}},
      color={255,0,255}));
  connect(endUp1.yChi[1], chiOneSta1.u)
    annotation (Line(points={{262,168},{308,168},{308,130},{318,130}},
      color={255,0,255}));
  connect(endUp1.yChi[2], chiTwoSta1.u)
    annotation (Line(points={{262,170},{310,170},{310,90},{318,90}},
      color={255,0,255}));
  connect(chiTwoSta1.y, endUp1.uChi[2])
    annotation (Line(points={{342,90},{356,90},{356,60},{172,60},{172,167},
      {238,167}}, color={255,0,255}));
  connect(chiOneSta1.y, endUp1.uChi[1])
    annotation (Line(points={{342,130},{360,130},{360,40},{176,40},{176,165},
      {238,165}},  color={255,0,255}));
  connect(staUp1.y, endUp1.uOnOff)
    annotation (Line(points={{62,90},{180,90},{180,164},{238,164}},
      color={255,0,255}));
  connect(nexDisChi2.y, swi3.u1)
    annotation (Line(points={{22,10},{40,10},{40,-2},{78,-2}},
      color={0,0,127}));
  connect(zer4.y, swi3.u3)
    annotation (Line(points={{22,-30},{40,-30},{40,-18},{78,-18}},
      color={0,0,127}));
  connect(staUp1.y, swi3.u2)
    annotation (Line(points={{62,90},{70,90},{70,-10},{78,-10}},
      color={255,0,255}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{102,-10},{118,-10}}, color={0,0,127}));
  connect(reaToInt2.y, endUp1.nexDisChi)
    annotation (Line(points={{142,-10},{184,-10},{184,162},{238,162}},
      color={255,127,0}));
  connect(chiTwoSta1.y, endUp1.uChiWatReq[2])
    annotation (Line(points={{342,90},{356,90},{356,60},{188,60},{188,161},
      {238,161}},  color={255,0,255}));
  connect(chiOneSta1.y, endUp1.uChiWatReq[1])
    annotation (Line(points={{342,130},{360,130},{360,40},{192,40},{192,159},
      {238,159}},  color={255,0,255}));
  connect(fulOpe.y, chiIsoVal1.u3)
    annotation (Line(points={{22,-70},{40,-70},{40,-78},{78,-78}},
      color={0,0,127}));
  connect(staUp1.y, chiIsoVal1.u2)
    annotation (Line(points={{62,90},{70,90},{70,-70},{78,-70}},
      color={255,0,255}));
  connect(endUp1.yChiWatIsoVal, zerOrdHol1.u)
    annotation (Line(points={{262,165},{304,165},{304,-10},{318,-10}},
      color={0,0,127}));
  connect(zerOrdHol1[1].y, chiIsoVal1.u1)
    annotation (Line(points={{342,-10},{346,-10},{346,-40},{60,-40},{60,-62},
      {78,-62}}, color={0,0,127}));
  connect(chiIsoVal1.y, endUp1.uChiWatIsoVal[1])
    annotation (Line(points={{102,-70},{196,-70},{196,157},{238,157}},
      color={0,0,127}));
  connect(chiOneSta1.y, endUp1.uConWatReq[1])
    annotation (Line(points={{342,130},{360,130},{360,40},{204,40},{204,155},
      {238,155}},  color={255,0,255}));
  connect(chiTwoSta1.y, endUp1.uConWatReq[2])
    annotation (Line(points={{342,90},{356,90},{356,60},{208,60},{208,157},
      {238,157}},  color={255,0,255}));
  connect(enaHeaCon.y, chiOneHeaCon.u3)
    annotation (Line(points={{22,-160},{40,-160},{40,-168},{78,-168}},
      color={255,0,255}));
  connect(staUp1.y, chiOneHeaCon.u2)
    annotation (Line(points={{62,90},{70,90},{70,-160},{78,-160}},
      color={255,0,255}));
  connect(endUp1.yChiHeaCon[1], chiOneHea1.u)
    annotation (Line(points={{262,159},{300,159},{300,-120},{318,-120}},
      color={255,0,255}));
  connect(chiOneHea1.y, chiOneHeaCon.u1)
    annotation (Line(points={{342,-120},{350,-120},{350,-140},{60,-140},
      {60,-152},{78,-152}}, color={255,0,255}));
  connect(chiOneHeaCon.y, endUp1.uChiHeaCon[1])
    annotation (Line(points={{102,-160},{212,-160},{212,153},{238,153}},
      color={255,0,255}));
  connect(chiWatFlo1.y, endUp1.VChiWat_flow)
    annotation (Line(points={{22,-200},{220,-200},{220,152},{238,152}},
      color={0,0,127}));
  connect(fulOpe.y, endUp1.uChiWatIsoVal[2])
    annotation (Line(points={{22,-70},{40,-70},{40,-100},{200,-100},{200,159},
      {238,159}},  color={0,0,127}));
  connect(enaHeaCon.y, endUp1.uChiHeaCon[2])
    annotation (Line(points={{22,-160},{40,-160},{40,-180},{216,-180},{216,155},
      {238,155}}, color={255,0,255}));
  connect(chiWatIsoVal.y, endUp.uChiWatIsoVal)
    annotation (Line(points={{-338,-70},{-164,-70},{-164,158},{-122,158}},
      color={0,0,127}));
  connect(chiHea.y, endUp.uChiHeaCon)
    annotation (Line(points={{-338,-150},{-152,-150},{-152,154},{-122,154}},
      color={255,0,255}));
  connect(chiWatFlo.y, endUp.VMinChiWat_setpoint)
    annotation (Line(points={{-338,-230},{-148,-230},{-148,150},{-122,150}},
      color={0,0,127}));
  connect(chiWatFlo2.y, endUp1.VMinChiWat_setpoint)
    annotation (Line(points={{22,-240},{224,-240},{224,150},{238,150}},
      color={0,0,127}));

annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/UpEnd.mos"
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
September 30, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-380,-260},{380,260}}),
        graphics={
          Rectangle(
          extent={{-18,258},{378,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-378,258},{-22,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-362,250},{-330,242}},
          lineColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-358,236},{-198,226}},
          lineColor={0,0,127},
          textString="from stage 1 which has only chiller 1 being enabled, "),
        Text(
          extent={{-358,224},{-204,210}},
          lineColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 being enabled."),
        Text(
          extent={{-2,250},{30,242}},
          lineColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{4,236},{164,226}},
          lineColor={0,0,127},
          textString="from stage 1 which has small chiller 1 being enabled, "),
        Text(
          extent={{0,224},{262,210}},
          lineColor={0,0,127},
          textString="to stage 2 which has small chiller 1 being disabled and large chiller 2 being enabled.")}));
end UpEnd;
