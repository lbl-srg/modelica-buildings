within Buildings.HeatTransfer.BaseClasses;
model PartialConstruction
  "Partial model for constructions with and without convective heat transfer coefficient"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.Area A "Heat transfer area";

  replaceable parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Construction definition from Data.OpaqueConstructions"
    annotation (Evaluate=true, choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  final parameter Integer nLay(min=1, fixed=true) = layers.nLay
    "Number of layers";
  final parameter Integer nSta[nLay](min=1)={layers.material[i].nSta for i in 1:nLay}
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

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
This is a partial model for constructions and multi-layer heat conductors.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialConstruction;
