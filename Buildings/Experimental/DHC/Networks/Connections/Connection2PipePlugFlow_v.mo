within Buildings.Experimental.DHC.Networks.Connections;
model Connection2PipePlugFlow_v
  "Model for connecting an agent to a two-pipe distribution network, using plug flow pipe models in the main line"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length = lDis,
      final dIns = dIns,
      final kIns = kIns,
      v_nominal = v_nominal,
      roughness = roughness,
      cPip = cPip,
      rhoPip = rhoPip,
      thickness = thickness),
    redeclare model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length = lDis,
      final dIns = dIns,
      final kIns = kIns,
      v_nominal = v_nominal,
      roughness = roughness,
      cPip = cPip,
      rhoPip = rhoPip,
      thickness = thickness),
    redeclare model Model_pipCon = Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R";
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R";
  parameter Modelica.Units.SI.Velocity v_nominal = 1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)";
  parameter Modelica.Units.SI.Height roughness = 2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)";
  parameter Modelica.Units.SI.SpecificHeatCapacity cPip = 2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";
  parameter Modelica.Units.SI.Density rhoPip = 930
    "Density of pipe wall material. 930 for PE, 8000 for steel";
  parameter Modelica.Units.SI.Length thickness = 0.0035 "Pipe wall thickness";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortDis
    "Heat transfer to or from surroundings for distribution pipe(positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-110,44},{-90,64}}),
        iconTransformation(extent={{-110,44},{-90,64}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRet
    "Heat transfer to or from surroundings for return pipe (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-110,80},{-90,100}}),
        iconTransformation(extent={{-110,80},{-90,100}})));
equation
  connect(pipDisSup.heatPort, heatPortDis)
    annotation (Line(points={{-70,-30},{-70,54},{-100,54}}, color={191,0,0}));
  connect(pipDisRet.heatPort, heatPortRet) annotation (Line(points={{-70,-70},{-50,
          -70},{-50,90},{-100,90}}, color={191,0,0}));
  annotation (
    Documentation(
      info="<html>
<p>
This model represents the supply and return lines to connect an
agent (e.g. an energy transfer station) to a two-pipe main distribution
system.  A plug flow pipe model <a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a> that includes pressure drop, heat transfer, and transport
delays is used in the main distribution line,
but not in the connection to the building, as the latter is typically short.
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
June 14, 2023, by David Blum:<br/>
Fix redeclare of dis pipe models in connections.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2PipePlugFlow_v;
