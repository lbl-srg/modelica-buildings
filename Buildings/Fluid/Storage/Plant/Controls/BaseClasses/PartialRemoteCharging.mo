within Buildings.Fluid.Storage.Plant.Controls.BaseClasses;
partial block PartialRemoteCharging
  "Partial model for the remote charging blocks"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupToNet
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-10})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValFroNet
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,30})));
  Buildings.Controls.OBC.CDL.Logical.And andToNet
    "AND block that opens the to-network branch" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,70})));
  Buildings.Controls.OBC.CDL.Logical.And andFroNet
    "AND block that opens the from-network branch" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,30})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-10})));
  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=5,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-50})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,30}),                iconTransformation(extent={{-20,-20},
            {20,20}},
        rotation=0,
        origin={-120,20})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-10}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,90}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Modelica.Blocks.Interfaces.RealOutput yPum "Speed input of the pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-60})));
  Modelica.Blocks.Interfaces.RealInput mTan_flow "Flow rate of the tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-70}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Modelica.Blocks.Interfaces.RealOutput yVal[2] "Control signals for valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,30}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-20})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
equation
  connect(swiPumSup.y,yPum)
    annotation (Line(points={{82,-50},{110,-50}},  color={0,0,127}));
  connect(zero.y,swiPumSup. u3) annotation (Line(points={{1,-70},{30,-70},{30,
          -58},{58,-58}},
                      color={0,0,127}));
  connect(andToNet.u1, uAva) annotation (Line(points={{-22,70},{-30,70},{-30,90},
          {-110,90}}, color={255,0,255}));
  connect(conPI_pumSup.y,swiPumSup. u1) annotation (Line(points={{-39,-50},{20,
          -50},{20,-42},{58,-42}},
                                 color={0,0,127}));
  connect(booToReaValSupToNet.y,yVal [1]) annotation (Line(points={{82,-10},{90,
          -10},{90,27.5},{110,27.5}},  color={0,0,127}));
  connect(andFroNet.u1, uAva) annotation (Line(points={{-22,30},{-30,30},{-30,
          90},{-110,90}}, color={255,0,255}));
  connect(conPI_pumSup.u_m,mTan_flow)  annotation (Line(points={{-50,-62},{-50,-70},
          {-110,-70}},             color={0,0,127}));
  connect(swiValFroNet.u1,conPI_valCha. y) annotation (Line(points={{58,38},{20,
          38},{20,-10},{-39,-10}},color={0,0,127}));
  connect(swiValFroNet.u3,zero. y) annotation (Line(points={{58,22},{30,22},{30,
          -70},{1,-70}},   color={0,0,127}));
  connect(conPI_valCha.u_m,mTan_flow)  annotation (Line(points={{-50,-22},{-50,
          -30},{-80,-30},{-80,-70},{-110,-70}},
                              color={0,0,127}));
  connect(swiValFroNet.y,yVal [2]) annotation (Line(points={{82,30},{96,30},{96,
          32.5},{110,32.5}}, color={0,0,127}));
  connect(swiValFroNet.u2, andFroNet.y)
    annotation (Line(points={{58,30},{2,30}}, color={255,0,255}));
  connect(conPI_pumSup.u_s,mTanSet_flow)  annotation (Line(points={{-62,-50},{
          -90,-50},{-90,-10},{-110,-10}},
                                      color={0,0,127}));
  connect(mTanSet_flow,conPI_valCha. u_s)
    annotation (Line(points={{-110,-10},{-62,-10}}, color={0,0,127}));
  connect(booToReaValSupToNet.u, andToNet.y) annotation (Line(points={{58,-10},
          {40,-10},{40,70},{2,70}}, color={255,0,255}));
  connect(swiPumSup.u2, andToNet.y) annotation (Line(points={{58,-50},{40,-50},
          {40,70},{2,70}}, color={255,0,255}));
annotation(Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{60,60},{60,-60},{-40,-60},{-40,0}},
          color={28,108,200},
          thickness=1),
        Polygon(
          points={{-40,0},{-30,-30},{-50,-30},{-40,0}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,0},{-20,60}},
          lineColor={200,200,0},
          lineThickness=3,
          fillPattern=FillPattern.None)}));
end PartialRemoteCharging;
