within Buildings.Fluid.Storage.Plant.BaseClasses;
block ReversiblePumpValveControl
  "Control block for the secondary pump-valve group"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Sources.Constant conOne(k=1) "Constant y = 1"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Controls.OBC.CDL.Continuous.Switch swiOnOff "Online/offline switch"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Sources.Constant conZero(k=0) "Constant y = 0"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Controls.OBC.CDL.Continuous.Switch swiFloDirPum2 "Flow direction of pum2"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Controls.OBC.CDL.Continuous.Switch swiFloDirVal2 "Flow direction of val2"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Controls.OBC.CDL.Continuous.Switch swiFloDirVal1 "Flow direction of val2"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Controls.Continuous.LimPID conPI_pum2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=5,
    Ti=50,
    yMin=-1) "PI controller for pum2" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-70,60})));
  Modelica.Blocks.Math.Gain gaiPum2(k=1) "Gain" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,30})));
  Controls.Continuous.LimPID conPI_val2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=5,
    Ti=50,
    yMin=-1) "PI controller for val2" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-20,60})));
  Modelica.Blocks.Math.Gain gaiVal2(k=1) "Gain" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
  Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    "Flow direction, true = normal, false = reverse" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput us_mTan_flow
      "Tank mass flow rate setpoint" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-70,120}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,30})));
  Modelica.Blocks.Interfaces.RealInput um_mTan_flow
      "Measured tank mass flow rate" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={-10,120}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,70})));
  Controls.OBC.CDL.Continuous.Min minPum2 "Offline signal overrides all"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-80})));
  Controls.OBC.CDL.Continuous.Min minVal2 "Offline signal overrides all"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-80})));
  Controls.OBC.CDL.Continuous.Min minVal1 "Offline signal overrides all"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-80})));
  Controls.OBC.CDL.Interfaces.BooleanInput onOffLin
    "Plant online/offline signal, true = online, false = offline" annotation (
      Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput yPum2 "Normalised speed" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-10,-120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-110})));
  Modelica.Blocks.Interfaces.RealOutput yVal2 "Valve position" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={30,-120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-110})));
  Modelica.Blocks.Interfaces.RealOutput yVal1 "Valve position" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={70,-120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-110})));
equation

  connect(conOne.y,swiOnOff. u1) annotation (Line(points={{-79,-10},{-66,-10},{-66,
          -72},{-62,-72}},
                       color={0,0,127}));
  connect(conZero.y,swiOnOff. u3) annotation (Line(points={{-79,-50},{-72,-50},{
          -72,-88},{-62,-88}},
                         color={0,0,127}));
  connect(conZero.y,swiFloDirPum2. u3) annotation (Line(points={{-79,-50},{-60,-50},
          {-60,-38},{-52,-38}},
                              color={0,0,127}));
  connect(swiFloDirPum2.y, minPum2.u1)
    annotation (Line(points={{-28,-30},{-22,-30},{-22,-62},{-4,-62},{-4,-68}},
                                                           color={0,0,127}));
  connect(swiFloDirVal2.y, minVal2.u1)
    annotation (Line(points={{22,-30},{36,-30},{36,-68}},
                                                        color={0,0,127}));
  connect(swiFloDirVal1.y, minVal1.u1)
    annotation (Line(points={{72,-30},{76,-30},{76,-68}},
                                                        color={0,0,127}));
  connect(conOne.y,swiFloDirVal1. u1) annotation (Line(points={{-79,-10},{40,-10},
          {40,-22},{48,-22}},
                            color={0,0,127}));
  connect(conZero.y,swiFloDirVal1. u3) annotation (Line(points={{-79,-50},{40,-50},
          {40,-38},{48,-38}},
                            color={0,0,127}));
  connect(conZero.y,swiFloDirVal2. u1) annotation (Line(points={{-79,-50},{-10,-50},
          {-10,-22},{-2,-22}},
                             color={0,0,127}));
  connect(booFloDir,swiFloDirPum2. u2) annotation (Line(points={{-120,10},{-56,10},
          {-56,-30},{-52,-30}},
                              color={255,0,255}));
  connect(booFloDir,swiFloDirVal2. u2) annotation (Line(points={{-120,10},{-6,10},
          {-6,-30},{-2,-30}},
                            color={255,0,255}));
  connect(booFloDir,swiFloDirVal1. u2) annotation (Line(points={{-120,10},{46,10},
          {46,-30},{48,-30}},
                            color={255,0,255}));
  connect(conPI_pum2.y,gaiPum2. u)
    annotation (Line(points={{-70,49},{-70,42}},   color={0,0,127}));
  connect(gaiPum2.y,swiFloDirPum2. u1)
    annotation (Line(points={{-70,19},{-70,-22},{-52,-22}},
                                                          color={0,0,127}));
  connect(conPI_val2.y,gaiVal2. u) annotation (Line(points={{-20,49},{-20,42}},
                                  color={0,0,127}));
  connect(gaiVal2.y,swiFloDirVal2. u3)
    annotation (Line(points={{-20,19},{-20,-38},{-2,-38}},
                                                         color={0,0,127}));
    connect(conPI_pum2.u_s, us_mTan_flow)
      annotation (Line(points={{-70,72},{-70,120}}, color={0,0,127}));
    connect(conPI_val2.u_s, us_mTan_flow) annotation (Line(points={{-20,72},{-20,
            94},{-70,94},{-70,120}}, color={0,0,127}));
    connect(conPI_val2.u_m, um_mTan_flow) annotation (Line(points={{-8,60},{-2,
            60},{-2,96},{-10,96},{-10,120}}, color={0,0,127}));
    connect(conPI_pum2.u_m, um_mTan_flow) annotation (Line(points={{-58,60},{-52,
            60},{-52,96},{-10,96},{-10,120}}, color={0,0,127}));
  connect(swiOnOff.u2, onOffLin)
    annotation (Line(points={{-62,-80},{-120,-80}}, color={255,0,255}));
  connect(swiOnOff.y, minPum2.u2) annotation (Line(points={{-38,-80},{-34,-80},{
          -34,-56},{-16,-56},{-16,-68}}, color={0,0,127}));
  connect(swiOnOff.y, minVal2.u2) annotation (Line(points={{-38,-80},{-34,-80},{
          -34,-56},{24,-56},{24,-68}}, color={0,0,127}));
  connect(swiOnOff.y, minVal1.u2) annotation (Line(points={{-38,-80},{-34,-80},{
          -34,-56},{64,-56},{64,-68}}, color={0,0,127}));
  connect(minPum2.y, yPum2) annotation (Line(points={{-10,-92},{-10,-106},{-10,-106},
          {-10,-120}}, color={0,0,127}));
  connect(minVal2.y, yVal2)
    annotation (Line(points={{30,-92},{30,-120}}, color={0,0,127}));
  connect(minVal1.y, yVal1)
    annotation (Line(points={{70,-92},{70,-120}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end ReversiblePumpValveControl;
