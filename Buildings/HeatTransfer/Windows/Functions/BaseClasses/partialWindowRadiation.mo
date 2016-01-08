within Buildings.HeatTransfer.Windows.Functions.BaseClasses;
partial function partialWindowRadiation
  "Partial function for window radiation property"
  input Real traRef[3, N, N, HEM, NSta](each min=0, each max=0)
    "Transmittance and reflectance with exterior irradiation and no shading";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialGlassRadiation;

  annotation (preferredView="info",
  Documentation(info="<html>
This is a partial function that is used to implement the radiation functions for windows. It defines basic input variables and constants.
</html>", revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
<li>
September 16 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialWindowRadiation;
