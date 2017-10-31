within Buildings.Fluid.Sources.BaseClasses;
partial model Outside
  "Boundary that takes weather data, and optionally trace substances, as an input"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0));

  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-18},{-80,22}})));
protected
  final parameter Boolean singleSubstance = (Medium.nX == 1)
    "True if single substance medium";
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi if
       not singleSubstance "Block to compute water vapor concentration";

  Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX](
    each final unit="kg/kg",
    final quantity=Medium.substanceNames)
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput p_in_internal(final unit="Pa")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC](
       quantity=Medium.extraPropertiesNames)
    "Needed to connect to conditional connector";

equation
  // Check medium properties
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
    Medium.singleState, true, medium.X, "Boundary_pT");

  // Conditional connectors for trace substances
  connect(C_in, C_in_internal);
  if not use_C_in then
    C_in_internal = C;
  end if;
  // Connections to input. This is required to obtain the data from
  // the weather bus in case that the component x_pTphi is conditionally removed
  connect(weaBus.TDryBul, T_in_internal);

  // Connections to compute species concentration
  connect(p_in_internal, x_pTphi.p_in);
  connect(T_in_internal, x_pTphi.T);
  connect(weaBus.relHum, x_pTphi.phi);

  connect(X_in_internal, x_pTphi.X);
  if singleSubstance then
    X_in_internal = ones(Medium.nX);
  end if;
  // Assign medium properties
  medium.p = p_in_internal;
  medium.T = T_in_internal;
  medium.Xi = X_in_internal[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-98,100},{102,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-60,-80}},
          color={0,0,255}),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
    Documentation(info="<html>
<p>
This is the base class for models that describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained
from weather data, and that may be modified based on the wind pressure.
</p>
<p>If the parameter <code>use_C_in</code> is <code>false</code> (default option),
the <code>C</code> parameter
is used as the trace substance for flow that leaves the component, and the
<code>C_in</code> input connector is disabled; if <code>use_C_in</code> is <code>true</code>,
then the <code>C</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>
Note that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2017 by Jianjun Hu:<br/>
Corrected <code>X_in_internal = zeros()</code> to be <code>X_in_internal = ones()</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/787\"> #787</a>.
</li>
<li>
April, 25, 2016 by Marcus Fuchs:<br/>
Introduced missing <code>each</code> keyword. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/454\"> #454</a>,
to prevent a warning in OpenModelica.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 26, 2011 by Michael Wetter:<br/>
Introduced new base class to allow implementation of wind pressure for natural ventilation.
</li>
<li>
April 27, 2011 by Michael Wetter:<br/>
Revised implementation to allow medium model that do not have water vapor.
</li>
<li>
Feb. 9, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Outside;
