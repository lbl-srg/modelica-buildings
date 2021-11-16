within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDamperPressure
  "Dedicated minimum OA damper (two-position) with differential pressure sensor"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Dampers.Modulated damOut(
    redeclare final package Medium = MediumAir,
    final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
    "Outdoor air damper" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));

  Buildings.Templates.Components.Dampers.TwoPosition damOutMin(
    redeclare final package Medium = MediumAir,
    final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
    "Minimum outdoor air damper" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,60})));

  Buildings.Templates.Components.Sensors.Temperature TOutMin(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal)
    "Minimum outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure dpOutMin(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal)
    "Minimum outdoor air damper differential pressure sensor"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
equation
  /* Hardware point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(damOutMin.bus, bus.damOutMin);
  connect(TOutMin.y, bus.TOutMin);
  connect(dpOutMin.y, bus.dpOutMin);
  /* Hardware point connection - end */
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(damOutMin.port_b,TOutMin. port_a)
    annotation (Line(points={{60,60},{90,60}},         color={0,127,255}));
  connect(TOutMin.port_b, port_b) annotation (Line(points={{110,60},{160,60},{
          160,0},{180,0}},
                       color={0,127,255}));
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));

  connect(port_aIns, damOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},
          {-20,60},{40,60}}, color={0,127,255}));
  connect(damOutMin.port_a, dpOutMin.port_a) annotation (Line(points={{40,60},{
          20,60},{20,20},{40,20}}, color={0,127,255}));
  connect(damOutMin.port_b, dpOutMin.port_b) annotation (Line(points={{60,60},{
          80,60},{80,20},{60,20}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"));
end DedicatedDamperPressure;
