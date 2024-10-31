within Buildings.DHC.Networks;
model Distribution2PipePlugFlow_v
  "Model of a two-pipe distribution network using plug flow pipe models in the main lines with hydraulic diameter calculated from nominal velocity"
  extends Buildings.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
      redeclare Connections.Connection2PipePlugFlow_v con[nCon](
      final lDis=lDis,
      each final dIns=dIns,
      each final kIns=kIns,
      each final v_nominal=v_nominal,
      each final roughness=roughness,
      each final cPip=cPip,
      each final rhoPip=rhoPip,
      each final thickness=thickness),
      redeclare model Model_pipDis = Buildings.Fluid.FixedResistances.PlugFlowPipe(
        final length=lEnd,
        final dIns=dIns,
        final kIns=kIns,
        final v_nominal=v_nominal,
        final roughness=roughness,
        final cPip=cPip,
        final rhoPip=rhoPip,
        final thickness=thickness));
   parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
   parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (supply only, not counting return line)";
   parameter Modelica.Units.SI.Length dIns=0.05
    "Thickness of pipe insulation, used to compute R";
   parameter Modelica.Units.SI.ThermalConductivity kIns=0.028
    "Heat conductivity of pipe insulation, used to compute R";
   parameter Modelica.Units.SI.Velocity v_nominal=1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)";
   parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)";
   parameter Modelica.Units.SI.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";
   parameter Modelica.Units.SI.Density rhoPip=930
    "Density of pipe wall material. 930 for PE, 8000 for steel";
   parameter Modelica.Units.SI.Length thickness=0.0035 "Pipe wall thickness";
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
This is a model of a two-pipe distribution network using a connection model with a plug flow pipe
model (pressure drop, heat transfer, transport delays) in the main lines whose hydraulic diameters
are calculated based on nominal velocity at nominal flow rate <a href=\"modelica://Buildings.DHC.Networks.Connections.Connection2PipePlugFlow_v\">
Buildings.DHC.Networks.Connections.Connection2PipePlugFlow</a>. The same pipe model is also used
at the end of the distribution line (after the last connection) only on the supply side.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 15, 2024, by David Blum:<br/>
Renamed.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3712\">issue 3712</a>.
</li>
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
end Distribution2PipePlugFlow_v;
