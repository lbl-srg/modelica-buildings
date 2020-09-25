within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block Supply_
  CDL.Interfaces.IntegerInput                        uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,350},{-180,390}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  CDL.Continuous.Sources.Constant fanOff(k=0) "Fan off status"
    annotation (Placement(transformation(extent={{40,410},{60,430}})));
  CDL.Logical.Switch fanSpe "Supply fan speed"
    annotation (Placement(transformation(extent={{100,390},{120,410}})));
  CDL.Continuous.SlewRateLimiter ramLim(final raisingSlewRate=1/600, final Td=
        60) "Prevent changes in fan speed of more than 10% per minute"
    annotation (Placement(transformation(extent={{140,390},{160,410}})));
protected
  CDL.Integers.Sources.Constant                        unoMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode index"
    annotation (Placement(transformation(extent={{-160,390},{-140,410}})));
  CDL.Integers.Equal isUnoMod "Check if it is in unoccupied mode"
    annotation (Placement(transformation(extent={{-120,390},{-100,410}})));
equation
  connect(unoMod.y, isUnoMod.u1)
    annotation (Line(points={{-138,400},{-122,400}}, color={255,127,0}));
  connect(uOpeMod, isUnoMod.u2) annotation (Line(points={{-200,370},{-130,370},
          {-130,392},{-122,392}}, color={255,127,0}));
  connect(isUnoMod.y, fanSpe.u2)
    annotation (Line(points={{-98,400},{98,400}}, color={255,0,255}));
  connect(fanOff.y, fanSpe.u1) annotation (Line(points={{62,420},{80,420},{80,
          408},{98,408}}, color={0,0,127}));
  connect(fanSpe.y, ramLim.u)
    annotation (Line(points={{122,400},{138,400}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -440},{180,440}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-180,-440},{180,440}})));
end Supply_;
