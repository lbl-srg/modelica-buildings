within Buildings.HeatTransfer.Windows.Functions;
function glassProperty
  "Compute angular variation and hemispherical integration of the transmittance and reflectance for each glass pane without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real glass[3, N] "Propertry of each glass pane";
  input Real xGla[N] "Thickness of each glass pane";
  input Modelica.SIunits.Angle psi[HEM - 1] "Incident angles";

  output Real layer[3, N, HEM] "Transmittance, front and back reflectance";

protected
  parameter Real tol=0.005
    "Tolerance for difference between front and back reflectance to decide a glass is uncoated or coated";
  Real oneLay[3, HEM] "Temporary storage for glass property of one pane";
  Real oneGla[3];

algorithm
  // Compute specular value for angle 0 to 90 degree (psi[1] to psi[N]) and panes from 1 to N
  for i in 1:N loop
    // Copy data to temporary place
    for j in 1:3 loop
      oneGla[j] := glass[j, i];
    end for;

    //uncoated galss
    if (abs(glass[Ra, i] - glass[Rb, i]) < tol) then
      oneLay := Buildings.HeatTransfer.Windows.Functions.glassPropertyUncoated(
        HEM,
        oneGla,
        xGla[i],
        psi);

    else
      //coated glass
      oneLay := Buildings.HeatTransfer.Windows.Functions.glassPropertyCoated(
        HEM,
        oneGla,
        psi);
    end if;

    for j in 1:3 loop
      for k in 1:HEM loop
        layer[j, i, k] := oneLay[j, k];
      end for;
    end for;
  end for;
  annotation (Documentation(info="<html>
<p>
This function computes the angular variation and the hemispherical integration of the transmittance and reflectance for each glass pane.
There are two schemes for the calculation. One is for coated glass and the other is for uncoated glass.
The function checks the difference between front and back reflectances.
If the difference is less than the tolerance (0.005), it uses the formula for uncoated glass.
Otherwise, the formula for coated glass will be used.
</p>
</html>", revisions="<html>
<ul>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Calculate the property using formula for coated (existing) and uncoated glass (newly added).
</li>
<li>
August 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassProperty;
