within Buildings.HeatTransfer.Windows.Functions;
function devAbsInteriorIrradiationInteriorShading
  "Hemiperical absorptance of a shading device for interior irradiation with interior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrIntShaDev(min=0, max=1)
    "Hemiperical absorbtance of a shading device for interior irradiation with interior shading";
protected
  constant Real rRho=traRef[3, N, 1, HEM]*refIntShaDev
    "Part of equation (A.4.103)";
  constant Real rTau=traRef[3, N, 1, HEM]*traIntShaDev
    "Part of equation (A.4.103)";
  constant Real c=traIntShaDev*(1 - rRho/(1 - rRho)) "Equation (4.99)";

algorithm
  absIntIrrIntShaDev := (1 - traIntShaDev - refIntShaDev)*(1 + rTau/(1 - rRho))
    "Equation (4.103)";

  annotation (Documentation(info="<html>
<p>
This function computes the hemiperical absorbtance of a shading device for interior irradiation with interior shading.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end devAbsInteriorIrradiationInteriorShading;
