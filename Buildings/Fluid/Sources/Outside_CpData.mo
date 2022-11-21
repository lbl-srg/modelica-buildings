within Buildings.Fluid.Sources;
model Outside_CpData
  "Boundary that takes weather data as an input and computes the wind pressure from a given wind pressure profile"
  extends Buildings.Fluid.Sources.BaseClasses.Outside;

  parameter Modelica.Units.SI.Angle azi "Surface azimuth (South:0, West:pi/2)"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Angle incAngSurNor[:](
    each displayUnit="deg")
    "Wind incidence angles, relative to the surface normal (normal=0), first point must be 0, last smaller than 2 pi(=360 deg)";
  parameter Real Cp[:](
    each final unit="1")
    "Cp values at the corresponding incAngSurNor";

  parameter Real Cs(
    final min=0,
    final unit="1")=1
    "Wind speed modifier";

  Modelica.Units.SI.Pressure pWin(displayUnit="Pa") = Cs*0.5*CpAct*d*vWin*vWin
   "Change in pressure due to wind force";

  Real CpAct(
    final unit="1") = Buildings.Airflow.Multizone.BaseClasses.windPressureProfile(
      alpha=alpha,incAngTab=
      incAngExt,
      CpTab=CpExt,
      d=deri) "Actual wind pressure coefficient";

  Modelica.Units.SI.Angle alpha = winDir-surOut
    "Wind incidence angle (0: normal to wall)";


protected
  final parameter Modelica.Units.SI.Angle surOut = azi-Modelica.Constants.pi
    "Angle of surface that is used to compute the wind incidence angle relative to the surface normal";

  final parameter Integer n=size(incAngSurNor, 1)
    "Number of data points provided by user";
  final parameter Modelica.Units.SI.Angle incAngExt[n + 3](each displayUnit=
        "deg") = cat(
    1,
    {incAngSurNor[n - 1] - (2*Modelica.Constants.pi)},
    incAngSurNor,
    2*Modelica.Constants.pi .+ {incAngSurNor[1],incAngSurNor[2]})
    "Extended number of incidence angles";
  final parameter Real CpExt[n+3]=cat(1, {Cp[n-1]}, Cp, {Cp[1], Cp[2]})
    "Extended number of Cp values";

  final parameter Real[n+3] deri=
      Buildings.Utilities.Math.Functions.splineDerivatives(
      x=incAngExt,
      y=CpExt,
      ensureMonotonicity=false) "Derivatives for table interpolation";

  Modelica.Blocks.Interfaces.RealInput pAtm(
    min=0,
    nominal=1E5,
    final unit="Pa") "Atmospheric pressure";
  Modelica.Blocks.Interfaces.RealInput vWin(final unit="m/s")
    "Wind speed from weather bus";
  Modelica.Blocks.Interfaces.RealInput winDir(final unit="rad",displayUnit="deg") "Wind direction from weather bus";

  Modelica.Blocks.Interfaces.RealOutput pTot(min=0, nominal=1E5, final unit="Pa")=pAtm + pWin
    "Sum of atmospheric pressure and wind pressure";

  Modelica.Units.SI.Density d = Medium.density(
    Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal))
    "Air density";

initial equation
  assert(size(incAngSurNor, 1) == size(Cp, 1), "In " + getInstanceName() +
    ": Size of parameters are size(CpincAng, 1) = " + String(size(incAngSurNor,
    1)) + " and size(Cp, 1) = " + String(size(Cp, 1)) + ". They must be equal.");

  assert(abs(incAngSurNor[1]) < 1E-4, "In " + getInstanceName() +
    ": First point in the table CpAngAtt must be 0.");

  assert(2*Modelica.Constants.pi - incAngSurNor[end] > 1E-4, "In " +
    getInstanceName() +
    ": Last point in the table CpAngAtt must be smaller than 2 pi (360 deg).");

