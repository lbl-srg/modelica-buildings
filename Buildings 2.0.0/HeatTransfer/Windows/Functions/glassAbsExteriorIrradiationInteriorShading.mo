within Buildings.HeatTransfer.Windows.Functions;
function glassAbsExteriorIrradiationInteriorShading
  "Angular and hemispherical absorptance of each glass pane for exterior irradiation with interior shading"
  input Real absExtIrrNoSha[N, HEM](each min=0, each max=1)
    "Absorptance for exterior irradiation without shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialWindowShadingRadiation;
  output Real absExtIrrNoShaIntSha[N, HEM](each min=0, each max=1)
    "Angular and hemispherical absorptance of each glass pane for exterior irradiation with interior shading";

protected
  Real fac;
  Real absFro "Front (outside-facing) absorptance";
  Real absBac "Back (room-facing) absorptance";
  Integer i "Index of glass pane";

algorithm
  for iD in 1:HEM loop
    i := 1;
    fac := traRef[TRA, 1, N, iD]*refIntShaDev/(1 - traRef[Rb, N, 1, HEM]*
      refIntShaDev) "Equation (A.4.90)";
    absBac := 1 - traRef[TRA, i, i, iD] - traRef[Rb, i, i, iD]
      "Equation (A.4.81b)";

    if N >= 2 then
      absExtIrrNoShaIntSha[i, iD] := absExtIrrNoSha[i, iD] + fac*traRef[TRA, N,
        i + 1, HEM]*absBac "Equation (A.4.90)";

      for i in 2:N - 1 loop
        fac := traRef[TRA, 1, N, iD]*refIntShaDev/(1 - traRef[Rb, N, 1, HEM]*
          refIntShaDev) "Equation (A.4.90)";
        absFro := 1 - traRef[TRA, i, i, iD] - traRef[Ra, i, i, iD]
          "Equaiton (A.4.81a)";
        absBac := 1 - traRef[TRA, i, i, iD] - traRef[Rb, i, i, iD]
          "Equation (A.4.81b)";
        absExtIrrNoShaIntSha[i, iD] := absExtIrrNoSha[i, iD] + fac*(traRef[TRA,
          N, i, HEM]*traRef[Rb, i - 1, 1, HEM]*absFro + traRef[TRA, N, i + 1,
          HEM]*absBac) "Equation (A.4.90)";
      end for;

      i := N;
      fac := traRef[TRA, 1, N, iD]*refIntShaDev/(1 - traRef[Rb, N, 1, HEM]*
        refIntShaDev) "Equation (A.4.90)";
      absFro := 1 - traRef[TRA, i, i, iD] - traRef[Ra, i, i, iD]
        "Equaiton (A.4.81a)";
      absBac := 1 - traRef[TRA, i, i, iD] - traRef[Rb, i, i, iD]
        "Equation (A.4.81b)";
      absExtIrrNoShaIntSha[i, iD] := absExtIrrNoSha[i, iD] + fac*(traRef[TRA, N,
        i, HEM]*traRef[Rb, i - 1, 1, HEM]*absFro + absBac) "Equation (A.4.90)";

    else
      absExtIrrNoShaIntSha[i, iD] := absExtIrrNoSha[i, iD] + fac*absBac
        "Equation (A.4.90)";
    end if;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes angular and hemispherical absorptance of each glass pane for exterior irradiation with interior shading.
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
end glassAbsExteriorIrradiationInteriorShading;
