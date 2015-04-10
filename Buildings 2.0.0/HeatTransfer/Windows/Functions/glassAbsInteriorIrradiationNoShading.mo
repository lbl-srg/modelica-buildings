within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationNoShading
  "Hemispherical absorptance of each glass pane for interior irradiation without shading"

  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowRadiation;

  output Real[N] absIntIrrNoSha(each min=0, each max=1)
    "Hemispherical absorptance of each glass layer for interior irradiation without shading";

protected
  Real dTraRef[3, N, N, HEM](each min=0, each max=1)
    "Dummy transmittance and reflectance with exterior irradiation without shading";
  Real dAbs[N, HEM](each min=0, each max=1)
    "Dummy absorptance with exterior irradiation and no shading";

algorithm
  // Reverse the data srtucture for exterior irradiation and no shading
  for i in 1:N loop
    for j in 1:N loop
      for iD in 1:HEM loop
        dTraRef[TRA, i, j, iD] := traRef[TRA, N + 1 - i, N + 1 - j, iD];
        dTraRef[Ra, i, j, iD] := traRef[Rb, N + 1 - i, N + 1 - j, iD];
        dTraRef[Rb, i, j, iD] := traRef[Ra, N + 1 - i, N + 1 - j, iD];
      end for;
    end for;
  end for;

  dAbs :=
    Buildings.HeatTransfer.Windows.Functions.glassAbsExteriorIrradiationNoShading(
    dTraRef,
    N,
    HEM) "Dummmy absorptance with exterior irradiation";

  // Only output hemispherical absorptance. Need to change order for interior irradiation.
  for i in 1:N loop
    absIntIrrNoSha[i] := dAbs[N + 1 - i, HEM];
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorptance of each glass pane for interior irradiation without no shading.
The angular irradiation is not considered since the interior irradiation (from the room) is assumed to be diffusive.
It is a reverse of the function
<a href=\"modelica://Buildings.HeatTransfer.Windows.Functions.glassAbsInterirorIrradiationNoShading\">
Buildings.HeatTransfer.Windows.Functions.glassAbsInterirorIrradiationNoShading</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 7, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassAbsInteriorIrradiationNoShading;
