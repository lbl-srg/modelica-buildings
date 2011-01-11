within Buildings.RoomsBeta.BaseClasses.Examples;
model LongWaveRadiationGainDistribution
  "Test model for long-wave radiation gain"
  extends
    Buildings.RoomsBeta.BaseClasses.Examples.BaseClasses.PartialLongWaveRadiation;
  import Buildings;

  Buildings.RoomsBeta.BaseClasses.LongWaveRadiationGainDistribution lonWavRadGai(
    nConExt=nConExt,
    nConExtWin=nConExtWin,
    nConPar=nConPar,
    nConBou=nConBou,
    nSurBou=nSurBou,
    each AConExt={1 for i in 1:NConExt},
    each AConExtWinOpa={1 for i in 1:NConExtWin},
    each AConExtWinGla={1 for i in 1:NConExtWin},
    each AConExtWinFra={1 for i in 1:NConExtWin},
    each AConPar={1 for i in 1:NConPar},
    each AConBou={1 for i in 1:NConBou},
    each ASurBou={1 for i in 1:NSurBou},
    each epsConExt={0.5 for i in 1:NConExtWin},
    each epsConExtWinOpa={0.5 for i in 1:NConExtWin},
    each epsConExtWinUns={0.5 for i in 1:NConExtWin},
    each epsConExtWinSha={0.5 for i in 1:NConExtWin},
    each epsConExtWinFra={0.5 for i in 1:NConExtWin},
    each epsConPar_a={0.5 for i in 1:NConExtWin},
    each epsConPar_b={0.5 for i in 1:NConExtWin},
    each epsConBou={0.5 for i in 1:NConExtWin},
    each epsSurBou={0.5 for i in 1:NConExtWin})
    "Distribution for long wave radiative heat gains (e.g., due to equipment and people)"
    annotation (Placement(transformation(extent={{-30,0},{10,40}})));
protected
  Modelica.Blocks.Sources.Constant QRad_flow(k=1) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Modelica.Blocks.Sources.Constant zer[NConExtWin](each k=0)
    "Outputs zero. This block is needed to send a signal to the shading connector if no window is used in the room model"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(conConExt.port_a, lonWavRadGai.conExt) annotation (Line(
      points={{40,90},{30,90},{30,38.3333},{10,38.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.port_a, lonWavRadGai.conExtWin) annotation (Line(
      points={{40,60},{30,60},{30,35},{10,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWinFra.port_a, lonWavRadGai.conExtWinFra) annotation (Line(
      points={{40,30},{30,30},{30,20},{10.1667,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.port_a, lonWavRadGai.conPar_a) annotation (Line(
      points={{40,6.10623e-16},{32,6.10623e-16},{32,15},{10.1667,15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.port_a, lonWavRadGai.conPar_b) annotation (Line(
      points={{40,-30},{30,-30},{30,11.6667},{10.1667,11.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.port_a, lonWavRadGai.conBou) annotation (Line(
      points={{40,-60},{28,-60},{28,6.66667},{10.1667,6.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.port_a, lonWavRadGai.surBou) annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{10.0833,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(QRad_flow.y, lonWavRadGai.Q_flow) annotation (Line(
      points={{-59,10},{-40,10},{-40,20},{-31.6667,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, lonWavRadGai.uSha) annotation (Line(
      points={{-59,50},{-40,50},{-40,35},{-31.6667,35}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="LongWaveRadiationGainDistribution.mos" "run"));
end LongWaveRadiationGainDistribution;
