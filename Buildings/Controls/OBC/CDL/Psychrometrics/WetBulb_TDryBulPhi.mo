within Buildings.Controls.OBC.CDL.Psychrometrics;
block WetBulb_TDryBulPhi
  "Block to compute the wet bulb temperature based on relative humidity"
  Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),iconTransformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100)
    "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Real TDryBul_degC(
    final unit="degC",
    displayUnit="degC")
    "Dry bulb temperature in degree Celsius";
  Real rh_per(
    min=0)
    "Relative humidity in percentage";

equation
  TDryBul_degC=TDryBul-273.15;
  rh_per=100*phi;
  TWetBul=273.15+TDryBul_degC*Modelica.Math.atan(
    0.151977*sqrt(
      rh_per+8.313659))+Modelica.Math.atan(
    TDryBul_degC+rh_per)-Modelica.Math.atan(
    rh_per-1.676331)+0.00391838*rh_per^(1.5)*Modelica.Math.atan(
    0.023101*rh_per)-4.686035;
  annotation (
    defaultComponentName="wetBul",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,82},{-62,38}},
          textColor={0,0,127},
          textString="TDryBul"),
        Text(
          extent={{-90,-44},{-70,-70}},
          textColor={0,0,127},
          textString="phi"),
        Text(
          extent={{62,22},{92,-22}},
          textColor={0,0,127},
          textString="TWetBul"),
        Line(
          points={{78,-74},{-48,-74}}),
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
        Line(
          points={{-48,-48},{-2,-30},{28,-4},{48,32},{52,72}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-48,84},{-48,-74}}),
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
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-4},{36,-10},{34,-12},{26,-4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
This block computes the wet bulb temperature for a given dry bulb temperature, relative air humidity
and atmospheric pressure.
</p>
<p>
The block uses the approximation of Stull (2011) to compute
the wet bulb temperature without requiring a nonlinear equation.
The approximation by Stull is valid for a relative humidity of <i>5%</i> to <i>99%</i>,
a temperature range from <i>-20</i>&deg;C to <i>50</i>&deg;C
and standard sea level pressure.
For this range of data, the approximation error is <i>-1</i> Kelvin to <i>+0.65</i> Kelvin,
with a mean error of less than <i>0.3</i> Kelvin.
</p>
<p>
The model is validated in
<a href=\"modelica://Buildings.Controls.OBC.CDL.Psychrometrics.Validation.WetBulb_TDryBulPhi\">
Buildings.Controls.OBC.CDL.Psychrometrics.Validation.WetBulb_TDryBulPhi</a>.
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
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
September 29, 2020, by Michael Wetter:<br/>
Removed unused input <code>p</code> and renamed block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 11, 2017, by Jianjun Hu:<br/>
Changed the model to avoid using nonlinear equation.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Changed icon.
</li>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Corrected exact implementation.
See  <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/474\">#474</a>
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
end WetBulb_TDryBulPhi;
