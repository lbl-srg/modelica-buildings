within Buildings.Utilities.Psychrometrics;
block TWetBul_TDryBulPhi
  "Model to compute the wet bulb temperature based on relative humidity"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
    annotation (choicesAllMatching = true);

  parameter Boolean approximateWetBulb=false
    "Set to true to approximate wet bulb temperature" annotation (Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    start=Medium.T_default,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput phi(min=0, max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealInput p(final quantity="Pressure",
                                         final unit="Pa",
                                         min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealOutput TWetBul(
    start=Medium.T_default,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // Modelica.Math.atan returns a value with unit set to "rad".
  // The following constant is used to satisfy the unit check.
protected
  constant Real uniCon1(final unit="1/rad") = 1 "Constant to satisfy unit check";
  constant Real uniConK(final unit="K/rad") = 1 "Constant to satisfy unit check";

  Modelica.Units.NonSI.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Real rh_per(min=0) "Relative humidity in percentage";
  Modelica.Units.SI.MassFraction XiDryBul
    "Water vapor mass fraction at dry bulb state";
  Modelica.Units.SI.MassFraction XiSat
    "Water vapor mass fraction at saturation";
  Modelica.Units.SI.MassFraction XiSatRefIn
    "Water vapor mass fraction at saturation, referenced to inlet mass flow rate";

equation
  if approximateWetBulb then
    TDryBul_degC = TDryBul - 273.15;
    rh_per       = 100*phi;
    TWetBul      = 273.15 + uniCon1 * TDryBul_degC
       * Modelica.Math.atan(0.151977 * sqrt(rh_per + 8.313659))
       + uniConK * (Modelica.Math.atan(TDryBul_degC + rh_per)
         - Modelica.Math.atan(rh_per-1.676331)
         + 0.00391838 * rh_per^(1.5) * Modelica.Math.atan( 0.023101 * rh_per))
       - 4.686035;
    XiSat    = 0;
    XiDryBul = 0;
    XiSatRefIn=0;
  else
    XiSatRefIn=(1-XiDryBul)*XiSat/(1-XiSat);
    XiSat  = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TWetBul),
      p =    p,
      phi =  1);
    XiDryBul =Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      p =    p,
      pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TDryBul),
      phi =  phi);
    (TWetBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-XiDryBul) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              XiSatRefIn * Buildings.Utilities.Psychrometrics.Constants.cpSte +
              (XiDryBul-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    =
    (TDryBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-XiDryBul) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              XiDryBul * Buildings.Utilities.Psychrometrics.Constants.cpSte)  +
    (XiDryBul-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.h_fg;

    TDryBul_degC = 0;
    rh_per       = 0;
  end if;

annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-92,100},{-62,56}},
          textColor={0,0,127},
          textString="TDryBul"),
        Text(
          extent={{-92,14},{-72,-12}},
          textColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-90,-72},{-72,-90}},
          textColor={0,0,127},
          textString="p"),
        Text(
          extent={{62,22},{92,-22}},
          textColor={0,0,127},
          textString="TWetBul"),
        Line(points={{78,-74},{-48,-74}}),
        Text(
          extent={{76,-78},{86,-94}},
          textColor={0,0,0},
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
          textColor={0,0,0},
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
This block computes the wet bulb temperature for a given dry bulb temperature, relative air humidity
and atmospheric pressure.
</p>
<p>
If the constant <code>approximateWetBulb</code> is <code>true</code>,
then the block uses the approximation of Stull (2011) to compute
the wet bulb temperature without requiring a nonlinear equation.
Otherwise, the model will introduce one nonlinear equation.
The approximation by Stull is valid for a relative humidity of <i>5%</i> to <i>99%</i>,
a temperature range from <i>-20</i>&deg;C to <i>50</i>&deg;C
and standard sea level pressure.
For this range of data, the approximation error is <i>-1</i> Kelvin to <i>+0.65</i> Kelvin,
with a mean error of less than <i>0.3</i> Kelvin.
</p>
<p>
Otherwise a calculation based on an energy balance is used.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">#474</a> for a discussion.
The model is validated in
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Examples.TWetBul_TDryBulPhi\">
Buildings.Utilities.Psychrometrics.Examples.TWetBul_TDryBulPhi</a>.
</p>
<p>
For a model that takes the mass fraction instead of the relative humidity as an input, see
<a href=\"modelica://Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi\">
Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi</a>.
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
March 6, 2023, by Michael Wetter:<br/>
Added a constant in order for unit check to pass.<br/>
See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1711\">#1711</a>
for a discussion.
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
October 3, 2014, by Michael Wetter:<br/>
Changed assignment of nominal value to avoid in OpenModelica the warning
alias set with different nominal values.
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
October 1, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulPhi;
