within Buildings.DHC.ETS.Combined.Validation.BaseClasses;
partial model PartialHeatPump
  "fixme: this can be deleted. Partial validation of the ETS model with heat pump and optional water-side economiser"

equation
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-340,-220},{340,220}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 6, 2025, by Hongxiang Fu:<br/>
Revised load curves so that the heating and cooling loads can be staggered
instead of always appearing and disappearing at the same time.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4133\">#4133</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a partial model used as a base class to construct the
validation and example models.
</p>
<ul>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided
by the building automation system are here computed based on the condition
that the load is greater than 1% of the nominal load.
</li>
<li>
Simplified chiller performance data are used, which represent a linear
variation of the EIR and the capacity with the evaporator outlet temperature
and the condenser inlet temperature (no variation of the EIR at part
load is considered).
</li>
</ul>
</html>"));
end PartialHeatPump;
