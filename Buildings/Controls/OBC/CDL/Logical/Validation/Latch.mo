within Buildings.Controls.OBC.CDL.Logical.Validation;
model Latch
  "Validation model for the Latch block"
  Buildings.Controls.OBC.CDL.Logical.Latch falCleTruIni
    "Latch block with clear input being contantly false and true initial latch input"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch truCleTruIni
    "Latch block with clear input being contantly true and true initial latch input"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch falCleFalIni
    "Latch block with clear input being contantly false and false initial latch input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch truCleFalIni
    "Latch block with clear input being contantly true and false initial latch input"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch swiCleInp
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch swiCleInp1
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cleInp(
    final width=0.5,
    final period=6)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logcal not"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false)
    "False clear input"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.5,
    final period=2)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true)
    "True clear input"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  connect(cleInp.y,swiCleInp.clr)
    annotation (Line(points={{22,40},{70,40},{70,94},{98,94}},color={255,0,255}));
  connect(not1.u,cleInp.y)
    annotation (Line(points={{38,-60},{30,-60},{30,40},{22,40}},color={255,0,255}));
  connect(not1.y,swiCleInp1.clr)
    annotation (Line(points={{62,-60},{72,-60},{72,-66},{98,-66}},color={255,0,255}));
  connect(fal.y,falCleTruIni.clr)
    annotation (Line(points={{-98,80},{-70,80},{-70,94},{-62,94}},color={255,0,255}));
  connect(latInp.y,falCleTruIni.u)
    annotation (Line(points={{-138,160},{-80,160},{-80,100},{-62,100}},color={255,0,255}));
  connect(tru.y,truCleTruIni.clr)
    annotation (Line(points={{-98,-60},{-70,-60},{-70,-46},{-62,-46}},color={255,0,255}));
  connect(latInp.y,truCleTruIni.u)
    annotation (Line(points={{-138,160},{-80,160},{-80,-40},{-62,-40}},color={255,0,255}));
  connect(latInp.y,swiCleInp.u)
    annotation (Line(points={{-138,160},{80,160},{80,100},{98,100}},color={255,0,255}));
  connect(latInp.y,swiCleInp1.u)
    annotation (Line(points={{-138,160},{80,160},{80,-60},{98,-60}},color={255,0,255}));
  connect(latInp.y,not2.u)
    annotation (Line(points={{-138,160},{-130,160},{-130,0},{-122,0}},color={255,0,255}));
  connect(not2.y,falCleFalIni.u)
    annotation (Line(points={{-98,0},{-90,0},{-90,40},{-62,40}},color={255,0,255}));
  connect(fal.y,falCleFalIni.clr)
    annotation (Line(points={{-98,80},{-70,80},{-70,34},{-62,34}},color={255,0,255}));
  connect(tru.y,truCleFalIni.clr)
    annotation (Line(points={{-98,-60},{-70,-60},{-70,-106},{-62,-106}},color={255,0,255}));
  connect(not2.y,truCleFalIni.u)
    annotation (Line(points={{-98,0},{-90,0},{-90,-100},{-62,-100}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Latch.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Latch\">
Buildings.Controls.OBC.CDL.Logical.Latch</a>. Following tests are implemented:
</p>
<ul>
<li>
When the clear input is <code>false</code>, the initial output should equal to the initial latch input.
</li>
<li>
When the clear input is <code>true</code>, the initial output should be <code>false</code>,
regardless of the value of the latch input.
</li>
<li>
At the same moment, when both the clear input and the latch input rise from <code>false</code>
to <code>true</code>, the output should become <code>false</code> if it was <code>true</code>,
or remain <code>false</code> if it was <code>false</code>.
</li>
<li>
At the same moment, when the clear input falls from <code>true</code> to <code>false</code>
and the latch input rises from <code>false</code> to <code>true</code>, the output
should rise from <code>false</code> to <code>true</code>.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Added test to validate initial output. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
</li>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-180,-180},{180,180}}),
      graphics={
        Text(
          extent={{-68,140},{-2,130}},
          textColor={28,108,200},
          textString="Clear input keeps false"),
        Text(
          extent={{76,148},{136,140}},
          textColor={28,108,200},
          textString="At 3rd second:"),
        Text(
          extent={{92,128},{172,118}},
          textColor={28,108,200},
          textString="Clear input falls: true to false"),
        Text(
          extent={{92,138},{170,128}},
          textColor={28,108,200},
          textString="Latch input falls: true to false"),
        Text(
          extent={{92,64},{170,56}},
          textColor={28,108,200},
          textString="Clear input rises: false to true"),
        Text(
          extent={{92,76},{172,66}},
          textColor={28,108,200},
          textString="Latch input rise: false to true"),
        Text(
          extent={{76,86},{136,78}},
          textColor={28,108,200},
          textString="At 6th second:"),
        Text(
          extent={{92,-96},{172,-104}},
          textColor={28,108,200},
          textString="Clear input falls: true to false"),
        Text(
          extent={{92,-84},{172,-94}},
          textColor={28,108,200},
          textString="Latch input rise: false to true"),
        Text(
          extent={{76,-74},{136,-82}},
          textColor={28,108,200},
          textString="At 6th second:"),
        Text(
          extent={{76,-12},{136,-20}},
          textColor={28,108,200},
          textString="At 3rd second:"),
        Text(
          extent={{92,-32},{172,-42}},
          textColor={28,108,200},
          textString="Clear input rises: false to true"),
        Text(
          extent={{92,-22},{170,-32}},
          textColor={28,108,200},
          textString="Latch input falls: true to false"),
        Text(
          extent={{-68,130},{-24,122}},
          textColor={28,108,200},
          textString="True initial input"),
        Text(
          extent={{-68,66},{-24,58}},
          textColor={28,108,200},
          textString="False initial input"),
        Text(
          extent={{-68,76},{-2,66}},
          textColor={28,108,200},
          textString="Clear input keeps false"),
        Text(
          extent={{-68,-14},{-24,-22}},
          textColor={28,108,200},
          textString="True initial input"),
        Text(
          extent={{-68,-4},{-2,-14}},
          textColor={28,108,200},
          textString="Clear input keeps true"),
        Text(
          extent={{-66,-74},{-22,-82}},
          textColor={28,108,200},
          textString="False initial input"),
        Text(
          extent={{-66,-64},{0,-74}},
          textColor={28,108,200},
          textString="Clear input keeps false")}));
end Latch;
