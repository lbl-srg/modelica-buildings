within Buildings.ThermalZones.Detailed.BaseClasses;
record ConstructionNumbers "Data records for construction data"
  extends Modelica.Icons.Record;

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
  final parameter Integer NConExt(min=1) = max(1, nConExt)
    "Number of elements for exterior constructions"
    annotation (HideResult=true);

  final parameter Integer NConExtWin(min=1)=max(1, nConExtWin)
    "Number of elements for exterior constructions with windows"
    annotation (HideResult=true);

  final parameter Integer NConPar(min=1)=max(1, nConPar)
    "Number of elements for partition constructions"
    annotation (HideResult=true);

  final parameter Integer NConBou(min=1)=max(1, nConBou)
    "Number of elements for constructions that have their outside surface exposed to the boundary of this room"
    annotation (HideResult=true);

  final parameter Integer NSurBou(min=1)=max(1, nSurBou)
    "Number of elements for surface heat transfer models that connect to constructions that are modeled outside of this room"
    annotation (HideResult=true);

  // Flags to conditionally remove components
  final parameter Boolean haveConExt = nConExt > 0
    "Flag to conditionally remove components"
    annotation (HideResult=true);
  final parameter Boolean haveConExtWin = nConExtWin > 0
    "Flag to conditionally remove components"
    annotation (HideResult=true);
  final parameter Boolean haveConPar = nConPar > 0
    "Flag to conditionally remove components"
    annotation (HideResult=true);
  final parameter Boolean haveConBou = nConBou > 0
    "Flag to conditionally remove components"
    annotation (HideResult=true);
  final parameter Boolean haveSurBou = nSurBou > 0
    "Flag to conditionally remove components"
    annotation (HideResult=true);
annotation (
Documentation(
info="<html>
<p>
Record that defines the number of constructions that are
used in the room model.
</p>
<p>
This record also declares parameters that contain the number of constructions,
such as the number of exterior constructions <code>nConExt</code>.
This parameter may take on the value <code>0</code>.
If this parameter were to be used to declare the size of vectors of
component models, then there may be vectors with zero components.
This can cause problems in Dymola 7.4.
Therefore, a parameter is declared in the form
</p>
<pre>
  NConExt = max(1, nConExt)
</pre>
<p>This parameter is the used by models that extend this model
to set the size of the vector of component models.</p>
<p>
There are also parameters that can be used to conditionally remove components,
such as <code>haveConExt</code>, which is set to
</p>
<pre>
  haveConExt = nConExt &gt; 0;
</pre>
</html>",
revisions="<html>
<ul>
<li>
October 1, 2013, by Michael Wetter:<br/>
Added <code>HideResult=true</code> annotation.
</li>
<li>
January 14, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end ConstructionNumbers;
