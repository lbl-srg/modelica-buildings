within Buildings.Rooms.BaseClasses.Examples;
model InfraredRadiationGainDistribution
  "Test model for infrared radiation gain"
  extends Modelica.Icons.Example;
  extends
    Buildings.Rooms.BaseClasses.Examples.BaseClasses.PartialInfraredRadiation;
  Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution irRadGai(
    nConExt=nConExt,
    nConExtWin=nConExtWin,
    nConPar=nConPar,
    nConBou=nConBou,
    nSurBou=nSurBou,
    final datConExt=datConExt,
    final datConExtWin=datConExtWin,
    final datConPar=datConPar,
    final datConBou=datConBou,
    final surBou=surBou,
    haveShade=true)
    "Distribution for infrared radiative heat gains (e.g., due to equipment and people)"
    annotation (Placement(transformation(extent={{-30,0},{10,40}})));
protected
  Modelica.Blocks.Sources.Constant QRad_flow(k=1) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant zer[NConExtWin](each k=0)
    "Outputs zero. This block is needed to send a signal to the shading connector if no window is used in the room model"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(conConExt.port_a, irRadGai.conExt)     annotation (Line(
      points={{40,90},{30,90},{30,38.3333},{10,38.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.port_a, irRadGai.conExtWin)     annotation (Line(
      points={{40,60},{30,60},{30,35},{10,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWinFra.port_a, irRadGai.conExtWinFra)     annotation (Line(
      points={{40,30},{30,30},{30,20},{10.1667,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.port_a, irRadGai.conPar_a)     annotation (Line(
      points={{40,0},{32,0},{32,15},{10.1667,15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.port_a, irRadGai.conPar_b)     annotation (Line(
      points={{40,-30},{30,-30},{30,11.6667},{10.1667,11.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.port_a, irRadGai.conBou)     annotation (Line(
      points={{40,-60},{28,-60},{28,6.66667},{10.1667,6.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.port_a, irRadGai.conSurBou)     annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{10.0833,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QRad_flow.y, irRadGai.Q_flow)     annotation (Line(
      points={{-59,10},{-40,10},{-40,20},{-31.6667,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, irRadGai.uSha)     annotation (Line(
      points={{-59,50},{-40,50},{-40,35},{-31.6667,35}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/InfraredRadiationGainDistribution.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(extent={{-160,-220},{120,120}})),
    Documentation(info="<html>
<p>
Test model for the distribution of the infrared radiation heat gain.
</p>
</html>"));
end InfraredRadiationGainDistribution;
