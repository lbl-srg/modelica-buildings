within Buildings.Fluid.Sensors;
model TraceSubstancesTwoPort "Ideal two port sensor for trace substance"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput C(min=0,
                                          start=C_start)
    "Trace substance of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Real C_start(min=0) = 0
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

protected
  constant Real sumC_nominal = sum(Medium.C_nominal) "Sum of Medium.C_nominal";
  Real CMed(min=0, start=C_start, nominal=
    if sumC_nominal > Modelica.Constants.eps then sumC_nominal else 1)
    "Medium trace substance to which the sensor is exposed";
  parameter Real s[:]= {
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false))
    then 1 else 0 for i in 1:Medium.nC}
    "Vector with zero everywhere except where species is";
initial equation
  assert(max(s) > 0.9, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");

  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(C) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      C = C_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     CMed = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=s*port_b.C_outflow,
              y2=s*port_a.C_outflow,
              x_small=m_flow_small);
  else
     CMed = s*port_b.C_outflow;
  end if;
  // Output signal of sensor
  if dynamic then
    der(C) = (CMed-C)*k*tauInv;
  else
    C = CMed;
  end if;
annotation (defaultComponentName="senTraSub",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{82,122},{0,92}},
          textColor={0,0,0},
          textString="C"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Text(
          extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(C, leftJustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the trace substance of the passing fluid.
The sensor is ideal, i.e., it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Avoided assignment of <code>CMed(nominal=0)</code> as this is
not allowed.
</li>
<li>
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
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
May 22, 2015, by Michael Wetter:<br/>
Corrected wrong sensor signal if <code>allowFlowReversal=false</code>.
For this setting, the sensor output was for the wrong flow direction.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/249\">issue 249</a>.
</li>
<li>
September 10, 2013, by Michael Wetter:<br/>
Corrected syntax errors in setting nominal value for output signal
and for state variable.
This eliminates a compilation error in OpenModelica.
</li>
<li>
August 30, 2013, by Michael Wetter:<br/>
Added default value <code>C_start=0</code>.
</li>
<li>
November 3, 2011, by Michael Wetter:<br/>
Moved <code>der(C) := 0;</code> from the initial algorithm section to
the initial equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved code that searches for index of trace substance in medium model.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstancesTwoPort;
