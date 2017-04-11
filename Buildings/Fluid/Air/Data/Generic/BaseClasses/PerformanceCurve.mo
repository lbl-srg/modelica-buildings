within Buildings.Fluid.Air.Data.Generic.BaseClasses;
record PerformanceCurve "Performance curve for fans in AHU"
  extends Buildings.Fluid.Movers.Data.Generic
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>
This record contains performance data for the fan in air handlers. Details can be found in
 <a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">Buildings.Fluid.Movers.Data.Generic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCurve;
