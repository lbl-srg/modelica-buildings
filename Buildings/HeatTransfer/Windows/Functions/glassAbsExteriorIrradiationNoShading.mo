within Buildings.HeatTransfer.Windows.Functions;
function glassAbsExteriorIrradiationNoShading
  "Angular and hemispherical absorptance of each glass pane for exterior irradiation without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowRadiation;
  output Real[N, HEM, NSta] abs(each min=0, each max=1) "Angular and hemispherical absorptance of each glass pane for exterior irradiation without shading.
     Indices: abs[1 to N : ] -> pane 1 to N;
     abs[ : 1 to HEM] -> angular (1:HEM-1) and hemispherical (HEM)";

protected
  Real af "Front (outside-facing side) absorptance of a pane";
  Real ab "Back (room-facing side) absorptance of a pane";
  Real deno1 "Denominantor";
  Real deno2 "Denominantor";
  Integer j;
  constant Real SMALL=Modelica.Constants.small "Small value";

algorithm
  if N == 1 then
    j := 1;
    for iSta in 1:NSta loop
      for iD in 1:HEM loop
        abs[j, iD, iSta] := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Ra, j, j, iD, iSta]
          "Equation (A.4.79)";
      end for;
    end for;
  else
    for iSta in 1:NSta loop
      for iD in 1:HEM loop
        j := 1;
        af := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Ra, j, j, iD, iSta]
          "Equation (A.4.81a)";
        ab := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Rb, j, j, iD, iSta]
          "Equation (A.4.81b)";
        deno2 := 1 - traRef[Rb, j, 1, iD, iSta]*traRef[Ra, j + 1, N, iD, iSta];
        if deno2 < SMALL then
          abs[j, iD, iSta] := 0;
        else
          abs[j, iD, iSta] := af + ab*traRef[TRA, 1, j, iD, iSta]*traRef[Ra, j + 1, N, iD, iSta]/
            deno2 "Equation (A.4.82) and (A.4.83b)";
        end if;

        for j in 2:N - 1 loop
          af := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Ra, j, j, iD, iSta]
            "Equation (A.4.81a)";
          ab := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Rb, j, j, iD, iSta]
            "Equation (A.4.81b)";
          deno1 := 1 - traRef[Ra, j, N, iD, iSta]*traRef[Rb, j - 1, 1, iD, iSta];
          deno2 := 1 - traRef[Rb, j, 1, iD, iSta]*traRef[Ra, j + 1, N, iD, iSta];
          if deno1 < SMALL or deno2 < SMALL then
            abs[j, iD, iSta] := 0;
          else
            abs[j, iD, iSta] := af*traRef[TRA, 1, j - 1, iD, iSta]/deno1 + ab*traRef[TRA, 1,
              j, iD, iSta]*traRef[Ra, j + 1, N, iD, iSta]/deno2
              "Equation (A.4.83b)";
          end if;
        end for;

        j := N;
        af := 1 - traRef[TRA, j, j, iD, iSta] - traRef[Ra, j, j, iD, iSta]
          "Equation (A.4.81a)";
        deno1 := 1 - traRef[Ra, j, N, iD, iSta]*traRef[Rb, j - 1, 1, iD, iSta];
        if deno1 < SMALL then
          abs[j, iD, iSta] := 0;
        else
          abs[j, iD, iSta] := af*traRef[TRA, 1, j - 1, iD, iSta]/deno1;
        end if;
      end for;
    end for; // iSta in 1:NSta
  end if;

  annotation (Documentation(info="<html>
<p>
This function computes specular and hemispherical absorptance of each glass pane for exterior irradiation without shading.
It counts the transmittance and reflectance among different panes.
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
August 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassAbsExteriorIrradiationNoShading;
