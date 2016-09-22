within Buildings.HeatTransfer.Windows.Functions.BaseClasses;
partial function partialGlassRadiation
  "Partial function for glass radiation property"

  input Integer N(min=1) "Number of glass layers";
  input Integer NSta(min=1)
    "Number of window states for electrochromic windows (set to 1 for regular windows)";

  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialSingleGlassRadiation;
  annotation (preferredView="info", Documentation(info="<html>
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
