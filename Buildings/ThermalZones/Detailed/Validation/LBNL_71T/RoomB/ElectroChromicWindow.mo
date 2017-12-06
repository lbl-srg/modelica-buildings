within Buildings.ThermalZones.Detailed.Validation.LBNL_71T.RoomB;
model ElectroChromicWindow
  "Validation model for the correct implementation of Electrochromic Window"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.Temperature T_start=273.15 + 24 "Initial value";

  parameter Integer nConExtWin=1 "Number of constructions with a window";
  parameter Integer nConExt=0 "Number of constructions without a window";
  parameter Integer nConBou=5
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou=0
    "Number of surface that are connected to the room air volume";
  parameter Integer nConPar=0 "Number of surface that are partitions";

  MixedAir roo(
    redeclare package Medium = MediumA,
    nConExt=nConExt,
    nConExtWin=nConExtWin,
    nConPar=nConPar,
    nConBou=nConBou,
    nSurBou=nSurBou,
    T_start=T_start,
    datConExtWin(
      layers={matExtWal},
      each A=10.22,
      glaSys={glaSys},
      each hWin=3.13,
      each wWin=2.782751,
      each fFra=0.000001,
      each til=Buildings.Types.Tilt.Wall,
      azi={Buildings.Types.Azimuth.S}),
    datConBou(
      layers={matFlo,matCeil,matEWWal,matNWal,matEWWal},
      A={13.94,13.94,15.33,10.22,15.33},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    AFlo=13.94,
    hRoo=3.37,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    each conBou(opa(T(each start = T_start))),
    lat=0.65484753534827,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                               "Room model"
    annotation (Placement(transformation(extent={{62,-16},{102,24}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    relHum=0,
    TDewPoi(displayUnit="K"),
    filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.File,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{140,104},{160,124}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-44,54},{-24,74}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    "Signal replicator"
    annotation (Placement(transformation(extent={{-4,54},{16,74}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matExtWal(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.000701,
        k=45.345,
        c=502.416,
        d=7833.028),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0127,
        k=0.12,
        c=1210,
        d=540),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84)}) "71T: South Wall"
    annotation (Placement(transformation(extent={{-20,106},{0,126}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matCeil(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009525,
        k=0.12,
        c=1210,
        d=540),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800)}) "71T: Ceiling"
    annotation (Placement(transformation(extent={{36,106},{56,126}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matFlo(
    final nLay=4,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=5.28,
        k=1,
        c=0,
        d=0),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.01905,
        k=0.15,
        c=1630,
        d=608),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.01905,
        k=0.12,
        c=1210,
        d=540),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.22,
        k=1,
        c=0,
        d=0)}) "71T: Floor"
    annotation (Placement(transformation(extent={{60,106},{80,126}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matEWWal(
    final nLay=2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800)}) "71T: East West Wall"
    annotation (Placement(transformation(extent={{10,106},{30,126}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matNWal(
    final nLay=4,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009525,
        k=0.12,
        c=1210,
        d=540),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800)}) "71T: North Wall"
    annotation (Placement(transformation(extent={{86,106},{106,126}})));

  parameter HeatTransfer.Data.GlazingSystems.DoubleElectrochromicAir13Clear glaSys(
    UFra=2,
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-48,106},{-28,126}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{130,10},{154,34}}), iconTransformation(extent={
            {-116,36},{-96,56}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1 "Multiplex"
    annotation (Placement(transformation(extent={{-56,-26},{-36,-6}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-94,16},{-74,36}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-96,-26},{-76,-6}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-96,-66},{-76,-46}})));
  Modelica.Blocks.Sources.Constant uWin(k=1)
    "Control signal for electrochromic window"
    annotation (Placement(transformation(extent={{-10,6},{10,26}})));
  Modelica.Blocks.Sources.CombiTimeTable refRes(
    tableOnFile=true,
    tableName="EnergyPlus",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Rooms/Validation/LBNL_71T/RoomB/EnergyPlusHeatingCoolingPower.txt"),
    columns=2:2)
    "Data reader with heating and cooling power from EnergyPlus. The output should be compared to roo.heaPorAir.Q_flow."
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(transformation(extent={{36,-102},{60,-78}})));
  Controls.Continuous.LimPID           conHea(
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=-1,
    k=5,
    Ti=30) "Controller for heating"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Math.Gain gaiHea(k=1E4) "Gain for heating"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=297.15) "Set point for room air"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-23,64},{-6,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{60.4,22},{40,22},{40,64},{17,64}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaBus, roo.weaBus) annotation (Line(
      points={{142,22},{136,22},{136,21.9},{99.9,21.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, weaDat1.weaBus) annotation (Line(
      points={{142,22},{142,20},{196,20},{196,114},{160,114}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(qRadGai_flow.y, multiplex3_1.u1[1]) annotation (Line(points={{-73,26},
          {-68,26},{-68,-9},{-58,-9}},          color={0,0,127}));
  connect(qConGai_flow.y, multiplex3_1.u2[1])
    annotation (Line(points={{-75,-16},{-66.5,-16},{-58,-16}},
                                                            color={0,0,127}));
  connect(qLatGai_flow.y, multiplex3_1.u3[1]) annotation (Line(points={{-75,-56},
          {-72,-56},{-72,-26},{-58,-26},{-58,-23}},
                                                 color={0,0,127}));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(points={{-35,-16},{
          -35,-16},{38,-16},{38,12},{60.4,12}},
                                        color={0,0,127}));
  connect(uWin.y, roo.uWin[1]) annotation (Line(points={{11,16},{34,16},{34,17},
          {60.4,17}}, color={0,0,127}));
  connect(preHea.port, roo.heaPorAir) annotation (Line(points={{60,-90},{72,-90},
          {72,-58},{72,4},{81,4}}, color={191,0,0}));
  connect(gaiHea.y, preHea.Q_flow)
    annotation (Line(points={{21,-90},{36,-90}}, color={0,0,127}));
  connect(conHea.y, gaiHea.u)
    annotation (Line(points={{-19,-90},{-2,-90}}, color={0,0,127}));
  connect(TRooSet.y, conHea.u_s)
    annotation (Line(points={{-59,-90},{-50,-90},{-42,-90}}, color={0,0,127}));
  connect(preHea.port, TRooAir.port)
    annotation (Line(points={{60,-90},{80,-90},{80,-90}}, color={191,0,0}));
  connect(TRooAir.T, conHea.u_m) annotation (Line(points={{100,-90},{110,-90},{
          110,-112},{-30,-112},{-30,-102}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{
            220,160}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/LBNL_71T/RoomB/ElectroChromicWindow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This model tests the correct implementation of electrochromic window.
The model represents the middle test cell (RoomB) of the window test facility 71T.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
Updated example to avoid dynamically selected states and overspecified initial conditions.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/605\">#605</a>.
</li>
<li>
November 21, 2016, by Michael Wetter:<br/>
Removed unused block <code>Infiltration</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/582\">#582</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
<code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
August 07, 2015, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=604800));
end ElectroChromicWindow;
