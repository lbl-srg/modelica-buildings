within Buildings.HeatTransfer.Windows.Functions;
function winTRInteriorIrradiationInteriorShading
  "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real traRefIntIrrIntSha[3](each min=0, each max=1)
    "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading";

protected
  constant Real rRho=traRef[Rb, N, 1, HEM]*refIntShaDev
    "Part of Equation (A.4.99)";
  constant Real rTau=traRef[Rb, N, 1, HEM]*traIntShaDev
    "Part of Equation (A.4.105)";
  constant Real c=traIntShaDev*(1 + rRho/(1 - rRho)) "Equation (A.4.99)";

algorithm
  traRefIntIrrIntSha[TRA] := c*traRef[TRA, N, 1, HEM] "Equation (A.4.100b)";
  traRefIntIrrIntSha[Rb] := refIntShaDev + c*rTau "Equation (A.4.105)";
  traRefIntIrrIntSha[Ra] := 0 "Dummy value";

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading.
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
end winTRInteriorIrradiationInteriorShading;
