within Buildings.Controls.OBC.CDL.Logical.Validation;
model Proof "Validation model for the Proof block"
  Buildings.Controls.OBC.CDL.Logical.Proof pro(
    debounce=0.5,
    feedbackDelay=0.75) "Both inputs change at the same time"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro1(
    debounce=0.5,
    feedbackDelay=0.75)
    "Commanded input changes from true to false earlier than measured input"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro2(
    debounce=0.5,
    feedbackDelay=0.75)
    "Measured input changes from true to false earlier than commanded input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro3(
    debounce=0.5,
    feedbackDelay=0.5)
    "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro4(
    debounce=0.5,
    feedbackDelay=0.5)
    "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro5(
    debounce=2,
    feedbackDelay=2)
    "Both inputs change at the same time"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    width=0.2,
    period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp1(
    width=0.2,
    period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp2(
    width=0.1,
    period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp3(
    width=0.5,
    period=2,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp4(
    width=0.9,
    period=12,
    shift=0.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  connect(latInp1.y, pro.u_s) annotation (Line(points={{-58,20},{-30,20},{-30,80},
          {-22,80}},color={255,0,255}));
  connect(latInp2.y, pro1.u_s) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          40},{-22,40}}, color={255,0,255}));
  connect(latInp1.y, pro2.u_s) annotation (Line(points={{-58,20},{-30,20},{-30,0},
          {-22,0}}, color={255,0,255}));
  connect(latInp2.y, pro4.u_s) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          -80},{-22,-80}}, color={255,0,255}));
  connect(latInp1.y, pro3.u_s) annotation (Line(points={{-58,20},{-30,20},{-30,-40},
          {-22,-40}},color={255,0,255}));
  connect(latInp.y, pro.u_m) annotation (Line(points={{-58,64},{-10,64},{-10,68}},
          color={255,0,255}));
  connect(latInp1.y, pro4.u_m) annotation (Line(points={{-58,20},{-30,20},{-30,-96},
          {-10,-96},{-10,-92}}, color={255,0,255}));
  connect(latInp2.y, pro3.u_m) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          -56},{-10,-56},{-10,-52}}, color={255,0,255}));
  connect(latInp2.y, pro2.u_m) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          -16},{-10,-16},{-10,-12}}, color={255,0,255}));
  connect(latInp1.y, pro1.u_m) annotation (Line(points={{-58,20},{-30,20},{-30,24},
          {-10,24},{-10,28}}, color={255,0,255}));
  connect(latInp3.y, pro5.u_m)
    annotation (Line(points={{62,40},{70,40},{70,68}}, color={255,0,255}));
  connect(latInp4.y, pro5.u_s)
    annotation (Line(points={{42,80},{58,80}}, color={255,0,255}));
annotation (
    experiment(StopTime=10.0, Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Proof.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Proof\">
Buildings.Controls.OBC.CDL.Logical.Proof</a>. The following tests are implemented:
</p>
<ul>
<li>
If both boolean inputs change simultaneously, both outputs will be
<code>false</code>. It is tested through instance <code>pro</code>.
</li>
<li>
Both the inputs change from <code>true</code> to <code>false</code>. However,
after the input <code>u_m</code> changes, the input <code>u_s</code> remains
<code>true</code> for a time that is longer than
<code>feedbackDelay</code>. The output <code>yProTru</code> will be <code>true</code>.
This is tested through instances <code>pro2</code> and <code>pro3</code>, with
different delay <code>feedbackDelay</code> for checking the input difference.
</li>
<li>
Both the inputs change from <code>true</code> to <code>false</code>. However,
after the input <code>u_s</code> changes, the input <code>u_m</code> remains
<code>true</code> for a time that is longer than
<code>feedbackDelay</code>. The output <code>yProFal</code> will be <code>true</code>.
This is tested through instances <code>pro1</code> and <code>pro4</code>, with
different delay <code>feedbackDelay</code> for checking the inputs.
</li>
<li>
It also tests the case when the measured input <code>u_m</code> cannot stay stable
for the debounce time. In this case, both the outputs will be <code>true</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 27, 2023, by Jianjun Hu:<br/>
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
        extent={{-100,-100},{100,100}})));
end Proof;
