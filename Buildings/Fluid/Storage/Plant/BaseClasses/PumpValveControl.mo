within Buildings.Fluid.Storage.Plant.BaseClasses;
block PumpValveControl
  "Control block for the supply pump and nearby valves"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean tankIsOpen = false "Tank is open";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if not tankIsOpen "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={10,10})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={210,110}),                iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,100})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-130,88}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput mTanBot_flow
    "Flow rate measured at the bottom of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (not cut off from the network by valve)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={210,30}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,60})));
  Modelica.Blocks.Interfaces.RealOutput yPum "Normalised speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValChaMod
    "Valve position, modulating signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-170}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDisOn
    "Valve position, on-off signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-110})));
  Modelica.Blocks.Interfaces.RealInput yValCha_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,-10}),
                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-100})));
  Modelica.Blocks.Interfaces.RealInput yValDis_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,-50}),
                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValDisClo(t=0.01)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPum
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-130})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValDis
    "True = 1, false = 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-130})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-130})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Plant online AND not charging remotely AND valCha closed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,10})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.01)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,70})));
  Buildings.Controls.OBC.CDL.Logical.And andValCha
    "Charging remotely AND valDis closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValCha if tankIsOpen
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-130})));
  Buildings.Controls.Continuous.LimPID conPI_pumSecNeg(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=true) "PI controller for negative tank flow"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,10})));
  Modelica.Blocks.Interfaces.RealOutput yValChaOn if tankIsOpen
    "Valve position, on-off signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDisMod if tankIsOpen
    "Valve position, modulating signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValDis if tankIsOpen
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-130})));
  Buildings.Controls.Continuous.LimPID conPI_valChaMod(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if tankIsOpen "PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,10})));
  Buildings.Controls.Continuous.LimPID conPI_valDisMod(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=true)  if tankIsOpen "PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={90,10})));

  Modelica.Blocks.Interfaces.RealInput mTanTop_flow if tankIsOpen
    "Flow rate measured at the top of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,68}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  Controls.Continuous.LimPID conPI_pumSecPos(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) "PI controller for positive tank flow" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,10})));
  Controls.OBC.CDL.Continuous.LessThreshold isPos(t=0)
    "= true tank flow setpoint is positive" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-30})));
  Controls.OBC.CDL.Continuous.Switch           swiPum1
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-70})));
equation
  if tankIsOpen then
    connect(uOnl, swiPum.u2) annotation (Line(points={{210,30},{190,30},{190,
            -100},{-70,-100},{-70,-118}},
                                 color={255,0,255}));
  else
    connect(and3.y, swiPum.u2) annotation (Line(points={{170,-2},{170,-100},{-70,
          -100},{-70,-118}}, color={255,0,255}));
  end if;

  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{10,22},{10,
          28},{-70,28},{-70,88},{-130,88}},
                                   color={0,0,127}));
  connect(conPI_valCha.u_m, mTanBot_flow) annotation (Line(points={{22,10},{28,
          10},{28,50},{-130,50}},
                              color={0,0,127}));
  connect(yValDisOn, yValDisOn)
    annotation (Line(points={{90,-170},{90,-170}}, color={0,0,127}));
  connect(swiPum.y, yPum)
    annotation (Line(points={{-70,-142},{-70,-170}}, color={0,0,127}));
  connect(zero.y, swiPum.u3) annotation (Line(points={{-99,-90},{-78,-90},{-78,
          -118}},
        color={0,0,127}));
  connect(swiValCha.y, yValChaMod)
    annotation (Line(points={{-20,-142},{-20,-170}},
                                                   color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-99,-90},{-28,-90},{
          -28,-118}},
                  color={0,0,127}));
  connect(isValChaClo.u, yValCha_actual)
    annotation (Line(points={{38,150},{-106,150},{-106,-10},{-130,-10}},
                                                color={0,0,127}));
  connect(isValDisClo.u, yValDis_actual)
    annotation (Line(points={{38,110},{-100,110},{-100,-50},{-130,-50}},
                                                color={0,0,127}));
  connect(isValDisClo.y, andValCha.u2) annotation (Line(points={{62,110},{122,
          110},{122,22}},              color={255,0,255}));
  connect(andValCha.y, swiValCha.u2) annotation (Line(points={{130,-2},{130,-80},
          {10,-80},{10,-112},{-20,-112},{-20,-118}},
                               color={255,0,255}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{10,-1},{10,
          -20},{-12,-20},{-12,-118}},
                              color={0,0,127}));
  connect(booToReaValDis.y, yValDisOn)
    annotation (Line(points={{90,-142},{90,-170}}, color={0,0,127}));
  connect(and3.y, booToReaValDis.u) annotation (Line(points={{170,-2},{170,-100},
          {90,-100},{90,-118}}, color={255,0,255}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{210,110},{180,110},{180,82}},
                                                        color={255,0,255}));
  connect(andValCha.u1, uRemCha)
    annotation (Line(points={{130,22},{130,110},{210,110}},
                                                        color={255,0,255}));
  connect(and3.u3, isValChaClo.y)
    annotation (Line(points={{162,22},{162,150},{62,150}}, color={255,0,255}));
  connect(notRemCha.y, and3.u2) annotation (Line(points={{180,58},{180,40},{170,
          40},{170,22}}, color={255,0,255}));
  connect(andValCha.y, booToReaValCha.u) annotation (Line(points={{130,-2},{130,
          -80},{10,-80},{10,-118}},
                                color={255,0,255}));
  connect(conPI_pumSecNeg.u_m, mTanBot_flow) annotation (Line(points={{-82,10},{
          -90,10},{-90,50},{-130,50}}, color={0,0,127}));
  connect(conPI_pumSecNeg.u_s, mTanSet_flow)
    annotation (Line(points={{-70,22},{-70,88},{-130,88}}, color={0,0,127}));
  connect(yValChaOn, booToReaValCha.y)
    annotation (Line(points={{10,-170},{10,-142}}, color={0,0,127}));

  connect(swiValDis.u2, and3.y) annotation (Line(points={{60,-118},{60,-100},{
          170,-100},{170,-2}}, color={255,0,255}));
  connect(swiValDis.y, yValDisMod)
    annotation (Line(points={{60,-142},{60,-170}}, color={0,0,127}));
  connect(zero.y, swiValDis.u3)
    annotation (Line(points={{-99,-90},{52,-90},{52,-118}}, color={0,0,127}));
  connect(conPI_valChaMod.y, swiValCha.u1) annotation (Line(points={{50,-1},{50,
          -20},{-12,-20},{-12,-118}},    color={0,0,127}));
  connect(conPI_valDisMod.y, swiValDis.u1) annotation (Line(points={{90,-1},{90,
          -20},{68,-20},{68,-118}},    color={0,0,127}));
  connect(and3.u1, uOnl)
    annotation (Line(points={{178,22},{178,30},{210,30}}, color={255,0,255}));
  connect(mTanSet_flow, conPI_valChaMod.u_s)
    annotation (Line(points={{-130,88},{-70,88},{-70,28},{50,28},{50,22}},
                                                         color={0,0,127}));
  connect(mTanSet_flow, conPI_valDisMod.u_s)
    annotation (Line(points={{-130,88},{-70,88},{-70,28},{90,28},{90,22}},
                                                         color={0,0,127}));

  connect(conPI_pumSecPos.u_s, mTanSet_flow) annotation (Line(points={{-30,22},
          {-30,28},{-70,28},{-70,88},{-130,88}}, color={0,0,127}));
  connect(conPI_pumSecPos.u_m, mTanBot_flow) annotation (Line(points={{-18,10},
          {-12,10},{-12,50},{-130,50}}, color={0,0,127}));
  connect(mTanSet_flow, isPos.u) annotation (Line(points={{-130,88},{-70,88},{
          -70,28},{-50,28},{-50,-18}}, color={0,0,127}));
  connect(swiPum1.y, swiPum.u1) annotation (Line(points={{-50,-82},{-50,-110},{
          -62,-110},{-62,-118}}, color={0,0,127}));
  connect(isPos.y, swiPum1.u2)
    annotation (Line(points={{-50,-42},{-50,-58}}, color={255,0,255}));
  connect(conPI_pumSecPos.y, swiPum1.u1) annotation (Line(points={{-30,-1},{-30,
          -50},{-42,-50},{-42,-58}}, color={0,0,127}));
  connect(conPI_pumSecNeg.y, swiPum1.u3) annotation (Line(points={{-70,-1},{-70,
          -50},{-58,-50},{-58,-58}}, color={0,0,127}));
  connect(mTanTop_flow, conPI_valDisMod.u_m) annotation (Line(points={{-130,68},
          {108,68},{108,10},{102,10}}, color={0,0,127}));
  connect(conPI_valChaMod.u_m, mTanBot_flow) annotation (Line(points={{62,10},{
          70,10},{70,50},{-130,50}}, color={0,0,127}));
  annotation (
  defaultComponentName="conPumVal",
  Diagram(coordinateSystem(extent={{-120,-160},{200,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>", info="<html>
<p>
This is a control block for the secondary pump-valve group in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.ChillerAndTank\">
Buildings.Fluid.Storage.Plant.ChillerAndTank</a>.
This block is conditionally enabled when the plant is configured to allow
remotely charging the tank.
</p>
</html>"));
end PumpValveControl;
