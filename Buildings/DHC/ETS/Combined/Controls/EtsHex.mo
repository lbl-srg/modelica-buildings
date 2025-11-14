within Buildings.DHC.ETS.Combined.Controls;
model EtsHex "Controller for enabling the ETS heat exchanger"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
   final min=0,
   final max=1,
   final unit="1")
   annotation (Placement(
        transformation(rotation=0, extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTan1
    "Charge signal from tank 1" annotation (Placement(transformation(extent={{-140,
            40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTan2
    "Charge signal from tank 2" annotation (Placement(transformation(extent={{-140,
            0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal1(
   final min=0,
   final max=1,
   final unit="1") "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal2(
   final min=0,
   final max=1,
   final unit="1") "Valve position"
    annotation (Placement(transformation(rotation=0, extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-102},{-100,-62}})));

  Buildings.Controls.OBC.CDL.Logical.Nor opeEtsHex
    "Output true to operate ETS heat exchanger"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal uEtsHex(realTrue=0,
      realFalse=1) "Control signal for ETS heat exchanger"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Add yVal
    "Sum of valve position to ensure that one of the two isolation valves is sufficiently open"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valOpe(t=0.3, h=0.05)
    "Outputs true if at least one valve is partially open"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(opeEtsHex.y,uEtsHex. u)
    annotation (Line(points={{-38,60},{-22,60}},     color={255,0,255}));
  connect(uTan1, opeEtsHex.u1)
    annotation (Line(points={{-120,60},{-62,60}}, color={255,0,255}));
  connect(uTan2, opeEtsHex.u2) annotation (Line(points={{-120,20},{-80,20},{-80,
          52},{-62,52}}, color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{82,0},{110,0}},
        color={0,0,127}));
  connect(yVal1,yVal. u1) annotation (Line(points={{-120,-20},{-90,-20},{-90,
          -64},{-82,-64}},
                      color={0,0,127}));
  connect(yVal2,yVal. u2) annotation (Line(points={{-120,-60},{-96,-60},{-96,-76},
          {-82,-76}}, color={0,0,127}));
  connect(valOpe.u,yVal. y)
    annotation (Line(points={{-42,-70},{-58,-70}}, color={0,0,127}));
  connect(swi.u1, uEtsHex.y)
    annotation (Line(points={{58,8},{8,8},{8,60},{2,60}},
                                                        color={0,0,127}));
  connect(valOpe.y, swi.u2) annotation (Line(points={{-18,-70},{14,-70},{14,0},{
          58,0}}, color={255,0,255}));
  connect(zer.y, swi.u3) annotation (Line(points={{42,-30},{50,-30},{50,-8},{58,
          -8}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Controller for enabling the ETS heat exchanger pump.
</p>
<p>
The controller outputs <i>1</i> to enable the heat exchanger pump if
no tank is requesting to be charged, and
if at least one of the two isolation valves is sufficiently open.
Otherwise, the controller outputs <i>0</i>.
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
