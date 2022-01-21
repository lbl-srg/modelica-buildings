within Buildings.Examples.DistrictReservoirNetworks.Agents;
model OneUTubeWithTough
  "Borefield model containing single U-tube boreholes, with ground response calcuted by TOUGH"
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefieldWithTough(
    show_T=true,
    redeclare Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHol,
    borFieDat(
      filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
          kFil=2.5,
          cFil=1000,
          dFil=2600),
      soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
          kSoi=2.5,
          cSoi=1000,
          dSoi=2600),
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
          borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
          cooBor={{6*mod((i - 1), 20),6*floor((i - 1)/
          20)} for i in 1:400})),
    toughRes(samplePeriod=900, flag=1));

//   parameter Modelica.SIunits.Length xBorFie = 120 "Borefield length"
//     annotation(Dialog(tab="Borefield"));
//   parameter Modelica.SIunits.Length yBorFie = 120 "Borefield width"
//     annotation(Dialog(tab="Borefield"));
//   parameter Modelica.SIunits.Length dBorHol = 6 "Distance between two boreholes"
//     annotation(Dialog(tab="Borefield"));
//   final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
//     "Number of boreholes in x-direction"
//     annotation(Dialog(tab="Borefield"));
//   final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
//     "Number of boreholes in y-direction"
//     annotation(Dialog(tab="Borefield"));
//   final parameter Integer nBorHol = nXBorHol*nYBorHol "Number of boreholes"
//     annotation(Dialog(tab="Borefield"));

  Boolean toughSuccess;
  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W") "Heat extracted from soil"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_single(final unit="W") "Heat extracted from soilConnector of Real output signal"
                                      annotation (Placement(transformation(
          extent={{100,90},{120,110}}), iconTransformation(extent={{100,90},{
            120,110}})));
  Modelica.Blocks.Interfaces.RealOutput pInt[10]
    "Pressure of the interested points" annotation (Placement(transformation(
          extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-50},{
            120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput xInt[10]
    "Satuation of the interested points" annotation (Placement(transformation(
          extent={{100,-82},{120,-62}}), iconTransformation(extent={{100,-70},{
            120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TInt[10]
    "Temperature at the interested points" annotation (Placement(transformation(
          extent={{100,-100},{120,-80}}), iconTransformation(extent={{100,-90},
            {120,-70}})));
protected
  Modelica.Blocks.Math.Sum QTotSeg_flow(final nin=nSeg, final k=ones(nSeg))
    "Total heat flow rate for all segments of this borehole"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Gain gaiQ_flow(k=borFieDat.conDat.nBor)
    "Gain to multiply the heat extracted by one borehole by the number of boreholes"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

initial equation
   pre(toughSuccess)=true;

equation
  if (toughRes.yCheTou > 0.5) then
    toughSuccess=true;
  else
    toughSuccess=false;
  end if;
   if (time >= 5) then
     assert(toughSuccess, "TOUGH simulation did not finish successfully!", AssertionLevel.error);
   end if;
  connect(QBorHol.Q_flow, QTotSeg_flow.u) annotation (Line(points={{-10,-10},{-60,
          -10},{-60,80},{-42,80}}, color={0,0,127}));
  connect(QTotSeg_flow.y, gaiQ_flow.u)
    annotation (Line(points={{-19,80},{18,80}}, color={0,0,127}));
  connect(gaiQ_flow.y, Q_flow)
    annotation (Line(points={{41,80},{110,80}}, color={0,0,127}));
  connect(QTotSeg_flow.y, Q_flow_single) annotation (Line(points={{-19,80},{0,
          80},{0,100},{110,100}}, color={0,0,127}));
  connect(toughRes.pInt, pInt) annotation (Line(points={{29,54},{36,54},{36,-60},
          {110,-60}}, color={0,0,127}));
  connect(toughRes.xInt, xInt) annotation (Line(points={{29,50},{36,50},{36,-72},
          {110,-72}}, color={0,0,127}));
  connect(toughRes.TInt, TInt) annotation (Line(points={{29,46},{36,46},{36,-90},
          {110,-90}}, color={0,0,127}));
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
</html>"),
    experiment(
      StopTime=7200,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end OneUTubeWithTough;
