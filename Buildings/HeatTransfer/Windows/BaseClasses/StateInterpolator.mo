within Buildings.HeatTransfer.Windows.BaseClasses;
block StateInterpolator "Block to interpolate between different window states"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer NSta(min=1)
    "Number of window states for electrochromic windows"
    annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput uSta(min=0, max=1, unit="1")
    if NSta > 1 "Control signal for window state"
                                       annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput HSta[NSta]
    "Radiation for each window state"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput H "Interpolated radiation" annotation (
      Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Real uSup[NSta] = {(i-1.0)/max(1.0, (NSta-1)) for i in 1:NSta}
    "Support points for the radiations HSta";
  Modelica.Blocks.Interfaces.RealInput uSta_internal(min=0, max=1, unit="1")
    "Control signal for window state";
equation
  if NSta == 1 then
    uSta_internal = 0;
    H = HSta[1];
  else
    connect(uSta, uSta_internal);
    // Linear interpolation. y=0 means off-state, in which case HSta[1] needs to
    // be assigned to the output.
    H = uSta_internal*HSta[2]+(1-uSta_internal)*HSta[1];
      Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=uSta_internal,
        xSup=uSup,
        ySup=HSta,
        ensureMonotonicity=true);
  end if;

  annotation (
  defaultComponentName="staInt",
  Documentation(info="<html>
<p>
This block interpolates the radiation data for the actual
state of the window.
For windows with only one state, e.g., conventional windows,
this block outputs <code>H=HSta[1]</code>.
For windows with multiple states, it outputs the
interpolated radiation using cubic spline interpolation.
</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StateInterpolator;
