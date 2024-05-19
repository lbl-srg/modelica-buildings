within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences;
block ProportionalRegulator
    "Sequence to calculate regulation signal with measured return temperature as input"

  parameter Real TRetSet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 60
    "Minimum hot water return temperature for optimal non-condensing boiler performance";

  parameter Real TRetMinAll(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 57.2
    "Minimum allowed hot water return temperature for non-condensing boiler";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRegSig(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1)
    "Regulation signal from P-only loop for condensation control"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Compare minimum return temperature setpoint to measured return temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=TRetSet)
    "Constant signal source for minimum return temperature setpoint"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=TRetSet - TRetMinAll,
    final uMin=0)
    "Limit input for calculating control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/(TRetSet - TRetMinAll))
    "Calculate control signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation

  connect(lim.y, gai.u)
    annotation (Line(points={{12,0},{38,0}}, color={0,0,127}));

  connect(gai.y, yRegSig)
    annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));

  connect(THotWatRet, sub.u2) annotation (Line(points={{-120,0},{-80,0},{-80,-6},
          {-62,-6}}, color={0,0,127}));
  connect(con.y, sub.u1) annotation (Line(points={{-68,40},{-66,40},{-66,6},{-62,
          6}}, color={0,0,127}));
  connect(sub.y, lim.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  annotation (defaultComponentName=
    "proReg",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=0.1),
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={28,108,200},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=5,
        borderPattern=BorderPattern.Raised),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
      Ellipse(
        extent={{-80,80},{80,-80}},
        lineColor={28,108,200},
        fillColor={170,255,213},
        fillPattern=FillPattern.Solid)},
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>
Block that generates proportional regulation signal for condensation control
in non-condensing boilers according to RP-1711, March, 2020 draft, section
5.3.5.
</p>
<p>
The minimum bypass valve position <code>yProReg</code> is calculated
as follows:
</p>
<ul>
<li>
The measured hot-water return temperature <code>THotWatRet</code> is compared
to the minimum hot water return temperature for optimal operation <code>TRetSet</code>,
with the output <code>yProReg</code> varying linearly from 0% at
<code>TRetSet</code> to 100% at <code>TRetMinAll</code>.    
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 21, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ProportionalRegulator;
