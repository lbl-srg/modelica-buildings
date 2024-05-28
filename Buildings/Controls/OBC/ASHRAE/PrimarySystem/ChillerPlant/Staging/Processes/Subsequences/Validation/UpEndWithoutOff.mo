within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model UpEndWithoutOff
  "Validate sequence of end staging up process which does not require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  CDL.Reals.Sources.Sin sin(freqHz=1/1200)
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexDisChi(
    final k=0) "Next disabling chiller"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiHea[2](
    final k=fill(true,2)) "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo(final k=1.667)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=true) "Chiller one status"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexEnaChi(
    final k=2) "Next enable chiller"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev "Upstream device status"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=false) "Chiller two status"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatIsoVal[2](
    final k=fill(1, 2))  "Constant one"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-118,80},{-102,80}}, color={255,0,255}));
  connect(staUp.y, swi2.u2)
    annotation (Line(points={{-78,80},{-70,80},{-70,150},{-62,150}},
      color={255,0,255}));
  connect(nexEnaChi.y, swi2.u1)
    annotation (Line(points={{-118,170},{-100,170},{-100,158},{-62,158}},
      color={0,0,127}));
  connect(zer2.y, swi2.u3)
    annotation (Line(points={{-118,130},{-100,130},{-100,142},{-62,142}},
      color={0,0,127}));
  connect(swi2.y, reaToInt.u)
    annotation (Line(points={{-38,150},{-22,150}}, color={0,0,127}));
  connect(booPul1.y, upStrDev.u)
    annotation (Line(points={{-118,40},{-102,40}}, color={255,0,255}));
  connect(endUp.yChi[1], chiOneSta.u)
    annotation (Line(points={{122,158.5},{130,158.5},{130,120},{138,120}},
      color={255,0,255}));
  connect(endUp.yChi[2], chiTwoSta.u)
    annotation (Line(points={{122,159.5},{130,159.5},{130,80},{138,80}},
      color={255,0,255}));
  connect(reaToInt.y, endUp.nexEnaChi)
    annotation (Line(points={{2,150},{20,150},{20,162},{98,162}},
      color={255,127,0}));
  connect(staUp.y, endUp.uStaUp)
    annotation (Line(points={{-78,80},{24,80},{24,160},{98,160}},
      color={255,0,255}));
  connect(upStrDev.y, endUp.uEnaChiWatIsoVal)
    annotation (Line(points={{-78,40},{28,40},{28,158},{98,158}},
      color={255,0,255}));
  connect(chiOneSta.y, endUp.uChi[1])
    annotation (Line(points={{162,120},{174,120},{174,100},{32,100},{32,155.5},{
          98,155.5}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uChi[2])
    annotation (Line(points={{162,80},{170,80},{170,60},{36,60},{36,156.5},{98,156.5}},
      color={255,0,255}));
  connect(onOff.y, endUp.uOnOff)
    annotation (Line(points={{-118,0},{40,0},{40,154},{98,154}},
      color={255,0,255}));
  connect(nexDisChi.y, endUp.nexDisChi)
    annotation (Line(points={{-118,-40},{44,-40},{44,152},{98,152}},
      color={255,127,0}));
  connect(chiOneSta.y, endUp.uChiWatReq[1])
    annotation (Line(points={{162,120},{174,120},{174,100},{48,100},{48,149.5},{
          98,149.5}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uChiWatReq[2])
    annotation (Line(points={{162,80},{170,80},{170,60},{52,60},{52,150.5},{98,150.5}},
      color={255,0,255}));
  connect(chiOneSta.y, endUp.uConWatReq[1])
    annotation (Line(points={{162,120},{174,120},{174,100},{60,100},{60,145.5},{
          98,145.5}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uConWatReq[2])
    annotation (Line(points={{162,80},{170,80},{170,60},{64,60},{64,146.5},{98,146.5}},
      color={255,0,255}));
  connect(chiWatFlo.y, endUp.VChiWat_flow)
    annotation (Line(points={{-118,-240},{72,-240},{72,142},{98,142}},
      color={0,0,127}));
  connect(chiWatIsoVal.y, endUp.uChiWatIsoVal)
    annotation (Line(points={{-118,-80},{56,-80},{56,148},{98,148}},
      color={0,0,127}));
  connect(chiHea.y, endUp.uChiHeaCon)
    annotation (Line(points={{-118,-160},{68,-160},{68,144},{98,144}},
      color={255,0,255}));
  connect(chiWatFlo.y, endUp.VMinChiWat_setpoint)
    annotation (Line(points={{-118,-240},{72,-240},{72,140},{98,140}},
      color={0,0,127}));
  connect(sin.y, triSam.u)
    annotation (Line(points={{102,200},{138,200}}, color={0,0,127}));
  connect(endUp.yEndSta, triSam.trigger) annotation (Line(points={{122,143},{150,
          143},{150,188}}, color={255,0,255}));
annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/UpEndWithoutOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd</a>.
</p>
<p>
It shows how the staging up process ends when the process does not require one chiller
being enabled and another chiller being disabled. The instance <code>endUp</code>
shows the results as below. It stages up from stage 1 which requires chiller 1 being
enabled, to stage 2 which requires chiller 1 and chiller 2 being enabled.
</p>
<ul>
<li>
Before 180 seconds, the plant is not in stagingg up process (<code>uStaUp=false</code>).
</li>
<li>
At 180 seconds, the plant starts staging up (<code>uStaUp=true</code>). However,
it does not yet starts the subprocess of ending the staging process
(<code>uEnaChiWatIsoVal=false</code>).
</li>
<li>
At 240 seconds, the ending process starts (<code>uEnaChiWatIsoVal=true</code>).
The chiller 2 is enabled (<code>yChi[2]=true</code>). The ending process is done
(the output <code>yEndSta</code> has a rising edge).
</li>
</ul>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-260},{180,260}}),
        graphics={
        Text(
          extent={{-142,240},{-110,232}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-138,226},{22,216}},
          textColor={0,0,127},
          textString="from stage 1 which has only chiller 1 being enabled, "),
        Text(
          extent={{-138,214},{16,200}},
          textColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 being enabled.")}));
end UpEndWithoutOff;
