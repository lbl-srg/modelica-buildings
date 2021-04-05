within Buildings.Fluid.Sources.BaseClasses;
partial model PartialSource_Xi_C
  "Partial component source with parameter definitions for Xi and C"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource;

  parameter Boolean use_X_in = false
    "Get the composition (all fractions) from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(tab="Advanced"));
  parameter Boolean use_Xi_in = false
    "Get the composition (independent fractions) from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.MassFraction X[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Fixed value of composition"
    annotation (Dialog(enable = (not use_X_in) and Medium.nXi > 0, group="Fixed inputs"));
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames) = fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0, group="Fixed inputs"));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames) if use_X_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Xi_in[Medium.nXi](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames[1:Medium.nXi]) if use_Xi_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

initial equation
  assert(not use_X_in or not use_Xi_in,
    "Cannot use both X and Xi inputs, choose either use_X_in or use_Xi_in.");

  if not use_X_in and not use_Xi_in then
    Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
      Medium.singleState, true, X_in_internal, "Boundary_pT");
  end if;

equation
  if use_X_in or use_Xi_in then
    Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
      Medium.singleState, true, X_in_internal, "Boundary_pT");
  end if;

  // Assign Xi_in_internal and X_in_internal
  // Note that at most one of X_in or Xi_in is present
  connect(X_in, X_in_internal);
  connect(Xi_in, Xi_in_internal);

  if use_Xi_in then
    // Must assign all components of X_in_internal, using Xi_in
    X_in_internal[1:Medium.nXi] = Xi_in_internal[1:Medium.nXi];
    // If reducedX = true, medium contains the equation sum(X) = 1.0
    // Media with only one substance (e.g., water) have reducedX=true
    // FlueGas and SimpleNaturalGas has reducedX = false
    if Medium.reducedX then
      X_in_internal[Medium.nX] = 1-sum(Xi_in_internal);
    end if;
  elseif use_X_in then
    X_in_internal[1:Medium.nXi] = Xi_in_internal[1:Medium.nXi];
  else
    // No connector is used. Use parameter X.
    X_in_internal = X;
    Xi_in_internal = X[1:Medium.nXi];
  end if;

  connect(C_in, C_in_internal);

  if not use_C_in then
    C_in_internal = C;
  end if;

  for i in 1:nPorts loop
    ports[i].Xi_outflow = Xi_in_internal;
    ports[i].C_outflow = C_in_internal;
  end for;


  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          visible=use_X_in,
          extent={{-164,4},{-62,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          visible=use_Xi_in,
          extent={{-164,4},{-62,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Xi"),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
          Documentation(info="<html>
<p>
Partial model that defines outflowing properties
<code>ports.Xi_outflow</code> and <code>ports.C_outflow</code>
using an optional input for both.
Otherwise the parameter value is used.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2019, by Michael Wetter:<br/>
Refactored handling of mass fractions which was needed to handle media such as
<a href=\"modelica://Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents\">
Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents</a> and
<a href=\"modelica://Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas\">
Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">IBPSA, #1205</a>.
</li>
<li>
February 13, 2018, by Michael Wetter:<br/>
Corrected error in quantity assignment for <code>Xi_in</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"));
end PartialSource_Xi_C;
