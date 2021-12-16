within Buildings.Utilities.Psychrometrics.BaseClasses;
partial block HumidityRatioVaporPressure
  "Humidity ratio for given water vapor pressure"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean use_p_in = true "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.Pressure p=101325 "Fixed value of pressure"
    annotation (Dialog(enable=not use_p_in));
  Modelica.Blocks.Interfaces.RealInput p_in(final quantity="Pressure",
                                         final unit="Pa",
                                         displayUnit="Pa",
                                         min = 0)  if use_p_in
    "Atmospheric Pressure"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal
    "Needed to connect to conditional connector";
equation
  connect(p_in, p_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
  annotation (
    Documentation(info="<html>
<p>
Partial Block to compute the relation between humidity ratio and water vapor partial pressure.
</p>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as atmospheric pressure,
and the <code>p_in</code> input connector is disabled;
if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored,
and the value provided by the input connector is used instead.
</p>
</html>", revisions="<html>
<ul>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
April 14, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,96},{96,-96}},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={255,255,255},
          fillColor={170,213,255}),
        Text(
          visible=use_p_in,
          extent={{-90,108},{-34,16}},
          textColor={0,0,0},
          textString="p_in")}));
end HumidityRatioVaporPressure;
