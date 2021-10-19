within Buildings.Templates.AHUs.BaseClasses;
package OutdoorSection
  extends Modelica.Icons.Package;

  model DedicatedAirflow
    "Dedicated minimum OA damper (modulated) with AFMS"
    extends Buildings.Templates.Interfaces.OutdoorSection(
      final typ=Types.OutdoorSection.DedicatedPressure,
      final typDamOut=damOut.typ,
      final typDamOutMin=damOutMin.typ);

     Buildings.Templates.BaseClasses.Dampers.Modulated damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

    Buildings.Templates.BaseClasses.Dampers.Modulated damOutMin(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={30,60})));

    Buildings.Templates.BaseClasses.Sensors.Temperature TOutMin(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{50,50},{70,70}})));

    Buildings.Templates.BaseClasses.Sensors.VolumeFlowRate VOutMin_flow(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air volume flow rate sensor"
      annotation (Placement(transformation(extent={{80,50},{100,70}})));
  equation
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
    connect(damOut.busCon, busCon) annotation (Line(
        points={{0,10},{0,76},{0,140},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(port_aIns, port_aIns)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,127,255}));
    connect(damOutMin.busCon, busCon) annotation (Line(
        points={{30,70},{30,80},{0,80},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(TOutMin.busCon, busCon.inp.TOutMin) annotation (Line(
        points={{60,70},{60,80},{0.1,80},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(damOut.port_b, port_b)
      annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
    connect(TOutMin.port_b, VOutMin_flow.port_a)
      annotation (Line(points={{70,60},{80,60}}, color={0,127,255}));
    connect(VOutMin_flow.port_b, port_b) annotation (Line(points={{100,60},{120,60},
            {120,0},{180,0}}, color={0,127,255}));
    connect(VOutMin_flow.busCon, busCon.inp.VOutMin_flow) annotation (Line(
        points={{90,70},{90,80},{0.1,80},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(damOutMin.port_b, TOutMin.port_a)
      annotation (Line(points={{40,60},{50,60}}, color={0,127,255}));
    connect(port_aIns, damOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},
            {-20,60},{20,60}}, color={0,127,255}));
    annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"));
  end DedicatedAirflow;

  model DedicatedPressure
    "Dedicated minimum OA damper (two-position) with differential pressure sensor"
    extends Buildings.Templates.Interfaces.OutdoorSection(
      final typ=Types.OutdoorSection.DedicatedPressure,
      final typDamOut=damOut.typ,
      final typDamOutMin=damOutMin.typ);

     Buildings.Templates.BaseClasses.Dampers.Modulated damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

    Buildings.Templates.BaseClasses.Dampers.TwoPosition damOutMin(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={50,60})));

    Buildings.Templates.BaseClasses.Sensors.Temperature TOutMin(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{70,50},{90,70}})));

    Buildings.Templates.BaseClasses.Sensors.DifferentialPressure dpOutMin(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper differential pressure sensor"
      annotation (Placement(transformation(extent={{10,50},{30,70}})));
  equation
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
    connect(damOut.busCon, busCon) annotation (Line(
        points={{0,10},{0,76},{0,140},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(damOutMin.port_b,TOutMin. port_a)
      annotation (Line(points={{60,60},{70,60}},         color={0,127,255}));
    connect(dpOutMin.port_b,damOutMin. port_a)
      annotation (Line(points={{30,60},{40,60}},         color={0,127,255}));
    connect(TOutMin.port_b, port_b) annotation (Line(points={{90,60},{120,60},{120,
            0},{180,0}}, color={0,127,255}));
    connect(port_aIns, port_aIns)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,127,255}));
    connect(port_aIns, dpOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},{
            -20,60},{10,60}}, color={0,127,255}));
    connect(dpOutMin.port_bRef, port_b) annotation (Line(points={{20,50},{20,40},{
            120,40},{120,0},{180,0}}, color={0,127,255}));
    connect(dpOutMin.busCon, busCon.inp.dpOutMin) annotation (Line(
        points={{20,70},{20,80},{0.1,80},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(damOutMin.busCon, busCon) annotation (Line(
        points={{50,70},{50,80},{0,80},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(TOutMin.busCon, busCon.inp.TOutMin) annotation (Line(
        points={{80,70},{80,80},{0.1,80},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(damOut.port_b, port_b)
      annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
    annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"));
  end DedicatedPressure;

  model NoEconomizer "No economizer"
    extends Buildings.Templates.Interfaces.OutdoorSection(
      final typ=Types.OutdoorSection.NoEconomizer,
      final typDamOut=damOut.typ,
      final typDamOutMin=Templates.Types.Damper.None);

    Buildings.Templates.BaseClasses.Dampers.TwoPosition damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-150,0})));
  equation
    connect(port_aIns, port_b)
      annotation (Line(points={{-80,0},{180,0}}, color={0,127,255}));
    connect(port_a, damOut.port_a)
      annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
    connect(damOut.port_b, pas.port_a)
      annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
    connect(damOut.busCon, busCon) annotation (Line(
        points={{-150,10},{-150,20},{0,20},{0,140}},
        color={255,204,51},
        thickness=0.5));
  end NoEconomizer;

  model SingleCommon "Single common OA damper (modulated) with AFMS"
    extends Buildings.Templates.Interfaces.OutdoorSection(
      final typ=Types.OutdoorSection.SingleCommon,
      final typDamOut=damOut.typ,
      final typDamOutMin=Templates.Types.Damper.None);

    Buildings.Templates.BaseClasses.Sensors.VolumeFlowRate VOut_flow(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air volume flow rate sensor"
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    Buildings.Templates.BaseClasses.Sensors.Temperature TOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
     Buildings.Templates.BaseClasses.Dampers.Modulated damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

  equation
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
    connect(damOut.port_b, TOut.port_a)
      annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
    connect(TOut.port_b, VOut_flow.port_a)
      annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
    connect(VOut_flow.port_b, port_b)
      annotation (Line(points={{90,0},{180,0}}, color={0,127,255}));
    connect(damOut.busCon, busCon) annotation (Line(
        points={{0,10},{0,76},{0,140},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(TOut.busCon, busCon.inp.TOut) annotation (Line(
        points={{40,10},{40,20},{0.1,20},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(VOut_flow.busCon, busCon.inp.VOut_flow) annotation (Line(
        points={{80,10},{80,20},{0.1,20},{0.1,140.1}},
        color={255,204,51},
        thickness=0.5));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
  end SingleCommon;
end OutdoorSection;
