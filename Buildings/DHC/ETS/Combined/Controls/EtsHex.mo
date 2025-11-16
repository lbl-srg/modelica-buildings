within Buildings.DHC.ETS.Combined.Controls;
model EtsHex "Controller for enabling the ETS heat exchanger"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput on
    "If true, operate heat exchanger" annotation (Placement(transformation(
          rotation=0, extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal1(
   final min=0,
   final max=1,
   final unit="1") "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal2(
   final min=0,
   final max=1,
   final unit="1") "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-140,-60},{-100,
            -20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Add yVal
    "Sum of valve position to ensure that one of the two isolation valves is sufficiently open"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valOpe(t=0.3, h=0.05)
    "Outputs true if at least one valve is partially open"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(yVal1,yVal. u1) annotation (Line(points={{-120,60},{-80,60},{-80,6},{
          -42,6}},    color={0,0,127}));
  connect(yVal2,yVal. u2) annotation (Line(points={{-120,-40},{-80,-40},{-80,-6},
          {-42,-6}},  color={0,0,127}));
  connect(valOpe.u,yVal. y)
    annotation (Line(points={{18,0},{-18,0}},      color={0,0,127}));
  connect(valOpe.y, on)
    annotation (Line(points={{42,0},{110,0}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Controller for enabling the ETS heat exchanger pump.
</p>
<p>
The controller outputs <i>true</i> to enable the heat exchanger pump if
no tank is requesting to be charged, and
if at least one of the two isolation valves is sufficiently open.
Otherwise, the controller outputs <i>false</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
</ul>
</html>"));
end EtsHex;
