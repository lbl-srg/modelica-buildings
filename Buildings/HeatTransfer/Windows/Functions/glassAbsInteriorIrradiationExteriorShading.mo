within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationExteriorShading
  "Hemispherical absorptance of each glass pane for interior irradiation with exterior shading"
  input Real absIntIrrNoSha[N, NSta]
    "Absorptance for interior irradiation without shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrExtSha[N, NSta](each min=0, each max=1)
    "Hemispherical absorptance of each glass pane for interior irradiation with exterior shading";

protected
  Real fac;
  Real absFro "Front absorptance";
  Real absBac "Back absorptance";
  Integer i "Pane index";

algorithm
  for iSta in 1:NSta loop
    fac := traRef[TRA, N, 1, HEM, iSta]*refExtShaDev/(1 - traRef[Ra, 1, N, HEM, iSta]*
      refExtShaDev);

    i := 1;
    absFro := 1 - traRef[TRA, i, i, HEM, iSta] - traRef[Ra, i, i, HEM, iSta]
      "Equaiton (A.4.81a)";
    absBac := 1 - traRef[TRA, i, i, HEM, iSta] - traRef[Rb, i, i, HEM, iSta]
      "Equation (A.4.81b)";

    if N >= 2 then
      absIntIrrExtSha[i, iSta] := absIntIrrNoSha[i, iSta] + fac*absFro + fac*traRef[TRA, 1, i,
        HEM, iSta]*traRef[Ra, i + 1, N, HEM, iSta]*absBac "Equation (A.4.94)";

      for i in 2:N - 1 loop
        absFro := 1 - traRef[TRA, i, i, HEM, iSta] - traRef[Ra, i, i, HEM, iSta]
          "Equaiton (A.4.81a)";
        absBac := 1 - traRef[TRA, i, i, HEM, iSta] - traRef[Rb, i, i, HEM, iSta]
          "Equation (A.4.81b)";
        absIntIrrExtSha[i, iSta] := absIntIrrNoSha[i, iSta] + fac*traRef[TRA, 1, i - 1, HEM, iSta]*
          absFro + fac*traRef[TRA, 1, i, HEM, iSta]*traRef[Ra, i + 1, N, HEM, iSta]*absBac
          "Equation (A.4.94)";
      end for;

      i := N;
      absFro := 1 - traRef[TRA, i, i, HEM, iSta] - traRef[Ra, i, i, HEM, iSta]
        "Equaiton (A.4.81a)";
      absIntIrrExtSha[i, iSta] := absIntIrrNoSha[i, iSta] + fac*traRef[TRA, 1, i - 1, HEM, iSta]*
        absFro "Equation (A.4.94)";
    else
      absIntIrrExtSha[i, iSta] := absIntIrrNoSha[i, iSta] + fac*absFro
        "Equation (A.4.94)";
    end if;
  end for;
  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorptance of each glass pane for interior irradiation with exterior shading.
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
end glassAbsInteriorIrradiationExteriorShading;
