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
      final kIns=kIns,
      v_nominal=v_nominal,
      roughness=roughness,
      cPip=cPip,
      rhoPip=rhoPip,
      thickness=thickness),
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
  parameter Modelica.Units.SI.Velocity v_nominal=1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)";
  parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)";
  parameter Modelica.Units.SI.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";
  parameter Modelica.Units.SI.Density rhoPip=930
    "Density of pipe wall material. 930 for PE, 8000 for steel";
  parameter Modelica.Units.SI.Length thickness=0.0035 "Pipe wall thickness";
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
