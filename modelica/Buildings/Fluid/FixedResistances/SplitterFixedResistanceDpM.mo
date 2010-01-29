within Buildings.Fluid.FixedResistances;
model SplitterFixedResistanceDpM
  "Flow splitter with fixed resistance at each port"
    extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
    mDyn_flow_nominal = sum(m_flow_nominal[:]/3),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
         redeclare package Medium=Medium,
         from_dp=from_dp, m_flow_nominal=m_flow_nominal[1], dp_nominal=dp_nominal[1],
         ReC=ReC[1], dh=dh[1],
         linearized=linearized, deltaM=deltaM),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
         redeclare package Medium=Medium,
         from_dp=from_dp, m_flow_nominal=m_flow_nominal[2], dp_nominal=dp_nominal[2],
         ReC=ReC[2], dh=dh[2],
         linearized=linearized, deltaM=deltaM),
      redeclare Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
         redeclare package Medium=Medium,
         from_dp=from_dp, m_flow_nominal=m_flow_nominal[3], dp_nominal=dp_nominal[3],
         ReC=ReC[3], dh=dh[3],
         linearized=linearized, deltaM=deltaM));

  annotation (Diagram(graphics),
                       Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{-100,-46},{-32,-40},{-32,-100},{30,-100},{30,-36},{100,-30},
              {100,38},{-100,52},{-100,-46}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-34},{-18,-28},{-18,-100},{18,-100},{18,-26},{100,-20},
              {100,22},{-100,38},{-100,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255}),
        Ellipse(
   visible=dynamicBalance,
          extent={{-38,36},{40,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model of a flow splitter (or mixer) with a fixed resistance in each flow leg.
</p>
</html>"),
revisions="<html>
<ul>
<li>
June 11, 2008 by Michael Wetter:<br>
Based class on 
<a href=\"Modelica:Buildings.Fluid.BaseClasses.PartialThreeWayFixedResistance\">
PartialThreeWayFixedResistance</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");

  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter" 
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.SIunits.MassFlowRate[3] m_flow_nominal(each min=0)
    "Mass flow rate"                                                annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure[3] dp_nominal(each min=0) "Pressure" 
                                                      annotation(Dialog(group = "Nominal condition"));
  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs" 
       annotation(Dialog(enable = not use_dh and not linearized));

  parameter Modelica.SIunits.Length[3] dh={1, 1, 1} "Hydraulic diameter" 
    annotation(Dialog(enable = use_dh and not linearized));
  parameter Real[3] ReC={4000, 4000, 4000}
    "Reynolds number where transition to turbulent starts" 
      annotation(Dialog(enable = use_dh and not linearized));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
end SplitterFixedResistanceDpM;
