within Buildings.Examples.DistrictReservoirNetworks.Agents;
model OneUTube "Borefield model containing single U-tube boreholes"
  extends Buildings.Fluid.Geothermal.Borefields.OneUTube(
    nSeg=10,
    nCel=5,
    tLoaAgg=300,
    show_T=true,
    borFieDat(
      final filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
          kFil=2.5,
          cFil=1000,
          dFil=2600),
      final soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
          kSoi=2.5,
          cSoi=1000,
          dSoi=2600),
      final conDat=
          Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
          borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
          cooBor={{6*mod((i - 1), 20),6*floor((i - 1)/20)} for i in 1:400})));

//    parameter Modelica.SIunits.Length xBorFie = 120 "Borefield length"
//      annotation(Dialog(tab="Borefield"));
//    parameter Modelica.SIunits.Length yBorFie = 120 "Borefield width"
//      annotation(Dialog(tab="Borefield"));
//    parameter Modelica.SIunits.Length dBorHol = 6 "Distance between two boreholes"
//      annotation(Dialog(tab="Borefield"));
//    final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
//      "Number of boreholes in x-direction"
//      annotation(Dialog(tab="Borefield"));
//    final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
//      "Number of boreholes in y-direction"
//      annotation(Dialog(tab="Borefield"));
//    final parameter Integer nBorHol = nXBorHol*nYBorHol "Number of boreholes"
//      annotation(Dialog(tab="Borefield"));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W") "Heat extracted from soil"
    annotation (Placement(transformation(extent={{100,56},{120,76}}),
        iconTransformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_single(final unit="W") "Heat extracted from soilConnector of Real output signal"
                                      annotation (Placement(transformation(
          extent={{100,90},{120,110}}), iconTransformation(extent={{100,90},{
            120,110}})));
equation
  connect(gaiQ_flow.y, Q_flow) annotation (Line(points={{1,80},{10,80},{10,66},{
          110,66},{110,66}}, color={0,0,127}));
  connect(QTotSeg_flow.y, Q_flow_single) annotation (Line(points={{-39,80},{-30,
          80},{-30,100},{110,100}}, color={0,0,127}));
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
end OneUTube;
