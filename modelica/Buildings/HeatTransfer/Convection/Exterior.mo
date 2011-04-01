within Buildings.HeatTransfer;
model Exterior
  "Model for a exterior (outside) convective heat transfer"
  extends Buildings.HeatTransfer.Convection.BaseClasses.PartialConvection;

  parameter Buildings.HeatTransfer.Types.ExteriorConvection conMod=
    Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_3
    "Convective heat transfer model"
  annotation(Evaluate=true);
  parameter Modelica.SIunits.Angle azi "Surface azimuth";

  Modelica.Blocks.Interfaces.RealInput v(unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput dir(unit="rad", displayUnit="deg",
     min=0, max=2*Modelica.Constants.pi) "Wind direction (0=wind from North)"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.SIunits.CoefficientOfHeatTransfer hF
    "Convective heat transfer coefficient due to forced convection";
  Modelica.SIunits.HeatFlux qN_flow
    "Convective heat flux from solid -> fluid due to natural convection";
  Modelica.SIunits.HeatFlux qF_flow
    "Convective heat flux from solid -> fluid due to forced convection";
protected
   parameter Real R(fixed=false) "Surface roughness";
   Real W(min=0.5, max=1) "Wind direction modifier";
initial equation
  if (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_1) then
    R=2.17;
  elseif (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_2) then
    R=1.67;
  elseif (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_3) then
    R=1.52;
  elseif (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_4) then
    R=1.13;
  elseif (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_5) then
    R=1.11;
  elseif (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_6) then
    R=1.00;
  else
    R=0;
  end if;
equation
  if (conMod == Buildings.HeatTransfer.Types.ExteriorConvection.Fixed) then
    qN_flow = hFixed * dT;
    W = 0;
    hF = 0;
    qF_flow = 0;
  else
    // Even if hCon is a step function with a step at zero,
    // the product hCon*dT is differentiable at zero with
    // a continuous first derivative
    if isCeiling then
       qN_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.ceiling(dT=dT);
    elseif isFloor then
       qN_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.floor(dT=dT);
    else
       qN_flow = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.wall(dT=dT);
    end if;
    // Forced convection
    W = Buildings.HeatTransfer.Functions.windDirectionModifier(azi=azi, dir=dir);
    hF = 2.537 * W * R * 2 / A^(0.25) *
         Buildings.Utilities.Math.Functions.regNonZeroPower(x=v, n=0.5, delta=0.5);
    qF_flow = hF*dT;
  end if;
  q_flow = qN_flow + qF_flow;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
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
          lineColor={255,0,0},
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
          lineColor={0,0,127},
          textString="v"),               Text(
          extent={{-100,64},{-62,34}},
          lineColor={0,0,127},
          textString="dir")}),
    defaultComponentName="con",
    Documentation(info="<html>
This is a model for a convective heat transfer for exterior, outside-facing surfaces.
The parameter <code>conMod</code> determines the model that is used to compute
the heat transfer coefficient:
</p>
<p>
<ol>
<li><p>If <code>conMod=Buildings.HeatTransfer.Types.ExteriorConvection.Fixed</code>, then
the convective heat transfer coefficient is set to the value specified by the parameter
<code>hFixed</code>.
</p>
</li>
<li>
<p>
If <code>conMod=Buildings.HeatTransfer.Types.ExteriorConvection.SimpleCombined_x</code>,
where <code>x = 1, 2, 3, 4, 5, 6</code>, then the convective heat transfer coefficient is
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
The forced convection coefficient <i>h<sub>f</i> 
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
The coefficients for the surface roughness are
</p>
<p>
<table border=\"1\">
<tr>
<th>Roughness index</th>
<th><i>R</i></th>
<th>Example material</th>
</tr>
<tr><td>1 (very rough)</td>   <td>2.17</td>  <td>Stucco</td></tr>
<tr><td>2 (rough)</td>        <td>1.67</td>  <td>Brick</td></tr>
<tr><td>3 (medium rough)</td> <td>1.52</td>  <td>Concrete</td></tr>
<tr><td>4 (medium smooth)</td><td>1.13</td>  <td>Clear pine</td></tr>
<tr><td>5 (smooth)</td>       <td>1.11</td>  <td>Smooth plaster</td></tr>
<tr><td>6 (very smooth)</td>  <td>1.00</td>  <td>Glass</td></tr>
</tr>
</table>
</p>
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
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Exterior;
