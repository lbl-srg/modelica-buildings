within Buildings.Templates.BaseClasses;
package Coils
  extends Modelica.Icons.Package;
  model DirectExpansion
    extends Buildings.Templates.Interfaces.Coil(
      final typ=AHUs.Types.Coil.DirectExpansion,
      final have_weaBus=true,
      final have_sou=false,
      final typAct=AHUs.Types.Actuator.None,
      final typHex=hex.typ);

    inner parameter Boolean have_dryCon = true
      "Set to true for purely sensible cooling of the condenser";

    replaceable HeatExchangers.DXVariableSpeed hex
      constrainedby Buildings.Templates.Interfaces.HeatExchangerDX(
        redeclare final package Medium = MediumAir,
        final m_flow_nominal=mAir_flow_nominal,
        final dp_nominal=dpAir_nominal)
      "Heat exchanger"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(port_a, hex.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(hex.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(weaBus, hex.weaBus) annotation (Line(
        points={{-60,100},{-60,20},{-6,20},{-6,10}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon,hex.busCon)  annotation (Line(
        points={{0,100},{0,10}},
        color={255,204,51},
        thickness=0.5));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end DirectExpansion;

  model None
    extends Buildings.Templates.Interfaces.Coil(
      final typ=AHUs.Types.Coil.None,
      final have_weaBus=false,
      final have_sou=false,
      final typAct=AHUs.Types.Actuator.None,
      final typHex=AHUs.Types.HeatExchanger.None);

  equation
    connect(port_a, port_b)
      annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
    annotation (
      defaultComponentName="coi",
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                Line(
            points={{-100,0},{100,0}},
            color={28,108,200},
            thickness=1)}),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end None;

  model WaterBased
    extends Buildings.Templates.Interfaces.Coil(
      final typ=AHUs.Types.Coil.WaterBased,
      final have_weaBus=false,
      final have_sou=true,
      final typAct=act.typ,
      final typHex=hex.typ);

    inner parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)=
      dat.getReal(varName=id + "." + funStr + " coil.Liquid mass flow rate")
      "Liquid mass flow rate"
      annotation(Dialog(group = "Nominal condition"), Evaluate=true);
  //     Templates.BaseClasses.getReal(
  //       id + "." + funStr + " coil.Liquid mass flow rate",
  //       dat.fileName)
    inner parameter Modelica.SIunits.PressureDifference dpWat_nominal(
      displayUnit="Pa")=
      dat.getReal(varName=id + "." + funStr + " coil.Liquid pressure drop")
      "Liquid pressure drop"
      annotation(Dialog(group = "Nominal condition"), Evaluate=true);
      // Templates.BaseClasses.getReal(
      //   id + "." + funStr + " coil.Liquid pressure drop",
      //   dat.fileName)

    replaceable Valves.None act
      constrainedby Buildings.Templates.Interfaces.Valve(
        redeclare final package Medium = MediumSou)
      "Actuator"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-70},{10,-50}})));

    // TODO: conditional choices based on funStr to restrict HX models for cooling.
    replaceable HeatExchangers.DryCoilEffectivenessNTU hex constrainedby
      Buildings.Templates.Interfaces.HeatExchangerWater(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir,
      final m1_flow_nominal=mWat_flow_nominal,
      final m2_flow_nominal=mAir_flow_nominal,
      final dp1_nominal=if typAct==AHUs.Types.Actuator.None
                                                       then dpWat_nominal else 0,
      final dp2_nominal=dpAir_nominal)
      "Heat exchanger"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{10,4},{-10,-16}})));
    Modelica.Blocks.Routing.RealPassThrough yCoiCoo if funStr=="Cooling"
      "Pass through to connect with specific control signal"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-40,50})));
    Modelica.Blocks.Routing.RealPassThrough yCoiHea if funStr=="Heating"
      "Pass through to connect with specific control signal"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,50})));
    Modelica.Blocks.Routing.RealPassThrough yCoiReh if funStr=="Reheat"
      "Pass through to connect with specific control signal"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,50})));
  equation
    connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
            {-4,-80},{-4,-70}}, color={0,127,255}));
    connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
            -80},{40,-100}}, color={0,127,255}));
    connect(act.port_bSup,hex. port_a1) annotation (Line(points={{-4,-50},{-4,-22},
            {20,-22},{20,-12},{10,-12}}, color={0,127,255}));
    connect(hex.port_b1, act.port_aRet) annotation (Line(points={{-10,-12},{-20,-12},
            {-20,-24},{4,-24},{4,-50}}, color={0,127,255}));
    connect(port_a,hex. port_a2)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(hex.port_b2, port_b) annotation (Line(points={{10,0},{56,0},{56,0},{100,
            0}}, color={0,127,255}));

    connect(yCoiCoo.y, act.y)
      annotation (Line(points={{-40,39},{-40,-60},{-11,-60}}, color={0,0,127}));
    connect(yCoiHea.y, act.y) annotation (Line(points={{-1.9984e-15,39},{
            -1.9984e-15,30},{0,30},{0,20},{-40,20},{-40,-60},{-11,-60}},
                                                             color={0,0,127}));
    connect(busCon.out.yCoiHea, yCoiHea.u) annotation (Line(
        points={{0.1,100.1},{0.1,82},{0,82},{0,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(busCon.out.yCoiCoo, yCoiCoo.u) annotation (Line(
        points={{0.1,100.1},{-2,100.1},{-2,80},{-40,80},{-40,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(busCon.out.yCoiReh, yCoiReh.u) annotation (Line(
        points={{0.1,100.1},{0.1,100.1},{2,100.1},{2,80},{40,80},{40,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(yCoiReh.y, act.y) annotation (Line(points={{40,39},{40,20},{-40,20},{
            -40,-60},{-11,-60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(revisions="<html>
<p>
Using modified getReal function with annotation(__Dymola_translate=true)
avoids warning for non literal nominal attributes.
Not supported by OCT though:
Compliance error at line 8, column 4, 
  Constructors for external objects is not supported in functions

</p>
</html>"));
  end WaterBased;

  package HeatExchangers
    extends Modelica.Icons.Package;
    model DXMultiStage
      extends Buildings.Templates.Interfaces.HeatExchangerDX(
        final typ=AHUs.Types.HeatExchanger.DXMultiStage);

      replaceable parameter
        Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
        constrainedby
        Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
        "Performance record"
        annotation(choicesAllMatching=true);

      outer parameter Boolean have_dryCon
        "Set to true for purely sensible cooling of the condenser";

      Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage coi(
        redeclare final package Medium = Medium,
        final datCoi=datCoi,
        final dp_nominal=dp_nominal,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
        "DX coil"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Modelica.Blocks.Routing.RealPassThrough TWet if not have_dryCon
        annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
      Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

    equation
      connect(port_a, coi.port_a)
        annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
      connect(coi.port_b, port_b)
        annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
      connect(weaBus.TWetBul, TWet.u) annotation (Line(
          points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul, TDry.u) annotation (Line(
          points={{-60,100},{-60,40},{-80,40},{-80,-20},{-62,-20}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(TWet.y, coi.TConIn) annotation (Line(points={{-39,20},{-30,20},{-30,3},
              {-11,3}}, color={0,0,127}));
      connect(TDry.y, coi.TConIn) annotation (Line(points={{-39,-20},{-30,-20},{-30,
              3},{-11,3}}, color={0,0,127}));
      connect(busCon.out.yCoiCoo, coi.stage) annotation (Line(
          points={{0.1,100.1},{0.1,100.1},{0.1,20},{-20,20},{-20,8},{-11,8}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DXMultiStage;

    model DXVariableSpeed
      extends Buildings.Templates.Interfaces.HeatExchangerDX(
        final typ=AHUs.Types.HeatExchanger.DXVariableSpeed);

      parameter Real minSpeRat(min=0,max=1)=0.1 "Minimum speed ratio";
      parameter Real speRatDeaBan=0.05 "Deadband for minimum speed ratio";

      replaceable parameter
        Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
        constrainedby
        Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
        "Performance record"
        annotation(choicesAllMatching=true);

      outer parameter Boolean have_dryCon
        "Set to true for purely sensible cooling of the condenser";

      Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coi(
        redeclare final package Medium = Medium,
        final datCoi=datCoi,
        final minSpeRat=minSpeRat,
        final speRatDeaBan=speRatDeaBan,
        final dp_nominal=dp_nominal,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
        "DX coil"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      Modelica.Blocks.Routing.RealPassThrough TWet if not have_dryCon
        annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
      Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    equation
      connect(port_a, coi.port_a)
        annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
      connect(coi.port_b, port_b)
        annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
      connect(weaBus.TWetBul, TWet.u) annotation (Line(
          points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul, TDry.u) annotation (Line(
          points={{-60,100},{-60,40},{-80,40},{-80,-20},{-62,-20}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(TWet.y, coi.TConIn) annotation (Line(points={{-39,20},{-30,20},{-30,3},
              {-11,3}}, color={0,0,127}));
      connect(TDry.y, coi.TConIn) annotation (Line(points={{-39,-20},{-30,-20},{-30,
              3},{-11,3}}, color={0,0,127}));
      connect(busCon.out.yCoiCoo, coi.speRat) annotation (Line(
          points={{0.1,100.1},{-20,100.1},{-20,8},{-11,8}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DXVariableSpeed;

    model WetCoilCounterFlow
      extends Buildings.Templates.Interfaces.HeatExchangerWater(
        final typ=AHUs.Types.HeatExchanger.WetCoilCounterFlow);

      parameter Modelica.SIunits.ThermalConductance UA_nominal=
        dat.getReal(varName=id + "." + funStr + " coil.UA (dry coil conditions)")
        "Thermal conductance at nominal flow"
        annotation(Evaluate=true);
      parameter Real r_nominal=2/3
        "Ratio between air-side and water-side convective heat transfer coefficient";
      parameter Integer nEle=4
        "Number of pipe segments used for discretization";

      Fluid.HeatExchangers.WetCoilCounterFlow hex(
        redeclare final package Medium1 = Medium1,
        redeclare final package Medium2 = Medium2,
        final m1_flow_nominal=m1_flow_nominal,
        final m2_flow_nominal=m2_flow_nominal,
        final dp1_nominal=dp1_nominal,
        final dp2_nominal=dp2_nominal,
        final UA_nominal=UA_nominal,
        final r_nominal=r_nominal,
        final nEle=nEle,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
              -6},{-10,-6}}, color={0,127,255}));
      connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
              {-100,60}}, color={0,127,255}));
      connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
              100,60}}, color={0,127,255}));
      connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
              {100,-60}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end WetCoilCounterFlow;

    model DryCoilEffectivenessNTU
      extends Buildings.Templates.Interfaces.HeatExchangerWater(
        final typ=AHUs.Types.HeatExchanger.DryCoilEffectivenessNTU);

      parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)=
        dat.getReal(varName=id + "." + funStr + " coil.Capacity")
        "Nominal heat flow rate"
        annotation(Dialog(group = "Nominal condition"));
      parameter Modelica.SIunits.Temperature T_a1_nominal=
        dat.getReal(varName=id + "." + funStr + " coil.Entering liquid temperature")
        "Nominal inlet temperature"
        annotation(Dialog(group = "Nominal condition"));
      parameter Modelica.SIunits.Temperature T_a2_nominal=
        dat.getReal(varName=id + "." + funStr + " coil.Entering air temperature")
        "Nominal inlet temperature"
        annotation(Dialog(group = "Nominal condition"));
      parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
        Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
        "Heat exchanger configuration"
        annotation (Evaluate=true);

      Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
        redeclare final package Medium1 = Medium1,
        redeclare final package Medium2 = Medium2,
        final m1_flow_nominal=m1_flow_nominal,
        final m2_flow_nominal=m2_flow_nominal,
        final dp1_nominal=dp1_nominal,
        final dp2_nominal=dp2_nominal,
        final use_Q_flow_nominal=true,
        final configuration=configuration,
        final Q_flow_nominal=Q_flow_nominal,
        final T_a1_nominal=T_a1_nominal,
        final T_a2_nominal=T_a2_nominal)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    equation
      connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
              -6},{-10,-6}}, color={0,127,255}));
      connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
              {-100,60}}, color={0,127,255}));
      connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
              100,60}}, color={0,127,255}));
      connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
              {100,-60}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DryCoilEffectivenessNTU;
  end HeatExchangers;

  package Valves
    extends Modelica.Icons.Package;
    model None "No actuator"
      extends Buildings.Templates.Interfaces.Valve(
        final typ=AHUs.Types.Actuator.None);

    equation
      connect(port_bSup, port_aSup)
        annotation (Line(points={{-40,100},{-40,-100}}, color={0,127,255}));
      connect(port_bRet, port_aRet)
        annotation (Line(points={{40,-100},{40,100}}, color={0,127,255}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                  Line(
              points={{-40,100},{-40,-100}},
              color={28,108,200},
              thickness=1),                                       Line(
              points={{40,100},{40,-100}},
              color={28,108,200},
              thickness=1)}),                              Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end None;

    model ThreeWayValve "Three-way valve"
      extends Buildings.Templates.Interfaces.Valve(
        final typ=AHUs.Types.Actuator.ThreeWayValve);

      parameter Modelica.SIunits.PressureDifference dpValve_nominal(
         displayUnit="Pa",
         min=0)=
        dat.getReal(varName=id + "." + funStr + " coil valve.Pressure drop")
        "Nominal pressure drop of fully open valve"
        annotation(Dialog(group="Nominal condition"));
      final parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2](
        each displayUnit="Pa",
        each min=0)={1, 1} * dpWat_nominal
        "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
        annotation(Dialog(group="Nominal condition"));

      replaceable Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
        constrainedby Fluid.Actuators.BaseClasses.PartialThreeWayValve(
          redeclare final package Medium=Medium,
          final m_flow_nominal=mWat_flow_nominal,
          final dpValve_nominal=dpValve_nominal,
          final dpFixed_nominal=dpFixed_nominal)
        "Valve"
        annotation (
          choicesAllMatching=true,
          Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={40,0})));
      Fluid.FixedResistances.Junction jun(
        redeclare final package Medium=Medium,
        final m_flow_nominal=mWat_flow_nominal * {1, -1, -1},
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        dp_nominal=fill(0, 3))
        "Junction"
        annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-40,0})));
    equation
      connect(y, val.y)
        annotation (Line(points={{-120,0},{-80,0},{-80,20},{60,20},{60,2.22045e-15},
              {52,2.22045e-15}},                   color={0,0,127}));
      connect(port_aSup, jun.port_1)
        annotation (Line(points={{-40,-100},{-40,-10}}, color={0,127,255}));
      connect(jun.port_2, port_bSup)
        annotation (Line(points={{-40,10},{-40,100}}, color={0,127,255}));
      connect(jun.port_3, val.port_3)
        annotation (Line(points={{-30,0},{30,0}}, color={0,127,255}));
      connect(val.port_2, port_bRet) annotation (Line(points={{40,-10},{40,-100},{
              40,-100}}, color={0,127,255}));
      connect(val.port_1, port_aRet)
        annotation (Line(points={{40,10},{40,100},{40,100}}, color={0,127,255}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ThreeWayValve;

    model TwoWayValve "Two-way valve"
      extends Buildings.Templates.Interfaces.Valve(
        final typ=AHUs.Types.Actuator.TwoWayValve);

      parameter Modelica.SIunits.PressureDifference dpValve_nominal(
         displayUnit="Pa",
         min=0)=
        dat.getReal(varName=id + "." + funStr + " coil valve.Pressure drop")
        "Nominal pressure drop of fully open valve"
        annotation(Dialog(group="Nominal condition"));
      final parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
        displayUnit="Pa",
        min=0)=dpWat_nominal
        "Nominal pressure drop of pipes and other equipment in flow leg"
        annotation(Dialog(group="Nominal condition"));

      replaceable Fluid.Actuators.Valves.TwoWayEqualPercentage val
        constrainedby Fluid.Actuators.BaseClasses.PartialTwoWayValve(
          redeclare final package Medium=Medium,
          final m_flow_nominal=mWat_flow_nominal,
          final dpValve_nominal=dpValve_nominal,
          final dpFixed_nominal=dpFixed_nominal)
        "Valve"
        annotation (
          choicesAllMatching=true,
          Placement(
            transformation(
            extent={{-10,10},{10,-10}},
            rotation=-90,
            origin={40,0})));
    equation
      connect(port_aSup, port_bSup)
        annotation (Line(points={{-40,-100},{-40,100}}, color={0,127,255}));
      connect(port_aRet, val.port_a)
        annotation (Line(points={{40,100},{40,10}}, color={0,127,255}));
      connect(y, val.y)
        annotation (Line(points={{-120,0},{-46,0},{-46,2.22045e-15},{28,2.22045e-15}},
                                                   color={0,0,127}));
      connect(val.port_b, port_bRet)
        annotation (Line(points={{40,-10},{40,-100}}, color={0,127,255}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end TwoWayValve;
  end Valves;
end Coils;
