within Buildings.HeatTransfer.Windows.Functions;
function winTRInteriorIrradiationExteriorShading
  "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with exterior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;
  output Real traRefIntIrrExtSha[3](each min=0, each max=1)
    "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with exterior shading";
algorithm
  traRefIntIrrExtSha[TRA] := traRef[TRA, N, 1, HEM]*traExtShaDev/(1 -
    refExtShaDev*traRef[Ra, 1, N, HEM]) "Equation (A.4.95)";
  traRefIntIrrExtSha[Rb] := traRef[Rb, N, 1, HEM] + traRef[TRA, N, 1, HEM]*
    refExtShaDev*traRef[1, 1, N, HEM]/(1 - traRef[Ra, 1, N, HEM]*refExtShaDev)
    "Equation (A.4.97)";
  traRefIntIrrExtSha[Ra] := 0 "Dummy value";
  annotation (Documentation(info="<html>
This function computes hemispherical transmittance and back reflectance of a window for interior irradiation with exterior shading.
Pane <code>1</code> is facing the outside and pane <code>N</code> is facing the room.
The variables are<br/>
<pre>
traRefIntIrrExtSha[1]: Transmittance;
traRefIntIrrExtSha[2]: Back reflectance;
traRefIntIrrExtSha[3]: Dummy value
</pre>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end winTRInteriorIrradiationExteriorShading;
