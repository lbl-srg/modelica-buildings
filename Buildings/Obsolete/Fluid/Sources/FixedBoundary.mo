within Buildings.Obsolete.Fluid.Sources;
model FixedBoundary "Boundary source component"
  extends Buildings.Obsolete.BaseClasses.ObsoleteModel;
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource(final verifyInputs=true);
  parameter Boolean use_p=true "select p or d"
    annotation (Evaluate = true,
                Dialog(group = "Boundary pressure or Boundary density"));
  parameter Medium.AbsolutePressure p=Medium.p_default "Boundary pressure"
    annotation (Dialog(group = "Boundary pressure or Boundary density",
                       enable = use_p));
  parameter Medium.Density d=Medium.density_pTX(
    p = Medium.p_default,
    T = Medium.T_default,
    X = Medium.X_default) "Boundary density"
    annotation (Dialog(group = "Boundary pressure or Boundary density",
                       enable=not use_p));
  parameter Boolean use_T=true "select T or h"
    annotation (Evaluate = true,
                Dialog(group = "Boundary temperature or Boundary specific enthalpy"));
  parameter Medium.Temperature T=Medium.T_default "Boundary temperature"
    annotation (Dialog(group = "Boundary temperature or Boundary specific enthalpy",
                       enable = use_T));
  parameter Medium.SpecificEnthalpy h=Medium.h_default
    "Boundary specific enthalpy"
    annotation (Dialog(group="Boundary temperature or Boundary specific enthalpy",
                enable = not use_T));
  parameter Medium.MassFraction X[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Boundary mass fractions m_i/m"
    annotation (Dialog(group = "Only for multi-substance flow", enable=Medium.nXi > 0));

  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Boundary trace substances"
    annotation (Dialog(group = "Only for trace-substance flow", enable=Medium.nC > 0));

protected
  Modelica.Blocks.Interfaces.RealInput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput p_in_internal(final unit="Pa")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput h_in(final unit="J/kg")
    "Needed to connect to conditional connector";

  Modelica.Blocks.Interfaces.RealInput h_in_internal= Medium.specificEnthalpy(Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal));
  // Modelica.Blocks.Interfaces.RealInput d_in_internal = Medium.density(Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal));

initial equation
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
                                        Medium.singleState, use_p, X,
                                        "FixedBoundary");

equation
  h_in = h;
  if use_p or Medium.singleState then
    p_in_internal = p;
    connect(medium.p, p_in_internal);
  else
    p_in_internal = Medium.p_default;
    connect(medium.p, p_in_internal);
  end if;
  if use_T then
    T_in_internal = T;
    connect(medium.h, h_in_internal);
  else
    T_in_internal = Medium.T_default;
    connect(medium.h, h_in);
  end if;

  X_in_internal = X;
  connect(X_in_internal[1:Medium.nXi], Xi_in_internal);
  connect(medium.Xi, Xi_in_internal);

  ports.C_outflow = fill(C, nPorts);
  C_in_internal = C;

  if not verifyInputs then
    h_in_internal = Medium.h_default;
    p_in_internal = Medium.p_default;
    X_in_internal = Medium.X_default;
    T_in_internal = Medium.T_default;
  end if;

  for i in 1:nPorts loop
     ports[i].p          = p_in_internal;
     ports[i].h_outflow  = h_in_internal;
     ports[i].Xi_outflow = Xi_in_internal;
  end for;

annotation (defaultComponentName="bou",
  obsolete = "Obsolete model - use Buildings.Fluid.Sources.Boundary_pT or Buildings.Fluid.Sources.Boundary_ph instead",
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}), Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
This model defines constant values for boundary conditions:
</p>
<ul>
<li> Boundary pressure or boundary density.</li>
<li> Boundary temperature or boundary specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
Note, that boundary temperature, density, specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the Boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 13, 2019 by Jianjun Hu:<br/>
Moved from Buildings.Fluid.Sources.FixedBoundary to Buildings.Obsolete.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
January 14, 2019 by Jianjun Hu:<br/>
Changed to extend <a href=\"modelica://Buildings.Fluid.Sources.BaseClasses.PartialSource\">
Buildings.Fluid.Sources.BaseClasses.PartialSource</a>. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\"> #1050</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
since it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end FixedBoundary;
