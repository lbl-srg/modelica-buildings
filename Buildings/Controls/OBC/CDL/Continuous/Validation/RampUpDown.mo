within Buildings.Controls.OBC.CDL.Continuous.Validation;
model RampUpDown "Validation model for the RampUpDown block"
  Buildings.Controls.OBC.CDL.Continuous.RampUpDown
                                             sorAsc(upDuration=5)
    "Block that sorts signals in ascending order"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Logical.Sources.Pulse                            booPul(width=0.5, period=12)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Logical.Sources.Constant                         con(k=false)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(booPul.y, sorAsc.up) annotation (Line(points={{-58,50},{-20,50},{-20,36},
          {-2,36}}, color={255,0,255}));
  connect(con.y, sorAsc.down) annotation (Line(points={{-58,10},{-8,10},{-8,24},
          {-2,24}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/RampUpDown.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.RampUpDown\">
Buildings.Controls.OBC.CDL.Continuous.RampUpDown</a>.
</p>


<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+2</i>,
input <code>u3</code> varies from <i>+2</i> to <i>-2</i>, input <code>u4</code> varies from <i>+3</i> to <i>+2</i>,
input <code>u5</code> varies from <i>0</i> to <i>+4</i>,
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 8, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end RampUpDown;
