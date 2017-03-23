within Buildings.HeatTransfer.Windows.Functions.BaseClasses;
partial function partialSingleGlassRadiation
  "Partial function for single glass radiation property"

  input Integer HEM "Index of hemispherical integration";
protected
  constant Integer TRA=1 "Index of Transmittance";
  constant Integer Ra=2 "Index of front reflectance (outside facing side)";
  constant Integer Rb=3 "Index of back reflectance (room-facing side)";

  annotation (preferredView="info",
  Documentation(info="<html>
This is a partial function that is used to implement the radiation functions for windows. It defines basic constants.
</html>", revisions="<html>
<ul>
<li>
September 16 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialSingleGlassRadiation;
