within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses;
partial model Slab "Base class for radiant slab"
  parameter
    Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType
     sysTyp "Radiant system type";

  parameter Modelica.Units.SI.Distance disPip "Pipe distance";

  parameter Buildings.Fluid.Data.Pipes.Generic pipe
    "Record for pipe geometry and material"
    annotation (choicesAllMatching = true, Placement(transformation(extent={{-60,60},{-40,80}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic layers(nLay(min=2))
    "Definition of the construction, which must have at least two material layers"
    annotation (Dialog(group="Construction"), choicesAllMatching=true, Placement(transformation(extent={{-20,60},
            {0,80}})));
  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start, T_c_start and T_b_start"
    annotation(Dialog(tab="Initialization", group="Construction"));

  parameter Integer iLayPip(min=1)
    "Number of the interface layer in which the pipes are located"
  annotation(Dialog(group="Construction"), Evaluate=true);

  parameter Modelica.Units.SI.Temperature T_a_start=293.15
    "Initial temperature at surf_a, used if steadyStateInitial = false"
    annotation (Dialog(tab="Initialization", group="Construction"));
  parameter Modelica.Units.SI.Temperature T_b_start=293.15
    "Initial temperature at surf_b, used if steadyStateInitial = false"
    annotation (Dialog(tab="Initialization", group="Construction"));

  parameter Boolean stateAtSurface_a=true
    "=true, a state will be at the surface a"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);
  parameter Boolean stateAtSurface_b=true
    "=true, a state will be at the surface b"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_a
    "Heat port at construction surface"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_b
    "Heat port at construction surface"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  annotation (Documentation(info="<html>
<p>
This partial model is used to construct radiant slab models with one circuit or with multiple parallel circuits.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Slab;
