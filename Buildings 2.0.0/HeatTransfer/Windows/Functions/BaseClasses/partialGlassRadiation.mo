within Buildings.HeatTransfer.Windows.Functions.BaseClasses;
partial function partialGlassRadiation
  "Partial function for glass radiation property"

  input Integer N(min=1) "Number of glass layers";
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialSingleGlassRadiation;
  annotation (preferredView="info", Documentation(info="<html>
This is a partial function that is used to implement the radiation functions for windows. It defines basic input variables and constants.
</html>", revisions="<html>
<ul>
<li>
December 19 2011, by Wangda Zuo:<br/>
Separate part of definitions to particalSingleGlassRadiation.mo.
</li>
</ul>
<ul>
<li>
September 16 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialGlassRadiation;
