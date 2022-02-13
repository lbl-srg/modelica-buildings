within Buildings.ThermalZones.Detailed.BaseClasses;
record PartialParameterConstruction "Partial record for constructions"
  extends Modelica.Icons.Record;

  parameter String name = ""
    "Surface name. Optional for MixedAir, required for FFD.";

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Material properties of opaque construction"
    annotation(Dialog(group="Opaque construction"),
               choicesAllMatching=true, Placement(transformation(extent={{146,258},
            {166,278}})));

  parameter Modelica.Units.SI.Angle til "Surface tilt";
  parameter Modelica.Units.SI.Angle azi "Surface azimuth";
  final parameter Boolean is_floor=til > 2.74889125 and til < 3.53428875
    "Flag, true if construction is a floor" annotation (Evaluate=true);
  final parameter Boolean is_ceiling=til > -0.392699 and til < 0.392699
    "Flag, true if construction is a floor" annotation (Evaluate=true);
//  final parameter Integer nLay(min=1, fixed=true) = size(layers.material, 1)
//    "Number of layers";
//  final parameter Integer nSta[:](each min=1)={layers.material[i].nSta for i in 1:size(layers.material, 1)}
//    "Number of states"  annotation(Evaluate=true);
  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
        annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.Units.SI.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));

  parameter Boolean stateAtSurface_a=true
    "=true, a state will be at the surface a"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);
  parameter Boolean stateAtSurface_b=true
    "=true, a state will be at the surface b"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);

  parameter Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions boundaryCondition=
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature
    "Boundary condition used in the CFD simulation"
    annotation(Dialog(group="Boundary condition"));

  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of constructions that do not have a window.
</p>
<p>
The surface azimuth is defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Michael Wetter:<br/>
Change parameter <code>isFloor</code> to <code>is_floor</code>,
and <code>isCeiling</code> to <code>is_ceiling</code>,
for consistency with naming convention.
</li>
<li>
December 8, 2016, by Michael Wetter:<br/>
Added parameters <code>stateAtSurface_a</code> and
<code>stateAtSurface_b</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">#565</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
October 11, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialParameterConstruction;
