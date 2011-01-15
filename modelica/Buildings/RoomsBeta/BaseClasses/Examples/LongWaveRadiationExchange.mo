within Buildings.RoomsBeta.BaseClasses.Examples;
model LongWaveRadiationExchange "Test model for long-wave radiation exchange"
  extends
    Buildings.RoomsBeta.BaseClasses.Examples.BaseClasses.PartialLongWaveRadiation;
  import Buildings;

  Buildings.RoomsBeta.BaseClasses.LongWaveRadiationExchange lonWavRadGai(
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
    each epsSurBou={0.5 for i in 1:NConExtWin},
    linearizeRadiation = true )
    "Distribution for long wave radiative heat gains (e.g., due to equipment and people)"
    annotation (Placement(transformation(extent={{-30,0},{10,40}})));
  Buildings.HeatTransfer.Radiosity.Constant radSou[NConExtWin](each k=-10)
    "Radiosity source for window"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

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
  connect(conSurBou.port_a, lonWavRadGai.conSurBou) annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{10.0833,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radSou.JOut, lonWavRadGai.JInConExtWin) annotation (Line(
      points={{-59,80},{20,80},{20,26.6667},{10.8333,26.6667}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="LongWaveRadiationExchange.mos" "run"));
end LongWaveRadiationExchange;
