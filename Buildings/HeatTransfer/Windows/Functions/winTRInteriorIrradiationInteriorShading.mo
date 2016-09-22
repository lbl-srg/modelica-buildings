within Buildings.HeatTransfer.Windows.Functions;
function winTRInteriorIrradiationInteriorShading
  "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real traRefIntIrrIntSha[3, NSta](each min=0, each max=1)
    "Hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading";

protected
  Real rRho;
  Real rTau;
  Real c;

algorithm
  for iSta in 1:NSta loop
    rRho:=traRef[Rb, N, 1, HEM, iSta]*refIntShaDev "Part of Equation (A.4.99)";
    rTau:=traRef[Rb, N, 1, HEM, iSta]*traIntShaDev "Part of Equation (A.4.105)";
    c:=traIntShaDev*(1 + rRho/(1 - rRho)) "Equation (A.4.99)";

    traRefIntIrrIntSha[TRA, iSta] := c*traRef[TRA, N, 1, HEM, iSta]
      "Equation (A.4.100b)";
    traRefIntIrrIntSha[Rb, iSta] := refIntShaDev + c*rTau "Equation (A.4.105)";
    traRefIntIrrIntSha[Ra, iSta] := 0 "Dummy value";
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical transmittance and back reflectance of a window system (glass and shading device) for interior irradiation with interior shading.
Pane <code>1</code> is facing the outside and pane <code>N</code> is facing the room.
</p>
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
end winTRInteriorIrradiationInteriorShading;
