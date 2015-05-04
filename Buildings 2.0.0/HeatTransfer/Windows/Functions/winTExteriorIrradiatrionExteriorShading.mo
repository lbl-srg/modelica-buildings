within Buildings.HeatTransfer.Windows.Functions;
function winTExteriorIrradiatrionExteriorShading
  "Angular and hemispherical transmittance of a window system (glass + shading device) for exterior irradiation with exterior shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;
  output Real traExtIrrExtSha[HEM](each min=0, each max=1)
    "Angular and hemispherical transmittance of a window system (glass + shading device) for exterior irradiation with exterior shading";

protected
  Real c;

algorithm
  for iD in 1:HEM loop
    c := traExtShaDev*(1 + traRef[Ra, 1, N, iD]*refExtShaDev/(1 - traRef[Ra, 1,
      N, HEM]*refExtShaDev)) "Equation (A.4.88a)";
    traExtIrrExtSha[iD] := c*traRef[TRA, 1, N, iD] "Equation (A.4.88c)";
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the angular and hemispherical transmittance of a window system (glass + shading device) for exterior irradiation with exterior shading.
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
end winTExteriorIrradiatrionExteriorShading;
