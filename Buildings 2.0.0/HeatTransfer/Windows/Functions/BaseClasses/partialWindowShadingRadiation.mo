within Buildings.HeatTransfer.Windows.Functions.BaseClasses;
partial function partialWindowShadingRadiation
  "Partial function for window radiation property with shading device"
  input Real traRef[3, N, N, HEM](each min=0, each max=1)
    "Transmittance and reflectance with exterior irradiation and no shading";
  input Real traRefShaDev[2, 2](each min=0, each max=1)
    "Transmittance and reflectance of shading device";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;
protected
  Real traExtShaDev=traRefShaDev[1, 1]
    "Transmittance of the exterior shading device";
  Real refExtShaDev=traRefShaDev[2, 1]
    "Reflectance of the exterior shading device";
  Real traIntShaDev=traRefShaDev[1, 2]
    "Transmittance of the interior shading device";
  Real refIntShaDev=traRefShaDev[2, 2]
    "Reflectance of the interior shading device";
  annotation (preferredView="info",
  Documentation(info="<html>
This is a partial function that is used to implement the radiation functions for windows. It defines basic input variables and parameters.
</html>", revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Corrected wrong <code>max</code> value for <code>traRef</code> and
<code>traRefShaDev</code>.
</li>
<li>
September 16 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialWindowShadingRadiation;
