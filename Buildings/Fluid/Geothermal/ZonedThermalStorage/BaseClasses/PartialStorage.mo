within Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses;
partial model PartialStorage
  "Partial model for borehole thermal energy storage with independent borefield zones"
  extends
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces.PartialTwoNPortsInterface(
    final nPorts=nZon,
    final m_flow_nominal=borFieDat.conDat.mZon_flow_nominal);
  extends
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces.TwoNPortsFlowResistanceParameters(
    final nPorts=nZon,
    final dp_nominal=borFieDat.conDat.dp_nominal,
    final computeFlowResistance={_dp_nominal > Modelica.Constants.eps for _dp_nominal in borFieDat.conDat.dp_nominal});

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the borehole pipes"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  // Simulation parameters
  parameter Modelica.Units.SI.Time tLoaAgg = 3600.0
    "Time resolution of load aggregation";
  parameter Integer nCel(min=1) = 5
    "Number of cells per aggregation level";
  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material"
    annotation (Dialog(tab="Dynamics"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  // Temperature gradient in undisturbed soil
  parameter Modelica.Units.SI.Temperature TExt0_start=283.15
    "Initial far field temperature"
    annotation (Dialog(tab="Initialization", group="Soil"));
  parameter Modelica.Units.SI.Temperature TExt_start[nSeg]=
    {if z[i] >= z0 then TExt0_start + (z[i] - z0)*dT_dz else TExt0_start for i in 1:nSeg}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Initialization", group="Soil"));
  parameter Modelica.Units.SI.Temperature TGro_start[nSeg]=TExt_start
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization", group="Filling material"));
  parameter Modelica.Units.SI.Temperature TFlu_start[nSeg]=TGro_start
    "Start value of fluid temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Height z0=10
    "Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));
  parameter Real dT_dz(final unit="K/m", min=0) = 0.01
    "Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));

  // General parameters of borefield
  parameter Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Borefield.Template borFieDat
    "Borefield data record"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-80,-80},{-60,-60}})));
  final parameter Integer nZon(min=1) = borFieDat.conDat.nZon
    "Total number of independent bore field zones";
  final parameter Integer[nZon] nBorPerZon(min=1) = borFieDat.conDat.nBorPerZon
    "Number of boreholes per borefield zone";

  // Models
  replaceable
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole
    borHol[nZon] constrainedby
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole(
    redeclare each final package Medium = Medium,
    final borFieDat=zonDat,
    each final nSeg=nSeg,
    final m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    final dp_nominal=dp_nominal,
    each final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    each final show_T=show_T,
    final computeFlowResistance=computeFlowResistance,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final mSenFac=mSenFac,
    each final dynFil=dynFil,
    each final TFlu_start=TFlu_start,
    each final TGro_start=TGro_start) "Borehole"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.GroundTemperatureResponse groTemRes(
    final tLoaAgg=tLoaAgg,
    final nCel=nCel,
    final nSeg=nSeg,
    final borFieDat=borFieDat) "Ground thermal response"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Modelica.Blocks.Interfaces.RealOutput TBorAve[nZon](
    each quantity="ThermodynamicTemperature",
    each unit="K",
    each displayUnit="degC",
    each start=TExt0_start)
    "Average borehole wall temperature in the borefield"
    annotation (Placement(transformation(extent={{100,34},{120,54}})));

  Modelica.Blocks.Interfaces.RealOutput QBorAve[nZon](
    each quantity="HeatFlowRate",
    each unit="W") "Average (per borehole) heat transfer rate in each zone"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

