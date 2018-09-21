within Buildings.Utilities.Plotters;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <code>Buildings.Utilities.Plotters</code> consists of models
that generate time series plots or scatter plots, and
save them in one or multiple html files.
The plotters allow for example to plot control sequences such as
the one shown below, which was generated from
<a href=\"modelica://Buildings.Utilities.Plotters.Examples.SingleZoneVAVSupply_u\">
Buildings.Utilities.Plotters.Examples.SingleZoneVAVSupply_u</a>.
</p>
<p align=\"center\">
<img alt=\"Control chart\"
src=\"modelica://Buildings/Resources/Images/Utilities/Plotters/UsersGuide/TemperatureSetPoints.png\"
width=\"1200\"
border=\"1\" />
</p>

<h4>Usage</h4>
<p>
First, drag at the top-level of the model an instance of
<a href=\"modelica://Buildings.Utilities.Plotters.Configuration\">
Buildings.Utilities.Plotters.Configuration</a>
and enter a value for its <code>samplePeriod</code>,
which is the frequency with which data will be written to the plots.
This global configuration block is required for the plotters to work.
This global configuration block also allows
to specify other optional global configurations that are by default
used by all plotter instances.
</p>
<p>
Next, to create time series or scatter plots, drag as many instances of
<a href=\"modelica://Buildings.Utilities.Plotters.TimeSeries\">
Buildings.Utilities.Plotters.TimeSeries</a>
or 
<a href=\"modelica://Buildings.Utilities.Plotters.Scatter\">
Buildings.Utilities.Plotters.Scatter</a>
and connect them to the signals that you like to plot.
</p>
<p>
By default, all plots will be written to the file <code>plots.html</code>.
This file name can be changed with the parameter <code>fileName</code>,
either globally for all plots in the instance
<a href=\"modelica://Buildings.Utilities.Plotters.Configuration\">
Buildings.Utilities.Plotters.Configuration</a>,
or for individual plotters in the respective instance.
Similarly, the sampling time, which is specified globally
in
<a href=\"modelica://Buildings.Utilities.Plotters.Configuration\">
Buildings.Utilities.Plotters.Configuration</a>,
can be overwritten by each block.
</p>
<h4>Activating and deactivating plotters</h4>
<p>
For some plots such as for control signals, it makes sense to only plot
the data when the HVAC system is operating. To allow this,
the global configuration block, as well as each individual plotter instance,
allows to enable a boolean input port called <code>activate</code>.
Through the parameter <code>activation</code>, this boolean input port can be
enabled or disabled. If enabled, then the plotter is activated if the signal
at this port is <code>true</code>. If it is <code>false</code>, then no data will be sampled.
By default, the plotters inherit the activation from the global configuration.
</p>
<p>
Moreover, it may make sense to not plot data in the first few minutes after
the HVAC system has been switched on. For example, one may only want to plot
the mixed air temperature at an economizer <i>2</i> minutes
after the HVAC system has been switched on.
To support this, the parameter <code>activationDelay</code> can be set.
For example, if  <code>activationDelay=120</code> seconds, then
data will be collected for plotting only
<i>120</i> seconds after <code>activate</code> becomes <code>true</code>.
As with the other parameters, the plotters inherit by default the
<code>activationDelay</code> from the global configuration,
but this value can locally be overwritten.
A local overwrite allows for example in an HVAC system
to not plot the mixed air temperature
for <i>2</i> minutes and not plot the room air temperature
for <i>30</i> minutes after the system has been switched on.
</p>
<p>
Various examples that illustrate the use of the plotters can be found in
<a href=\"modelica://Buildings.Utilities.Plotters.Examples\">
Buildings.Utilities.Plotters.Examples</a>.
</p>
<h4>Implementation</h4>
<p>
The plotters write an html file with JavaScript that uses the
<a href=\"https://plot.ly/javascript/\">plotly</a> library
to render the plots.
</p>
</html>"));

end UsersGuide;
