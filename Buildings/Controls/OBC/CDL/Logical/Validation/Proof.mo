within Buildings.Controls.OBC.CDL.Logical.Validation;
model Proof "Validation model for the Proof block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Logical.Proof pro(debounce=2, delay=0.5)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Sources.Pulse                                    latInp1(
    final width=0.2,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro1(debounce=2, delay=0.5)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Sources.Pulse                                    latInp2(
    final width=0.1,
    final period=10,
    shift=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-160,-2},{-140,18}})));
  Buildings.Controls.OBC.CDL.Logical.Proof pro2(debounce=2, delay=0.5)
    annotation (Placement(transformation(extent={{-100,-32},{-80,-12}})));
equation
  connect(latInp.y, pro.u1) annotation (Line(points={{-138,110},{-120,110},{
          -120,96},{-102,96}}, color={255,0,255}));
  connect(latInp1.y, pro.u2) annotation (Line(points={{-138,60},{-110,60},{-110,
          84},{-102,84}}, color={255,0,255}));
  connect(latInp1.y, pro1.u1) annotation (Line(points={{-138,60},{-110,60},{
          -110,36},{-102,36}}, color={255,0,255}));
  connect(latInp2.y, pro1.u2) annotation (Line(points={{-138,8},{-130,8},{-130,
          24},{-102,24}}, color={255,0,255}));
  connect(latInp1.y, pro2.u2) annotation (Line(points={{-138,60},{-110,60},{
          -110,-28},{-102,-28}}, color={255,0,255}));
  connect(latInp2.y, pro2.u1) annotation (Line(points={{-138,8},{-130,8},{-130,
          -16},{-102,-16}}, color={255,0,255}));
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
        extent={{-180,-180},{180,180}})));
end Proof;
