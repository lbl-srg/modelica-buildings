within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block NormalizedTimeDelay
  "Calculate the normalized time delay of the response of a relay controller"
  parameter Real gamma(min=1+1E-6) = 4
    "Asymmetry level of the relay controller";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rho
    "Half period ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput inTun
    "Check if the tuning is ongoing"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau
    "Normalized time delay"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-1)
    "Block that calculates the difference between gamma and 1"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=0.65)
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant asyLev(
    final k=gamma)
    "Asymmetry level of the relay controller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Block that calculates the normalized time delay"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subGamRho
    "Block that calculates the difference between the asymmetry level of the relay controller and the half period ratio"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.35)
    "Gain for the half period ratio"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{20,-48},{40,-28}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: the asymmetry level of the relay controller is lower than the half period ratio. Increase the asymmetry level.")
    "Warning message when asymmetry level is less than the half period ratio"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=1e-6)
    "Output true if the asymmetry level is greater than the half period ratio"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable the assert to check the asymmetry level"
    annotation (Placement(transformation(extent={{26,50},{46,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not and1
    "Disable the assert when the tuning is not ongoing"
    annotation (Placement(transformation(extent={{28,-90},{48,-70}})));
equation
  connect(subGamRho.u1, asyLev.y) annotation (Line(points={{18,26},{-50,26},{
          -50,80},{-58,80}}, color={0,0,127}));
  connect(subGamRho.u2, rho) annotation (Line(points={{18,14},{-90,14},{-90,0},
          {-120,0}}, color={0,0,127}));
  connect(gai.u, rho) annotation (Line(points={{-82,-60},{-90,-60},{-90,0},{
          -120,0}},
               color={0,0,127}));
  connect(div.u1, subGamRho.y)
    annotation (Line(points={{58,6},{50,6},{50,20},{42,20}}, color={0,0,127}));
  connect(div.u2, mul.y) annotation (Line(points={{58,-6},{50,-6},{50,-38},{42,
          -38}}, color={0,0,127}));
  connect(div.y, tau)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(gai.y, addPar2.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(addPar2.y, mul.u2) annotation (Line(points={{-18,-60},{0,-60},{0,-44},
          {18,-44}}, color={0,0,127}));
  connect(addPar1.u, asyLev.y) annotation (Line(points={{-42,-10},{-50,-10},{
          -50,80},{-58,80}}, color={0,0,127}));
  connect(addPar1.y, mul.u1) annotation (Line(points={{-18,-10},{0,-10},{0,-32},
          {18,-32}}, color={0,0,127}));
  connect(asyLev.y, gre.u1) annotation (Line(points={{-58,80},{-50,80},{-50,60},
          {-22,60}}, color={0,0,127}));
  connect(rho, gre.u2) annotation (Line(points={{-120,0},{-90,0},{-90,52},{-22,
          52}},
        color={0,0,127}));
  connect(gre.y, or2.u1)
    annotation (Line(points={{2,60},{24,60}}, color={255,0,255}));
  connect(and1.u, inTun)
    annotation (Line(points={{26,-80},{0,-80},{0,-120}}, color={255,0,255}));
  connect(and1.y, or2.u2) annotation (Line(points={{50,-80},{90,-80},{90,40},{20,
          40},{20,52},{24,52}}, color={255,0,255}));
  connect(or2.y, assMes.u)
    annotation (Line(points={{48,60},{58,60}}, color={255,0,255}));
  annotation (
        defaultComponentName = "norTimDel",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation.<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the normalized time delay of the output from a relay controller.
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau; = (&gamma; - &rho;)/(&gamma; - 1)/(&rho;*0.35+0.65),
</p>
<p>
where <code>&gamma;</code> and <code>&rho;</code> are the asymmetry level of
the relay controller and the half-period ratio, respectively.
</p>
<h4>References</h4>
<p>
J. Berner (2017).
<a href=\"https://lucris.lub.lu.se/ws/portalfiles/portal/33100749/ThesisJosefinBerner.pdf\">
\"Automatic Controller Tuning using Relay-based Model Identification.\"</a>
Department of Automatic Control, Lund University.
</p>
</html>"));
end NormalizedTimeDelay;
