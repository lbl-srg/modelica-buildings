within Buildings.Experimental.DHC.Networks;
model Distribution2PipePlugFlow
  "Model of a two-pipe distribution network, using plug flow pipe models"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    redeclare Connection2PipePlugFlow con[nCon](
      final length=length,
      final dIns=dIns,
      final kIns=kIns),
    redeclare model Model_pipDis=Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.Length length[nCon]
    "Pipe length"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.Length dIns[nCon]=fill(0.05,nCon)
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  parameter Modelica.Units.SI.ThermalConductivity kIns[nCon]=fill(0.028,nCon)
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Pipe"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat transfer to or from surroundings (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}}),
        iconTransformation(extent={{-140,-110},{-120,-90}})));
equation
  for i in 1:nCon loop
  connect(heatPort, con[i].heatPort)
   annotation (Line(points={{-100,30},{-30,30},{-30,7},{-10,7}},
     color={191,0,0}));
  end for;
  connect(port_aDisSup, port_aDisSup)
    annotation (Line(points={{-100,0},{-100,0}}, color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a model of a two-pipe distribution network using
</p>
<ul>
<li>
a connection model with a plug flow pipe
model (pressure drop, heat transfer, transport delays), and
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
January 2, 2023, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution2PipePlugFlow;
