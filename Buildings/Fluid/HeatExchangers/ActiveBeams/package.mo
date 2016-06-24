within Buildings.Fluid.HeatExchangers;
package ActiveBeams 
  extends Modelica.Icons.VariantsPackage;






annotation (Documentation(info="<html>
<p>
This package contains models of active beams.
</p>
Active beams are devices used for heating, cooling and ventilation of spaces.
Schematic diagram of a general active beam unit is given below. 
</p>
<p align=\"center\" >
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/ActiveBeams/schematicAB.png\" border=\"1\"/>
</p>
It consists of a primary air plenum, a mixing chamber, a heat exchanger (coil) and several nozzles. 
Typically, an air-handling unit supplies primary air to the active beams. The primary air is discharged to the mixing chamber through the nozzles.
This generates a low-pressure region which induced air from the room up through the heat exchanger, where hot or cold water is circulating. 
The conditioned induced air is then mixed with primary air, and the mixture descent back to the space.
</p>
<p>
</html>"));
end ActiveBeams;