protected
  constant Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the volume";

  parameter Modelica.Units.SI.Height z[nSeg]={borFieDat.conDat.hBor/nSeg*(i - 0.5) for i in 1:nSeg}
    "Distance from the surface to the considered segment";

  // General parameters of the boreholes. These records are required because
  // the borehole model expects a configuration record from the
  // Buildings.Fluid.Geothermal.Borefields that is different from the record in
  // the Buildings.Fluid.Geothermal.ZonedThermalStorage package.
  final parameter Borefields.Data.Borefield.Template zonDat[nZon](
    each filDat=borFieDat.filDat,
    each soiDat=borFieDat.soiDat,
    conDat=zonConDat) "Data record for the boreholes"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  final parameter Borefields.Data.Configuration.Template zonConDat[nZon](
    each borCon=borFieDat.conDat.borCon,
    each use_Rb=borFieDat.conDat.use_Rb,
    each Rb=borFieDat.conDat.Rb,
    mBor_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    mBorFie_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    dp_nominal=borFieDat.conDat.dp_nominal,
    each hBor=borFieDat.conDat.hBor,
    each rBor=borFieDat.conDat.rBor,
    each dBor=borFieDat.conDat.dBor,
    nBor=borFieDat.conDat.nBorPerZon,
    each cooBor=borFieDat.conDat.cooBor,
    each rTub=borFieDat.conDat.rTub,
    each kTub=borFieDat.conDat.kTub,
    each eTub=borFieDat.conDat.eTub,
    each xC=borFieDat.conDat.xC,
    mBor_flow_small=borFieDat.conDat.mBor_flow_small)
    "Configuration data record for each borehole zone"
    annotation (Placement(transformation(extent={{62,-80},{82,-60}})));

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloDiv[nZon](
    redeclare final package Medium = Medium,
    final k=nBorPerZon) "Division of flow rate"
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloMul[nZon](
    redeclare final package Medium = Medium,
    final k=nBorPerZon) "Mass flow multiplier"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Modelica.Blocks.Sources.Constant TSoiUnd[nSeg](
    k = TExt_start,
    y(each unit="K",
      each displayUnit="degC"))
    "Undisturbed soil temperature"
    annotation (Placement(transformation(extent={{-56,14},{-36,34}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QBorHol[nZon,nSeg]
    "Heat flow rate of all segments of all boreholes"
                                                     annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-10})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TemBorWal[nZon,nSeg]
    "Borewall temperature at each segment"
    annotation (Placement(transformation(extent={{50,6},{70,26}})));

  Modelica.Blocks.Math.Add TSoiDisl[nZon,nSeg](each final k1=1, each final k2=1)
    "Addition of undisturbed soil temperature and change of soil temperature"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  Modelica.Blocks.Routing.Replicator repTSoiUnd[nSeg](each final nout=nZon)
    "Signal replicator for temperature difference of the borehole"
    annotation (Placement(transformation(extent={{-28,14},{-8,34}})));
  Buildings.Utilities.Math.Average aveTBor[nZon](each final nin=nSeg)
    "Average temperature of all the borehole segments in each zone"
    annotation (Placement(transformation(extent={{50,34},{70,54}})));
  Modelica.Blocks.Math.Sum aveQBor[nZon](each nin=nSeg)
    "Average (per borehole) heat transfer rate, equal to the sum of the heat transfer rates att all segments along a borehole"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));

equation

  connect(borHol.port_wall, QBorHol.port_a) annotation (Line(points={{0,-30},{0,
          -25},{-6.10623e-16,-25},{-6.10623e-16,-20}}, color={191,0,0}));
  connect(TemBorWal.port, QBorHol.port_b) annotation (Line(points={{70,16},{80,
          16},{80,4},{0,4},{0,0}}, color={191,0,0}));
  connect(QBorHol.Q_flow, groTemRes.QBor_flow) annotation (Line(points={{-11,-10},
          {-60,-10},{-60,80},{-41,80}},color={0,0,127}));
  connect(TSoiUnd.y, repTSoiUnd.u)
    annotation (Line(points={{-35,24},{-30,24}}, color={0,0,127}));
  for i in 1:nZon loop
    for j in 1:nSeg loop
      connect(repTSoiUnd[j].y[i], TSoiDisl[i,j].u2) annotation (Line(points={{-7,24},{8,24}}, color={0,0,127}));
    end for;
  end for;
  connect(groTemRes.delTBor, TSoiDisl.u1) annotation (Line(points={{-19,80},{0,
          80},{0,36},{8,36}},            color={0,0,127}));
  connect(TSoiDisl.y, TemBorWal.T) annotation (Line(points={{31,30},{42,30},{42,
          16},{48,16}}, color={0,0,127}));
  connect(TSoiDisl.y, aveTBor.u) annotation (Line(points={{31,30},{42,30},{42,44},
          {48,44}}, color={0,0,127}));
  connect(aveTBor.y, TBorAve)
    annotation (Line(points={{71,44},{110,44}}, color={0,0,127}));
  connect(port_a, masFloDiv.port_b) annotation (Line(points={{-100,0},{-86,0},{-86,
          -40},{-80,-40}}, color={0,127,255}));
  connect(masFloDiv.port_a, borHol.port_a)
    annotation (Line(points={{-60,-40},{-10,-40}}, color={0,127,255}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{10,-40},{60,-40}}, color={0,127,255}));
  connect(masFloMul.port_b, port_b) annotation (Line(points={{80,-40},{86,-40},{
          86,0},{100,0}}, color={0,127,255}));
  connect(aveQBor.y, QBorAve)
    annotation (Line(points={{71,80},{110,80}}, color={0,0,127}));
  connect(QBorHol.Q_flow, aveQBor.u) annotation (Line(points={{-11,-10},{-60,-10},
          {-60,96},{40,96},{40,80},{48,80}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),Documentation(info="<html>
<p>
This model simulates a borehole thermal energy storage system with multiple
zones of boreholes. Boreholes within the same zone are connected
in parallel. The borefield configuration and thermal parameters are defined in
the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using one borehole heat exchanger
(To be added in an extended model) per borefield zone. The
fluid mass flow rate into each borehole is divided to reflect the per-borehole
fluid mass flow rate. The borehole model calculates the dynamics within the
borehole itself using an axial discretization and a resistance-capacitance
network for the internal thermal resistances between the individual pipes and
between each pipe and the borehole wall.
</p>
<p>
The ground thermal response at each borehole segment is evaluated using
analytical thermal response factors. Spatial and temporal superposition are used
to evaluate the total temperature change at each of the borehole segments.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialStorage;
