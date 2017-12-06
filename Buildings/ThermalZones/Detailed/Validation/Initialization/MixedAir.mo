within Buildings.ThermalZones.Detailed.Validation.Initialization;
model MixedAir
  "Validation model for the correct initialization of the mixed air model"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.Temperature T_start=273.15-15 "Initial value";

  parameter
    Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200
    matLayExt "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 matLayPar
    "Construction material for partition walls"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayRoo(
        material={
          HeatTransfer.Data.Solids.InsulationBoard(x=0.2),
          HeatTransfer.Data.Solids.Concrete(x=0.2)},
        final nLay=2) "Construction material for roof"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayFlo(
        material={
          HeatTransfer.Data.Solids.Concrete(x=0.2),
          HeatTransfer.Data.Solids.InsulationBoard(x=0.15),
          HeatTransfer.Data.Solids.Concrete(x=0.05)},
        final nLay=3) "Construction material for floor"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));

  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  parameter Integer nConExtWin = 1 "Number of constructions with a window";
  parameter Integer nConBou = 1
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou = 1
    "Number of surface that are connected to the room air volume";

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=2,
    datConExt(layers={matLayRoo, matLayExt},
           A={6*4, 6*3},
           til={Buildings.Types.Tilt.Ceiling, Buildings.Types.Tilt.Wall},
           azi={Buildings.Types.Azimuth.S, Buildings.Types.Azimuth.W}),
    nConExtWin=nConExtWin,
    datConExtWin(
              layers={matLayExt},
              each A=4*3,
              glaSys={glaSys},
              each hWin=2,
              each wWin=4,
              ove(wR={0},wL={0}, gap={0.1}, dep={1}),
              each fFra=0.1,
              each til=Buildings.Types.Tilt.Wall,
              azi={Buildings.Types.Azimuth.S}),
    nConPar=1,
    datConPar(layers={matLayPar}, each A=10,
           each til=Buildings.Types.Tilt.Wall),
    nConBou=1,
    datConBou(layers={matLayFlo}, each A=6*4,
           each til=Buildings.Types.Tilt.Floor),
    nSurBou=1,
    surBou(each A=6*3,
           each absIR=0.9,
           each absSol=0.9,
           each til=Buildings.Types.Tilt.Wall),
    linearizeRadiation = false,
    nPorts=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.73268921998722,
    T_start=T_start) "Room model"
    annotation (Placement(transformation(extent={{46,20},{86,60}})));

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-62,2},{-42,22}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    HSou=Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor,
    TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover,
    relHumSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    relHum=0,
    TDewPoi(displayUnit="K") = T_start,
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Input,
    TBlaSkySou=Buildings.BoundaryConditions.Types.DataSource.Input)
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1,nConExtWin))
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](each T=T_start)
    "Boundary condition for construction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,-10})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou[nSurBou](each T=T_start)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={150,-50})));
  HeatTransfer.Conduction.MultiLayer conOut[nSurBou](
    each A=6*4,
    each layers=matLayPar,
    each steadyStateInitial=true)
    "Construction that is modeled outside of room"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Fluid.Sources.FixedBoundary boundary(
    nPorts=1,
    redeclare package Medium = MediumA,
    T=T_start) "Boundary condition"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Modelica.Blocks.Sources.Constant HSol(k=0) "Solar irradition"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Modelica.Blocks.Sources.Constant T(k=T_start)
    "Dry bulb and black body sky temperature"
    annotation (Placement(transformation(extent={{130,150},{150,170}})));
equation
  connect(qRadGai_flow.y, multiplex3_1.u1[1])  annotation (Line(
      points={{-39,90},{-32,90},{-32,57},{-22,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(qLatGai_flow.y, multiplex3_1.u3[1])  annotation (Line(
      points={{-41,12},{-32,12},{-32,43},{-22,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{1,50},{22,50},{22,48},{44,48}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{180,150},{190,150},{190,57.9},{83.9,57.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(uSha.y, replicator.u) annotation (Line(
      points={{1,100},{8,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSoi.port, roo.surf_conBou)  annotation (Line(
      points={{100,-10},{72,-10},{72,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBou.port,conOut. port_b) annotation (Line(
      points={{140,-50},{120,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.surf_surBou, conOut.port_a) annotation (Line(
      points={{62.2,26},{62,26},{62,-50},{100,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{44,56},{40,56},{40,100},{31,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.ports[1], boundary.ports[1]) annotation (Line(
      points={{51,30},{34,30},{34,10},{20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HSol.y, weaDat.HGloHor_in) annotation (Line(
      points={{151,120},{154,120},{154,137},{159,137}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HSol.y, weaDat.HDifHor_in) annotation (Line(
      points={{151,120},{154,120},{154,142.4},{159,142.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T.y, weaDat.TDryBul_in) annotation (Line(
      points={{151,160},{154,160},{154,159},{159,159}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.TBlaSky_in, T.y) annotation (Line(
      points={{159,157},{155.5,157},{155.5,160},{151,160}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}})),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/Initialization/MixedAir.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the correct initialization of
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>.
The air temperature should start at <i>-15</i>&circ; C
and remain there.
</p>
<p>
Note that there are still very small heat flows even if all solar radiation
is set to zero and all boundary conditions and start values are set to
<i>-15</i>&circ; C.
The reasons are as follows:
</p>
<ul>
<li>
The block
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation</a>
avoids that the radiation becomes negative, which may happen due to the
smooth interpolation in the weather data reader.
To achieve this, it sets a minimum radiation of <i>0.0001</i> W/m<sup>2</sup>.
</li>
<li>
The model requires the numerical solution of nonlinear systems of equations
and of systems of ordinary differential equations.
These are of course only solved within the solver tolerance.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
October 29, 2016, by Michael Wetter:<br/>
Corrected error in the documentation.
</li>
<li>
March 26, 2015, by Michael Wetter:<br/>
First implementation based on
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.Initialization.MixedAir\">
Buildings.ThermalZones.Detailed.Examples.MixedAirInitialization</a>.
</li>
</ul>
</html>"),
    experiment(
      Tolerance=1e-06, StopTime=172800));
end MixedAir;
