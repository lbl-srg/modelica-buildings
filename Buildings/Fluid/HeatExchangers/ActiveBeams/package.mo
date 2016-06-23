within Buildings.Fluid.HeatExchangers;
package ActiveBeams
  extends Modelica.Icons.VariantsPackage;





annotation (Documentation(info="<html>
<p>
This package contains models of active beams.
</p>
<p>
Active beams are devices used for heating, cooling and ventilation of spaces.
A schematic diagram of an active beam unit is given below. 
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/ActiveBeams/schematicAB.jpg\" border=\"1\"/>
</p>
<p>
The active beam unit consists of a primary air plenum, a mixing chamber, a heat exchanger (coil) and several nozzles. 
Typically, an air-handling unit supplies primary air to the active beams.
The primary air is discharged to the mixing chamber through the nozzles.
This generates a low-pressure region which induces air from the room up through the heat exchanger,
where hot or cold water is circulating. 
The conditioned induced air is then mixed with primary air, and the mixture descents back to the space.
</p>
</html>"));
end ActiveBeams;
