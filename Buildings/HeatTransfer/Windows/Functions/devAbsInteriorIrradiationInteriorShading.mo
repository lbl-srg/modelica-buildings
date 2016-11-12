within Buildings.HeatTransfer.Windows.Functions;
function devAbsInteriorIrradiationInteriorShading
  "Hemiperical absorptance of a shading device for interior irradiation with interior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrIntShaDev[NSta](each min=0, each max=1)
    "Hemiperical absorbtance of a shading device for interior irradiation with interior shading";
protected
  Real rRho;
  Real rTau;
  Real c;

algorithm
  for iSta in 1:NSta loop
    rRho:=traRef[3, N, 1, HEM, iSta]*refIntShaDev "Part of equation (A.4.103)";
    rTau:=traRef[3, N, 1, HEM, iSta]*traIntShaDev "Part of equation (A.4.103)";
    c:=traIntShaDev*(1 - rRho/(1 - rRho)) "Equation (4.99)";

    absIntIrrIntShaDev[iSta] := (1 - traIntShaDev - refIntShaDev)*(1 + rTau/(1 - rRho))
      "Equation (4.103)";
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemiperical absorbtance of a shading device for interior irradiation with interior shading.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2016, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
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
end devAbsInteriorIrradiationInteriorShading;
