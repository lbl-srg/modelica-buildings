within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts;
block ManualOverrideLockout
  "Locks out natural ventilation if manual override is on"
  Controls.OBC.CDL.Interfaces.BooleanInput uManOveRid
    "True if manual override; false if not" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yManOveNatVenSig
    "True if natural ventilation is allowed; false if natural ventilation is locked out due to manual override"
                                                                                                               annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
equation
  connect(not1.y,yManOveNatVenSig)
    annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
  connect(uManOveRid, not1.u)
    annotation (Line(points={{-120,10},{-2,10}}, color={255,0,255}));
  annotation (defaultComponentName = "manLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if a manual override is specified. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
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
          textString="M"),
        Text(
          lineColor={0,0,255},
          extent={{-146,102},{154,142}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(
          extent={{-96,104},{304,72}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Manual Override Lockout:
Locks out natural ventilation if manual override is on")}));
end ManualOverrideLockout;
