within Buildings.Utilities.Plotters;
model Configuration "Configuration for plotters"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Time samplePeriod(min=1E-3)
    "Sample period of component";
  parameter String fileName = Modelica.Utilities.Files.fullPathName("plots.html")
   "Name of html file";
  parameter Buildings.Utilities.Plotters.Types.TimeUnit timeUnit = Types.TimeUnit.hours
  "Time unit for plot"
    annotation(Dialog(group="Labels"));

  parameter Buildings.Utilities.Plotters.Types.GlobalActivation activation=
    Buildings.Utilities.Plotters.Types.GlobalActivation.always
    "Set to true to enable an input that allows activating and deactivating the plotting"
    annotation(Dialog(group="Activation"));

  parameter Modelica.Units.SI.Time activationDelay(min=0) = 0
    "Time that needs to elapse to enable plotting after activate becomes true"
    annotation (Dialog(group="Activation", enable=(activation == Buildings.Utilities.Plotters.Types.GlobalActivation.use_input)));

  Modelica.Blocks.Interfaces.BooleanInput activate
  if (activation == Buildings.Utilities.Plotters.Types.GlobalActivation.use_input)
    "Set to true to enable plotting of time series after activationDelay elapsed"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Boolean active "Flag, true if plots record data";
protected
  Modelica.Blocks.Interfaces.BooleanInput activate_internal
    "Internal connector to activate plots";
  discrete Modelica.Units.SI.Time tActivateLast
    "Time when plotter was the last time activated";
initial equation
  tActivateLast = time-2*activationDelay;
equation
  if (activation == Buildings.Utilities.Plotters.Types.GlobalActivation.use_input) then
    connect(activate, activate_internal);
  else
    activate_internal = true;
  end if;
  when (activate_internal) then
    tActivateLast = time;
  end when;
  active = activate_internal and time >= tActivateLast + activationDelay;
  annotation (
  defaultComponentName="plotConfiguration",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"plotConfiguration\" component but
an inner \"plotConfiguration\" component is not defined.
For simulation drag Buildings.Utilities.Plotters.Configuration into your model
to specify system properties.",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,254,238},
          fillPattern=FillPattern.Solid),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Line(
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
    Line(origin = {-1.939,-1.816},
        points = {{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,113.485},{-65.374,-61.217},{-78.061,-78.184}},
        color = {0,0,127},
        smooth = Smooth.Bezier),
        Text(
          extent={{-42,-44},{34,-74}},
          textColor={0,0,0},
          textString="delay=%activationDelay"),
        Ellipse(
          extent={{-95,67},{-81,53}},
          lineColor=DynamicSelect({235,235,235}, if activate > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if activate > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid,
          visible=activation == Buildings.Utilities.Plotters.Types.GlobalActivation.use_input)}),  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block can be used to globally configure the parameters
for the blocks from the package
<a href=\"modelica://Buildings.Utilities.Plotters\">Buildings.Utilities.Plotters</a>.
Use this block for example to set the same
plot file name and sampling time.
</p>
<p>
To use this block, simply drag it at the top-most level, or higher,
where your plotters are.
</p>
</html>"));
end Configuration;
