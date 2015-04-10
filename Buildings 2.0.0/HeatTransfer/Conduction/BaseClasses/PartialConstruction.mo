within Buildings.HeatTransfer.Conduction.BaseClasses;
model PartialConstruction "Partial model for multi-layer constructions"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.Area A "Heat transfer area";

  replaceable parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Construction definition from Data.OpaqueConstructions"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  final parameter Integer nLay(min=1, fixed=true) = size(layers.material, 1)
    "Number of layers";
  final parameter Integer nSta[nLay](each min=1)={layers.material[i].nSta for i in 1:nLay}
    "Number of states"  annotation(Evaluate=true);
  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
        annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.SIunits.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.SIunits.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  annotation (    Documentation(info="<html>
Partial model for constructions and multi-layer heat conductors.
</html>", revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed assignment of <code>nLay</code> to avoid a translation error
in OpenModelica.
</li>
<li>
August 12, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in <code>min</code>
attribute of <code>nSta</code>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialConstruction;
