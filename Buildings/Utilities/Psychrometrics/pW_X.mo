within Buildings.Utilities.Psychrometrics;
block pW_X "Water vapor pressure for given humidity ratio"
  extends
    Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;
  Modelica.Blocks.Interfaces.RealInput X_w(min=0, max=0.99999, nominal=0.1)
    "Water concentration at dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput p_w(final quantity="Pressure",
                                           final unit="Pa",
                                           displayUnit="Pa",
                                           min = 0) "Water vapor pressure"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  output Modelica.Units.SI.MassFraction x_w(
    min=0,
    max=1,
    nominal=0.1,
    start=0.001) "Water mass fraction per mass of dry air";

equation
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_X(X_w=X_w, p=p_in_internal);
  x_w = X_w/(1-X_w);
  annotation (
    defaultComponentName="pWat",
    Documentation(info="<html>
<p>
Block to compute the water vapor partial pressure for a given humidity ratio.
</p>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as atmospheric pressure,
and the <code>p_in</code> input connector is disabled;
if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored,
and the value provided by the input connector is used instead.
</p>
</html>", revisions="<html>
<ul>
<li>
October 3, 2014, by Michael Wetter:<br/>
Changed assignment of nominal value to avoid in OpenModelica the warning
alias set with different nominal values.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>VaporPressure_X</code> to <code>pW_X</code>.
</li>
<li>
April 14, 2009 by Michael Wetter:<br/>
Converted model to block because <code>RealInput</code> are obsolete in Modelica 3.0.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-88,26},{-60,-26}},
          textColor={0,0,0},
          textString="X"), Text(
          extent={{46,30},{90,-32}},
          textColor={0,0,0},
          textString="pW")}));
end pW_X;
