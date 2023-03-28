within Buildings.Controls.OBC.CDL.Logical.Validation;
model Proof "Validation model for the Proof block"
  Buildings.Controls.OBC.CDL.Logical.Proof pro(
    final valInpDel=2,
    final difCheDel=0.5)
    "Both inputs change at the same time"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro1(
    final valInpDel=2,
    final difCheDel=0.5)
    "Commanded input changes from true to false earlier than measured input"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro2(
    final valInpDel=2,
    final difCheDel=0.5)
    "Measured input changes from true to false earlier than commanded input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro3(
    final valInpDel=0.5,
    final difCheDel=0.5) "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro4(
    final valInpDel=0.5,
    final difCheDel=0.5) "Shorter delay to valid input"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp1(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp2(
    final width=0.1,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(latInp.y, pro.uMea) annotation (Line(points={{-58,80},{-40,80},{-40,86},
          {-22,86}},      color={255,0,255}));
  connect(latInp1.y, pro.uCom) annotation (Line(points={{-58,20},{-32,20},{-32,74},
          {-22,74}},      color={255,0,255}));
  connect(latInp1.y, pro1.uMea) annotation (Line(points={{-58,20},{-32,20},{-32,
          46},{-22,46}},  color={255,0,255}));
  connect(latInp2.y, pro1.uCom) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          34},{-22,34}},  color={255,0,255}));
  connect(latInp1.y, pro2.uCom) annotation (Line(points={{-58,20},{-32,20},{-32,
          -6},{-22,-6}},    color={255,0,255}));
  connect(latInp2.y, pro2.uMea) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          6},{-22,6}},      color={255,0,255}));
  connect(latInp1.y,pro4. uMea) annotation (Line(points={{-58,20},{-32,20},{-32,
          -74},{-22,-74}}, color={255,0,255}));
  connect(latInp2.y,pro4. uCom) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          -86},{-22,-86}}, color={255,0,255}));
  connect(latInp1.y, pro3.uCom) annotation (Line(points={{-58,20},{-32,20},{-32,
          -46},{-22,-46}}, color={255,0,255}));
  connect(latInp2.y, pro3.uMea) annotation (Line(points={{-58,-50},{-40,-50},{-40,
          -34},{-22,-34}}, color={255,0,255}));
annotation (
    experiment(StopTime=10.0, Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Proof.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Proof\">
Buildings.Controls.OBC.CDL.Logical.Proof</a>. Following tests are implemented:
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
