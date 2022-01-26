within Buildings.HeatTransfer.Windows.Functions;
function glassProperty
  "Compute angular variation and hemispherical integration of the transmittance and reflectance for each glass pane without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
  input Real glass[3, N, NSta] "Propertry of each glass pane";
  input Real xGla[N] "Thickness of each glass pane";
  input Modelica.Units.SI.Angle psi[HEM - 1] "Incident angles";

  output Real layer[3, N, HEM, NSta]
    "Transmittance, front and back reflectance";

protected
  parameter Real tol=0.005
    "Tolerance for difference between front and back reflectance to decide a glass is uncoated or coated";
  Real oneLay[3, HEM, NSta] "Temporary storage for glass property of one pane";
  Real oneGla[3, NSta];

algorithm
  // Compute specular value for angle 0 to 90 degree (psi[1] to psi[N]) and panes from 1 to N
  for i in 1:N loop
    // Copy data to temporary place
    for j in 1:3 loop
      oneGla[j, 1:NSta] := glass[j, i, 1:NSta];
    end for;

    for iSta in 1:NSta loop
      //uncoated galss
      if (abs(glass[Ra, i, iSta] - glass[Rb, i, iSta]) < tol) then
        oneLay[:,:,iSta] := Buildings.HeatTransfer.Windows.Functions.glassPropertyUncoated(
          HEM,
          oneGla[:,iSta],
          xGla[i],
          psi);

       else
        //coated glass
        oneLay[:,:,iSta] := Buildings.HeatTransfer.Windows.Functions.glassPropertyCoated(
          HEM,
          oneGla[:, iSta],
          psi);
       end if;
     end for; // iSta

    for j in 1:3 loop
      for k in 1:HEM loop
        layer[j, i, k, 1:NSta] := oneLay[j, k, 1:NSta];
      end for;
    end for;
  end for; // i in 1:N
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
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
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
