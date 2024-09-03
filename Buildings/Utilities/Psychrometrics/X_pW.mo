within Buildings.Utilities.Psychrometrics;
block X_pW "Humidity ratio for given water vapor pressure"
  extends
    Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;
  Modelica.Blocks.Interfaces.RealOutput X_w(min=0, max=1, nominal=0.01)
    "Species concentration at dry bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput p_w(final quantity="Pressure",
                                           final unit="Pa",
                                           displayUnit="Pa",
                                           min = 0.003,
                                           start=2000,
                                           nominal=1000) "Water vapor pressure"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  output Modelica.Units.SI.MassFraction x_w(
    min=0,
    max=1,
    nominal=0.01,
    start=0.001) "Water mass fraction per mass of dry air";
equation
  X_w = Buildings.Utilities.Psychrometrics.Functions.X_pW(p_w=p_w, p=p_in_internal);
  x_w = X_w/(1-X_w);
  annotation (
defaultComponentName="humRat",
    Documentation(info="<html>
<p>
Block to compute the humidity ratio for a given water vapor partial pressure.
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
September 16, 2013 by Michael Wetter:<br/>
Added attributes to variable <code>p_w</code>.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>HumidityRatio_pWat</code> to <code>X_pW</code>.
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
          extent={{-92,52},{-36,-40}},
          textColor={0,0,0},
          textString="pW"), Text(
          extent={{46,44},{94,-24}},
          textColor={0,0,0},
          textString="X")}));
end X_pW;
