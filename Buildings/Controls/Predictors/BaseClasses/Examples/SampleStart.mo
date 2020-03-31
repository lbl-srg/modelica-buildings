within Buildings.Controls.Predictors.BaseClasses.Examples;
model SampleStart "Test model for sampleStart function"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Time tSimSta[21]={i for i in -10:10}
    "Simulation start times";
  parameter Modelica.Units.SI.Time tSample=5 "Sample time";
  parameter Modelica.Units.SI.Time samSta[21](each fixed=false)
    "Start of sampling time";
initial equation
 samSta = sampleStart(t =            tSimSta,
                      samplePeriod = tSample);
 /*
 for i in 1:size(tSimSta,1) loop
   Modelica.Utilities.Streams.print("t = " + String(tSimSta[i]) + " samSta = " + String(samSta[i]));
 end for;
 */
  annotation (
  experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/BaseClasses/Examples/SampleStart.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the function
<a href=\"modelica://Buildings.Controls.Predictors.BaseClasses.sampleStart\">
Buildings.Controls.Predictors.BaseClasses.sampleStart</a>.
The function produces the following sequence of points
</p>
<table summary=\"Table with start of the simulation and sampling time\"
border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\" >
<tr><th>simulation start</th><th>start of sampling</th></tr>
<tr><td>-10</td><td> -10</td></tr>
<tr><td>-9</td><td> -5</td></tr>
<tr><td>-8</td><td> -5</td></tr>
<tr><td>-7</td><td> -5</td></tr>
<tr><td>-6</td><td> -5</td></tr>
<tr><td>-5</td><td> -5</td></tr>
<tr><td>-4</td><td> -0</td></tr>
<tr><td>-3</td><td> -0</td></tr>
<tr><td>-2</td><td> -0</td></tr>
<tr><td>-1</td><td> -0</td></tr>
<tr><td>0</td><td> 0</td></tr>
<tr><td>1</td><td> 5</td></tr>
<tr><td>2</td><td> 5</td></tr>
<tr><td>3</td><td> 5</td></tr>
<tr><td>4</td><td> 5</td></tr>
<tr><td>5</td><td> 5</td></tr>
<tr><td>6</td><td> 10</td></tr>
<tr><td>7</td><td> 10</td></tr>
<tr><td>8</td><td> 10</td></tr>
<tr><td>9</td><td> 10</td></tr>
<tr><td>10</td><td> 10</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
October 25, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SampleStart;
