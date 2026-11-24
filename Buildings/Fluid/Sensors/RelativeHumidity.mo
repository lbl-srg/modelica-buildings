within Buildings.Fluid.Sensors;
model RelativeHumidity "Ideal one port relative humidity sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RoundSensor;

  Modelica.Blocks.Interfaces.RealOutput phi(final unit="1", min=0)
    "Relative humidity in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Real s[Medium.nXi](each final unit="1") = {
    if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                          string2="water",
                                          caseSensitive=false)
    then 1 else 0 for i in 1:Medium.nXi}
    "Vector with zero everywhere except where water is";
  Modelica.Units.SI.Temperature T "Temperature of the medium";
  Medium.MassFraction Xi[Medium.nXi](
    quantity=Medium.substanceNames[1:Medium.nXi]) "Mass fraction of the medium";
initial equation
  assert(max(s) > 0.9, "Substance 'water' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Change medium model to one that has 'water' as a substance.");
equation
  Xi = inStream(port.Xi_outflow);
  T = Medium.temperature(state=Medium.setState_phX(
      p=port.p,
      h=inStream(port.h_outflow),
      X=Xi));

  phi = Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
    p=port.p,
    T=T,
    X_w=s*Xi);

annotation (defaultComponentName="senRelHum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{160,-30},{60,-60}},
          textColor={0,0,0},
          textString="phi"),
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Text(
          extent={{180,90},{60,40}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(phi, leftJustified=false, significantDigits=2)))}),
  Documentation(info="<html>
<p>
This model outputs the relative humidity of the fluid connected to its port.
The sensor is ideal, i.e. it does not influence the fluid.
</p>
<p>
Note that this sensor can only be used with media that contain the variable <code>phi</code>,
which is typically the case for moist air models.
</p>
<p>
To measure relative humidity in a duct or pipe, use
<a href=\"modelica://Buildings.Fluid.Sensors.RelativeHumidityTwoPort\">Buildings.Fluid.Sensors.RelativeHumidityTwoPort</a>
rather than this sensor.
Read the
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model to see about potential numerical problems if this sensor is used incorrectly
in a system model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2026, by Michael Wetter:<br/>
Constructed the full composition vector <code>X</code> from <code>Xi</code> when <code>Medium.reducedX</code> is true before calling <code>Medium.temperature_phX</code>.
</li>
<li>
September 21, 2020, by Michael Wetter:<br/>
Introduced parameter <code>warnAboutOnePortConnection</code> and updated documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1399\">#1399</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
January 26, 2016 by Michael Wetter:<br/>
Added <code>quantity</code> attribute for mass fraction variables.<br/>
Made unit assignment of output signal final.
</li>
<li>
May 12, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidity;
