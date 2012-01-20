within Buildings;
package Rooms "Package with models for rooms"
  extends Modelica.Icons.Package;

annotation (
preferedView="info", Documentation(info="<html>
<p>
This package contains models for the heat transfer in rooms
and through the building envelope. 
Multiple instances of these models can be connected to create
a multi-zone building model.
To compute the air exchange between rooms and between a room
and the exterior, the room models can be connected to 
multi-zone air exchange models from the package
<a href=\"modelica://Buildings.Airflow\">
Buildings.Airflow</a>.
The room models can also be linked to models of HVAC systems
that are composed of the components in the package
<a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>.
</html>"));
end Rooms;
