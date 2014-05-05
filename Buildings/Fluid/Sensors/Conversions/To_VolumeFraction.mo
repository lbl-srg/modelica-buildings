within Buildings.Fluid.Sensors.Conversions;
model To_VolumeFraction "Conversion from mass fraction to volume fraction"

  parameter Modelica.SIunits.MolarMass MMMea "Molar mass of measured substance";
  parameter Modelica.SIunits.MolarMass MMBul=Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM
    "Molar mass of bulk medium";

  Modelica.Blocks.Interfaces.RealInput m "Mass fraction"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput V "Volume fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
 parameter Real con = MMBul/MMMea
    "Conversion coefficient from mass to volume fraction";
equation
  V = con * m;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,52},{-14,14}},
          lineColor={0,0,255},
          textString="M'"),
        Text(
          extent={{36,48},{102,8}},
          lineColor={0,0,255},
          textString="V'"),
        Text(
          extent={{22,-14},{106,-52}},
          lineColor={0,0,255},
          textString="V"),
        Text(
          extent={{-88,-12},{-22,-48}},
          lineColor={0,0,255},
          textString="M"),
        Rectangle(
          extent={{-72,4},{-38,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,2},{80,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-48,146},{50,98}},
          lineColor={0,0,255},
          textString="%name")}),
defaultComponentName="toVolFra",
Documentation(info="<html>
<p>
This component converts mass fraction to volume fraction for an ideal gas.
The default value for the parameter <code>MMBul</code>
assumes that the bulk medium is air.
The model assumes that the concentration
of the measured substance is small enough to be neglected in the molar mass
of the mixture.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 13, 2011 by Michael Wetter:<br/>
Changed connectors from the obsolete <code>RealSignal</code>
to <code>RealInput</code> and <code>RealOutput</code>.
</li>
<li>
September 22, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end To_VolumeFraction;
