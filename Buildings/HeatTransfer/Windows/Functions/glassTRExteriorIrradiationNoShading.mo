within Buildings.HeatTransfer.Windows.Functions;
function glassTRExteriorIrradiationNoShading
  "Transmittance and reflectance of glass panes for exterior irradiation without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real layer[3, N, HEM, NSta] "Angular data of glass pane";
  output Real traRef[3, N, N, HEM, NSta](each min=0, each max=1)=fill(0,3, N, N, HEM, NSta)
    "Transmittance and reflectance of each glass pane for exterior irradiation without shading";

protected
  Real aij "Temporary variable";
  constant Real SMALL=Modelica.Constants.small "Small value";

algorithm
  // Property for single pane of glass or the first pane of multiple panes glass
  for iD in 1:HEM loop
    for k in TRA:Rb loop
      traRef[k, 1, 1, iD, 1:NSta] := layer[k, 1, iD, 1:NSta]
        "Equation (A.4.71)";
    end for;
  end for;

  // Property for multiple panes glass
  if N > 1 then
    for iD in 1:HEM loop
      for i in 1:N - 1 loop
        for j in i + 1:N loop
          for k in TRA:Rb loop
            traRef[k, j, j, iD, 1:NSta] := layer[k, j, iD, 1:NSta];
          end for;

          for iSta in 1:NSta loop
            aij := 1 - traRef[Ra, j, j, iD, iSta]*traRef[Rb, j - 1, i, iD, iSta]
              "Equation (A.4.77)";
            assert(aij > -SMALL,
              "Glass transmittance and reflectance data was not correct.\n");
            if aij < SMALL then
              traRef[TRA, i, j, iD, iSta] := 0;
              traRef[Ra, i, j, iD, iSta] := 1;
              traRef[Rb, j, i, iD, iSta] := 1;
            else
              aij := 1/aij;
              traRef[TRA, i, j, iD, iSta] := aij*traRef[TRA, i, j - 1, iD, iSta]*traRef[TRA,
                j, j, iD, iSta] "Equation (A.4.78a)";
              traRef[Ra, i, j, iD, iSta] := traRef[Ra, i, j - 1, iD, iSta] + aij*traRef[TRA,
                i, j - 1, iD, iSta]*traRef[TRA, i, j - 1, iD, iSta]*traRef[Ra, j, j, iD, iSta]
                "Equation (A.4.78b)";
              traRef[Rb, j, i, iD, iSta] := traRef[Rb, j, j, iD, iSta] + aij*traRef[TRA, j, j,
                iD, iSta]*traRef[TRA, j, j, iD, iSta]*traRef[Rb, j - 1, i, iD, iSta]
                "Equation (A.4.78c)";
            end if;
          end for; // iSta in 1:NSta
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
September 23, 2022, by Jianjun Hu:<br/>
Added default value to the output variable.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3111\">issue 3111</a>.
</li>
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
end glassTRExteriorIrradiationNoShading;
