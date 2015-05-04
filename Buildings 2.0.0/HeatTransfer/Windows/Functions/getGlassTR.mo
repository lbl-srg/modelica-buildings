within Buildings.HeatTransfer.Windows.Functions;
function getGlassTR "Transmittance and reflectance of glass"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;

  input Real layer[3, N, HEM] "Property of glass pane";
  output Real traRef[3, N, N, HEM](each min=0, each max=1)
    "Glass transmittance, front and back reflectance";

protected
  Real traRefIntIrr[3, N, N, HEM](each min=0, each max=1)
    "temporary array for glass transmittance, front and back reflectance for interior irradiation";

algorithm
  traRef :=
    Buildings.HeatTransfer.Windows.Functions.glassTRExteriorIrradiationNoShading(
    N,
    HEM,
    layer) "property for exterior irradiation";
  traRefIntIrr :=
    Buildings.HeatTransfer.Windows.Functions.glassTRInteriorIrradiationNoShading(
    N,
    HEM,
    layer) "property for interior irradiation";

  // Copy the property for interior irradiation to glass property
  for k in TRA:Rb loop
    for i in 1:N - 1 loop
      for j in i + 1:N loop
        for iD in 1:HEM loop
          traRef[k, N + 1 - i, N + 1 - j, iD] := traRefIntIrr[k, N + 1 - i, N
             + 1 - j, iD];
        end for;
      end for;
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the angular variation of the transmittance and reflectance of each glass pane.
It accounts for the transmittance and reflectance among different panes.
Pane <code>1</code> is facing outside and pane <code>N</code> is facing the room.
For instance, <code>traRef[TRA, 1, N, iD]</code> means transmittance between layer <code>1</code> to <code>N</code> for exterior irradiation and
<code>traRef[TRA, N, 1, iD]</code> means the transmittance for interior irradiation.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end getGlassTR;
