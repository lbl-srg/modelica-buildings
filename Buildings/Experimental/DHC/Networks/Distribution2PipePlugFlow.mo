within Buildings.Experimental.DHC.Networks;
model Distribution2PipePlugFlow
  "Model of a two-pipe distribution network, using plug flow pipe models in the main line"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
      redeclare Connections.Connection2PipePlugFlow con[nCon](
      final lDis=lDis,
      each final dIns=dIns,
      each final kIns=kIns),
      redeclare model Model_pipDis =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=lEnd,
      final dIns=dIns,
      final kIns=kIns));
   parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
   parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (supply only, not counting return line)";
   parameter Modelica.Units.SI.Length dIns=0.05
    "Thickness of pipe insulation, used to compute R";
   parameter Modelica.Units.SI.ThermalConductivity kIns=0.028
    "Heat conductivity of pipe insulation, used to compute R";
  Modelica.Fluid.Interfaces.HeatPorts_a heatPortsDis[nCon + 1]
    "Multiple heat ports that connect to outside of pipe wall for distribution pipe"
    annotation (Placement(transformation(
        extent={{-10.5,-10},{10.5,10}},
        rotation=0,
        origin={-59.5,16}), iconTransformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={78,16})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPortsRet[nCon]
    "Multiple heat ports that connect to outside of pipe wall for return pipe"
    annotation (Placement(transformation(
        extent={{-10.5,-10},{10.5,10}},
        rotation=180,
        origin={-59.5,-76}),iconTransformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-74,-76})));
equation
  connect(con.heatPortRet, heatPortsRet) annotation (Line(points={{-10,9},{-14,
          9},{-14,-76},{-59.5,-76}}, color={191,0,0}));
  connect(con.heatPortDis, heatPortsDis[1:nCon]) annotation (Line(points={{-10,
          5.4},{-36,5.4},{-36,16},{-59.5,16}}, color={191,0,0}));
  connect(pipEnd.heatPort, heatPortsDis[nCon + 1])
    annotation (Line(points={{70,10},{70,16},{-59.5,16}}, color={191,0,0}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a model of a two-pipe distribution network using
</p>
<ul>
<li>
a connection model with a plug flow pipe
model (pressure drop, heat transfer, transport delays)in the main line, and
</li>
<li>
a dummy pipe model with no hydraulic resistance and no heat loss for the end of
the distribution line (after the last connection).
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
January 27, 2023, by Michael Wetter:<br/>
Removed connection to itself.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution2PipePlugFlow;
