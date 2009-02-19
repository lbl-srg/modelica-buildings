within Buildings.Fluids.Sensors.Conversions;
model MassFractionVolumeFraction
  "Model to convert between mass fraction and volume fraction"
  extends Buildings.BaseClasses.BaseIcon;
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
          fillPattern=FillPattern.Solid)}),
Documentation(info="<HTML>
<p>
This component converts mass fraction to volume fraction for an ideal gas.
The default value for the parameter <tt>MMBul</tt>
assumes that the bulk medium is air. 
The model assumes that the concentration
of the measured specy is small enough to be neglected in the molar mass
of the mixture.
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
September 22, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal m "Mass fraction" 
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}}, rotation=
           0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal V "Volume fraction" 
    annotation (Placement(transformation(extent={{92,-10},{112,10}}, rotation=0)));

 parameter Modelica.SIunits.MolarMass MMMea "Molar mass of measured substance";
 parameter Modelica.SIunits.MolarMass MMBul=Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM
    "Molar mass of bulk medium";
protected
 parameter Real con = MMBul/MMMea
    "Conversion coefficient from mass to volume fraction";
equation
  V = con * m;
end MassFractionVolumeFraction;
