within Buildings.HeatTransfer.Windows.Functions;
function glassTRInteriorIrradiationNoShading
  "Transmittance and reflectance of each glass pane for interior irradiation without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real layer[3, N, HEM] "Angular data of glass pane";
  output Real traRef[3, N, N, HEM](each min=0, each max=1)
    "Glass transmittance, front and back reflectance";

protected
  Real dLayer[3, N, HEM]
    "Dummy glass property with Pane 1 facing inside and Pane N facing outside";
  Real dTraRef[3, N, N, HEM]
    "Dummy transmittance and reflectance for exterior irradiation";

algorithm
  // Copy the dummy glass property
  for iD in 1:HEM loop
    for j in 1:N loop
      dLayer[TRA, j, iD] := layer[TRA, N + 1 - j, iD];
      dLayer[Ra, j, iD] := layer[Rb, N + 1 - j, iD]
        "swap the front and back reflectance";
      dLayer[Rb, j, iD] := layer[Ra, N + 1 - j, iD]
        "swap the front and back reflectance";
    end for;
  end for;

  // Calculate transmittance and reflectance of dummy glass for exterior irradiation without shading
  dTraRef :=
    Buildings.HeatTransfer.Windows.Functions.glassTRExteriorIrradiationNoShading(
    N,
    HEM,
    dLayer);

  // Convert the dummy data to real glass
  for iD in 1:HEM loop
    for i in 1:N - 1 loop
      for j in i + 1:N loop
        traRef[TRA, N + 1 - i, N + 1 - j, iD] := dTraRef[TRA, i, j, iD];
        traRef[Ra, N + 1 - i, N + 1 - j, iD] := dTraRef[Rb, i, j, iD]
          "swap the front and back reflectance";
        traRef[Rb, N + 1 - i, N + 1 - j, iD] := dTraRef[Ra, i, j, iD]
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
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassTRInteriorIrradiationNoShading;
