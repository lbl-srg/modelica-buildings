within Buildings.Fluid.Sources;
model FixedBoundary "Boundary source component"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
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

initial equation
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
                                        Medium.singleState, use_p, X,
                                        "FixedBoundary");

equation
  if use_p or Medium.singleState then
    medium.p = p;
  else
    medium.d = d;
  end if;
  if use_T then
    medium.T = T;
  else
    medium.h = h;
  end if;

  medium.Xi = X[1:Medium.nXi];

  ports.C_outflow = fill(C, nPorts);
  annotation (defaultComponentName="bou",
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
          lineColor={0,0,255})}),
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
