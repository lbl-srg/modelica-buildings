within Buildings.Fluid.Sources;
model Outside_CpLowRise
  "Boundary that takes weather data as an input and computes the wind pressure for low-rise buildings based on the equation from Swami and Chandra (1987)"
  extends Buildings.Fluid.Sources.BaseClasses.Outside;

  parameter Real Cp0(min=0, max=1, final unit="1") = 0.6
    "Wind pressure coefficient for wind normal to wall";
  parameter Real s(final min=0, final unit="1")
    "Side ratio, s=length of this wall/length of adjacent wall";
  parameter Modelica.Units.SI.Angle azi "Surface azimuth (South:0, West:pi/2)"
    annotation (choicesAllMatching=true);

  Modelica.Units.SI.Angle alpha = winDir-surOut
    "Wind incidence angle (0: normal to wall)";
  Real CpAct(final unit="1")=
   Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise(
     Cp0=Cp0,
     alpha=alpha,
     G=G)
   "Actual wind pressure coefficient";
  Modelica.Units.SI.Pressure pWin(displayUnit="Pa")=
    0.5*CpAct*d*vWin*vWin
    "Change in pressure due to wind force";
protected
  Modelica.Blocks.Interfaces.RealInput pWea(min=0, nominal=1E5, final unit="Pa")
    "Pressure from weather bus";
  Modelica.Blocks.Interfaces.RealInput vWin(final unit="m/s")
    "Wind speed from weather bus";
  Modelica.Blocks.Interfaces.RealOutput pTot(
    min=0,
    nominal=1E5,
    final unit="Pa") = pWea + pWin
    "Sum of atmospheric pressure and wind pressure";
  final parameter Real G = Modelica.Math.log(s)
    "Natural logarithm of side ratio";

  Modelica.Blocks.Interfaces.RealInput winDir(final unit="rad",
                                              displayUnit="deg")
    "Wind direction from weather bus";
  Modelica.Units.SI.Angle surOut=azi - Modelica.Constants.pi
    "Angle of surface that is used to compute angle of attack of wind";
  Modelica.Units.SI.Density d = Medium.density(
    Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal))
    "Air density";

equation
  connect(weaBus.winDir, winDir);
  connect(weaBus.winSpe, vWin);
  connect(weaBus.pAtm, pWea);
  connect(p_in_internal, pTot);
  connect(weaBus.TDryBul, T_in_internal);
  annotation (defaultComponentName="out",
    Documentation(info="<html>
<p>
This model describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained
from weather data. The model is identical to
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>,
except that it adds the wind pressure to the
pressure at the fluid port <code>ports</code>.
The correlation that is used to compute the wind pressure is based
on Swami and Chandra (1987) and valid for low-rise buildings
with rectangular shape.
The same correlation is also implemented in CONTAM (Persily and Ivy, 2001).
For other buildings, the model
<a href=\"modelica://Buildings.Fluid.Sources.Outside_CpData\">
Buildings.Fluid.Sources.Outside_CpData</a> or
<a href=\"modelica://Buildings.Fluid.Sources.Outside_Cp\">
Buildings.Fluid.Sources.Outside_Cp</a>
should be used that takes
the wind pressure coefficient as a parameter or an input.
</p>
<p>
The wind pressure coefficient is computed based on the
side ratio of the walls, which is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
s = x &frasl; y
</p>
<p>
where <i>x</i> is the length of the wall that will be connected to
this model, and <i>y</i> is the length of the adjacent wall.
The wind direction is computed relative to the azimuth of this surface,
which is equal to the parameter <code>azi</code>.
The surface azimuth is defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>.
For example, if an exterior wall is South oriented, i.e., its outside-facing
surface is towards South, use
<code>Buildings.Types.Azimuth.S</code>.
</p>
<p>
Based on the surface azimuth, the wind direction and the side ratio
of the walls, the model computes how much the wind pressure
is attenuated compared to the reference wind pressure <code>Cp0</code>.
The reference wind pressure <code>Cp0</code> is a user-defined parameter,
and must be equal to the wind pressure at zero wind incidence angle.
Swami and Chandra (1987) recommend <i>C<sub>p0</sub> = 0.6</i> for
all low-rise buildings as this represents the average of
various values reported in the literature.
The computation of the actual wind pressure coefficient <i>C<sub>p</sub></i>
is explained in the function
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise\">
Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise</a>
that is called by this model.
</p>
<p>
The pressure <i>p</i> at the port <code>ports</code> is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  p = p<sub>w</sub> + C<sub>p</sub> 1 &frasl; 2 v<sup>2</sup> &rho;,
</p>
<p>
where
<i>p<sub>w</sub></i> is the atmospheric pressure from the weather bus,
<i>v</i> is the wind speed from the weather bus, and
<i>&rho;</i> is the fluid density.
</p>

<p>
This model differs from <a href=\"modelica://Buildings.Fluid.Sources.Outside_CpData\">
Buildings.Fluid.Sources.Outside_CpData</a> by the calculation of the wind pressure coefficient C<sub>p,act</sub>.
The wind pressure coefficient is defined by an equation in stead of a user-defined table.
This model is only suited for low-rise rectangular buildings.
</p>

<h4>References</h4>
<ul>
<li>
Muthusamy V. Swami and
Subrato Chandra.
<i>
<a href=\"http://www.fsec.ucf.edu/en/publications/pdf/FSEC-CR-163-86.pdf\">
Procedures for
Calculating Natural
Ventilation Airflow
Rates in Buildings.</a></i>
Florida Solar Energy Center, FSEC-CR-163-86. March, 1987.
Cape Canaveral, Florida.
</li>
<li>
Andrew K. Persily and Elizabeth M. Ivy.
<i>
<a href=\"http://ws680.nist.gov/publication/get_pdf.cfm?pub_id=860831\">
Input Data for Multizone Airflow and IAQ Analysis.</a></i>
NIST, NISTIR 6585.
January, 2001.
Gaithersburg, MD.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2023, by Michael Wetter:<br/>
Removed use of non-existent parameter in annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1724\">IBPSA, #1724</a>.
</li>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Jun 28, 2021, by Klaas De Jonge:<br/>
Documentation changes to explain the difference with <a href=\"modelica://Buildings.Fluid.Sources.Outside_CpData\">
Buildings.Fluid.Sources.Outside_CpData</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
October 26, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
          Text(
          visible=use_C_in,
          extent={{-154,-28},{-102,-62}},
          textColor={0,0,255},
          textString="C"),
        Text(
          extent={{-28,22},{28,-22}},
          textColor={255,255,255},
          textString="Cp")}));
end Outside_CpLowRise;
