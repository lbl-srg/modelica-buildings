within Buildings.ThermalZones.Detailed.BaseClasses;
model RadiationAdapter
  "Model to connect between signals and heat port for radiative gains of the room"
  extends Buildings.BaseClasses.BaseIcon;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a rad
    "Port for radiative heat gain and radiation temperature"    annotation (Placement(transformation(extent={{-10,
            -110},{10,-90}}), iconTransformation(extent={{-12,
            -110},{8,-90}})));
public
  Modelica.Blocks.Interfaces.RealInput TRad "Radiation temperature of room"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput QRad_flow "Radiative heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  QRad_flow = rad.Q_flow;
  rad.T = TRad;
 annotation (Placement(transformation(extent={{-140,-20},{-100,20}})),
            Documentation(info="<html>
This model can be used as a thermal adapter in situations where the temperature
and the heat flow rate are computed in separate models.
For example, this thermal adapter is used in the room model, which computes
the distribution of radiative heat gains (such as due to a radiator) in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution\">
Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution</a>
and computes the radiative temperature in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.RadiationTemperature\">
Buildings.ThermalZones.Detailed.BaseClasses.RadiationTemperature</a>.
This adapter combines the heat flow rate and the temperatures that are computed in these
separate models, and exposes these two quantities at its heat port.

</html>",
        revisions="<html>
<ul>
<li>
Feb. 2, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,24},{-40,-26}},
          textColor={0,0,127},
          textString="TRad"),
        Text(
          extent={{50,14},{92,-12}},
          textColor={0,0,127},
          textString="Q")}),
        Documentation(info = "<html>
This is a dummy model that is required to implement the room
model with a variable number of surface models.
The model is required since arrays of models, such as used for the surfaces
that model the construction outside of the room,
must have at least one element, unless the whole array
is conditionally removed if its size is zero.
However, conditionally removing the surface models does not work in this
situation since some models, such as for computing the radiative heat exchange
between the surfaces, require access to the area and absorptivity of the surface models.

</html>",
        revisions="<html>
<ul>
<li>
June 8 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiationAdapter;
