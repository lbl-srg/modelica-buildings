within Buildings.Utilities.Psychrometrics;
block TWetBul_TDryBulXi
  "Model to compute the wet bulb temperature based on mass fraction"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"                          annotation (
      choicesAllMatching = true);

  parameter Boolean approximateWetBulb=false
    "Set to true to approximate wet bulb temperature" annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput TDryBul(
    start=303,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput p(  final quantity="Pressure",
                                           final unit="Pa",
                                           min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TWetBul(
    start=293,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi]
    "Species concentration at dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Real rh_per(min=0) "Relative humidity in percentage";

  Modelica.SIunits.MassFraction XiSat(start=0.01,
                                      nominal=0.01)
    "Water vapor mass fraction at saturation";
  Modelica.SIunits.MassFraction XiSatRefIn
    "Water vapor mass fraction at saturation, referenced to inlet mass flow rate";

 parameter Integer iWat = sum({(
   if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i], string2="Water", caseSensitive=false)
   then i else 0) for i in 1:Medium.nX})
     "Index of water in medium composition vector";

initial equation
  assert(iWat > 0, "Did not find medium species 'water' in the medium model. Change medium model.");

equation
  if approximateWetBulb then
    TDryBul_degC = TDryBul - 273.15;
    rh_per       = 100 * p/
         Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TDryBul)
         *Xi[iWat]/(Xi[iWat] +
         Buildings.Utilities.Psychrometrics.Constants.k_mair*(1-Xi[iWat]));
    TWetBul      = 273.15 + TDryBul_degC
       * Modelica.Math.atan(0.151977 * sqrt(rh_per + 8.313659))
       + Modelica.Math.atan(TDryBul_degC + rh_per)
       - Modelica.Math.atan(rh_per-1.676331)
       + 0.00391838 * rh_per^(1.5) * Modelica.Math.atan( 0.023101 * rh_per)  - 4.686035;
    XiSat = 0;
    XiSatRefIn=0;
  else
    XiSatRefIn=(1-Xi[iWat])*XiSat/(1-XiSat);
    XiSat  = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TWetBul),
      p =    p,
      phi =  1);
    (TWetBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-Xi[iWat]) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              XiSatRefIn * Buildings.Utilities.Psychrometrics.Constants.cpSte +
              (Xi[iWat]-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    =
    (TDryBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-Xi[iWat]) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              Xi[iWat] * Buildings.Utilities.Psychrometrics.Constants.cpSte)  +
    (Xi[iWat]-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.h_fg;
    TDryBul_degC = 0;
    rh_per       = 0;
  end if;

annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-92,100},{-62,56}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          extent={{-86,14},{-72,-6}},
          lineColor={0,0,127},
          textString="Xi"),
        Text(
          extent={{-90,-72},{-72,-90}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          extent={{62,22},{92,-22}},
          lineColor={0,0,127},
          textString="TWetBul"),
        Line(points={{78,-74},{-48,-74}}),
        Text(
          extent={{76,-78},{86,-94}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{76,-46},{26,-4}},
          color={255,0,0},
          thickness=0.5),
        Line(points={{-48,-48},{-2,-30},{28,-4},{48,32},{52,72}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(points={{-48,84},{-48,-74}}),
        Text(
          extent={{-44,82},{-22,64}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Polygon(
          points={{86,-74},{76,-72},{76,-76},{86,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,88},{-46,74},{-50,74},{-48,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    defaultComponentName="wetBul",
    Documentation(info="<html>
<p>
This block computes the wet bulb temperature for a given dry bulb temperature, mass fraction
and atmospheric pressure.
</p>
<p>
If the constant <code>approximateWetBulb</code> is <code>true</code>,
then the block uses the approximation of Stull (2011) to compute
the wet bulb temperature without requiring a nonlinear equation.
Otherwise, the model will introduce one nonlinear equation.
The approximation by Stull is valid for a relative humidity of <i>5%</i> to <i>99%</i>,
a temperature range from <i>-20&circ;C</i> to <i>50&circ;C</i>
and standard sea level pressure.
For this range of data, the approximation error is <i>-1</i> Kelvin to <i>+0.65</i> Kelvin,
with a mean error of less than <i>0.3</i> Kelvin.
</p>
<p>
Otherwise a calculation based on an energy balance is used.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">#474</a> for a discussion.
</p>
<p>
For a model that takes the relative humidity instead of the mass fraction as an input, see
<a href=\"modelica://Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi\">
Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi</a>.
</p>
<h4>References</h4>
<p>
Stull, Roland.
<i><a href=\"http://dx.doi.org/10.1175/JAMC-D-11-0143.1\">
Wet-Bulb Temperature from Relative Humidity and Air Temperature
Roland Stull.</a></i>
Journal of Applied Meteorology and Climatology.
Volume 50, Issue 11, pp. 2267-2269. November 2011
DOI: 10.1175/JAMC-D-11-0143.1
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2017, by Filip Jorissen:<br/>
Revised computation of <code>iWat</code>
such that it does not require an initial algorithm.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/759\">#759</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Changed icon.
</li>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Corrected exact implementation.
See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">#474</a>
for a discussion.
</li>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
November 17, 2014, by Michael Wetter:<br/>
Removed test on saturation pressure that avoids it to be larger than
<code>p</code>.
This test is not needed as it is only active near or above the boiling temperature,
and the result is only used in the computation of <code>rh_per</code>.
I do not see any negative impact from removing this test.
</li>
<li>
July 24, 2014 by Michael Wetter:<br/>
Revised computation of <code>rh_per</code> to use
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothMin\">
Buildings.Utilities.Math.Functions.smoothMin</a> rather
than <code>min</code>.
</li>
<li>
November 20, 2013 by Michael Wetter:<br/>
Updated model to use
<code>Buildings.Utilities.Psychrometrics.Functions.saturationPressure()</code>
and
<code>Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid()</code>
as these functions have been moved from the medium to the psychrometrics package.
</li>
<li>
September 10, 2013 by Michael Wetter:<br/>
Added start value and nominal value for <code>XiSat</code> as this is an iteration
variable in OpenModelica.
</li>
<li>
October 1, 2012 by Michael Wetter:<br/>
Revised implementation to change the dimension of the nonlinear
system of equations from two to one.
Added option to compute wet bulb temperature explicitly.
</li>
<li>
February 22, 2011 by Michael Wetter:<br/>
Changed the code sections that obtain the water concentration. The old version accessed
the water concentration using the index of the vector <code>X</code>.
However, Dymola 7.4 cannot differentiate the function if vector elements are accessed
using their index. In the new implementation, an inner product is used to access the vector element.
In addition, the medium substance name is searched using a case insensitive search.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>WetBulbTemperature</code> to <code>TWetBul_TDryBulXi</code>
and changed obsolete real connectors to input and output connectors.
</li>
<li>
May 19, 2008 by Michael Wetter:<br/>
Added relative humidity as a port.
</li>
<li>
May 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulXi;
