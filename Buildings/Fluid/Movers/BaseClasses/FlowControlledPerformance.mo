within Buildings.Fluid.Movers.BaseClasses;
model FlowControlledPerformance
  "Partial model with performance curves for fans or pumps"
  extends Modelica.Blocks.Icons.Block;

//  parameter Modelica.SIunits.Efficiency etaMot_nominal(max=1) = 0.7
//    "Motor efficiency of pump or fan";
//  parameter Modelica.SIunits.Efficiency etaHyd_nominal(max=1) = 0.7
//    "Hydraulic efficiency of pump or fan";

  parameter Modelica.SIunits.Density rho_default
    "Fluid density at medium default state";

 // Normalized speed

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput rho(
    final quantity="Density",
    final unit="kg/m3",
    min=0.0) "Medium density"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput V_flow(
    quantity="VolumeFlowRate",
    final unit="m3/s") "Volume flow rate"
    annotation (Placement(transformation(extent={{100,38},{120,58}}),
        iconTransformation(extent={{100,38},{120,58}})));

  Modelica.Blocks.Interfaces.RealInput dp_in(
    quantity="PressureDifference",
    final unit="Pa") "Prescribed pressure increase"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));

  Modelica.Blocks.Interfaces.RealOutput dp(
    quantity="Pressure",
    final unit="Pa") "Pressure increase (computed or prescribed)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput WFlo(
    quantity="Power",
    final unit="W") "Flow work"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,-20},{120,0}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Modelica.Blocks.Interfaces.RealOutput eta(
    final quantity="Efficiency",
    final unit="1") "Overall efficiency"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput etaHyd(
    final quantity="Efficiency",
    final unit="1") "Hydraulic efficiency"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Modelica.Blocks.Interfaces.RealOutput etaMot(
    final quantity="Efficiency",
    final unit="1") "Motor efficiency"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}}),
        iconTransformation(extent={{100,-110},{120,-90}})));

  // "Shaft rotational speed";
//  Modelica.Blocks.Interfaces.RealOutput r_N(unit="1")
//    "Ratio N_actual/N_nominal";
//  Real r_V(start=1, unit="1") "Ratio V_flow/V_flow_max";


equation
  V_flow = m_flow/rho;
  dp = dp_in;
  // Hydraulic equations
//  r_V = V_flow/V_flow_max;

  // Flow work
  WFlo = dp_in*V_flow;
  etaHyd = 0.7;
  etaMot = 0.7;
  eta = etaHyd * etaMot;
  PEle = WFlo / eta;


  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(extent={{56,66},{106,52}},
          lineColor={0,0,127},
          textString="dp"),
        Text(extent={{56,8},{106,-6}},
          lineColor={0,0,127},
          textString="PEle"),
        Text(extent={{52,-22},{102,-36}},
          lineColor={0,0,127},
          textString="eta"),
        Text(extent={{50,-52},{100,-66}},
          lineColor={0,0,127},
          textString="etaHyd"),
        Text(extent={{50,-72},{100,-86}},
          lineColor={0,0,127},
          textString="etaMot"),
        Ellipse(
          extent={{-78,34},{44,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,18},{28,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,-18},{-8,-36}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-22},{-32,-8},{-30,10},{-8,20},{-6,14},{-24,6},{-24,-8},{
              -18,-20},{-26,-22}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-8,-32},{-2,-46},{-4,-64},{-26,-74},{-28,-68},{-10,-60},{-10,
              -46},{-16,-34},{-8,-32}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{7,21},{13,7},{11,-11},{-11,-21},{-13,-15},{5,-7},{5,7},{-1,19},
              {7,21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={9,-23},
          rotation=90),
        Polygon(
          points={{-7,-21},{-13,-7},{-11,11},{11,21},{13,15},{-5,7},{-5,-7},{1,-19},
              {-7,-21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={-43,-31},
          rotation=90),
        Text(extent={{56,36},{106,22}},
          lineColor={0,0,127},
          textString="WFlo"),
        Text(extent={{56,94},{106,80}},
          lineColor={0,0,127},
          textString="V_flow")}),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw
and efficiency of fans and pumps that take as control input the mass flow rate or head.
</p>
<p>
The nominal hydraulic characteristic (volume flow rate versus total pressure)
is not computed by this model as such a computation is not well defined
for certain operating conditions. For example, if a pump is exposed to some pressure
difference but has zero flow rate, computing the associated speed has
shown to be numerically difficult, in some cases leading to negative speeds.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
February 19, 2016, by Michael Wetter and Filip Jorissen:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference and reformatted code.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 2, 2015, by Michael Wetter:<br/>
Corrected computation of
<code>etaMot = cha.efficiency(per=per.motorEfficiency, V_flow=V_flow, d=motDer, r_N=r_N, delta=1E-4)</code>
which previously used <code>V_flow_max</code> instead of <code>V_flow</code>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Removed in <code>N_actual</code> and <code>N_filtered</code>
the <code>max</code> attribute to
avoid a translation warning.
</li>
<li>
April 21, 2014, by Filip Jorissen and Michael Wetter:<br/>
Changed model to use
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
April 19, 2014, by Filip Jorissen:<br/>
Passed extra parameters to power() and efficiency()
to be able to properly evaluate the
scaling law. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Reformulated <code>per=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3</code>
by moving the computation into the idividual logical branches because OpenModelica generates an
error when assign the statement to <code>data</code>
as <code>pCur1</code>, <code>pCur2</code> and <code>pCur3</code> have different dimensions.
</li>
<li>
September 17, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of parameters
that are an array.
</li>
<li>
March 20, 2013, by Michael Wetter:<br/>
Removed assignment in declaration of <code>pCur?.V_flow</code> as
these parameters have the attribute <code>fixed=false</code> set.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
Changed implementation of <code>etaMot=sqrt(eta)</code> to
<code>etaHyd = 1</code> to avoid infinite derivative as <code>eta</code>
converges to zero.
</li>
<li>
February 20, 2012, by Michael Wetter:<br/>
Assigned value to nominal attribute of <code>V_flow</code>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
October 4 2011, by Michael Wetter:<br/>
Revised the implementation of the pressure drop computation as a function
of speed and volume flow rate.
The new implementation avoids a singularity near zero volume flow rate and zero speed.
</li>
<li>
March 28 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 23 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowControlledPerformance;
