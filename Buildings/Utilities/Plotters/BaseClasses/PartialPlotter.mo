within Buildings.Utilities.Plotters.BaseClasses;
partial block PartialPlotter "Partial block for plotters"
  extends Modelica.Blocks.Icons.Block;

  outer Buildings.Utilities.Plotters.Configuration plotConfiguration
    "Default plot configuration";

  parameter String fileName = plotConfiguration.fileName "Name of html file";

  parameter Modelica.Units.SI.Time samplePeriod(min=1E-3) = plotConfiguration.samplePeriod
    "Sample period of component" annotation (Dialog(group="Activation"));

  parameter String title = getInstanceName() "Title of the plot"
    annotation(Dialog(group="Labels"));

  parameter String introduction = ""
    "Introduction text written below title and above the plot";
  parameter Integer n = 0 "Number of independent data series (dimension of y)"
  annotation (Dialog(connectorSizing=true), HideResult=true);

  parameter String[n] legend "String array for legend, such as {\"x1\", \"x2\"}"
    annotation(Dialog(group="Labels"));

  parameter Buildings.Utilities.Plotters.Types.LocalActivation activation=
    Buildings.Utilities.Plotters.Types.LocalActivation.use_activation
    "Set to true to enable an input that allows activating and deactivating the plotting"
    annotation(Dialog(group="Activation"));

  parameter Modelica.Units.SI.Time activationDelay(min=0) = plotConfiguration.activationDelay
    "Time that needs to elapse to enable plotting after activate becomes true"
    annotation (Dialog(group="Activation"));

  Modelica.Blocks.Interfaces.RealVectorInput y[n] "y-data" annotation (
      Placement(transformation(extent={{-130,-20},{-90,20}}),
        iconTransformation(extent={{-140,20},{-100,-20}})));

  Modelica.Blocks.Interfaces.BooleanInput activate
  if (activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_input)
    "Set to true to enable plotting of time series after activationDelay elapsed"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Boolean active "Flag, true if plots record data";
protected
  parameter Modelica.Units.SI.Time t0(fixed=false) "First sample time instant";
  parameter String insNam = Modelica.Utilities.Strings.replace(
    getInstanceName(), ".", "_")
    "Name of this instance with periods replace by underscore";
  parameter Boolean connectPoints=
    (activation == Buildings.Utilities.Plotters.Types.LocalActivation.always) or
    (activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_activation and
    plotConfiguration.activation == Buildings.Utilities.Plotters.Types.GlobalActivation.always)
    "Flag, true if points should be connected in plots";

  parameter String plotMode = "mode: '" +
   (if connectPoints then "lines+" else "") + "markers',"
    "Configuration to connect or disconnect the points";

  Modelica.Blocks.Interfaces.BooleanInput activate_internal
    "Internal connector to activate plots";
  discrete Modelica.Units.SI.Time tActivateLast
    "Time when plotter was the last time activated";

  output Boolean sampleTrigger "True, if sample time instant";

  Buildings.Utilities.Plotters.BaseClasses.Backend plt=
    Buildings.Utilities.Plotters.BaseClasses.Backend(
      fileName=fileName,
      instanceName=insNam,
      nDbl=n+1)
    "Object that stores data for this plot";
initial equation
  t0 = time;
  Buildings.Utilities.Plotters.BaseClasses.sendString(
    plt=plt,
    string="
    <h1>" + title + "</h1>
    " + (if (Modelica.Utilities.Strings.length(introduction) > 0) then
      "<p>" + introduction + "</p>"
      else "")  + "
    <div id=\"" + insNam + "\"></div>
    <script>
    ");
  tActivateLast = time-2*activationDelay;
equation
  if (activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_input) then
    connect(activate, activate_internal);
  elseif  (activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_activation) then
    activate_internal = plotConfiguration.active;
  elseif  (activation == Buildings.Utilities.Plotters.Types.LocalActivation.always) then
    activate_internal = true;
  end if;
  when (activate_internal) then
    tActivateLast = time;
  end when;

  active = activate_internal and time >= tActivateLast + activationDelay;

  // sample only if the plotter is active
  sampleTrigger = active and sample(t0, samplePeriod);

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
            color={192,192,192}),
        Ellipse(
          extent={{-96,10},{-76,-10}},
          lineColor={0,140,72},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          visible=activation == Buildings.Utilities.Plotters.Types.LocalActivation.always),
        Ellipse(
          extent={{-96,10},{-76,-10}},
          lineColor={28,108,200},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          visible=activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_activation),
        Ellipse(
          extent={{-95,67},{-81,53}},
          lineColor=DynamicSelect({235,235,235}, if activate > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if activate > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid,
          visible=activation == Buildings.Utilities.Plotters.Types.LocalActivation.use_input)}),
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
