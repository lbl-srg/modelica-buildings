within Buildings.Rooms.BaseClasses.Examples;
model InfraredRadiationExchange "Test model for infrared radiation exchange"
  extends Modelica.Icons.Example;
  extends
    Buildings.Rooms.BaseClasses.Examples.BaseClasses.PartialInfraredRadiation;
  Buildings.Rooms.BaseClasses.InfraredRadiationExchange irRadExc(
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
    linearizeRadiation=true)
    "Distribution for infrared radiative heat transfer"
    annotation (Placement(transformation(extent={{-30,0},{10,40}})));
  Buildings.HeatTransfer.Radiosity.Constant radSou[NConExtWin](each k=187)
    "Radiosity source for window"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
equation
  connect(conConExt.port_a, irRadExc.conExt)     annotation (Line(
      points={{40,90},{30,90},{30,38.3333},{10,38.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.port_a, irRadExc.conExtWin)     annotation (Line(
      points={{40,60},{30,60},{30,35},{10,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWinFra.port_a, irRadExc.conExtWinFra)     annotation (Line(
      points={{40,30},{30,30},{30,20},{10.1667,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.port_a, irRadExc.conPar_a)     annotation (Line(
      points={{40,0},{32,0},{32,15},{10.1667,15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.port_a, irRadExc.conPar_b)     annotation (Line(
      points={{40,-30},{30,-30},{30,11.6667},{10.1667,11.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.port_a, irRadExc.conBou)     annotation (Line(
      points={{40,-60},{28,-60},{28,6.66667},{10.1667,6.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.port_a, irRadExc.conSurBou)     annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{10.0833,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSou.JOut, irRadExc.JInConExtWin)     annotation (Line(
      points={{-59,80},{20,80},{20,26.6667},{10.8333,26.6667}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/InfraredRadiationExchange.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-160,-220},{120,120}})),
    Documentation(info="<html>
<p>
Test model for the infrared radiation exchange.
</p>
</html>"));
end InfraredRadiationExchange;
