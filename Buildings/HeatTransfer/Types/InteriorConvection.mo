within Buildings.HeatTransfer.Types;
type InteriorConvection = enumeration(
    Fixed "Fixed coefficient (a user-specified parameter is used)",
    Temperature "Temperature dependent")
  "Enumeration defining the convective heat transfer model for interior surfaces"
  annotation (Documentation(info="<html>
<p>
This enumeration is used to set the function
that is used to compute the convective
heat transfer coefficient for interior (room-side facing) surfaces.
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
