within Buildings.Rooms.Validation.LBNL_71T.RoomB;
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
    linearizeRadiation=false,
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.65484753534827,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "Room model"
    annotation (Placement(transformation(extent={{62,-16},{102,24}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    relHum=0,
    TDewPoi(displayUnit="K"),
    filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.File,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
    annotation (Placement(transformation(extent={{140,104},{160,124}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-44,54},{-24,74}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
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

  // Fixme: The frame ratio and U value has not yet been updated.
  parameter HeatTransfer.Data.GlazingSystems.DoubleElectrochromicAir13Clear glaSys(
    UFra=2,
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-48,106},{-28,126}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{130,10},{154,34}}), iconTransformation(extent={
            {-116,36},{-96,56}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-56,-26},{-36,-6}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-94,16},{-74,36}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-96,-26},{-76,-6}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-96,-66},{-76,-46}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature preTem(T=297.15)
    "Prescribed room air temperature"
    annotation (Placement(transformation(extent={{8,-72},{28,-52}})));
  block Infiltration
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.VolumeFlowRate V_flow
      "Infiltration flow rate at current outdoor air density";
    parameter Real A "Constant term coefficient";
    parameter Real B(unit="1/K") "Temperature term coefficient";
    parameter Real C(unit="s/m") "Velocity term coefficient";

    BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
             {{-120,-20},{-80,20}})));
    Modelica.Blocks.Interfaces.RealOutput m_flow "Infiltration mass flow rate"
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));

    Modelica.Blocks.Interfaces.RealInput TRoo(unit="K") "Room air temperature"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

    Modelica.Blocks.Math.Add dT(k2=-1) "Temperature difference"
      annotation (Placement(transformation(extent={{-60,-72},{-40,-52}})));
    Modelica.Blocks.Math.Product m "Mass flow rate"
      annotation (Placement(transformation(extent={{-8,40},{12,60}})));
    Modelica.Blocks.Sources.Constant V(k=V_flow) "Volume flow rate"
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Utilities.Psychrometrics.Density_pTX rho "Density"
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=true)
      annotation (Placement(transformation(extent={{-72,-42},{-52,-22}})));
    Modelica.Blocks.Math.Abs dTAbs "Temperature difference"
      annotation (Placement(transformation(extent={{-30,-72},{-10,-52}})));
    Modelica.Blocks.Sources.Constant ACoef(k=A) "Constant coefficient"
      annotation (Placement(transformation(extent={{12,-40},{32,-20}})));
    Modelica.Blocks.Math.Gain gainB(k=B)
      "Gain for temperature dependent effect"
      annotation (Placement(transformation(extent={{12,-72},{32,-52}})));
    Modelica.Blocks.Math.Gain gainC(k=C) "Gain for wind dependent effect"
      annotation (Placement(transformation(extent={{12,-100},{32,-80}})));
    Modelica.Blocks.Math.Add3 add3_1
      annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
    Modelica.Blocks.Math.Product mAct_flow "Mass flow rate"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Math.Gain ter(k=(270/10)^0.14*((3.35/2)/370)^0.22)
      "Wind speed correction for terrain and zone height"
      annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  equation
    connect(m.u1, V.y) annotation (Line(points={{-10,56},{-50,56},{-50,80},{-59,
            80}}, color={0,0,127}));
    connect(rho.T, weaBus.TDryBul) annotation (Line(points={{-41,18},{-80,18},{
            -80,0},{-100,0}}, color={0,0,127}));
    connect(x_pTphi.p_in, weaBus.pAtm) annotation (Line(points={{-74,-26},{-84,
            -26},{-84,0},{-100,0}}, color={0,0,127}));
    connect(x_pTphi.T, weaBus.TDryBul) annotation (Line(points={{-74,-32},{-84,
            -32},{-84,0},{-100,0}}, color={0,0,127}));
    connect(x_pTphi.phi, weaBus.relHum) annotation (Line(points={{-74,-38},{-84,
            -38},{-84,0},{-100,0}}, color={0,0,127}));
    connect(rho.X_w, x_pTphi.X[1]) annotation (Line(points={{-41,10},{-48,10},{
            -48,-32},{-51,-32}}, color={0,0,127}));
    connect(rho.p, weaBus.pAtm) annotation (Line(points={{-41,2},{-68,2},{-68,0},
            {-100,0}}, color={0,0,127}));
    connect(rho.d, m.u2) annotation (Line(points={{-19,10},{-14,10},{-14,44},{
            -10,44}}, color={0,0,127}));
    connect(dT.u1, TRoo) annotation (Line(points={{-62,-56},{-62,-56},{-82,-56},
            {-84,-56},{-84,60},{-120,60}}, color={0,0,127}));
    connect(dT.u2, weaBus.TDryBul) annotation (Line(points={{-62,-68},{-84,-68},
            {-84,0},{-100,0}}, color={0,0,127}));
    connect(dT.y, dTAbs.u) annotation (Line(points={{-39,-62},{-35.5,-62},{-32,
            -62}}, color={0,0,127}));
    connect(gainB.u, dTAbs.y)
      annotation (Line(points={{10,-62},{-9,-62}}, color={0,0,127}));
    connect(add3_1.u1, ACoef.y) annotation (Line(points={{58,-52},{46,-52},{46,
            -30},{33,-30}}, color={0,0,127}));
    connect(add3_1.u2, gainB.y) annotation (Line(points={{58,-60},{46,-60},{46,
            -62},{33,-62}}, color={0,0,127}));
    connect(add3_1.u3, gainC.y) annotation (Line(points={{58,-68},{46,-68},{46,
            -90},{33,-90}}, color={0,0,127}));
    connect(mAct_flow.y, m_flow)
      annotation (Line(points={{81,0},{81,0},{110,0}}, color={0,0,127}));
    connect(add3_1.y, mAct_flow.u2) annotation (Line(points={{81,-60},{90,-60},
            {90,-20},{50,-20},{50,-6},{50,-6},{58,-6}}, color={0,0,127}));
    connect(m.y, mAct_flow.u1) annotation (Line(points={{13,50},{30,50},{30,6},
            {58,6}}, color={0,0,127}));
    connect(ter.y, gainC.u)
      annotation (Line(points={{-19,-90},{10,-90}}, color={0,0,127}));
    connect(ter.u, weaBus.winSpe) annotation (Line(points={{-42,-90},{-100,-90},
            {-100,0}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})));
  end Infiltration;
  Modelica.Blocks.Sources.Constant uWin(k=1)
    "Control signal for electrochromic window"
    annotation (Placement(transformation(extent={{4,14},{24,34}})));
  Modelica.Blocks.Sources.CombiTimeTable refRes(
    tableOnFile=true,
    tableName="EnergyPlus",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Rooms/Validation/LBNL_71T/RoomB/EnergyPlusHeatingCoolingPower.txt"),
    columns=2:2)
    "Data reader with heating and cooling power from EnergyPlus. The output should be compared to roo.heaPorAir.Q_flow."
    annotation (Placement(transformation(extent={{8,-108},{28,-88}})));

equation
  for i in 2:nConBou loop
  end for;

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-23,64},{-6,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{60.4,22},{60.4,64},{17,64}},
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
  connect(roo.heaPorAir, preTem.port) annotation (Line(points={{81,4},{81,-62},
          {78,-62},{28,-62}},             color={191,0,0}));
  connect(uWin.y, roo.uWin[1]) annotation (Line(points={{25,24},{42,24},{42,17},
          {60.4,17}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{
            220,160}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/LBNL_71T/RoomB/ElectroChromicWindow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This model tests the correct implementation of electrochromic window. <span style=\"font-family: Sans Serif;\">This model represents the middle test cell (RoomB) of the window test facility 71T.</span></p>
</html>", revisions="<html>
<ul>
<li>
August 07, 2015, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=604800));
end ElectroChromicWindow;
