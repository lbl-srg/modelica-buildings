within Buildings.Experimental.DHC.Networks;
model Distribution1PipePlugFlow
  "Model of a one-pipe distribution network with plug flow pipes"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    tau=5*60,
    redeclare
      Buildings.Experimental.DHC.Networks.Connections.Connection1PipePlugFlow
      con[nCon](
      each final dIns=dIns,
      each final kIns=kIns,
      final lDis=lDis),
    redeclare model Model_pipDis =
       Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=lEnd,
      final dIns=dIns,
      final kIns=kIns));

  parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (after last connection)";
  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nCon + 1]
    "Multiple heat ports that connect to outside of pipe wall" annotation (
      Placement(transformation(
        extent={{-10.5,-10},{10.5,10}},
        rotation=90,
        origin={-95.5,50}), iconTransformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={4,-22})));
equation
  connect(con.heatPortDis, heatPorts[1:nCon])
    annotation (Line(points={{-5,2.6},{-5,50},{-95.5,50}}, color={191,0,0}));
  connect(pipEnd.heatPort, heatPorts[nCon + 1])
    annotation (Line(points={{50,10},{50,50},{-95.5,50}}, color={191,0,0}));
  annotation (Documentation(info="<html>
<p>
This model represents a one-pipe distribution network using a connection model with a plug flow pipe
model (pressure drop, heat transfer, transport delays)in the main line, and
a dummy pipe model with no hydraulic resistance and no heat loss for the end of
the distribution line (after the last connection).
</p>
</html>", revisions="<html>
<ul>
<li>
December 10, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution1PipePlugFlow;
