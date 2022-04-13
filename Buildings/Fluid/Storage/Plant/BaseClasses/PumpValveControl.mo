within Buildings.Fluid.Storage.Plant.BaseClasses;
block PumpValveControl
  "Control block for the supply pump and nearby valves"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean tankIsOpen = false "Tank is open";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.Continuous.LimPID conPI_pumSecNor(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) "Normal-acting PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,10})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if not tankIsOpen "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,50})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,110}),                iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,100})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-130,70}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,20})));
  Modelica.Blocks.Interfaces.RealInput mTan_flow "Measured tank mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (not cut off from the network by valve)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,50}),
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
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValChaMod
    "Valve position, modulating signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-170}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDisOn
    "Valve position, on-off signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-110})));
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
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValDisClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
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
    "Plant online AND not charging remotely AND valCha closed"
                                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,30})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,90})));
  Buildings.Controls.OBC.CDL.Logical.And andValCha
    "Charging remotely AND valDis closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValCha if tankIsOpen
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-130})));
  Buildings.Controls.Continuous.LimPID conPI_pumSecRev(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=true) "Reverse-acting PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,10})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumAct
    "True = mTanSet_flow > 0, reverse acting; false = mTanSet_flow < 0, normal acting"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-70})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isPos(t=0)
    "= true if mTanSet_flow > 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-30})));
  Modelica.Blocks.Interfaces.RealOutput yValChaOn if tankIsOpen
    "Valve position, on-off signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDisMod if tankIsOpen
    "Valve position, modulating signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValDis if tankIsOpen
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-130})));
  Modelica.Blocks.Interfaces.RealInput pCHWSSet if tankIsOpen
    "Pressure setpoint at supply line" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-10}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,20})));
  Modelica.Blocks.Interfaces.RealInput pCHWRSet if tankIsOpen
    "Pressure setpoint at return line" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-30}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-20})));
  Modelica.Blocks.Interfaces.RealInput pCHWS if tankIsOpen
    "Pressure at supply line" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-50}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-100})));
  Modelica.Blocks.Interfaces.RealInput pCHWR if tankIsOpen
    "Pressure at return line" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-70}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-60})));
  Buildings.Controls.Continuous.LimPID conPI_valChaMod(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if tankIsOpen "PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={30,-50})));
  Buildings.Controls.Continuous.LimPID conPI_valDisMod(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if tankIsOpen "PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={90,-70})));

equation
  connect(conPI_pumSecNor.u_m, mTan_flow) annotation (Line(points={{-28,10},{
          -22,10},{-22,-8},{-100,-8},{-100,50},{-130,50}},
                                   color={0,0,127}));
  connect(conPI_pumSecNor.u_s, mTanSet_flow)
    annotation (Line(points={{-40,22},{-40,70},{-130,70}}, color={0,0,127}));
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{-10,62},{
          -10,70},{-130,70}},      color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow)
    annotation (Line(points={{-22,50},{-130,50}},      color={0,0,127}));
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
    annotation (Line(points={{18,70},{14,70},{14,110},{-112,110},{-112,-10},{
          -130,-10}},                           color={0,0,127}));
  connect(isValDisClo.u, yValDis_actual)
    annotation (Line(points={{18,30},{8,30},{8,104},{-106,104},{-106,-50},{-130,
          -50}},                                color={0,0,127}));
  connect(isValDisClo.y, andValCha.u2) annotation (Line(points={{42,30},{62,30},
          {62,22}},                    color={255,0,255}));
  connect(andValCha.y, swiValCha.u2) annotation (Line(points={{70,-2},{70,-80},
          {10,-80},{10,-112},{-20,-112},{-20,-118}},
                               color={255,0,255}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{-10,39},{-10,
          -70},{-12,-70},{-12,-118}},
                              color={0,0,127}));
  connect(and3.y, swiPum.u2) annotation (Line(points={{110,18},{110,-100},{-70,
          -100},{-70,-118}},
                       color={255,0,255}));
  connect(booToReaValDis.y, yValDisOn)
    annotation (Line(points={{90,-142},{90,-170}}, color={0,0,127}));
  connect(and3.y, booToReaValDis.u) annotation (Line(points={{110,18},{110,-100},
          {90,-100},{90,-118}},
                              color={255,0,255}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{130,110},{110,110},{110,102}},
                                                        color={255,0,255}));
  connect(andValCha.u1, uRemCha)
    annotation (Line(points={{70,22},{70,110},{130,110}},
                                                        color={255,0,255}));
  connect(and3.u3, isValChaClo.y)
    annotation (Line(points={{102,42},{102,70},{42,70}},   color={255,0,255}));
  connect(notRemCha.y, and3.u2)
    annotation (Line(points={{110,78},{110,42}},color={255,0,255}));
  connect(andValCha.y, booToReaValCha.u) annotation (Line(points={{70,-2},{70,
          -80},{10,-80},{10,-118}},
                                color={255,0,255}));
  connect(conPI_pumSecRev.u_m, mTan_flow) annotation (Line(points={{-92,10},{
          -100,10},{-100,50},{-130,50}},
                                   color={0,0,127}));
  connect(conPI_pumSecRev.u_s, mTanSet_flow)
    annotation (Line(points={{-80,22},{-80,70},{-130,70}}, color={0,0,127}));
  connect(conPI_pumSecNor.y, swiPumAct.u1)
    annotation (Line(points={{-40,-1},{-40,-58},{-52,-58}}, color={0,0,127}));
  connect(conPI_pumSecRev.y, swiPumAct.u3)
    annotation (Line(points={{-80,-1},{-80,-58},{-68,-58}}, color={0,0,127}));
  connect(isPos.u, mTanSet_flow)
    annotation (Line(points={{-60,-18},{-60,70},{-130,70}}, color={0,0,127}));
  connect(swiPumAct.y, swiPum.u1) annotation (Line(points={{-60,-82},{-60,-110},
          {-62,-110},{-62,-118}}, color={0,0,127}));
  connect(isPos.y, swiPumAct.u2)
    annotation (Line(points={{-60,-42},{-60,-58}}, color={255,0,255}));
  connect(yValChaOn, booToReaValCha.y)
    annotation (Line(points={{10,-170},{10,-142}}, color={0,0,127}));

  connect(swiValDis.u2, and3.y) annotation (Line(points={{60,-118},{60,-100},{
          110,-100},{110,18}}, color={255,0,255}));
  connect(swiValDis.y, yValDisMod)
    annotation (Line(points={{60,-142},{60,-170}}, color={0,0,127}));
  connect(zero.y, swiValDis.u3)
    annotation (Line(points={{-99,-90},{52,-90},{52,-118}}, color={0,0,127}));
  connect(conPI_valChaMod.u_m, pCHWS)
    annotation (Line(points={{42,-50},{130,-50}}, color={0,0,127}));
  connect(conPI_valChaMod.u_s, pCHWSSet)
    annotation (Line(points={{30,-38},{30,-10},{130,-10}}, color={0,0,127}));
  connect(conPI_valChaMod.y, swiValCha.u1) annotation (Line(points={{30,-61},{
          30,-70},{-12,-70},{-12,-118}}, color={0,0,127}));
  connect(pCHWR, conPI_valDisMod.u_m)
    annotation (Line(points={{130,-70},{102,-70}}, color={0,0,127}));
  connect(conPI_valDisMod.u_s, pCHWRSet)
    annotation (Line(points={{90,-58},{90,-30},{130,-30}}, color={0,0,127}));
  connect(conPI_valDisMod.y, swiValDis.u1) annotation (Line(points={{90,-81},{
          90,-90},{68,-90},{68,-118}}, color={0,0,127}));
  connect(and3.u1, uOnl)
    annotation (Line(points={{118,42},{118,50},{130,50}}, color={255,0,255}));
  annotation (
  defaultComponentName="conPumVal",
  Diagram(coordinateSystem(extent={{-120,-160},{120,120}})), Icon(
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
