within Buildings.Fluid.FMI.Examples;
block FlowMachine_dp "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare final package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated,
     redeclare final Movers.FlowMachine_dp com(
      final m_flow_nominal=m_flow_nominal,
      final dynamicBalance=false,
      final filteredSpeed=false));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(start=1) = 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=10
    "Pressure drop at nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealInput dp_in(min=0, final unit="Pa")
    "Prescribed pressure rise"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

equation
  connect(dp_in, com.dp_in) annotation (Line(
      points={{0,120},{-0.2,120},{-0.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.FlowMachine_dp\">
Buildings.Fluid.FixedResistances.FlowMachine_dp</a>.
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FlowMachine_dp.mos"
        "Export FMU"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end FlowMachine_dp;
