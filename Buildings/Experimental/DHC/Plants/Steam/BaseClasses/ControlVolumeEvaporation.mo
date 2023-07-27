within Buildings.Experimental.DHC.Plants.Steam.BaseClasses;
model ControlVolumeEvaporation
  "Control volume model exhibiting the evaporation process of water"
  extends Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte,
    hSte(start = MediumSte.h_default),
    hWat(start = MediumWat.h_default),
    p(final fixed=fixed_p_start));
  parameter Boolean fixed_p_start = false
    "Set to true if p_start is to be used as an explicit initial equation, 
    not an initial guess"
    annotation(Dialog(tab = "Initialization"));
equation
// boundary conditions at the ports
  port_a.m_flow = mWat_flow;
  port_a.h_outflow = hWat;
  port_b.m_flow = mSte_flow;
  port_b.h_outflow = hSte;

annotation (defaultComponentName="vol",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
    graphics={
      Line(
        points={{40,42},{0,22},{40,-18},{0,-38}},
        color={238,46,47},
        smooth=Smooth.Bezier),
      Line(
        points={{0,42},{-40,22},{0,-18},{-40,-38}},
        color={238,46,47},
        smooth=Smooth.Bezier)}),
    Documentation(revisions="<html>
<ul>
<li>
February 26, 2022 by Kathryn Hinkelman:<br/>
Moved control volume formulation into a base class 
for reusability in condensation and evaporation instances.
</li>
<li>
July 22, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents an evaporation process of water with 
liquid and vapor phases in equilibrium and at a saturated state.
Further information regarding the model formulation and assumptions
are in the base class 
<a href=\"modelica://Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume\">
Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume</a>.

<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>"));
end ControlVolumeEvaporation;
