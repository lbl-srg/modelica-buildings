within Buildings.Templates.AirHandlersFans.Components;
package OutdoorSection
  extends Modelica.Icons.Package;

  model DedicatedDamperAirflow
    "Dedicated minimum OA damper (modulated) with AFMS"
    extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
      final typ=Types.OutdoorSection.DedicatedPressure,
      final typDamOut=damOut.typ,
      final typDamOutMin=damOutMin.typ);

    Buildings.Templates.Components.Dampers.Modulated damOut(
      redeclare final package Medium = MediumAir,
      final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

    Buildings.Templates.Components.Dampers.Modulated damOutMin(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={30,60})));

    Buildings.Templates.Components.Sensors.Temperature TOutMin(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{50,50},{70,70}})));

    Buildings.Templates.Components.Sensors.VolumeFlowRate VOutMin_flow(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air volume flow rate sensor"
      annotation (Placement(transformation(extent={{80,50},{100,70}})));
  equation
    /* Hardware point connection - start */
    connect(damOut.bus, bus.damOut);
    connect(damOutMin.bus, bus.damOutMin);
    /* Hardware point connection - end */
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
    connect(port_aIns, port_aIns)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,127,255}));
    connect(damOut.port_b, port_b)
      annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
    connect(TOutMin.port_b, VOutMin_flow.port_a)
      annotation (Line(points={{70,60},{80,60}}, color={0,127,255}));
    connect(VOutMin_flow.port_b, port_b) annotation (Line(points={{100,60},{120,60},
            {120,0},{180,0}}, color={0,127,255}));
    connect(damOutMin.port_b, TOutMin.port_a)
      annotation (Line(points={{40,60},{50,60}}, color={0,127,255}));
    connect(port_aIns, damOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},
            {-20,60},{20,60}}, color={0,127,255}));
    connect(TOutMin.y, bus.TOutMin) annotation (Line(points={{60,72},{60,80},
            {0.1,80},{0.1,140.1}}, color={0,0,127}));
    connect(VOutMin_flow.y, bus.VOutMin_flow) annotation (Line(points={{90,
            72},{90,80},{0.1,80},{0.1,140.1}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"));
  end DedicatedDamperAirflow;

  model DedicatedDamperPressure
    "Dedicated minimum OA damper (two-position) with differential pressure sensor"
    extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
      final typ=Types.OutdoorSection.DedicatedPressure,
      final typDamOut=damOut.typ,
      final typDamOutMin=damOutMin.typ);

    Buildings.Templates.Components.Dampers.Modulated damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

    Buildings.Templates.Components.Dampers.TwoPosition damOutMin(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={50,60})));

    Buildings.Templates.Components.Sensors.Temperature TOutMin(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{70,50},{90,70}})));

    Buildings.Templates.Components.Sensors.DifferentialPressure dpOutMin(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.MinimumOutdoorAir)
      "Minimum outdoor air damper differential pressure sensor"
      annotation (Placement(transformation(extent={{10,50},{30,70}})));
  equation
    /* Hardware point connection - start */
    connect(damOut.bus, bus.damOut);
    connect(damOutMin.bus, bus.damOutMin);
    /* Hardware point connection - end */
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
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
    connect(damOut.port_b, port_b)
      annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
    connect(TOutMin.y, bus.TOutMin) annotation (Line(points={{80,72},{80,80},
            {0.1,80},{0.1,140.1}}, color={0,0,127}));
    connect(dpOutMin.y, bus.dpOutMin) annotation (Line(points={{20,72},{20,
            80},{0.1,80},{0.1,140.1}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"));
  end DedicatedDamperPressure;

  model NoEconomizer "No economizer"
    extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
      final typ=Types.OutdoorSection.NoEconomizer,
      final typDamOut=damOut.typ,
      final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

    Buildings.Templates.Components.Dampers.TwoPosition damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-150,0})));
  equation
    /* Hardware point connection - start */
    connect(damOut.bus, bus.damOut);
    /* Hardware point connection - end */
    connect(port_aIns, port_b)
      annotation (Line(points={{-80,0},{180,0}}, color={0,127,255}));
    connect(port_a, damOut.port_a)
      annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
    connect(damOut.port_b, pas.port_a)
      annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
  end NoEconomizer;

  model SingleDamper "Single common OA damper (modulated) with AFMS"
    extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
      final typ=Types.OutdoorSection.SingleCommon,
      final typDamOut=damOut.typ,
      final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

    Buildings.Templates.Components.Sensors.VolumeFlowRate VOut_flow(redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air volume flow rate sensor"
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    Buildings.Templates.Components.Sensors.Temperature TOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air temperature sensor"
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    Buildings.Templates.Components.Dampers.Modulated damOut(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
      "Outdoor air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

  equation
    /* Hardware point connection - start */
    connect(damOut.bus, bus.damOut);
    /* Hardware point connection - end */
    connect(port_aIns, damOut.port_a)
      annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
    connect(damOut.port_b, TOut.port_a)
      annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
    connect(TOut.port_b, VOut_flow.port_a)
      annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
    connect(VOut_flow.port_b, port_b)
      annotation (Line(points={{90,0},{180,0}}, color={0,127,255}));
    connect(port_a, pas.port_a)
      annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
    connect(TOut.y, bus.TOut) annotation (Line(points={{40,12},{40,20},{0.1,
            20},{0.1,140.1}}, color={0,0,127}));
    connect(VOut_flow.y, bus.VOut_flow) annotation (Line(points={{80,12},{
            80,20},{0.1,20},{0.1,140.1}}, color={0,0,127}));
  end SingleDamper;

  package Interfaces "Classes defining the component interfaces"
    extends Modelica.Icons.InterfacesPackage;

    partial model PartialOutdoorSection "Outdoor air section"

      replaceable package MediumAir=Buildings.Media.Air
        constrainedby Modelica.Media.Interfaces.PartialMedium
        "Air medium";

      parameter AirHandlersFans.Types.OutdoorSection typ "Outdoor air section type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDamOut
        "Outdoor air damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDamOutMin
        "Minimum outdoor air damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Boolean have_recHea
        "Set to true in case of heat recovery"
        annotation (Evaluate=true, Dialog(group="Configuration"));

      outer parameter String id
        "System identifier";
      outer parameter ExternData.JSONFile dat
        "External parameter file";

      parameter Boolean allowFlowReversal = true
        "= false to simplify equations, assuming, but not enforcing, no flow reversal"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

      Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Fluid connector a (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Fluid connector b (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{190,-10},{170,10}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_aHeaRec(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
        "Optional fluid connector for heat recovery"
        annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bHeaRec(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
        "Optional fluid connector for heat recovery"
        annotation (Placement(transformation(extent={{-110,130},{-130,150}})));
      Buildings.Templates.AirHandlersFans.Interfaces.Bus bus "Control bus"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={0,140}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={0,140})));

      Buildings.Templates.BaseClasses.PassThroughFluid pas(redeclare final
          package Medium =
                   MediumAir) if not have_recHea
        "Direct pass through (conditional)"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

    protected
      Modelica.Fluid.Interfaces.FluidPort_a port_aIns(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Inside fluid connector a (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
    equation
      connect(pas.port_b, port_aIns)
        annotation (Line(points={{-90,0},{-80,0}}, color={0,127,255}));
      connect(port_aHeaRec, port_aIns)
        annotation (Line(points={{-80,140},{-80,0},{-80,0}}, color={0,127,255}));
      connect(port_bHeaRec, pas.port_a) annotation (Line(points={{-120,140},{-120,0},
              {-110,0}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
                {180,140}}), graphics={
            Text(
              extent={{-149,-150},{151,-190}},
              lineColor={0,0,255},
              textString="%name")}),                                 Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
    end PartialOutdoorSection;
  end Interfaces;
end OutdoorSection;
