within Buildings.ThermalZones.Detailed.Examples.SingleZoneFloor.Validation.BaseClasses;
model Floor "Five-zone floor model with modified internal gains"
  extends Buildings.Examples.VAVReheat.ThermalZones.Floor(
    gai(K=10*[0.4; 0.4; 0.2]));
  annotation (Documentation(info="<html>
  <p>
  This model extends the five-zone floor model from 
  <a href=\"modelica://Buildings.Examples.VAVReheat.ThermalZones.Floor\">
  Buildings.Examples.VAVReheat.ThermalZones.Floor</a>. The internal gains per 
  area in this model is modified to 10 W/m&#178;.
  </p>
  </html>",
  revisions="
  <html>
  <ul>
  <li>
  April 3, 2020, by Kun Zhang:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end Floor;
