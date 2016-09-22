within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationInteriorShading
  "Hemispherical absorptance of each glass pane for interior irradiation with interior shading"
  input Real absIntIrrNoSha[N, NSta](each min=0, each max=1)
    "Hemispherical absorptance wfor interior irradiation without interior shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrIntSha[N, NSta](each min=0, each max=1)
    "Hemispherical absorbtance of each glass pane for interior irradiation with interior shading";

protected
  Real rRho;
  Real c;

algorithm
  for iSta in 1:NSta loop
    rRho :=traRef[Rb, N, 1, HEM, iSta]*refIntShaDev "Part of Equation (4.99)";
    c :=traIntShaDev*(1 + rRho/(1 - rRho)) "Equation (4.99)";
    for i in 1:N loop
      absIntIrrIntSha[i, iSta] := c*absIntIrrNoSha[i, iSta]
        "Equation (A4.100a)";
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorbtance of each glass pane for interior irradiation with interior shading.
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
end glassAbsInteriorIrradiationInteriorShading;
