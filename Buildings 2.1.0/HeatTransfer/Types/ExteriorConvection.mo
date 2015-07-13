within Buildings.HeatTransfer.Types;
type ExteriorConvection = enumeration(
    Fixed "Fixed coefficient (a user-specified parameter is used)",
    TemperatureWind "Wind speed and temperature dependent")
  "Enumeration defining the convective heat transfer model for exterior surfaces"
annotation (Documentation(info="<html>
<p>
This enumeration is used to set the function
that is used to compute the convective
heat transfer coefficient for exterior (outside-side facing) surfaces.
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
