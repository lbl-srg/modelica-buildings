within Buildings.HeatTransfer.Windows.Functions;
function glassAbsInteriorIrradiationExteriorShading
  "Hemispherical absorptance of each glass pane for interior irradiation with exterior shading"
  input Real absIntIrrNoSha[N]
    "Absorptance for interior irradiation without shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;

  output Real absIntIrrExtSha[N](each min=0, each max=1)
    "Hemispherical absorptance of each glass pane for interior irradiation with exterior shading";

protected
  Real fac;
  Real absFro "Front absorptance";
  Real absBac "Back absorptance";
  Integer i "Pane index";

algorithm
  fac := traRef[TRA, N, 1, HEM]*refExtShaDev/(1 - traRef[Ra, 1, N, HEM]*
    refExtShaDev);

  i := 1;
  absFro := 1 - traRef[TRA, i, i, HEM] - traRef[Ra, i, i, HEM]
    "Equaiton (A.4.81a)";
  absBac := 1 - traRef[TRA, i, i, HEM] - traRef[Rb, i, i, HEM]
    "Equation (A.4.81b)";

  if N >= 2 then
    absIntIrrExtSha[i] := absIntIrrNoSha[i] + fac*absFro + fac*traRef[TRA, 1, i,
      HEM]*traRef[Ra, i + 1, N, HEM]*absBac "Equation (A.4.94)";

    for i in 2:N - 1 loop
      absFro := 1 - traRef[TRA, i, i, HEM] - traRef[Ra, i, i, HEM]
        "Equaiton (A.4.81a)";
      absBac := 1 - traRef[TRA, i, i, HEM] - traRef[Rb, i, i, HEM]
        "Equation (A.4.81b)";
      absIntIrrExtSha[i] := absIntIrrNoSha[i] + fac*traRef[TRA, 1, i - 1, HEM]*
        absFro + fac*traRef[TRA, 1, i, HEM]*traRef[Ra, i + 1, N, HEM]*absBac
        "Equation (A.4.94)";
    end for;

    i := N;
    absFro := 1 - traRef[TRA, i, i, HEM] - traRef[Ra, i, i, HEM]
      "Equaiton (A.4.81a)";
    absIntIrrExtSha[i] := absIntIrrNoSha[i] + fac*traRef[TRA, 1, i - 1, HEM]*
      absFro "Equation (A.4.94)";
  else
    absIntIrrExtSha[i] := absIntIrrNoSha[i] + fac*absFro "Equation (A.4.94)";
  end if;
  annotation (Documentation(info="<html>
<p>
This function computes the hemispherical absorptance of each glass pane for interior irradiation with exterior shading.
Pane <code>1</code> is facing the outside and pane <code>N</code> is facing the room.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassAbsInteriorIrradiationExteriorShading;
