within Buildings.Experimental.NatVentControl.Lockouts.SubLockouts;
block OccupancyLockout
  "Locks out natural ventilation if room is unoccupied and night flush mode is off"
  Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "True if room is occupied; false if not" annotation (Placement(
        transformation(extent={{-140,30},{-100,70}}), iconTransformation(extent=
           {{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yOccNatVenSig
    "True if nat vent allowed, false if nat vent locked out" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uNitFlu
    "True if night flush mode on; false if not" annotation (Placement(
        transformation(extent={{-140,-50},{-100,-10}}), iconTransformation(
          extent={{-140,8},{-100,48}})));
  Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(uOcc, or2.u1) annotation (Line(points={{-120,50},{-60,50},{-60,10},{-2,
          10}}, color={255,0,255}));
  connect(uNitFlu, or2.u2) annotation (Line(points={{-120,-30},{-62,-30},{-62,2},
          {-2,2}}, color={255,0,255}));
  connect(or2.y,yOccNatVenSig)
    annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "occLoc", Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the building is unoccupied, unless night flush mode is on. 
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
          textString="O"),
        Text(
          lineColor={0,0,255},
          extent={{-138,100},{162,140}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(
          extent={{-96,106},{304,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Occupancy Lockout:
Locks out natural ventilation if building is unoccupied AND night flush signal is off")}));
end OccupancyLockout;
