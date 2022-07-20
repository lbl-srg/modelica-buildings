within Buildings.Fluid.ZoneEquipment.FanCoilUnit;
package Controls
  block Controller_VariableFan_ConstantWaterFlowrate

    parameter Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      "Type of controller"
      annotation(Dialog(group="Cooling mode"));
    parameter Real kCoo=1 "Gain of controller"
      annotation(Dialog(group="Cooling mode"));
    parameter Real TiCoo=0.5 "Time constant of integrator block"
      annotation(Dialog(group="Cooling mode",
        enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
    parameter Real TdCoo=0.1 "Time constant of derivative block"
      annotation(Dialog(group="Cooling mode",
        enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
        controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      "Type of controller"
      annotation(Dialog(group="Heating mode"));

    parameter Real kHea=1 "Gain of controller"
      annotation(Dialog(group="Heating mode"));
    parameter Real TiHea=0.5 "Time constant of integrator block"
      annotation(Dialog(group="Heating mode",
        enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
    parameter Real TdHea=0.1 "Time constant of derivative block"
      annotation(Dialog(group="Heating mode",
        enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
        controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real dTHys(
      final unit="K",
      displayUnit="K",
      final quantity="TemperatureDifference") = 0.2
      "Temperature difference used for enabling coooling and heating mode"
      annotation(Dialog(tab="Advanced"));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon "Measured zone temperature"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
          iconTransformation(extent={{-140,20},{-100,60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet
      "Zone cooling temperature setpoint"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet
      "Zone heating temperature setpoint"
      annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
          iconTransformation(extent={{-140,-60},{-100,-20}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo "Cooling signal"
      annotation (Placement(transformation(extent={{100,40},{140,80}}),
          iconTransformation(extent={{100,40},{140,80}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea "Heating signal"
      annotation (Placement(transformation(extent={{100,0},{140,40}}),
          iconTransformation(extent={{100,0},{140,40}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe "Fan speed signal"
                                                             annotation (Placement(
          transformation(extent={{100,-50},{140,-10}}),
                                                      iconTransformation(extent={
              {100,-40},{140,0}})));

    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan "Fan enable signal"
                                                             annotation (Placement(
          transformation(extent={{100,-100},{140,-60}}),iconTransformation(extent=
             {{100,-80},{140,-40}})));

    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=-dTHys,
                                                                     uHigh=0)
      "Enable cooling when zone temperature is higher than cooling setpoint"
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

    Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
      "Find difference between zone temperature and cooling setpoint"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
      "Boolean to Real conversion"
      annotation (Placement(transformation(extent={{0,60},{20,80}})));

    Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
      "Find difference between zone temperature and heating setpoint"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(uLow=-dTHys,
                                                                     uHigh=0)
      "Enable heating when zone temperature is lower than heating setpoint"
      annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
      "Boolean to Real conversion"
      annotation (Placement(transformation(extent={{0,10},{20,30}})));

    Buildings.Controls.OBC.CDL.Logical.Or or2
      "Enable fan in heating mode and cooling mode"
      annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

    Buildings.Controls.OBC.CDL.Continuous.PID conPID(
      controllerType=controllerTypeCoo,
      k=kCoo,
      Ti=TiCoo,
      Td=TdCoo,                                      reverseActing=false)
      "PI controller for fan speed in cooling mode"
      annotation (Placement(transformation(extent={{0,-20},{20,0}})));

    Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
      controllerType=controllerTypeHea,
      k=kHea,
      Ti=TiHea,
      Td=TdHea,                                       reverseActing=false)
      "PI controller for fan speed in heating mode"
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
      "Constant zero signal"
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

    Buildings.Controls.OBC.CDL.Continuous.Add add3
      "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  equation
    connect(TZon,sub2. u1) annotation (Line(points={{-120,60},{-94,60},{-94,76},{
            -82,76}}, color={0,0,127}));

    connect(TCooSet,sub2. u2) annotation (Line(points={{-120,20},{-90,20},{-90,64},
            {-82,64}}, color={0,0,127}));

    connect(sub2.y, hys1.u)
      annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));

    connect(hys1.y, booToRea.u)
      annotation (Line(points={{-18,70},{-2,70}}, color={255,0,255}));

    connect(booToRea.y, yCoo) annotation (Line(points={{22,70},{60,70},{60,60},{
            120,60}}, color={0,0,127}));

    connect(sub1.y, hys2.u)
      annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));

    connect(hys2.y, booToRea1.u)
      annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));

    connect(TZon,sub1. u2) annotation (Line(points={{-120,60},{-94,60},{-94,14},{
            -82,14}}, color={0,0,127}));

    connect(THeaSet,sub1. u1) annotation (Line(points={{-120,-20},{-88,-20},{-88,
            26},{-82,26}}, color={0,0,127}));

    connect(booToRea1.y, yHea)
      annotation (Line(points={{22,20},{120,20}}, color={0,0,127}));

    connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-80},{
            58,-80}},  color={255,0,255}));

    connect(hys2.y, or2.u2) annotation (Line(points={{-18,20},{-14,20},{-14,-88},{
            58,-88}},  color={255,0,255}));

    connect(or2.y, yFan)
      annotation (Line(points={{82,-80},{120,-80}}, color={255,0,255}));

    connect(sub2.y, conPID.u_m) annotation (Line(points={{-58,70},{-50,70},{-50,
            -26},{10,-26},{10,-22}}, color={0,0,127}));

    connect(sub1.y, conPID1.u_m) annotation (Line(points={{-58,20},{-54,20},{-54,-68},
            {10,-68},{10,-62}},      color={0,0,127}));

    connect(con.y, conPID.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
            -10},{-2,-10}}, color={0,0,127}));

    connect(con.y, conPID1.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
            -50},{-2,-50}}, color={0,0,127}));

    connect(add3.y, yFanSpe)
      annotation (Line(points={{52,-30},{120,-30}}, color={0,0,127}));

    connect(conPID.y, add3.u1) annotation (Line(points={{22,-10},{26,-10},{26,-24},
            {28,-24}}, color={0,0,127}));

    connect(conPID1.y, add3.u2) annotation (Line(points={{22,-50},{26,-50},{26,-36},
            {28,-36}},      color={0,0,127}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end Controller_VariableFan_ConstantWaterFlowrate;

  package Validation

    extends Modelica.Icons.ExamplesPackage;

    block Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate
      extends Modelica.Icons.Example;
      Buildings.Fluid.ZoneEquipment.FanCoilUnit1.FCUControls.Controller_VariableFan_ConstantWaterFlowrate
        controller_VariableFan_ConstantWaterFlowrate
        annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=25)
        annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=23)
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
        amplitude=2,
        freqHz=1/60,
        offset=24)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

    equation
      connect(con.y, controller_VariableFan_ConstantWaterFlowrate.TCooSet)
        annotation (Line(points={{-38,20},{-30,20},{-30,0},{-10,0}}, color={0,0,
              127}));

      connect(con1.y, controller_VariableFan_ConstantWaterFlowrate.THeaSet)
        annotation (Line(points={{-38,-20},{-30,-20},{-30,-4},{-10,-4}}, color={0,
              0,127}));

      connect(sin.y, controller_VariableFan_ConstantWaterFlowrate.TZon)
        annotation (Line(points={{-58,50},{-20,50},{-20,4},{-10,4}}, color={0,0,
              127}));

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(StopTime=60, __Dymola_Algorithm="Dassl"));
    end Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate;
  end Validation;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}));
end Controls;
