within Buildings.Utilities.Plotters;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

 type GlobalActivation = enumeration(
    always  "Always on",
    use_input  "On based on input") "Enumeration for global activation of plotters"
  annotation (Documentation(info="<html>
<p>
Enumeration that is used to configure the global plotters.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  type TimeUnit = enumeration(
    seconds,
    minutes,
    hours,
    days)   "Enumeration for time unit" annotation (Documentation(info="<html>
<p>
Enumeration that is used to configure the time axis of the time series plotter.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

annotation (Documentation(info="<html>
<p>
Package with type definitions that are used to configure the plotters.
</p>
</html>"));
end Types;
