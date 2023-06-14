within Buildings.Experimental.DHC.Networks;
model Connection2PipePlugFlow
  "Model for connecting an agent to a two-pipe distribution network, using plug flow pipe models in the main line"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=length,
      final dIns=dIns,
      final kIns=kIns),
    redeclare model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=length,
      final dIns=dIns,
      final kIns=kIns),
    redeclare model Model_pipCon=Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.Length length
    "Pipe length"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat transfer to or from surroundings (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
equation
  connect(pipDisRet.heatPort, heatPort) annotation (Line(points={{-70,-70},{-70,
          -60},{-52,-60},{-52,70},{-100,70}},
                                    color={191,0,0}));
  connect(pipDisSup.heatPort, heatPort) annotation (Line(points={{-70,-30},{-70,
          -20},{-52,-20},{-52,70},{-100,70}}, color={191,0,0}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a model of a connection with a two-pipe distribution network using 
a plug flow pipe model that includes pressure drop, heat transfer, and transport
delays.
</p>
<p>
The plug flow pipe model is used in the main distribution line,
but not in the connection to the building, as the latter is typically short.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2PipePlugFlow;
