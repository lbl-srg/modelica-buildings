within Buildings.Experimental.DHC.Networks.Connections;
model Connection1PipePlugFlow
  "Model for connecting an agent to the DHC system"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection1Pipe(
    tau=5*60,
    redeclare replaceable model Model_pipDis =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=lDis,
      final dIns=dIns,
      final kIns=kIns),
    redeclare replaceable model Model_pipCon =
        Buildings.Fluid.FixedResistances.LosslessPipe);

  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.Length lDis
    "Length of the distribution pipe before the connection";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortDis
    "Heat transfer to and from the distribution pipe" annotation (Placement(
        transformation(extent={{-106,70},{-86,90}}), iconTransformation(extent={{-60,16},
            {-40,36}})));
equation
  connect(pipDis.heatPort, heatPortDis)
    annotation (Line(points={{-70,-30},{-70,80},{-96,80}}, color={191,0,0}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
December 10, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents the supply and return lines to connect an
agent (e.g., an energy transfer station) to a one-pipe main distribution
system.
The plug flow pipe model is used in the main distribution line,
but not in the connection to the building, as the latter is typically short.
</p>
</html>"));
end Connection1PipePlugFlow;
