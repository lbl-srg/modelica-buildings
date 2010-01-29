within Buildings.Utilities.Psychrometrics.BaseClasses;
partial block HumidityRatioVaporPressure
  "Humidity ratio for given water vapor pressure"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
<p>
Partial Block to compute the relation between humidity ratio and water vapor partial pressure.
</p>
<p>If <tt>use_p_in</tt> is false (default option), the <tt>p</tt> parameter
is used as atmospheric pressure, 
and the <tt>p_in</tt> input connector is disabled; 
if <tt>use_p_in</tt> is true, then the <tt>p</tt> parameter is ignored, 
and the value provided by the input connector is used instead.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2009 by Michael Wetter:<br>
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
          lineColor={0,0,0},
          textString="p_in")}));
  parameter Boolean use_p_in = true "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Modelica.SIunits.Pressure p = 101325 "Fixed value of pressure" 
    annotation (Evaluate = true,
                Dialog(enable = not use_p_in));
  Modelica.Blocks.Interfaces.RealInput p_in(final quantity="Pressure",
                                         final unit="Pa",
                                         min = 0) if  use_p_in
    "Atmospheric Pressure" 
    annotation (Placement(transformation(extent={{-120,50},{-100,70}},
                rotation=0)));
  output Modelica.SIunits.MassFraction X_dryAir(min=0, max=1, nominal=0.01, start=0.001)
    "Water mass fraction per mass of dry air";
protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal
    "Needed to connect to conditional connector";
equation
  connect(p_in, p_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
end HumidityRatioVaporPressure;
