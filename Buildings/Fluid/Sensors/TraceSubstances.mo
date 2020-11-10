within Buildings.Fluid.Sensors;
model TraceSubstances "Ideal one port trace substances sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;

  parameter String substanceName = "CO2" "Name of trace substance";

  Modelica.Blocks.Interfaces.RealOutput C(min=0)
    "Trace substance in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Real s[:]= {
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false))
    then 1 else 0 for i in 1:Medium.nC}
    "Vector with zero everywhere except where species is"
    annotation(Evaluate=true);
initial equation
  assert(max(s) > 0.9, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  // We obtain the species concentration with a vector multiplication
  // because Dymola 7.3 cannot find the derivative in the model
  // Buildings.Examples.VAVSystemCTControl.mo
  // if we set C = CVec[ind];
  C = s*inStream(port.C_outflow);
annotation (defaultComponentName="senTraSub",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Text(
          extent={{180,90},{60,40}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(C, leftjustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the trace substances contained in the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
To measure trace substances in a duct or pipe, use
<a href=\"modelica://Buildings.Fluid.Sensors.TraceSubstancesTwoPort\">Buildings.Fluid.Sensors.TraceSubstancesTwoPort</a>
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
September 21, 2020, by Michael Wetter:<br/>
Introduced parameter <code>warnAboutOnePortConnection</code> and updated documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1399\">#1399</a>.
</li>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
June 10, 2015, by Michael Wetter:<br/>
Reformulated assignment of <code>s</code> and <code>assert</code>
statement. The reformulation of the assignment of <code>s</code> was
done to allow a model check in non-pedantic mode.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/268\">issue 268</a>.
</li>
<li>
September 10, 2013, by Michael Wetter:<br/>
Corrected a syntax error in setting the nominal value for the output signal.
This eliminates a compilation error in OpenModelica.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved code that searches for index of trace substance in medium model.
</li>
<li>
March 22, 2010 by Michael Wetter:<br/>
Changed assignment for <code>C</code> so that Dymola 7.4 can find
the analytic derivative.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstances;
