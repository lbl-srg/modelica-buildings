within Buildings.Experimental.DHC.Loads.HotWater.BaseClasses;
block TankChargingController
  "Controller to enable or disable storage tank charging"

  Controls.OBC.CDL.Interfaces.RealInput TTanTop(
    final unit="K",
    displayUnit="degC") "Measured temperature at top of tank"
                                          annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),  iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TTanTopSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint for top section of hot water tank" annotation (
      Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Outputs true if tank should be charged" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TTanBot(final unit="K", displayUnit=
        "degC") "Measured temperature at bottom of tank" annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
protected
  Controls.OBC.CDL.Reals.Hysteresis cha(uLow=-5, uHigh=0)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

protected
  Controls.OBC.CDL.Reals.Hysteresis cha1(uLow=-5, uHigh=0)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(sub.u2, TTanTop) annotation (Line(points={{-42,-6},{-80,-6},{-80,0},{
          -120,0}},    color={0,0,127}));
  connect(sub.u1, TTanTopSet) annotation (Line(points={{-42,6},{-80,6},{-80,70},
          {-120,70}}, color={0,0,127}));
  connect(sub.y, cha.u)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(sub1.y, cha1.u)
    annotation (Line(points={{-18,-60},{18,-60}}, color={0,0,127}));
  connect(TTanTopSet, sub1.u1) annotation (Line(points={{-120,70},{-80,70},{-80,
          6},{-50,6},{-50,-54},{-42,-54}}, color={0,0,127}));
  connect(TTanBot, sub1.u2) annotation (Line(points={{-120,-100},{-80,-100},{
          -80,-66},{-42,-66}}, color={0,0,127}));
  connect(or2.y, charge)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));
  connect(cha.y, or2.u1)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));
  connect(or2.u2, cha1.y) annotation (Line(points={{58,-8},{50,-8},{50,-60},{42,
          -60}}, color={255,0,255}));
  annotation (
  defaultComponentName="tanCha",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-96,98},{-46,62}},
          textColor={0,0,127},
          textString="TTanTopSet"),
        Text(
          extent={{-96,18},{-46,-18}},
          textColor={0,0,127},
          textString="TTanTop"),
        Text(
          extent={{42,20},{92,-16}},
          textColor={0,0,127},
          textString="charge"),
        Text(
          extent={{-96,-62},{-46,-98}},
          textColor={0,0,127},
          textString="TTanBot")}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 4, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Controller that outputs <code>charge=true</code> if the domestic hot
water tank needs to be charged, and <code>false</code> otherwise.
</p>
<p>
Whether the tank needs to be charged depends on the difference between the
measured tank temperature and its set point.
The charge signal has a hysteresis of <i>5</i> Kelvin.
</p>
</html>"));
end TankChargingController;
