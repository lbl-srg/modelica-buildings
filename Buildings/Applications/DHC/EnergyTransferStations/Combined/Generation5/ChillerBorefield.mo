within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5;
model ChillerBorefield
  "ETS model for 5GDHC systems with heat recovery chiller and borefield"
  extends Chiller(
    nSouAmb=2,
    colAmbWat(mCon_flow_nominal={m2Hex_flow_nominal, borFie.m_flow_nominal}));

  parameter Fluid.Geothermal.Borefields.Data.Borefield.Template datBorFie
    "Borefield parameters" annotation (Dialog(group="Borefield"), Placement(
        transformation(extent={{20,222},{40,242}})));
  parameter Modelica.SIunits.Temperature TBorWatEntMax=313.15
    "Maximum value of borefield water entering temperature"
    annotation (Dialog(group="Borefield"));
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed"
    annotation (Dialog(group="Borefield"));

  Subsystems.Borefield borFie(
    redeclare final package Medium = MediumBui,
    final dat=datBorFie,
    final TBorWatEntMax=TBorWatEntMax,
    final spePumBorMin=spePumBorMin)
    "Borefield subsystem"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
equation
  connect(colAmbWat.ports_bCon[2], borFie.port_a) annotation (Line(points={{-16,
          -116},{-14,-116},{-14,-136},{-100,-136},{-100,-220},{-80,-220}},
        color={0,127,255}));
  connect(borFie.port_b, colAmbWat.ports_aCon[2]) annotation (Line(points={{-60,
          -220},{8,-220},{8,-116}}, color={0,127,255}));
  connect(conSup.yAmb[1], borFie.u) annotation (Line(points={{-238,24},{-198,24},
          {-198,-212},{-82,-212}}, color={0,0,127}));
  connect(valIsoCon.y_actual, borFie.yValIso[1]) annotation (Line(points={{-55,
          -113},{-40,-113},{-40,-198},{-90,-198},{-90,-218},{-82,-218}}, color=
          {0,0,127}));
  connect(valIsoEva.y_actual, borFie.yValIso[2]) annotation (Line(points={{55,
          -113},{40,-113},{40,-200},{-88,-200},{-88,-216},{-82,-216}}, color={0,
          0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerBorefield;
