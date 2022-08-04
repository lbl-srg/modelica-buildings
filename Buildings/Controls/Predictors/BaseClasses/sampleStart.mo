within Buildings.Controls.Predictors.BaseClasses;
function sampleStart "Start time for sampling"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Time t "Simulation time";
  input Modelica.Units.SI.Time samplePeriod "Sample Period";
  output Modelica.Units.SI.Time sampleStart
    "Time at which first sample happens";
algorithm
  sampleStart :=ceil(t/samplePeriod)*samplePeriod;

  annotation (Documentation(info="<html>
<p>
Function that returns the time at which the sampling needs to start.
</p>
<p>
This function takes as arguments the sampling interval and the
current time. It returns the time at which the sampling will start.
The start of the sampling will be such that a sample instant
coincides with <i>t=0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 25, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end sampleStart;
