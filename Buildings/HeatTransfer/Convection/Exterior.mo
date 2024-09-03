within Buildings.HeatTransfer.Convection;
model Exterior "Model for a exterior (outside) convective heat transfer"
  extends Buildings.HeatTransfer.Convection.BaseClasses.PartialConvection;

  parameter Buildings.HeatTransfer.Types.ExteriorConvection conMod=
    Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind
    "Convective heat transfer model"
  annotation(Evaluate=true);

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient" annotation (Dialog(enable=(conMod ==
          Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)));

  parameter Buildings.HeatTransfer.Types.SurfaceRoughness roughness=
    Buildings.HeatTransfer.Types.SurfaceRoughness.Medium "Surface roughness"
    annotation (Dialog(enable=(conMod <> Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)));
  parameter Modelica.Units.SI.Angle azi "Surface azimuth";

  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt"
    annotation (Dialog(enable=(conMod <> Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)));

  Modelica.Blocks.Interfaces.RealInput v(unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput dir(unit="rad", displayUnit="deg",
     min=0, max=2*Modelica.Constants.pi) "Wind direction (0=wind from North)"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Units.SI.CoefficientOfHeatTransfer hF
    "Convective heat transfer coefficient due to forced convection";
  Modelica.Units.SI.HeatFlux qN_flow
    "Convective heat flux from solid -> fluid due to natural convection";
  Modelica.Units.SI.HeatFlux qF_flow
    "Convective heat flux from solid -> fluid due to forced convection";
protected
  constant Modelica.Units.SI.Velocity v_small=0.5
    "Small value for wind velocity below which equations are regularized";
  final parameter Real cosTil=Modelica.Math.cos(til) "Cosine of window tilt";
  final parameter Real sinTil=Modelica.Math.sin(til) "Sine of window tilt";
  final parameter Boolean is_ceiling = abs(sinTil) < 10E-10 and cosTil > 0
    "Flag, true if the surface is a ceiling";
  final parameter Boolean is_floor = abs(sinTil) < 10E-10 and cosTil < 0
    "Flag, true if the surface is a floor";

  parameter Real R(fixed=false) "Surface roughness";

  Real W(min=0.5, max=1) "Wind direction modifier";

initial equation
  if (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.VeryRough) then
    R=2.17;
  elseif (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.Rough) then
    R=1.67;
  elseif (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.Medium) then
    R=1.52;
  elseif (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.MediumSmooth) then
    R=1.13;
  elseif (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth) then
    R=1.11;
  elseif (roughness == Buildings.HeatTransfer.Types.SurfaceRoughness.VerySmooth) then
    R=1.00;
  else
    R=0;
  end if;
equation
  if (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.Fixed) then
    qN_flow = hFixed * dT;
    W = 1;
    hF = 0;
    qF_flow = 0;
  else
    // Even if hCon is a step function with a step at zero,
    // the product hCon*dT is differentiable at zero with
    // a continuous first derivative
    if is_ceiling then
       qN_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling(dT=dT);
    elseif is_floor then
       qN_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor(dT=dT);
    else
       qN_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall(dT=dT);
    end if;
    // Forced convection
    W = Buildings.Utilities.Math.Functions.regStep(
          x = v-v_small/2,
          y1 = Buildings.HeatTransfer.Convection.Functions.windDirectionModifier(
            azi=azi,
            dir=dir),
          y2 = 0.75,
          x_small=v_small/4);
    hF = 2.537 * W * R * 2 / A^(0.25) *
       Buildings.Utilities.Math.Functions.regNonZeroPower(
           x=v,
           n=0.5,
           delta=v_small);
    qF_flow = hF*dT;
  end if;
  q_flow = qN_flow + qF_flow;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-35,42},{-5,20}},
          textColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0}),
                                         Text(
          extent={{-102,128},{-64,98}},
          textColor={0,0,127},
          textString="v"),               Text(
          extent={{-100,64},{-62,34}},
          textColor={0,0,127},
          textString="dir")}),
    defaultComponentName="con",
    Documentation(info="<html>
<p>
This is a model for a convective heat transfer for exterior, outside-facing surfaces.
The parameter <code>conMod</code> determines the model that is used to compute
the heat transfer coefficient:
</p>

<ol>
<li><p>If <code>conMod=
<a href=\"modelica://Buildings.HeatTransfer.Types.ExteriorConvection\">
Buildings.HeatTransfer.Types.ExteriorConvection.Fixed</a>
</code>, then
the convective heat transfer coefficient is set to the value specified by the parameter
<code>hFixed</code>.
</p>
</li>
<li>
<p>
If <code>conMod=
<a href=\"modelica://Buildings.HeatTransfer.Types.ExteriorConvection\">
Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind</a>
</code>,
then the convective heat transfer coefficient is
computed based on wind speed, wind direction and temperature difference.
</p>
<p>
The total convection coefficient <i>h<sub>t</sub></i> is the sum of the
temperature-driven free convection coefficient <i>h<sub>n</sub></i>
and the wind-driven forced convection coefficient <i>h<sub>f</sub></i>,
<p align=\"center\" style=\"font-style:italic;\">
 h<sub>t</sub> = h<sub>n</sub> + h<sub>f</sub>
</p>
The free convection coefficient <i>h<sub>n</sub></i> is computed in the same way as in
<a href=\"modelica://Buildings.HeatTransfer.Convection.Interior\">
Buildings.HeatTransfer.Convection.Interior</a>.
The forced convection coefficient <i>h<sub>f</sub></i>
is computed based on a correlation by Sparrow, Ramsey, and Mass
(1979), which is
<p align=\"center\" style=\"font-style:italic;\">
 h<sub>f</sub> = 2.537 W R &radic;( P v &frasl; A )
</p>
<p>
where <i>W=1</i> for windward surfaces and
<i>W=0.5</i> for leeward surfaces, with leeward defined as greater than 100 degrees
from normal incidence,
<i>R</i> is a surface roughness multiplier,
<i>P</i> is the perimeter of the surface and
<i>A</i> is the area of the surface.
This is the same equation as implemented in EnergyPlus 6.0.
</p>
<p>
We make the simplified assumption that the surface is square, and hence we set
<p align=\"center\" style=\"font-style:italic;\">
 h<sub>f</sub> = 2.537 W R &radic;( 4 v &frasl; &radic;(A) )
</p>
<p>
The surface roughness is specified by the parameter <code>surfaceRoughness</code>
which has to be set to a type of
<a href=\"modelica://Buildings.HeatTransfer.Types.SurfaceRoughness\">
Buildings.HeatTransfer.Types.SurfaceRoughness</a>.The coefficients for the surface roughness are
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Roughness index</th>
<th><i>R</i></th>
<th>Example material</th>
</tr>
<tr><td>VeryRough</td>   <td>2.17</td>  <td>Stucco</td></tr>
<tr><td>Rough</td>        <td>1.67</td>  <td>Brick</td></tr>
<tr><td>MediumRough</td> <td>1.52</td>  <td>Concrete</td></tr>
<tr><td>MediumSmooth</td><td>1.13</td>  <td>Clear pine</td></tr>
<tr><td>Smooth</td>       <td>1.11</td>  <td>Smooth plaster</td></tr>
<tr><td>VerySmooth</td>  <td>1.00</td>  <td>Glass</td></tr>
</table>

</li>
</ol>
<h4>References</h4>
<p>
Sparrow, E. M., J. W. Ramsey, and E. A. Mass. 1979. Effect of Finite Width on Heat Transfer
and Fluid Flow about an Inclined Rectangular Plate. Journal of Heat Transfer, Vol. 101, p.
204.
</p>
<p>
Walton, G. N. 1981. Passive Solar Extension of the Building Loads Analysis and System
Thermodynamics (BLAST) Program, Technical Report, United States Army Construction
Engineering Research Laboratory, Champaign, IL.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Michael Wetter:<br/>
Change parameter <code>isFloor</code> to <code>is_floor</code>,
and <code>isCeiling</code> to <code>is_ceiling</code>,
for consistency with naming convention.
</li>
<li>
May 7, 2020, by Michael Wetter:<br/>
Set wind direction modifier to a constant as wind velocity approaches zero.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1923\">#1923</a>.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Refactored model as part of enabling the pedantic model check in Dymola 2017 FD01 beta 2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
November 29, 2011, by Michael Wetter:<br/>
Fixed error in assignment of wind-based convection coefficient.
The old implementation did not take into account the surface roughness.
Bug fix is due to feedback from Tobias Klingbeil (Fraunhofer ISE).
</li>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Exterior;
