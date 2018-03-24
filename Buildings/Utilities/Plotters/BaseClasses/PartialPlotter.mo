within Buildings.Utilities.Plotters.BaseClasses;
partial block PartialPlotter "Partial block for plotters"
  extends Modelica.Blocks.Icons.Block;

  outer Buildings.Utilities.Plotters.Configuration plotConfiguration
    "Default plot configuration";

  parameter String fileName = plotConfiguration.fileName "Name of html file";

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3) = plotConfiguration.samplePeriod
    "Sample period of component";

  parameter String title = getInstanceName() "Title of the plot";

  parameter Integer n(min=1) = 1 "Number of independent data series (dimension of y)";

  parameter String[n] legend "String array for legend, such as {\"x1\", \"x2\"}";

  parameter Buildings.Utilities.Plotters.Types.LocalActivation localActivation=
    Buildings.Utilities.Plotters.Types.LocalActivation.use_globalActivation
    "Set to true to enable an input that allows activating and deactivating the plotting";
  parameter Modelica.SIunits.Time activationDelay(min=0)=plotConfiguration.activationDelay
    "Time that needs to elapse to enable plotting after activate becomes true";

  Modelica.Blocks.Interfaces.RealVectorInput y[n] "y-data" annotation (
      Placement(transformation(extent={{-130,-20},{-90,20}}),
        iconTransformation(extent={{-140,20},{-100,-20}})));

  Modelica.Blocks.Interfaces.BooleanInput activate if
     (localActivation == Buildings.Utilities.Plotters.Types.LocalActivation.use_input)
    "Set to true to enable plotting of time series after activationDelay elapsed"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Boolean active "Flag, true if plots record data";
protected
  Modelica.Blocks.Interfaces.BooleanInput activate_internal
    "Internal connector to activate plots";
  discrete Modelica.SIunits.Time tActivateLast "Time when plotter was the last time activated";

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter String insNam = Modelica.Utilities.Strings.replace(
    getInstanceName(), ".", "_")
    "Name of this instance with periods replace by underscore";

  output Boolean sampleTrigger "True, if sample time instant";

//  output Boolean firstTrigger(start=false, fixed=true)
//    "Rising edge signals first sample instant";
  Buildings.Utilities.Plotters.BaseClasses.Backend plt=
    Buildings.Utilities.Plotters.BaseClasses.Backend(fileName=fileName)
    "Object that stores data for this plot";
  String str "Temporary string";
  Boolean firstCall "Flag, true before the first data are written";
initial equation
  t0 = time;
  Buildings.Utilities.Plotters.BaseClasses.print(
    plt=plt,
    string="
    <div id=\"" + insNam + "\"></div>
    <script>
    ",
    finalCall = false);
  str = "";
  tActivateLast = time-2*activationDelay;
  firstCall = true;
equation
  if (localActivation == Buildings.Utilities.Plotters.Types.LocalActivation.use_input) then
    connect(activate, activate_internal);
  elseif  (localActivation == Buildings.Utilities.Plotters.Types.LocalActivation.use_globalActivation) then
    activate_internal = plotConfiguration.active;
  end if;
  when (activate_internal) then
    tActivateLast = time;
  end when;

  active = activate_internal and time >= tActivateLast + activationDelay;

  // sample only if the plotter is active
  sampleTrigger = active and sample(t0, samplePeriod);
//  when sampleTrigger then
//    firstTrigger = time <= t0 + samplePeriod/2;
//  end when;

  annotation (
    Icon(graphics={
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-74,90},{-82,68},{-66,68},{-74,90}}),
          Line(
            points={{-74,78},{-74,-80}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{96,-68},{74,-60},{74,-76},{96,-68}}),
          Line(
            points={{-84,-68},{88,-68}},
            color={192,192,192})}),
Documentation(info="<html>
<p>
Partial block that implements the basic functionality
used by the scatter and the time series plotters.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPlotter;
