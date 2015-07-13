within Buildings.Rooms.BaseClasses.Examples.BaseClasses;
model PartialInfraredRadiation
  "Partial model to test infrared radiation inside the room"
  extends Buildings.Rooms.BaseClasses.ConstructionRecords(
  nConExt=1,
  nConExtWin=1,
  nConPar=1,
  nConBou=1,
  nSurBou=1,
  datConExt(each A=1),
  datConBou(each A=1),
  datConExtWin(each A=1, each hWin=1, each wWin=0.5),
  surBou(each A=1),
  datConPar(each A=1));

protected
  Buildings.HeatTransfer.Sources.FixedTemperature bouConExt[NConExt](each T=293.15)
    "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,90})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConExt[NConExt](each G=
        100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConExtWin[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConExtWinFra[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConPar_a[NConPar](each G=
        100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConPar_b[NConPar](each G=
        100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conConBou[NConBou](each G=
        100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conSurBou[NSurBou](each G=
        100) "Heat conductor"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
protected
  Buildings.HeatTransfer.Sources.FixedTemperature bouConExtWin[
    NConExtWin](each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,60})));

  Buildings.HeatTransfer.Sources.FixedTemperature bouConExtWinFra[
    NConExtWin](each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));

  Buildings.HeatTransfer.Sources.FixedTemperature bouConPar_a[NConPar](each T=
       293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));

  Buildings.HeatTransfer.Sources.FixedTemperature bouConPar_b[NConPar](each T=
       293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-30})));

  Buildings.HeatTransfer.Sources.FixedTemperature bouConBou[NConBou](each T=293.15)
    "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-60})));

  Buildings.HeatTransfer.Sources.FixedTemperature bouSurBou[NSurBou](each T=293.15)
    "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-90})));
equation
  connect(bouConExt.port, conConExt.port_b) annotation (Line(
      points={{80,90},{60,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExtWin.port, conConExtWin.port_b) annotation (Line(
      points={{80,60},{60,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExtWinFra.port, conConExtWinFra.port_b) annotation (Line(
      points={{80,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConPar_a.port, conConPar_a.port_b) annotation (Line(
      points={{80,1.72421e-15},{70,1.72421e-15},{70,6.10623e-16},{60,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(bouConPar_b.port, conConPar_b.port_b) annotation (Line(
      points={{80,-30},{60,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConBou.port, conConBou.port_b) annotation (Line(
      points={{80,-60},{60,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouSurBou.port, conSurBou.port_b) annotation (Line(
      points={{80,-90},{60,-90}},
      color={191,0,0},
      smooth=Smooth.None));
end PartialInfraredRadiation;
