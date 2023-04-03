within Buildings.Controls.OBC.CDL.Logical.Validation;
model Proof "Validation model for the Proof block"
  Buildings.Controls.OBC.CDL.Logical.Proof pro(
    final debounce=0.5,
    final feedbackDelay=0.75) "Both inputs change at the same time"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro1(
    final debounce=0.5,
    final feedbackDelay=0.75)
    "Commanded input changes from true to false earlier than measured input"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro2(
    final debounce=0.5,
    final feedbackDelay=0.75)
    "Measured input changes from true to false earlier than commanded input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro3(
    final debounce=0.5,
    final feedbackDelay=0.5)
    "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro4(
    final debounce=0.5,
    final feedbackDelay=0.5)
    "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp1(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp2(
    final width=0.1,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

equation
  connect(latInp1.y, pro.u_s) annotation (Line(points={{-18,20},{10,20},{10,80},
          {18,80}}, color={255,0,255}));
  connect(latInp2.y, pro1.u_s) annotation (Line(points={{-18,-50},{0,-50},{0,40},
          {18,40}}, color={255,0,255}));
  connect(latInp1.y, pro2.u_s) annotation (Line(points={{-18,20},{10,20},{10,0},
          {18,0}},  color={255,0,255}));
  connect(latInp2.y, pro4.u_s) annotation (Line(points={{-18,-50},{0,-50},{0,-80},
          {18,-80}}, color={255,0,255}));
  connect(latInp1.y, pro3.u_s) annotation (Line(points={{-18,20},{10,20},{10,-40},
          {18,-40}}, color={255,0,255}));
  connect(latInp.y, pro.u_m) annotation (Line(points={{-18,80},{0,80},{0,64},{30,
          64},{30,68}}, color={255,0,255}));
  connect(latInp1.y, pro4.u_m) annotation (Line(points={{-18,20},{10,20},{10,-96},
          {30,-96},{30,-92}}, color={255,0,255}));
  connect(latInp2.y, pro3.u_m) annotation (Line(points={{-18,-50},{0,-50},{0,-56},
          {30,-56},{30,-52}}, color={255,0,255}));
  connect(latInp2.y, pro2.u_m) annotation (Line(points={{-18,-50},{0,-50},{0,-16},
          {30,-16},{30,-12}}, color={255,0,255}));
  connect(latInp1.y, pro1.u_m) annotation (Line(points={{-18,20},{10,20},{10,24},
          {30,24},{30,28}}, color={255,0,255}));
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
after the input <code>uMea</code> changes, the input <code>uCom</code> remains
<code>true</code> for a time that is longer than
<code>feedbackDelay</code>. The output <code>yProTru</code> will be <code>true</code>.
This is tested through instances <code>pro2</code> and <code>pro3</code>, with
different delay <code>feedbackDelay</code> for checking the input difference.
</li>
<li>
Both the inputs change from <code>true</code> to <code>false</code>. However,
after the input <code>uCom</code> changes, the input <code>uMea</code> remains
<code>true</code> for a time that is longer than
<code>feedbackDelay</code>. The output <code>yProFal</code> will be <code>true</code>.
This is tested through instances <code>pro1</code> and <code>pro4</code>, with
different delay <code>feedbackDelay</code> for checking the inputs.
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
