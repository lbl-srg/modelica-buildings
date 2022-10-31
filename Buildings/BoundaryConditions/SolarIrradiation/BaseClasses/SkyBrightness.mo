within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block SkyBrightness "Sky brightness"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput relAirMas "Relative air mass"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal diffuse solar radiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput skyBri "Sky brightness"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real extRadCor "Correction for extraterrestrial radiation";
equation
  extRadCor =1 + 0.033*cos(2*Modelica.Constants.pi*(solTim/86400 + 1)/365);
  skyBri = Buildings.Utilities.Math.Functions.smoothMin(
    HDifHor*relAirMas/(1366.1*extRadCor),
    1,
    0.025);
  annotation (
    defaultComponentName="skyBri",
    Documentation(info="<html>
<p>
This component computes the sky brightness.
</p>
<h4>References</h4>
<p>
R. Perez, P. Ineichen, R. Seals, J. Michalsky and R. Stewart (1990).
<i>Modeling Dyalight Availability and Irradiance Componets From Direct and Global Irradiance</i>,
Solar Energy, 44(5):271-289.
</p>
</html>", revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
Added input connector <code>solTim</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
July 07, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-46,54},{-98,66}},
          textColor={0,0,127},
          textString="relAirMas"),
        Text(
          extent={{-46,-6},{-98,6}},
          textColor={0,0,127},
          textString="HDifHor"),
        Text(
          extent={{-46,-66},{-98,-54}},
          textColor={0,0,127},
          textString="solTim")}));
end SkyBrightness;
