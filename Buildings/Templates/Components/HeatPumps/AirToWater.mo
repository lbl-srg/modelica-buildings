within Buildings.Templates.Components.HeatPumps;
model AirToWater "Air-to-water heat pump"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump(
    redeclare replaceable package MediumSou=Buildings.Media.Air,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirSource,
    bou(nPorts=3));

  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare final package Medium1 = MediumLoa,
    redeclare final package Medium2 = MediumSou,
    final per=dat.per)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData souAir(
    redeclare final package Medium=MediumSou,
    final use_m_flow_in=true,
    nPorts=1)
    "Air flow source"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-60})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch setpoint depending on operating mode"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1Int
    "Convert on/off command into integer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1HeaInt(
    final integerTrue=1,
    final integerFalse=-1)
    "Convert heating mode command into integer"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,30})));
  Modelica.Blocks.Routing.BooleanPassThrough y1Hea if is_rev
    "Operating mode command: true=heating, false=cooling"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1HeaNonRev(
    final k=true) if not is_rev
    "Placeholder signal for non-reversible heat pumps"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetNonRev(final k=
        Buildings.Templates.Data.Defaults.TChiWatSup)
    if not is_rev "Placeholder signal for non-reversible heat pumps"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Combine on/off and operating mode command signals"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-10})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAir_flow(k=max(dat.per.hea.mSou_flow,
        dat.per.coo.mSou_flow)) "Air mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert on/off command into real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,30})));
equation
  connect(port_a, heaPum.port_a1)
    annotation (Line(points={{-100,0},{-96,0},{-96,-28},{-10,-28}},
                                                color={0,127,255}));
  connect(heaPum.port_b1, port_b)
    annotation (Line(points={{10,-28},{96,-28},{96,0},{100,0}},
                                              color={0,127,255}));
  connect(souAir.ports[1], heaPum.port_a2)
    annotation (Line(points={{40,-50},{40,-40},{10,-40}}, color={0,127,255}));
  connect(heaPum.port_b2, bou.ports[3]) annotation (Line(points={{-10,-40},{-40,
          -40},{-40,-80},{0,-80}}, color={0,127,255}));
  connect(busWea, souAir.weaBus) annotation (Line(
      points={{-60,100},{-60,90},{-90,90},{-90,-70},{40.2,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.THeaWatSupSet, swi.u1) annotation (Line(
      points={{0,100},{0,54},{8,54},{8,42}},
      color={255,204,51},
      thickness=0.5));
  connect(swi.y, heaPum.TSet)
    annotation (Line(points={{0,18},{0,10},{-20,10},{-20,-25},{-11.4,-25}},
                                                      color={0,0,127}));
  connect(bus.y1, y1Int.u) annotation (Line(
      points={{0,100},{-40,100},{-40,42}},
      color={255,204,51},
      thickness=0.5));
  connect(y1HeaNonRev.y, swi.u2) annotation (Line(points={{-58,70},{-50,70},{-50,
          50},{0,50},{0,42}}, color={255,0,255}));
  connect(bus.y1Heat, y1Hea.u) annotation (Line(
      points={{0,100},{0,96},{20,96},{20,82}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Hea.y, swi.u2) annotation (Line(points={{20,59},{20,50},{0,50},{0,
          42}}, color={255,0,255}));
  connect(y1HeaNonRev.y, y1HeaInt.u) annotation (Line(points={{-58,70},{-50,70},
          {-50,50},{-70,50},{-70,42}}, color={255,0,255}));
  connect(y1Hea.y, y1HeaInt.u) annotation (Line(points={{20,59},{20,50},{-26,50},
          {-26,42},{-70,42}},
                     color={255,0,255}));
  connect(bus.TChiWatSupSet, swi.u3) annotation (Line(
      points={{0,100},{0,54},{-8,54},{-8,42}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetNonRev.y, swi.u3) annotation (Line(points={{-20,58},{-20,54},{-8,
          54},{-8,42}},
                    color={0,0,127}));
  connect(y1Int.y, mulInt.u1) annotation (Line(points={{-40,18},{-40,16},{-44,16},
          {-44,2}},  color={255,127,0}));
  connect(y1HeaInt.y, mulInt.u2) annotation (Line(points={{-70,18},{-70,16},{-56,
          16},{-56,2}},  color={255,127,0}));
  connect(mulInt.y, heaPum.uMod) annotation (Line(points={{-50,-22},{-50,-34},{-11,
          -34}}, color={255,127,0}));
  connect(mAir_flow.y, souAir.m_flow_in) annotation (Line(points={{80,-72},{80,
          -80},{48,-80},{48,-70}}, color={0,0,127}));
  connect(y1Rea.y, mAir_flow.u)
    annotation (Line(points={{80,18},{80,-48}}, color={0,0,127}));
  connect(bus.y1, y1Rea.u) annotation (Line(
      points={{0,100},{0,96},{40,96},{40,60},{80,60},{80,42}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(info=".<html>
<p>
Input power of fan included in HP power, as per EN 14511 and AHRI?
The performance data for air-source heat pumps should use 0 for
the dependency to air flow rate. 
</p>
</html>"));
end AirToWater;
