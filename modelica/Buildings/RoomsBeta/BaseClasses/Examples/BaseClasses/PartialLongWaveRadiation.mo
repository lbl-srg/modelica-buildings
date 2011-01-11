within Buildings.RoomsBeta.BaseClasses.Examples.BaseClasses;
model PartialLongWaveRadiation
  "Partial model to test long-wave radiation inside the room"
  import Buildings;

  parameter Integer nConExt(min=0)=1 "Number of exterior constructions"
    annotation (Dialog(group="Exterior constructions"));
  parameter Integer nConExtWin(min=0)=1 "Number of window constructions"
    annotation (Dialog(group="Exterior constructions"));

  parameter Integer nConPar(min=0)=1 "Number of partition constructions"
  annotation (Dialog(group="Partition constructions"));

  parameter Integer nConBou(min=0)=1
    "Number of constructions that have their outside surface exposed to the boundary of this room"
  annotation (Dialog(group="Boundary constructions"));

  parameter Integer nSurBou(min=0)=1
    "Number of surface heat transfer models that connect to constructions that are modeled outside of this room"
  annotation (Dialog(group="Boundary constructions"));
protected
  parameter Integer NConExt(min=1)=max(1, nConExt)
    "Number of elements for exterior constructions";

  parameter Integer NConExtWin(min=1)=max(1, nConExtWin)
    "Number of elements for exterior constructions with windows";

  parameter Integer NConPar(min=1)=max(1, nConPar)
    "Number of elements for partition constructions";

  parameter Integer NConBou(min=1)=max(1, nConBou)
    "Number of elements for constructions that have their outside surface exposed to the boundary of this room";

  parameter Integer NSurBou(min=1)=max(1, nSurBou)
    "Number of elements for surface heat transfer models that connect to constructions that are modeled outside of this room";

protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConExt[NConExt](each T=293.15)
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConExtWin[
    NConExtWin](each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,60})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConExtWinFra[
    NConExtWin](each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConPar_a[NConPar](each T=
       293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConPar_b[NConPar](each T=
       293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-30})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouConBou[NConBou](each T=293.15)
    "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-60})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bouSurBou[NSurBou](each T=293.15)
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
  annotation (Diagram(graphics));
end PartialLongWaveRadiation;
