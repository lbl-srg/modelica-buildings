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
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TTanBot(final unit="K", displayUnit=
        "degC") "Measured temperature at bottom of tank" annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Controls.OBC.CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
protected
  Controls.OBC.CDL.Reals.Hysteresis cha(uLow=-5, uHigh=0)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

protected
  Controls.OBC.CDL.Reals.Hysteresis cha1(uLow=-5, uHigh=0)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(sub.u2, TTanTop) annotation (Line(points={{-42,-6},{-80,-6},{-80,0},{
          -120,0}},    color={0,0,127}));
  connect(sub.u1, TTanTopSet) annotation (Line(points={{-42,6},{-80,6},{-80,70},
          {-120,70}}, color={0,0,127}));
  connect(sub.y, cha.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(sub1.y, cha1.u)
    annotation (Line(points={{-18,-60},{-2,-60}}, color={0,0,127}));
  connect(TTanTopSet, sub1.u1) annotation (Line(points={{-120,70},{-80,70},{-80,
          6},{-50,6},{-50,-54},{-42,-54}}, color={0,0,127}));
  connect(TTanBot, sub1.u2) annotation (Line(points={{-120,-100},{-80,-100},{
          -80,-66},{-42,-66}}, color={0,0,127}));
  connect(cha.y, lat.u)
    annotation (Line(points={{22,0},{48,0}}, color={255,0,255}));
  connect(lat.y, charge)
    annotation (Line(points={{72,0},{120,0}}, color={255,0,255}));
  connect(cha1.y, not1.u)
    annotation (Line(points={{22,-60},{28,-60}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{52,-60},{60,-60},{60,-34},
          {40,-34},{40,-6},{48,-6}}, color={255,0,255}));
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
measured top and bottom tank temperatures and the tank's set point.
If the top temperature is below the set point with hysteresis, 
charging is enabled until the bottom temperature reaches the set point with
hysteresis, at which point charging is disabled.  
The hysteresis is <i>5</i> Kelvin.
</p>
</html>"));
end TankChargingController;
