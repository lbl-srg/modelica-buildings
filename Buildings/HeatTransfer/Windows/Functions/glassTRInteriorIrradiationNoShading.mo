within Buildings.HeatTransfer.Windows.Functions;
function glassTRInteriorIrradiationNoShading
  "Transmittance and reflectance of each glass pane for interior irradiation without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real layer[3, N, HEM, NSta] "Angular data of glass pane";
  output Real traRef[3, N, N, HEM, NSta](each min=0, each max=1)=fill(0,3, N, N, HEM, NSta)
    "Glass transmittance, front and back reflectance";

protected
  Real dLayer[3, N, HEM, NSta]
    "Dummy glass property with Pane 1 facing inside and Pane N facing outside";
  Real dTraRef[3, N, N, HEM, NSta]
    "Dummy transmittance and reflectance for exterior irradiation";

algorithm
  // Copy the dummy glass property
  for iD in 1:HEM loop
    for j in 1:N loop
      dLayer[TRA, j, iD, 1:NSta] := layer[TRA, N + 1 - j, iD, 1:NSta];
      dLayer[Ra, j, iD, 1:NSta] := layer[Rb, N + 1 - j, iD, 1:NSta]
        "swap the front and back reflectance";
      dLayer[Rb, j, iD, 1:NSta] := layer[Ra, N + 1 - j, iD, 1:NSta]
        "swap the front and back reflectance";
    end for;
  end for;

  // Calculate transmittance and reflectance of dummy glass for exterior irradiation without shading
  dTraRef :=
    Buildings.HeatTransfer.Windows.Functions.glassTRExteriorIrradiationNoShading(
    N=N,
    NSta=NSta,
    HEM=HEM,
    layer=dLayer);

  // Convert the dummy data to real glass
  for iD in 1:HEM loop
    for i in 1:N - 1 loop
      for j in i + 1:N loop
        traRef[TRA, N + 1 - i, N + 1 - j, iD, 1:NSta] := dTraRef[TRA, i, j, iD, 1:NSta];
        traRef[Ra, N + 1 - i, N + 1 - j, iD, 1:NSta] := dTraRef[Rb, i, j, iD, 1:NSta]
          "swap the front and back reflectance";
        traRef[Rb, N + 1 - i, N + 1 - j, iD, 1:NSta] := dTraRef[Ra, i, j, iD, 1:NSta]
          "swap the front and back reflectance";
      end for;
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the angular variation of the transmittance and reflectance of each glass pane for interior irradiation without shading.
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
end glassTRInteriorIrradiationNoShading;
