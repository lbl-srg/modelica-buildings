within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model ControlVolumeCondensation
  "Control volume model exhibiting the condensation process of water"
  extends
    Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume(
      redeclare final package Medium_a=MediumSte,
      redeclare final package Medium_b=MediumWat);
equation
  // boundary conditions at the ports
  port_a.m_flow = mSte_flow;
  port_a.h_outflow = hSte;
  port_b.m_flow = mWat_flow;
  port_b.h_outflow = hWat;

annotation (defaultComponentName="vol",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
      Line(
        points={{38,40},{-2,20},{38,-20},{-2,-40}},
        color={0,0,255},
        smooth=Smooth.Bezier),
      Line(
        points={{-2,40},{-42,20},{-2,-20},{-42,-40}},
        color={0,0,255},
        smooth=Smooth.Bezier)}),
    Documentation(revisions="<html>
<ul>
<li>
September 15, 2023, by Kathryn Hinkelman:<br/>
Added publication references.
</li>
<li>
February 26, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a condensation process of water with
liquid and vapor phases in equilibrium and at a saturated state.
Further information regarding the model formulation and assumptions
are in the base class
<a href=\"modelica://Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume\">
Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume</a>.

<h4>References </h4>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Wangda Zuo. 2022.
&ldquo;A Fast and Accurate Modeling Approach for Water and Steam
Thermodynamics with Practical Applications in District Heating System Simulation,&rdquo;
<i>Energy</i>, 254(A), pp. 124227.
<a href=\"https://doi.org/10.1016/j.energy.2022.124227\">10.1016/j.energy.2022.124227</a>
</p>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Baptiste Ravache, Wangda Zuo 2022.
&ldquo;Towards Open-Source Modelica Models For Steam-Based District Heating Systems.&rdquo;
<i>Proc. of the 1st International Workshop On Open Source Modelling And Simulation Of
Energy Systems (OSMSES 2022)</i>, Aachen, German, April 4-5, 2022.
<a href=\"https://doi.org/10.1109/OSMSES54027.2022.9769121\">10.1109/OSMSES54027.2022.9769121</a>
</p>
</html>"));
end ControlVolumeCondensation;
