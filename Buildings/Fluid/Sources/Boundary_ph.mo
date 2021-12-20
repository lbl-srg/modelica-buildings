within Buildings.Fluid.Sources;
model Boundary_ph
  "Boundary with prescribed pressure, specific enthalpy, composition and trace substances"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource_Xi_C;

  parameter Boolean use_p_in = false
    "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.AbsolutePressure p = Medium.p_default
    "Fixed value of pressure"
    annotation (Dialog(enable = not use_p_in, group="Fixed inputs"));

  parameter Boolean use_h_in= false
    "Get the specific enthalpy from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.SpecificEnthalpy h = Medium.h_default
    "Fixed value of specific enthalpy"
    annotation (Dialog(enable = not use_h_in, group="Fixed inputs"));

  Modelica.Blocks.Interfaces.RealInput p_in(final unit="Pa") if use_p_in
    "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput h_in(final unit="J/kg") if use_h_in
    "Prescribed boundary specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  // Boolean constants to avoid a potential string comparison in an equation section
protected
  constant Boolean checkWaterPressure = Medium.mediumName == "SimpleLiquidWater"
    "Evaluates to true if the pressure should be checked";
  constant Boolean checkAirPressure = Medium.mediumName == "Air"
    "Evaluates to true if the pressure should be checked";

  Modelica.Blocks.Interfaces.RealInput h_in_internal(final unit="J/kg")
    "Needed to connect to conditional connector";
initial equation
  if not use_p_in then
    if checkWaterPressure then
      assert(p_in_internal>1e4, "In "+getInstanceName() +
        ": The parameter value p="+String(p_in_internal)+" is low for water. This is likely an error.");
    end if;
    if checkAirPressure then
      assert(p_in_internal>5e4 and p_in_internal < 1.5e5, "In "+getInstanceName() +
        ": The parameter value p="+String(p_in_internal)+" is not within a realistic range for air. This is likely an error.");
    end if;
  end if;
equation
  if use_p_in then
    if checkWaterPressure then
      assert(p_in_internal>1e4, "In "+getInstanceName() +
        ": The value of p_in="+String(p_in_internal)+" is low for water. This is likely an error.");
    end if;
    if checkAirPressure then
      assert(p_in_internal>5e4 and p_in_internal < 1.5e5, "In "+getInstanceName() +
        ": The value of p_in="+String(p_in_internal)+" is not within a realistic range for air. This is likely an error.");
    end if;
  end if;

  // Pressure
  connect(p_in, p_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
  for i in 1:nPorts loop
    ports[i].p = p_in_internal;
  end for;
  // Enthalpy
  connect(h_in, h_in_internal);
  if not use_h_in then
    h_in_internal = h;
  end if;
  for i in 1:nPorts loop
     ports[i].h_outflow  = h_in_internal;
  end for;
  connect(medium.h, h_in_internal);


  annotation (defaultComponentName="bou",
    Documentation(info="<html>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<h4>Typical use and important parameters</h4>
<p>
If <code>use_p_in</code> is false (default option),
the <code>p</code> parameter is used as boundary pressure,
and the <code>p_in</code> input connector is disabled;
if <code>use_p_in</code> is true, then the <code>p</code>
parameter is ignored, and the value provided by the
input connector is used instead.
</p>
<p>
The same applies to the specific enthalpy <i>h</i>, composition <i>X<sub>i</sub></i> or <i>X</i> and trace substances <i>C</i>.
</p>
<h4>Options</h4>
<p>
Instead of using <code>Xi_in</code> (the <i>independent</i> composition fractions),
the advanced tab provides an option for setting all
composition fractions using <code>X_in</code>.
<code>use_X_in</code> and <code>use_Xi_in</code> cannot be used
at the same time.
</p>
<p>
Parameter <code>verifyInputs</code> can be set to <code>true</code>
to enable a check that verifies the validity of the used specific enthalpy
and pressures.
This removes the corresponding overhead from the model, which is
a substantial part of the overhead of this model.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>
for more information.
</p>
<p>
Note, that boundary specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
Juni 7, 2019, by Michael Wetter:<br/>
Added constant boolean expressions to avoid a potential string comparison in an equation section.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1148\">#1148</a>.
</li>
<li>
Juni 4, 2019, by Filip Jorissen:<br/>
Added check for the value of <code>p</code> and <code>p_in</code>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1148\">#1148</a>.
</li>
<li>
January 25, 2019, by Michael Wetter:<br/>
Refactored use of base classes.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\">#1072</a>.
</li>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Made <code>medium</code> conditional and refactored inputs.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          visible=use_h_in,
          extent={{-162,34},{-60,-6}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h"),
        Text(
          visible=use_p_in,
          extent={{-152,134},{-68,94}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p"),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end Boundary_ph;
