within Buildings.Rooms.BaseClasses.Examples;
model RadiationTemperature "Test model for the radiation temperature"
  extends Modelica.Icons.Example;
  extends
    Buildings.Rooms.BaseClasses.Examples.BaseClasses.PartialInfraredRadiation(
    bouConExt(each T=289.15),
    bouConExtWin(each T=290.15),
    bouConExtWinFra(each T=285.15),
    bouConPar_b(each T=291.15),
    bouConBou(each T=295.15),
    bouSurBou(each T=296.15));

  Buildings.Rooms.BaseClasses.RadiationTemperature radTem(
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
    haveShade=true) "Radiative temperature"
    annotation (Placement(transformation(extent={{-60,0},{-20,40}})));

  Modelica.Blocks.Sources.Constant uSha[NConExtWin](each k=0.5)
    "Shade control signal"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conGlaUns[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conGlaSha[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conSha[NConExtWin](
      each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.HeatTransfer.Sources.FixedTemperature bouGlaUns[NConExtWin](each T=
        288.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-120})));
  Buildings.HeatTransfer.Sources.FixedTemperature bouGlaSha[NConExtWin](each T=
        284.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-150})));
  Buildings.HeatTransfer.Sources.FixedTemperature bouSha[NConExtWin](
      each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-180})));
equation
  connect(conConExt.port_a, radTem.conExt)       annotation (Line(
      points={{40,90},{30,90},{30,38.3333},{-20,38.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.port_a, radTem.conExtWin)       annotation (Line(
      points={{40,60},{30,60},{30,35},{-20,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWinFra.port_a, radTem.conExtWinFra)       annotation (Line(
      points={{40,30},{30,30},{30,20},{-19.8333,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.port_a, radTem.conPar_a)       annotation (Line(
      points={{40,6.10623e-16},{32,6.10623e-16},{32,15},{-19.8333,15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.port_a, radTem.conPar_b)       annotation (Line(
      points={{40,-30},{30,-30},{30,11.6667},{-19.8333,11.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.port_a, radTem.conBou)       annotation (Line(
      points={{40,-60},{28,-60},{28,6.66667},{-19.8333,6.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.port_a, radTem.conSurBou)       annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{-19.9167,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(uSha.y, radTem.uSha)       annotation (Line(
      points={{-99,30},{-66,30},{-66,35},{-61.6667,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouGlaUns.port, conGlaUns.port_b)     annotation (Line(
      points={{60,-120},{40,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouGlaSha.port, conGlaSha.port_b) annotation (Line(
      points={{60,-150},{40,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouSha.port, conSha.port_b)       annotation (Line(
      points={{60,-180},{40,-180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.glaUns, conGlaUns.port_a)       annotation (Line(
      points={{-20,30},{10,30},{10,-120},{20,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.glaSha, conGlaSha.port_a)       annotation (Line(
      points={{-20,26.6667},{-10,26.6667},{-10,26},{0,26},{0,-150},{20,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.sha, conSha.port_a)       annotation (Line(
      points={{-20,23.1667},{-10,23.1667},{-10,-180},{20,-180}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},
            {100,100}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/RadiationTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for the radiative temperature of the room.
</p>
</html>"));
end RadiationTemperature;
