within Buildings.Rooms.BaseClasses;
record ConstructionNumbers "Data records for construction data"

  ////////////////////////////////////////////////////////////////////////
  // Number of constructions and surface areas
  parameter Integer nConExt(min=0) "Number of exterior constructions"
    annotation (Dialog(group="Exterior constructions"));
  parameter Integer nConExtWin(min=0) "Number of window constructions"
    annotation (Dialog(group="Exterior constructions"));

  parameter Integer nConPar(min=0) "Number of partition constructions"
  annotation (Dialog(group="Partition constructions"));

  parameter Integer nConBou(min=0)
    "Number of constructions that have their outside surface exposed to the boundary of this room"
  annotation (Dialog(group="Boundary constructions"));

  parameter Integer nSurBou(min=0)
    "Number of surface heat transfer models that connect to constructions that are modeled outside of this room"
  annotation (Dialog(group="Boundary constructions"));

  // Dimensions of components and connectors
protected
  parameter Integer NConExt(min=1)=max(1, nConExt)
    "Number of elements for exterior constructions";

  parameter Integer NConExtWin(min=1)=max(1, nConExtWin)
    "Number of elements for exterior constructions with windows";

  parameter Integer NConPar(min=1)=max(1, nConPar)
    "Number of elements for partition constructions";

  parameter Integer NConBou(min=1)=max(1, nConBou)
    "Number of elements for constructions that have their outside surface exposed to the boundary of this room";

  parameter Integer NSurBou(min=1)=max(1, nSurBou)
    "Number of elements for surface heat transfer models that connect to constructions that are modeled outside of this room";

  // Flags to conditionally remove components
  final parameter Boolean haveConExt = nConExt > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConExtWin = nConExtWin > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConPar = nConPar > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConBou = nConBou > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveSurBou = nSurBou > 0
    "Flag to conditionally remove components";
annotation (
Documentation(
info="<html>
<p>
Record that defines the number of constructions that are 
used in the room model.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 14, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end ConstructionNumbers;
