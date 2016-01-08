within Buildings.HeatTransfer.Windows.Functions;
function glassAbsExteriorIrradiationExteriorShading
  "Angular and hemispherical absorptance of each glass pane for exterior irradiation with exterior shading"
  input Real absExtIrrNoSha[N, HEM, NSta](each min=0, each max=1)
    "Angular and hemispherical absorptance of each glass pane for exterior irradiation without shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absExtIrrExtSha[N, HEM, NSta](each min=0, each max=1)
    "Angular and hemispherical absorptance of each glass pane for exterior irradiation with exterior shading";

protected
  Real c "Intermediate variable";

algorithm
  for iSta in 1:NSta loop
    for iD in 1:HEM loop
      c := traExtShaDev*(1 + traRef[Ra, 1, N, iD, iSta]*refExtShaDev/
        (1 - traRef[Ra, 1, N, HEM, iSta]*refExtShaDev));
      for i in 1:N loop
        absExtIrrExtSha[i, iD, iSta] := c*absExtIrrNoSha[i, iD, iSta];
       end for;
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes angular and hemispherical absorptance of each glass pane for exterior irradiation with exterior shading.
Pane <code>1</code> is facing outside and pane <code>N</code> is facing the room.
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
end glassAbsExteriorIrradiationExteriorShading;
