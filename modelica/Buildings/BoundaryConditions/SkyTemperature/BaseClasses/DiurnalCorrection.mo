within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block DiurnalCorrection
  "Diurnal correction for difference in sky emissivities at day and night"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput solTim(final quantity="Time", final unit
      ="s") "Solar time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput diuCor "Diurnal correction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  diuCor = 0.013*Modelica.Math.cos(Modelica.Constants.pi*solTim/43200);
  annotation (
    defaultComponentName="diuCor",
    Documentation(info="<HTML>
<p>
This component computes the diurnal correction.
</p>
<h4>References</h4>
P. Berdahl and R. Fromberg (1982).
<i>The Thermal Radiance of Clear Skies</i>,
Solar Energy, 29: 299-314.<br>
P. Berdahl and M. Martin (1984).
<i>Emissivity of Clear Skies</i>,
Solar Energy, 32: 663-664.<br>
M. Martin and P. Berdahl (1984).
<i>Characteristics of Infrared Sky Radiation in the United States</i>,
Solar Energy, 33: 321-336.

</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end DiurnalCorrection;
