model MassFractionVolumeFraction 
  "Model to convert between mass fraction and volume fraction" 
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(Rectangle(extent=[-100,100; 100,-100], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Text(
        extent=[-84,52; -14,14],
        style(color=3, rgbcolor={0,0,255}),
        string="M'"),
      Text(
        extent=[36,48; 102,8],
        style(color=3, rgbcolor={0,0,255}),
        string="V'"),
      Text(
        extent=[22,-14; 106,-52],
        style(color=3, rgbcolor={0,0,255}),
        string="V"),
      Text(
        extent=[-88,-12; -22,-48],
        style(color=3, rgbcolor={0,0,255}),
        string="M"),
      Rectangle(extent=[-72,4; -38,0], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Rectangle(extent=[46,2; 80,-2], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255}))),
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
  Modelica.Blocks.Interfaces.RealSignal m(redeclare type SignalType = 
        Modelica.SIunits.MassFraction) "Mass fraction" 
    annotation (extent=[-112,-10; -92,10]);
  Modelica.Blocks.Interfaces.RealSignal V(redeclare type SignalType = 
        Modelica.SIunits.VolumeFraction) "Volume fraction" 
    annotation (extent=[92,-10; 112,10]);
  
 parameter Modelica.SIunits.MolarMass MMMea "Molar mass of measured substance";
 parameter Modelica.SIunits.MolarMass MMBul=Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM 
    "Molar mass of bulk medium";
protected 
 parameter Real con = MMBul/MMMea 
    "Conversion coefficient from mass to volume fraction";
equation 
  V = con * m;
end MassFractionVolumeFraction;
