within Buildings.Fluid.Sources;
model Boundary_pT
  "Boundary with prescribed pressure, temperature, composition and trace substances"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_p_in = false
    "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_T_in= false
    "Get the temperature from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_X_in = false
    "Get the composition from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true);

  parameter Medium.AbsolutePressure p = Medium.p_default
    "Fixed value of pressure"
    annotation (Dialog(enable = not use_p_in));
  parameter Medium.Temperature T = Medium.T_default
    "Fixed value of temperature"
    annotation (Dialog(enable = not use_T_in));
  parameter Medium.MassFraction X[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Fixed value of composition"
    annotation (Dialog(enable = (not use_X_in) and Medium.nXi > 0));
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames) = fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput p_in(final unit="Pa") if use_p_in
    "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput T_in(final unit="K",
                                            displayUnit="degC") if use_T_in
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames) if use_X_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal(final unit="Pa")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames)
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Needed to connect to conditional connector";
equation
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
    Medium.singleState, true, X_in_internal, "Boundary_pT");
  connect(p_in, p_in_internal);
  connect(T_in, T_in_internal);
  connect(X_in, X_in_internal);
  connect(C_in, C_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
  if not use_T_in then
    T_in_internal = T;
  end if;
  if not use_X_in then
    X_in_internal = X;
  end if;
  if not use_C_in then
    C_in_internal = C;
  end if;
  medium.p = p_in_internal;
  medium.T = T_in_internal;
  medium.Xi = X_in_internal[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
  annotation (defaultComponentName="bou",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          visible=use_p_in,
          points={{-100,80},{-58,80}},
          color={0,0,255}),
        Line(
          visible=use_T_in,
          points={{-100,40},{-92,40}},
          color={0,0,255}),
        Line(
          visible=use_X_in,
          points={{-100,-40},{-92,-40}},
          color={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-60,-80}},
          color={0,0,255}),
        Text(
          visible=use_p_in,
          extent={{-152,134},{-68,94}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p"),
        Text(
          visible=use_X_in,
          extent={{-164,4},{-62,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Text(
          visible=use_T_in,
          extent={{-162,34},{-60,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T")}),
    Documentation(info="<html>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary temperature.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as boundary pressure, and the <code>p_in</code> input connector is disabled; if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>The same applies to the temperature, composition and trace substances.</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
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
</html>"));
end Boundary_pT;
