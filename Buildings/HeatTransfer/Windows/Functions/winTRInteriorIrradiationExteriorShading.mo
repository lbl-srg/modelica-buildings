within Buildings.HeatTransfer.Windows.Functions;
function winTRInteriorIrradiationExteriorShading
  "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with exterior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;
  output Real traRefIntIrrExtSha[3, NSta](each min=0, each max=1)
    "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with exterior shading";
algorithm
  for iSta in 1:NSta loop
    traRefIntIrrExtSha[TRA, iSta] := traRef[TRA, N, 1, HEM, iSta]*traExtShaDev/(1 -
      refExtShaDev*traRef[Ra, 1, N, HEM, iSta]) "Equation (A.4.95)";
    traRefIntIrrExtSha[Rb, iSta] := traRef[Rb, N, 1, HEM, iSta] + traRef[TRA, N, 1, HEM, iSta]*
      refExtShaDev*traRef[1, 1, N, HEM, iSta]/(1 - traRef[Ra, 1, N, HEM, iSta]*refExtShaDev)
      "Equation (A.4.97)";
    traRefIntIrrExtSha[Ra, iSta] := 0 "Dummy value";
  end for;
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
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end winTRInteriorIrradiationExteriorShading;
