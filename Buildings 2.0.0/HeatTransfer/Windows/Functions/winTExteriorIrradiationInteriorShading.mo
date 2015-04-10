within Buildings.HeatTransfer.Windows.Functions;
function winTExteriorIrradiationInteriorShading
  "Angular and hemispherical transmittance of a window system (glass and shading device) for exterior irradiation with interior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real traExtIrrIntSha[HEM](each min=0, each max=1)
    "Angular and hemispherical transmittance of a window system (glass and shading device) forh exterior irradiation with interior shading";

algorithm
  for iD in 1:HEM loop
    traExtIrrIntSha[iD] := traRef[TRA, 1, N, iD]*traIntShaDev/(1 - refIntShaDev
      *traRef[Rb, N, 1, HEM]) "Equation (A.4.92)";
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the angular and hemispherical transmittance of a window system (glass and shading device) for exterior irradiation with interior shading.
Pane <code>1</code> is facing outside and pane <code>N</code> is facing the room.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end winTExteriorIrradiationInteriorShading;
