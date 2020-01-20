within Buildings.Examples.DistrictReservoirNetworks.Agents;
model OneUTubeWithTough
  "Borefield model containing single U-tube boreholes, with ground response calcuted by TOUGH"
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefieldWithTough(
    redeclare Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHol,
    borFieDat(
      filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(),
      soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(),
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
          borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube)));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W") "Heat extracted from soil"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
protected
  Modelica.Blocks.Math.Sum QTotSeg_flow(final nin=nSeg, final k=ones(nSeg))
    "Total heat flow rate for all segments of this borehole"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Gain gaiQ_flow(k=borFieDat.conDat.nBor)
    "Gain to multiply the heat extracted by one borehole by the number of boreholes"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
equation
  connect(QBorHol.Q_flow, QTotSeg_flow.u) annotation (Line(points={{-10,-10},{-60,
          -10},{-60,80},{-42,80}}, color={0,0,127}));
  connect(QTotSeg_flow.y, gaiQ_flow.u)
    annotation (Line(points={{-19,80},{-2,80}}, color={0,0,127}));
  connect(gaiQ_flow.y, Q_flow)
    annotation (Line(points={{21,80},{110,80}}, color={0,0,127}));
  annotation (
  defaultComponentName="borFie",
  Documentation(info="<html>
<p>
This model simulates a borefield containing one or many single U-tube boreholes
using the parameters in the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using only one borehole heat exchanger. The
fluid mass flow rate into the borehole is divided to reflect the per-borehole
fluid mass flow rate. The borehole model calculates the dynamics within the
borehole itself using an axial discretization and a resistance-capacitance
network for the internal thermal resistances between the individual pipes and
between each pipe and the borehole wall.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Extended partial model and changed documentation to reflect the new approach
used by the borefield models.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneUTubeWithTough;
