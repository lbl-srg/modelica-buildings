within Buildings.HeatTransfer.Windows.Functions;
function glassTRExteriorIrradiationNoShading
  "Transmittance and reflectance of glass panes for exterior irradiation without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real layer[3, N, HEM] "Angular data of glass pane";
  output Real traRef[3, N, N, HEM](each min=0, each max=1)
    "Transmittance and reflectance of each glass pane for exterior irradiation without shading";

protected
  Real aij "Temporary variable";
  constant Real SMALL=Modelica.Constants.small "Small value";

algorithm
  // Property for single pane of glass or the first pane of multiple panes glass
  for iD in 1:HEM loop
    for k in TRA:Rb loop
      traRef[k, 1, 1, iD] := layer[k, 1, iD] "Equation (A.4.71)";
    end for;
  end for;

  // Property for multiple panes glass
  if N > 1 then
    for iD in 1:HEM loop
      for i in 1:N - 1 loop
        for j in i + 1:N loop
          for k in TRA:Rb loop
            traRef[k, j, j, iD] := layer[k, j, iD];
          end for;

          aij := 1 - traRef[Ra, j, j, iD]*traRef[Rb, j - 1, i, iD]
            "Equation (A.4.77)";
          assert(aij > -SMALL,
            "Glass transmittance and reflectance data was not correct.\n");
          if aij < SMALL then
            traRef[TRA, i, j, iD] := 0;
            traRef[Ra, i, j, iD] := 1;
            traRef[Rb, j, i, iD] := 1;
          else
            aij := 1/aij;
            traRef[TRA, i, j, iD] := aij*traRef[TRA, i, j - 1, iD]*traRef[TRA,
              j, j, iD] "Equation (A.4.78a)";
            traRef[Ra, i, j, iD] := traRef[Ra, i, j - 1, iD] + aij*traRef[TRA,
              i, j - 1, iD]*traRef[TRA, i, j - 1, iD]*traRef[Ra, j, j, iD]
              "Equation (A.4.78b)";
            traRef[Rb, j, i, iD] := traRef[Rb, j, j, iD] + aij*traRef[TRA, j, j,
              iD]*traRef[TRA, j, j, iD]*traRef[Rb, j - 1, i, iD]
              "Equation (A.4.78c)";
          end if;
        end for;
      end for;
    end for;
  end if;

  annotation (Documentation(info="<html>
<p>
This function computes the angular variation of the transmittance and reflectance of each glass pane for exteior irradiation without shading.
It accounts for the transmittance and reflectance among different panes.
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
end glassTRExteriorIrradiationNoShading;
