within Buildings.Fluid.FMI.Examples;
block FixedResistanceDpM "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated,
     redeclare final Buildings.Fluid.FixedResistances.FixedResistanceDpM com(
      m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(start=1) = 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=10
    "Pressure drop at nominal mass flow rate";
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>.
</p>
<p>
In Dymola, to export the model as an FMU,
select from the pull down menu <code>Commands - Export FMU</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FixedResistanceDpM.mos"
        "Export FMU"));
end FixedResistanceDpM;
