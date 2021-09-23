within Buildings.Controls.OBC.CDL.Logical.Validation;
model Toggle
  "Validation model for the Toggle block"
  Buildings.Controls.OBC.CDL.Logical.Toggle falCleTruIni
    "Toggle block with clear input being contantly false and true initial toggle input"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle falCleFalIni
    "Toggle block with clear input being contantly false and false initial toggle input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle truCleTruIni
    "Toggle block with clear input being contantly true and true initial toggle input"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle truCleFalIni
    "Toggle block with clear input being contantly true and false initial toggle input"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle swiCleInp
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle swiCleInp1
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cleInp(
    final width=0.5,
    final period=6)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse togInp(
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
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false)
    "False clear input"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

equation
  connect(cleInp.y,swiCleInp.clr)
    annotation (Line(points={{22,80},{70,80},{70,94},{98,94}},color={255,0,255}));
  connect(not1.u,cleInp.y)
    annotation (Line(points={{38,-60},{30,-60},{30,80},{22,80}},color={255,0,255}));
  connect(not1.y,swiCleInp1.clr)
    annotation (Line(points={{62,-60},{72,-60},{72,-66},{98,-66}},color={255,0,255}));
  connect(togInp.y,swiCleInp.u)
    annotation (Line(points={{-138,160},{80,160},{80,100},{98,100}},color={255,0,255}));
  connect(togInp.y,swiCleInp1.u)
    annotation (Line(points={{-138,160},{80,160},{80,-60},{98,-60}},color={255,0,255}));
  connect(togInp.y,falCleTruIni.u)
    annotation (Line(points={{-138,160},{-80,160},{-80,100},{-62,100}},color={255,0,255}));
  connect(fal.y,falCleTruIni.clr)
    annotation (Line(points={{-98,80},{-70,80},{-70,94},{-62,94}},color={255,0,255}));
  connect(togInp.y,truCleTruIni.u)
    annotation (Line(points={{-138,160},{-80,160},{-80,-40},{-62,-40}},color={255,0,255}));
  connect(fal.y,falCleFalIni.clr)
    annotation (Line(points={{-98,80},{-70,80},{-70,34},{-62,34}},color={255,0,255}));
  connect(togInp.y,not2.u)
    annotation (Line(points={{-138,160},{-130,160},{-130,0},{-122,0}},color={255,0,255}));
  connect(not2.y,falCleFalIni.u)
    annotation (Line(points={{-98,0},{-90,0},{-90,40},{-62,40}},color={255,0,255}));
  connect(tru.y,truCleTruIni.clr)
    annotation (Line(points={{-98,-60},{-70,-60},{-70,-46},{-62,-46}},color={255,0,255}));
  connect(tru.y,truCleFalIni.clr)
    annotation (Line(points={{-98,-60},{-70,-60},{-70,-106},{-62,-106}},color={255,0,255}));
  connect(not2.y,truCleFalIni.u)
    annotation (Line(points={{-98,0},{-90,0},{-90,-100},{-62,-100}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Toggle.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Toggle\">
Buildings.Controls.OBC.CDL.Logical.Toggle</a>. Following tests are implemented:
</p>
<ul>
<li>
When the clear input is <code>false</code>, the initial output should equal to the initial toggle input.
</li>
<li>
When the clear input is <code>true</code>, the initial output should be <code>false</code>,
regardless of the value of the toggle input.
</li>
<li>
At the same moment, when both the clear input and the toggle input rise from <code>false</code>
to <code>true</code>, the output should become <code>false</code> if it was <code>true</code>,
or remain <code>false</code> if it was <code>false</code>.
</li>
<li>
At the same moment, when the clear input falls from <code>true</code> to <code>false</code>
and the toggle input rises from <code>false</code> to <code>true</code>, the output
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
March 31, 2017, by Jianjun Hu:<br/>
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
          extent={{76,148},{136,140}},
          lineColor={28,108,200},
          textString="At 3rd second:"),
        Text(
          extent={{92,128},{172,118}},
          lineColor={28,108,200},
          textString="Clear input falls: true to false"),
        Text(
          extent={{92,138},{170,128}},
          lineColor={28,108,200},
          textString="Toggle input falls: true to false"),
        Text(
          extent={{92,64},{170,56}},
          lineColor={28,108,200},
          textString="Clear input rises: false to true"),
        Text(
          extent={{92,76},{172,66}},
          lineColor={28,108,200},
          textString="Toggle input rise: false to true"),
        Text(
          extent={{76,86},{136,78}},
          lineColor={28,108,200},
          textString="At 6th second:"),
        Text(
          extent={{92,-96},{172,-104}},
          lineColor={28,108,200},
          textString="Clear input falls: true to false"),
        Text(
          extent={{92,-84},{172,-94}},
          lineColor={28,108,200},
          textString="Toggle input rise: false to true"),
        Text(
          extent={{76,-74},{136,-82}},
          lineColor={28,108,200},
          textString="At 6th second:"),
        Text(
          extent={{76,-12},{136,-20}},
          lineColor={28,108,200},
          textString="At 3rd second:"),
        Text(
          extent={{92,-32},{172,-42}},
          lineColor={28,108,200},
          textString="Clear input rises: false to true"),
        Text(
          extent={{92,-22},{170,-32}},
          lineColor={28,108,200},
          textString="Toggle input falls: true to false"),
        Text(
          extent={{-68,130},{-24,122}},
          lineColor={28,108,200},
          textString="True initial input"),
        Text(
          extent={{-68,140},{-2,130}},
          lineColor={28,108,200},
          textString="Clear input keeps false"),
        Text(
          extent={{-68,76},{-2,66}},
          lineColor={28,108,200},
          textString="Clear input keeps false"),
        Text(
          extent={{-68,66},{-24,58}},
          lineColor={28,108,200},
          textString="False initial input"),
        Text(
          extent={{-68,-4},{-2,-14}},
          lineColor={28,108,200},
          textString="Clear input keeps true"),
        Text(
          extent={{-68,-14},{-24,-22}},
          lineColor={28,108,200},
          textString="True initial input"),
        Text(
          extent={{-66,-64},{0,-74}},
          lineColor={28,108,200},
          textString="Clear input keeps false"),
        Text(
          extent={{-66,-74},{-22,-82}},
          lineColor={28,108,200},
          textString="False initial input")}));
end Toggle;
