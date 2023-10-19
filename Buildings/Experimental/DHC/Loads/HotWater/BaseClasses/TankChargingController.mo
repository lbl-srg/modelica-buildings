within Buildings.Experimental.DHC.Loads.HotWater.BaseClasses;
block TankChargingController
  "Controller to enable or disable storage tank charging"

  Controls.OBC.CDL.Interfaces.RealInput TTanTop(
    final unit="K",
    displayUnit="degC")
    "Measured temperature at top of tank" annotation (Placement(transformation(
          extent={{-140,-60},{-100,-20}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput TTanTopSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint for top section of hot water tank" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Outputs true if tank should be charged" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));
protected
  Controls.OBC.CDL.Reals.Hysteresis cha(uLow=-5, uHigh=0)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(sub.u2, TTanTop) annotation (Line(points={{-42,-6},{-60,-6},{-60,-40},
          {-120,-40}}, color={0,0,127}));
  connect(sub.u1, TTanTopSet) annotation (Line(points={{-42,6},{-60,6},{-60,40},
          {-120,40}}, color={0,0,127}));
  connect(sub.y, cha.u)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(cha.y, charge)
    annotation (Line(points={{42,0},{120,0}}, color={255,0,255}));
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
          extent={{-94,78},{-44,42}},
          textColor={0,0,127},
          textString="TTanTopSet"),
        Text(
          extent={{-94,-42},{-44,-78}},
          textColor={0,0,127},
          textString="TTanTop"),
        Text(
          extent={{42,20},{92,-16}},
          textColor={0,0,127},
          textString="charge")}),
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
