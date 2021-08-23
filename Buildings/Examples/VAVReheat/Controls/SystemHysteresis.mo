within Buildings.Examples.VAVReheat.Controls;
model SystemHysteresis
  "Block that applies hysteresis and a minimum on timer to a control signal"

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration(
        displayUnit="h") = 21600,                                                  final
      falseHoldDuration=0) "Keep pump running at least for trueHoldDuration"
    annotation (Placement(transformation(extent={{-11,-10},{9,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=0.02, h=0.01/
        2)
    "Threshold to switch on system"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch for control signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Control signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    "Zero output signal"
    annotation (Placement(transformation(extent={{-10,-78},{10,-58}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum
    "Control signal for pump" annotation (Placement(transformation(extent={{100,
            -90},{140,-50}}), iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
                                                "Switch for control signal"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    "Constant output signal of one"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
  connect(greThr.u, u)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));
  connect(greThr.y, truFalHol.u)
    annotation (Line(points={{-38,0},{-13,0}}, color={255,0,255}));
  connect(truFalHol.y, swi.u2)
    annotation (Line(points={{11,0},{38,0}}, color={255,0,255}));
  connect(swi.u1, u) annotation (Line(points={{38,8},{20,8},{20,20},{-90,20},{-90,
          0},{-120,0}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{12,-68},{32,-68},{32,-8},{38,
          -8}}, color={0,0,127}));
  connect(truFalHol.y, swi1.u2) annotation (Line(points={{11,0},{28,0},{28,-60},
          {38,-60}}, color={255,0,255}));
  connect(con.y, swi1.u3)
    annotation (Line(points={{12,-68},{38,-68}}, color={0,0,127}));
  connect(one.y, swi1.u1) annotation (Line(points={{12,-30},{20,-30},{20,-52},{
          38,-52}}, color={0,0,127}));
  connect(swi1.y, yPum) annotation (Line(points={{62,-60},{80,-60},{80,-70},{
          110,-70}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-48,154},{42,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if truFalHol.y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if truFalHol.y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},
            if truFalHol.u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if truFalHol.u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,30},{38,-18}},
          lineColor={0,0,0},
          textString="y = %y")}),
    Documentation(info="<html>
<p>
Block that ensure that the system runs for a minimum time once it is switched on.
</p>
</html>"));
end SystemHysteresis;