equation
  connect(weaBus.winDir, winDir);
  connect(weaBus.winSpe, vWin);
  connect(weaBus.pAtm,pAtm);
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
pressure at the fluid ports <code>ports</code>.
</p>
<p>
The pressure <i>p</i> at the fluid ports is computed as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
p = p<sub>w</sub> + C<sub>p,act</sub> C<sub>s</sub> v<sup>2</sup> &rho; &frasl; 2,
</p>
<p>
where <i>p<sub>w</sub></i> is the atmospheric pressure from the weather bus,
<i>v</i> is the wind speed from the weather bus, and
<i>&rho;</i> is the fluid density.
</p>
<p>
The wind pressure coefficient <i>C<sub>p,act</sub></i> is a function of the surface wind incidence
angle and is defined relative to the surface azimuth (normal to the surface is <i>0</i>).
The wind incidence angle <code>incAng</code> is computed from the wind direction obtained from the weather file 
with the surface azimuth <code>azi</code> as the base of the angle.
The relation between the wind pressure coefficient <i>C<sub>p,act</sub></i> and the incidence angle <code>incAng</code>
is defined by a cubic hermite interpolation of the users table input.
Typical table values can be obtained from the &quot;AIVC guide to energy efficient ventilation&quot;,
appendix 2 (1996). The default table is appendix 2, table 2.2, face 1.
</p>
<p>
The wind speed modifier <i>C<sub>s</sub></i> can be used to incorporate the effect of the surroundings on the local wind speed.
</p>
<h4>Definition of angles</h4>
<p>
The angles <code>incAngSurNor</code> for the wind incidence angle relative to the surface normal
are measured counter-clock wise.
The figure below shows an example entry, which is also used in the model
<a href=\"modelica://Buildings.Fluid.Sources.Examples.Outside_CpData_Specification\">
Buildings.Fluid.Sources.Examples.Outside_CpData_Specification</a>.
</p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Sources/Outside_CpData.png\"/> </p>

<p>
The wind incidence angle and surface azimuths are defined as follows:
The wind indicience angle is obtained directly from the weather data bus <code>weaBus.winDir</code>.
This variable contains the data from the weather data file that was read, such as a TMY3 file.
In accordance to TMY3, the data is as shown in the table below.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<caption>Value of <code>winDir</code> if the wind blows from different directions.</caption>
<tr><td></td>  <td style=\"text-align: center\">Wind from North:<br/>0 <br/> 0&deg;</td>  <td></td> </tr>
<tr><td style=\"text-align: center\">Wind from West:<br/>3&pi;/2 <br/> 270&deg;</td>  <td></td>  <td style=\"text-align: center\">Wind from East:<br/>&pi;/2 <br/> 90&deg;</td></tr>
<tr><td></td>  <td style=\"text-align: center\">Wind from South:<br/>&pi; <br/> 180&deg;</td>  <td></td></tr>
</table>
<p>
For the surface azimuth <code>azi</code>, the specification from
<a href=\"modelica://Buildings.Types.Azimuth\">Buildings.Types.Azimuth</a> is
used, which is as shown in the table below.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<caption>Value of <code>azi</code> if the exterior wall faces in the different directions.</caption>
<tr><td></td>  <td style=\"text-align: center\">Wall facing north:<br> &pi; <br/> 180&deg;</td>  <td></td> </tr>
<tr><td style=\"text-align: center\">Wall facing West:<br/> &pi;/2 <br/> 90&deg;</td>  <td></td>  <td style=\"text-align: center\">Wall facing east:<br/> 3&pi;/2 <br/> 270&deg;</td></tr>
<tr><td></td>  <td style=\"text-align: center\">Wall facing South:<br/>0; <br/> 0&deg;</td>  <td></td></tr>
</table>

<h4>Related model</h4>
<p>
This model differs from <a href=\"modelica://Buildings.Fluid.Sources.Outside_CpLowRise\">
Buildings.Fluid.Sources.Outside_CpLowRise</a> by the calculation of the wind pressure coefficient
<i>C<sub>p,act</sub></i>.
The wind pressure coefficient is defined by a user-defined table instead of a generalized equation
such that it can be used for all building sizes and situations, for shielded buildings,
and for buildings with non-rectangular shapes.
</p>
<p>
<b>References</b>
</p>
<ul>
<li>M. W. Liddament, 1996, <i>A guide to energy efficient ventilation</i>. AIVC Annex V. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Line(points={{-56,54},{-56,-44},{52,-44}}, color={255,255,255}),
        Line(points={{-56,16},{-50,16},{-44,12},{-38,-2},{-28,-24},{-20,-40},
              {-12,-42},{-6,-36},{0,-34},{6,-36},{12,-42},{20,-40},{28,-14},{
              36,6},{42,12},{50,14}},
                            color={255,255,255},
          smooth=Smooth.Bezier),
        Text(
          extent={{-54,66},{2,22}},
          textColor={255,255,255},
          textString="Cp")}));
end Outside_CpData;
