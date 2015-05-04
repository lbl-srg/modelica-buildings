within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function pressure
  "Flow vs. head characteristics for fan or pump pressure raise"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal
    per "Pressure performance data";
  input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Modelica.SIunits.VolumeFlowRate VDelta_flow "Small volume flow rate";
  input Modelica.SIunits.Pressure dpDelta "Small pressure";

  input Modelica.SIunits.VolumeFlowRate V_flow_max
    "Maximum volume flow rate at r_N=1 and dp=0";
  input Modelica.SIunits.Pressure dpMax(min=0)
    "Maximum pressure at r_N=1 and V_flow=0";

  input Real d[:] "Derivatives at support points for spline interpolation";
  input Real delta "Small value used to transition to other fan curve";
  input Real cBar[2]
    "Coefficients for linear approximation of pressure vs. flow rate";
  input Real kRes(unit="kg/(s.m4)")
    "Linear coefficient for fan-internal pressure drop";
  output Modelica.SIunits.Pressure dp "Pressure raise";

protected
   Integer dimD(min=2)=size(per.V_flow, 1) "Dimension of data vector";

  function performanceCurve "Performance curve away from the origin"
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
    input Real d[dimD] "Coefficients for polynomial of pressure vs. flow rate";
    input
      Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal per
      "Pressure performance data";
    input Integer dimD "Dimension of data vector";

    output Modelica.SIunits.Pressure dp "Pressure raise";

  protected
    Modelica.SIunits.VolumeFlowRate rat "Ratio of V_flow/r_N";
    Integer i "Integer to select data interval";
  algorithm
    rat := V_flow/r_N;
    i :=1;
    // Since the coefficients for the spline were evaluated for
    // rat_nominal = V_flow_nominal/r_N_nominal = V_flow_nominal/1, we use
    // V_flow_nominal below
    for j in 1:dimD-1 loop
       if rat > per.V_flow[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data
    dp:=r_N^2*Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=rat,
                x1=per.V_flow[i],
                x2=per.V_flow[i + 1],
                y1=per.dp[i],
                y2=per.dp[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
    annotation(smoothOrder=1);
  end performanceCurve;

algorithm
  if r_N >= delta then
     dp := performanceCurve(V_flow=V_flow, r_N=r_N, d=d,
                            per=per, dimD=dimD);
  elseif r_N <= delta/2 then
    dp := flowApproximationAtOrigin(r_N=r_N, V_flow=V_flow,
                                    VDelta_flow=  VDelta_flow, dpDelta=dpDelta,
                                    delta=delta, cBar=cBar);
  else
    dp := Modelica.Fluid.Utilities.regStep(x=r_N-0.75*delta,
                                           y1=performanceCurve(V_flow=V_flow, r_N=r_N, d=d,
                                                               per=per, dimD=dimD),
                                           y2=flowApproximationAtOrigin(r_N=r_N, V_flow=V_flow,
                                                   VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                   delta=delta, cBar=cBar),
                                           x_small=delta/4);
  end if;
  // linear equation for being able to handle r_N=0, see
  // Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf
  dp := dp - V_flow*kRes;
  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the fan static
pressure raise as a function of volume flow rate and revolution in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = r<sub>N</sub><sup>2</sup> &nbsp; s(V&#775;/r<sub>N</sub>, d)
  - &Delta;p<sub>r</sub> ,
</p>
<p>
where
<i>&Delta;p</i> is the pressure rise,
<i>r<sub>N</sub></i> is the normalized fan speed,
<i>V&#775;</i> is the volume flow rate and
<i>d</i> are performance data for fan or pump power consumption at <i>r<sub>N</sub>=1</i>.
The term
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;p<sub>r</sub> = V&#775; &nbsp; &Delta;p<sub>max</sub> &frasl; V&#775;<sub>max</sub> &nbsp; &delta;
</p>
<p>
where <i>&delta; &gt; 0</i> is a pressure that is small compared to pressure raise of the
fan at the nominal conditions,
models the flow resistance of the fan, approximated using a linear equation.
This is done for numerical reasons to avoid a singularity at <i>r<sub>N</sub>=0</i>.
Since <i>&delta;</i> is small, the contribution of this term is small.
The fan and pump models in
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a> modify the user-supplied performance data to add the term
<i>&Delta;p<sub>r</sub></i> prior to computing the performance curve.
Thus, at full speed, the fan or pump can operate exactly at the user-supplied performance data.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
<p>
For <i>r<sub>N</sub> &lt; &delta;</i>, the polynomial is replaced with an other model to avoid
a singularity at the origin. The composite model is once continuously differentiable
in all input variables.
</p>
</html>",
        revisions="<html>

<ul>
<li>
April 22, by Filip Jorissen:<br/>
Added more documentation references to paper
</li>
<li>
August 25, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=1);
end pressure;
