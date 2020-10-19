within Buildings.Experimental.NatVentControl.Lockouts.SubLockouts;
block RainLockout "Locks out natural ventilation if rain is detected"
   parameter Real locTimRai(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800  "Time for which natural ventilation is locked out after rain is detected";
  Controls.OBC.CDL.Interfaces.BooleanInput uRai
    "True if it is raining; false if not" annotation (Placement(transformation(
          extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yRaiNatVenSig
    "True if natural ventilation is allowed, false if natural ventilation is locked out due to rain"
                                                          annotation (Placement(
        transformation(extent={{100,-10},{140,30}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=locTimRai,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(not1.y,yRaiNatVenSig)
    annotation (Line(points={{62,10},{120,10}}, color={255,0,255}));
  connect(uRai, truFalHol.u)
    annotation (Line(points={{-120,10},{-42,10}}, color={255,0,255}));
  connect(truFalHol.y, not1.u)
    annotation (Line(points={{-18,10},{38,10}}, color={255,0,255}));
  annotation (defaultComponentName = "raiLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation for a user-specified amount of time (locTimRai, typically 30 minutes) if rain is detected. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
          textString="R"),
        Text(
          lineColor={0,0,255},
          extent={{-144,104},{156,144}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(
          extent={{-94,102},{306,70}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Rain Lockout: 
Locks out natural ventilation for a user-specified duration if rain is detected")}));
end RainLockout;
