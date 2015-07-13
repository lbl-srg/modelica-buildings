within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationInteriorShading
  "Hemispherical absorptance of each glass pane for interior irradiation with interior shading"
  input Real absIntIrrNoSha[N](each min=0, each max=1)
    "Hemispherical absorptance wfor interior irradiation without interior shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrIntSha[N](each min=0, each max=1)
    "Hemispherical absorbtance of each glass pane for interior irradiation with interior shading";

protected
  constant Real rRho=traRef[Rb, N, 1, HEM]*refIntShaDev
    "Part of Equation (4.99)";
  constant Real c=traIntShaDev*(1 + rRho/(1 - rRho)) "Equation (4.99)";

algorithm
  for i in 1:N loop
    absIntIrrIntSha[i] := c*absIntIrrNoSha[i] "Equation (A4.100a)";
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorbtance of each glass pane for interior irradiation with interior shading.
Pane <code>1</code> is facing the outside and pane <code>N</code> is facing the room.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassAbsInteriorIrradiationInteriorShading;
