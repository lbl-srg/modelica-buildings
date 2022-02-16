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
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Controls.OBC.CDL.Continuous.Switch swiFloDirVal1 "Flow direction of val2"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Controls.Continuous.LimPID conPI_pum2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=5,
    Ti=50)   "PI controller for pum2" annotation (Placement(transformation(
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
    reverseActing=false)
             "PI controller for val2" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-10,60})));
  Modelica.Blocks.Math.Gain gaiVal2(k=1) "Gain" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,30})));
  Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    "Flow direction, true = normal, false = reverse" annotation (Placement(
        transformation(extent={{-120,0},{-100,20}}),   iconTransformation(
          extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput us_mTan_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-70,110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,30})));
  Modelica.Blocks.Interfaces.RealInput um_mTan_flow
      "Measured tank mass flow rate" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={10,110}),  iconTransformation(
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
        origin={90,-80})));
  Controls.OBC.CDL.Continuous.Min minVal1 "Offline signal overrides all"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-80})));
  Controls.OBC.CDL.Interfaces.BooleanInput booOnOff
    "True = plant online, False = plant offline" annotation (Placement(
        transformation(extent={{-120,-90},{-100,-70}}), iconTransformation(
          extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput yPum2 "Normalised speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-110})));
  Modelica.Blocks.Interfaces.RealOutput yVal2 "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-110})));
  Modelica.Blocks.Interfaces.RealOutput yVal1 "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-110})));
equation

  connect(conOne.y,swiOnOff. u1) annotation (Line(points={{-79,-10},{-66,-10},{-66,
          -72},{-62,-72}},
                       color={0,0,127}));
  connect(conZero.y,swiOnOff. u3) annotation (Line(points={{-79,-50},{-72,-50},{
          -72,-88},{-62,-88}},
                         color={0,0,127}));
  connect(conZero.y,swiFloDirPum2. u3) annotation (Line(points={{-79,-50},{-60,
          -50},{-60,-38},{-52,-38}},
                              color={0,0,127}));
  connect(swiFloDirPum2.y, minPum2.u1)
    annotation (Line(points={{-28,-30},{-22,-30},{-22,-62},{-4,-62},{-4,-68}},
                                                           color={0,0,127}));
  connect(swiFloDirVal2.y, minVal2.u1)
    annotation (Line(points={{72,-30},{96,-30},{96,-68}},
                                                        color={0,0,127}));
  connect(swiFloDirVal1.y, minVal1.u1)
    annotation (Line(points={{22,-30},{22,-60},{46,-60},{46,-68}},
                                                        color={0,0,127}));
  connect(conOne.y,swiFloDirVal1. u1) annotation (Line(points={{-79,-10},{-10,
          -10},{-10,-22},{-2,-22}},
                            color={0,0,127}));
  connect(conZero.y,swiFloDirVal1. u3) annotation (Line(points={{-79,-50},{-10,
          -50},{-10,-38},{-2,-38}},
                            color={0,0,127}));
  connect(conZero.y,swiFloDirVal2. u1) annotation (Line(points={{-79,-50},{42,
          -50},{42,-22},{48,-22}},
                             color={0,0,127}));
  connect(booFloDir,swiFloDirPum2. u2) annotation (Line(points={{-110,10},{-62,
          10},{-62,-30},{-52,-30}},
                              color={255,0,255}));
  connect(conPI_pum2.y,gaiPum2. u)
    annotation (Line(points={{-70,49},{-70,42}},   color={0,0,127}));
  connect(gaiPum2.y,swiFloDirPum2. u1)
    annotation (Line(points={{-70,19},{-70,-22},{-52,-22}},
                                                          color={0,0,127}));
  connect(conPI_val2.y,gaiVal2. u) annotation (Line(points={{-10,49},{-10,45.5},
          {-10,45.5},{-10,42}},   color={0,0,127}));
  connect(gaiVal2.y,swiFloDirVal2. u3)
    annotation (Line(points={{-10,19},{-10,0},{30,0},{30,-38},{48,-38}},
                                                         color={0,0,127}));
    connect(conPI_pum2.u_s, us_mTan_flow)
      annotation (Line(points={{-70,72},{-70,110}}, color={0,0,127}));
    connect(conPI_val2.u_s, us_mTan_flow) annotation (Line(points={{-10,72},{
          -10,96},{-70,96},{-70,110}},
                                     color={0,0,127}));
    connect(conPI_val2.u_m, um_mTan_flow) annotation (Line(points={{2,60},{10,
          60},{10,110}},                     color={0,0,127}));
    connect(conPI_pum2.u_m, um_mTan_flow) annotation (Line(points={{-58,60},{
          -50,60},{-50,90},{10,90},{10,110}}, color={0,0,127}));
  connect(swiOnOff.u2, booOnOff)
    annotation (Line(points={{-62,-80},{-110,-80}}, color={255,0,255}));
  connect(swiOnOff.y, minPum2.u2) annotation (Line(points={{-38,-80},{-34,-80},{
          -34,-56},{-16,-56},{-16,-68}}, color={0,0,127}));
  connect(swiOnOff.y, minVal2.u2) annotation (Line(points={{-38,-80},{-34,-80},
          {-34,-56},{84,-56},{84,-68}},color={0,0,127}));
  connect(swiOnOff.y, minVal1.u2) annotation (Line(points={{-38,-80},{-34,-80},
          {-34,-56},{34,-56},{34,-68}},color={0,0,127}));
  connect(minPum2.y, yPum2) annotation (Line(points={{-10,-92},{-10,-110}},
                       color={0,0,127}));
  connect(minVal2.y, yVal2)
    annotation (Line(points={{90,-92},{90,-110}}, color={0,0,127}));
  connect(minVal1.y, yVal1)
    annotation (Line(points={{40,-92},{40,-110}}, color={0,0,127}));
  connect(swiFloDirVal2.u2, booFloDir) annotation (Line(points={{48,-30},{40,
          -30},{40,10},{-110,10}}, color={255,0,255}));
  connect(swiFloDirVal1.u2, booFloDir) annotation (Line(points={{-2,-30},{-20,
          -30},{-20,10},{-110,10}},color={255,0,255}));
  connect(yVal1, yVal1)
    annotation (Line(points={{40,-110},{40,-110}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end ReversiblePumpValveControl;
