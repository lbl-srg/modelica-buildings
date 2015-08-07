within Buildings.HeatTransfer.Windows.BaseClasses;
block StateInterpolator "Block to interpolate between different window states"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer NSta(min=1)
    "Number of window states for electrochromic windows"
    annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput uSta(min=0, max=1, unit="1") if
       NSta > 1 "Control signal for window state"
                                       annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput HSta[NSta]
    "Radiation for each window state"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput H "Interpolated radiation" annotation (
      Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));

protected
  Modelica.Blocks.Interfaces.RealInput uSta_internal(min=0, max=1, unit="1")
    "Control signal for window state";
equation
  if NSta < 2 then
    uSta_internal = 0;
    H = HSta[1];
  else
    connect(uSta, uSta_internal);
    H = HSta[1]; // fixme Add interpolation here
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
interpolated radiation.
</p>
</html>", revisions="<html>
<ul>
<li>
August 6, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StateInterpolator;
