within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationNoShading
  "Hemispherical absorptance of each glass pane for interior irradiation without shading"

  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowRadiation;

  output Real[N, NSta] absIntIrrNoSha(each min=0, each max=1)
    "Hemispherical absorptance of each glass layer for interior irradiation without shading";

protected
  Real dTraRef[3, N, N, HEM, NSta](each min=0, each max=1)
    "Dummy transmittance and reflectance with exterior irradiation without shading";
  Real dAbs[N, HEM, NSta](each min=0, each max=1)
    "Dummy absorptance with exterior irradiation and no shading";

algorithm
    // Reverse the data structure for exterior irradiation and no shading
  for i in 1:N loop
    for j in 1:N loop
      for iD in 1:HEM loop
        dTraRef[TRA, i, j, iD, 1:NSta] := traRef[TRA, N + 1 - i, N + 1 - j, iD, 1:NSta];
        dTraRef[Ra, i, j, iD, 1:NSta] := traRef[Rb, N + 1 - i, N + 1 - j, iD, 1:NSta];
        dTraRef[Rb, i, j, iD, 1:NSta] := traRef[Ra, N + 1 - i, N + 1 - j, iD, 1:NSta];
      end for;
    end for;
  end for;

  dAbs :=
    Buildings.HeatTransfer.Windows.Functions.glassAbsExteriorIrradiationNoShading(
    traRef=dTraRef,
    N=N,
    NSta=NSta,
    HEM=HEM) "Dummmy absorptance with exterior irradiation";

  // Only output hemispherical absorptance. Need to change order for interior irradiation.
  for i in 1:N loop
    absIntIrrNoSha[i, 1:NSta] := dAbs[N + 1 - i, HEM, 1:NSta];
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorptance of each glass pane
for interior irradiation without no shading.
The angular irradiation is not considered since the interior irradiation (from the room)
is assumed to be diffusive.
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
September 7, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassAbsInteriorIrradiationNoShading;
