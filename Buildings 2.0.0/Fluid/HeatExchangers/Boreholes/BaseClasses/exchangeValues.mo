within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function exchangeValues
  "Store the value u at the element n in the external object, and return the value of the element i"
  input ExtendableArray table "External object";
  input Integer iX
    "One-based index where u needs to be stored in the array of the external object";
  input Real x "Value to store in the external object";
  input Integer iY
    "One-based index of the element that needs to be returned from C to Modelica";
  output Real y "Value of the i-th element";
external"C" y = exchangeValues(table, iX, x, iY) annotation (Include="#include <exchangeValues.c>",
                   IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that stores the input value <code>x</code> as the element
<code>a[iX]</code> in the array
<code>a = [a[1], a[2], ...]</code>,
and that returns the element <code>a[iY]</code>.
The size of the array <code>a</code> is automatically enlarged as needed.
</p>
</html>", revisions="<html>
<ul><li>
September 9, 2011, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
July 27, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end exchangeValues;
