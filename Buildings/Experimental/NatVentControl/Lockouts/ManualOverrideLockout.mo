<<<<<<< HEAD
within Buildings.Experimental.NatVentControl.Lockouts;
block ManualOverrideLockout
  "Locks out natural ventilation if manual override is on"
  Controls.OBC.CDL.Interfaces.BooleanInput manOvrSig
    "True if manual override; false if not" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigManOvr annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
equation
  connect(manOvrSig, not1.u)
    annotation (Line(points={{-120,10},{-2,10}}, color={255,0,255}));
  connect(not1.y, natVenSigManOvr)
    annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "ManualOverrideLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if a manual override is specified. 
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
          textString="M")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ManualOverrideLockout;
=======
within Buildings.Experimental.NatVentControl.Lockouts;
block ManualOverrideLockout
  "Locks out natural ventilation if manual override is on"
  Controls.OBC.CDL.Interfaces.BooleanInput manOvrSig
    "True if manual override; false if not" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigManOvr annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
equation
  connect(manOvrSig, not1.u)
    annotation (Line(points={{-120,10},{-2,10}}, color={255,0,255}));
  connect(not1.y, natVenSigManOvr)
    annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "ManualOverrideLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if a manual override is specified. 
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
          textString="M")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ManualOverrideLockout;
>>>>>>> 2008edcd25685faae709310e80edf551fd923411
