within Buildings.Experimental.DHC.Networks.Connections;
model Connection2PipePlugFlow
  "Model for connecting an agent to a two-pipe distribution network, using plug flow pipe models in the main line"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=lDis,
      final dIns=dIns,
      final kIns=kIns),
    redeclare model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.PlugFlowPipe (
      final length=lDis,
      final dIns=dIns,
      final kIns=kIns),
    redeclare model Model_pipCon=Fluid.FixedResistances.LosslessPipe);
 parameter Modelica.Units.SI.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R";
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R";
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
June 14, 2023, by David Blum:<br/>
Fix redeclare of dis pipe models in connections.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2PipePlugFlow;
