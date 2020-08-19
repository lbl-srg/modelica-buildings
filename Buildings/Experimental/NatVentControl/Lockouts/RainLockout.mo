within Buildings.Experimental.NatVentControl.Lockouts;
block RainLockout "Locks out natural ventilation if rain is detected"
   parameter Real TiRai(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800  "Time for which natural ventilation is locked out after rain is detected";
  Controls.OBC.CDL.Interfaces.BooleanInput raiSig
    "True if it is raining; false if not" annotation (Placement(transformation(
          extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigRai annotation (Placement(
        transformation(extent={{100,-10},{140,30}}), iconTransformation(extent={{100,-20},
            {140,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=TiRai,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(not1.y, natVenSigRai)
    annotation (Line(points={{62,10},{120,10}}, color={255,0,255}));
  connect(raiSig, truFalHol.u)
    annotation (Line(points={{-120,10},{-42,10}}, color={255,0,255}));
  connect(truFalHol.y, not1.u)
    annotation (Line(points={{-18,10},{38,10}}, color={255,0,255}));
  annotation (defaultComponentName = "RainLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation for a user-specified amount of time if rain is detected. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,40},{-60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,86},{60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,40},{54,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-22,42},{28,-54}},
          lineColor={28,108,200},
          textString="R")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end RainLockout;
