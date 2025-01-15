within Buildings.DHC.Networks;
model Distribution1PipePlugFlow_v
  "Model of a one-pipe distribution network with plug flow pipes in the main line with hydraulic diameter calculated from nominal velocity"
  extends Buildings.DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    tau=5*60,
    redeclare Buildings.DHC.Networks.Connections.Connection1PipePlugFlow_v
      con[nCon](
      each final dIns=dIns,
      each final kIns=kIns,
      each final v_nominal=v_nominal,
      each final roughness=roughness,
      each final cPip=cPip,
      each final rhoPip=rhoPip,
      each final thickness=thickness,
      final lDis=lDis),
    redeclare model Model_pipDis = Buildings.Fluid.FixedResistances.PlugFlowPipe (
        final length=lEnd,
        final dIns=dIns,
        final kIns=kIns,
        final v_nominal=v_nominal,
        final roughness=roughness,
        final cPip=cPip,
        final rhoPip=rhoPip,
        final thickness=thickness));

  parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (after last connection)";
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
model (pressure drop, heat transfer, transport delays) in the main line whose hydraulic diameters
are calculated based on nominal velocity at nominal flow rate  <a href=\"modelica://Buildings.DHC.Networks.Connections.Connection1PipePlugFlow_v\">
Buildings.DHC.Networks.Connections.Connection1PipePlugFlow</a>. The same pipe model at the end of
the distribution line (after the last connection).
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2024, by David Blum:<br/>
Renamed.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3712\">issue 3712</a>.
</li>
<li>
December 10, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution1PipePlugFlow_v;
