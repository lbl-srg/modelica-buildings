within Buildings.Controls.OBC.CDL.Psychrometrics;
block SpecificEnthalpy_TDryBulPhi
  "Block to compute the specific enthalpy based on relative humidity"

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa") = 101325 "Atmospheric pressure";

  Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput phi(final min=0, final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Interfaces.RealOutput h(
    final quantity="SpecificEnergy",
    final unit="J/kg") "Specific enthalpy"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  Real w(final unit="1", nominal=0.01)
    "Water vapor mass fraction in kg per kg dry air";

equation
  TDryBul_degC = TDryBul - 273.15;
  p_w = phi * Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TDryBul);
  w = 0.6219647130774989*p_w/(pAtm-p_w);
  h = 1006*TDryBul_degC + w*(2501014.5+1860*TDryBul_degC);

    annotation (
    defaultComponentName="ent",
    Documentation(info="<html>
<p>
This block computes the specific enthalpy for a given dry bulb temperature, relative air humidity
and atmospheric pressure.
The specific enthalpy is zero if the temperature is <i>0</i>&deg;C and if there
is no moisture.
</p>
<p>
The correlation used in this model is from the 2009 ASHRAE Handbook Fundamentals, p. 1.9, equation 32.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2020, by Michael Wetter:<br/>
Removed input <code>p</code>, used instead a parameter for the atmospheric pressure and renamed block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 7, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-44,-52},{-30,-48},{0,-36},{32,-8},{44,16},{52,48},{56,68}},
          color={215,215,215},
          smooth=Smooth.Bezier),
        Line(
          points={{66,-58},{10,-28}},
          color={255,0,0},
          thickness=0.5),
        Text(
          extent={{-44,82},{-22,64}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Polygon(
          points={{-48,88},{-46,74},{-50,74},{-48,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-44},{-68,-70}},
          lineColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-92,82},{-62,38}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Line(points={{78,-74},{-48,-74}}),
        Polygon(
          points={{86,-74},{76,-72},{76,-76},{86,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{76,-78},{86,-94}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(points={{-48,84},{-48,-74}}),
        Text(
          extent={{74,14},{94,-12}},
          lineColor={0,0,127},
          textString="h")}));
end SpecificEnthalpy_TDryBulPhi;
