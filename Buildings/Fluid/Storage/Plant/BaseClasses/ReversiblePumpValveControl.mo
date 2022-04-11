within Buildings.Fluid.Storage.Plant.BaseClasses;
block ReversiblePumpValveControl
  "Control block for the secondary pump-valve group"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean tankIsOpen = false "Tank is open";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.Continuous.LimPID conPI_pumSecNor(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) "Normal-acting PI controller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,30})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) if not tankIsOpen
                         "PI controller" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-10,90})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,40}),                 iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-130,90}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput mTan_flow "Measured tank mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,70}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (not cut off from the network by valve)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-40}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,40})));
  Modelica.Blocks.Interfaces.RealOutput yPum "Normalised speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValCha "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDis "Valve position" annotation (
      Placement(transformation(
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
        origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealInput yValDis_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-130,-50}),
                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValDisClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPum
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-130})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValDis
    "True = 1, false = 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-130})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha if not tankIsOpen
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-130})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Plant online AND not charging remotely AND valCha closed"
                                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-70})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,10})));
  Buildings.Controls.OBC.CDL.Logical.And andValCha
    "Charging remotely AND valDis closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-70})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaValCha if tankIsOpen
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-130})));
  Controls.Continuous.LimPID conPI_pumSecRev(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=true) "Reverse-acting PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,30})));
  Controls.OBC.CDL.Continuous.Switch           swiPumPri1
    "True = mTanSet_flow > 0, reverse acting; false = mTanSet_flow < 0, normal acting"
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-70})));
  Controls.OBC.CDL.Continuous.LessThreshold isPos(t=0)
    "= true if mTanSet_flow > 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-30})));
equation

  connect(conPI_pumSecNor.u_m, mTan_flow) annotation (Line(points={{-18,30},{-10,
          30},{-10,70},{-130,70}}, color={0,0,127}));
  connect(conPI_pumSecNor.u_s, mTanSet_flow)
    annotation (Line(points={{-30,42},{-30,90},{-130,90}}, color={0,0,127}));
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{-22,90},{-130,
          90}},                    color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow)
    annotation (Line(points={{-10,102},{-10,110},{-90,110},{-90,70},{-130,70}},
                                                       color={0,0,127}));
  connect(yValDis, yValDis)
    annotation (Line(points={{90,-170},{90,-170}}, color={0,0,127}));
  connect(swiPum.y, yPum)
    annotation (Line(points={{-50,-142},{-50,-170}}, color={0,0,127}));
  connect(zero.y, swiPum.u3) annotation (Line(points={{-79,-90},{-58,-90},{-58,-118}},
        color={0,0,127}));
  connect(swiValCha.y, yValCha)
    annotation (Line(points={{10,-142},{10,-154},{30,-154},{30,-170}},
                                                   color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-79,-90},{2,-90},{2,-118}},
                  color={0,0,127}));
  connect(isValChaClo.u, yValCha_actual)
    annotation (Line(points={{38,-10},{-130,-10}},
                                                color={0,0,127}));
  connect(isValDisClo.u, yValDis_actual)
    annotation (Line(points={{-22,-50},{-130,-50}},
                                                color={0,0,127}));
  connect(isValDisClo.y, andValCha.u2) annotation (Line(points={{2,-50},{22,-50},
          {22,-58}},                   color={255,0,255}));
  connect(andValCha.y, swiValCha.u2) annotation (Line(points={{30,-82},{30,-110},
          {10,-110},{10,-118}},color={255,0,255}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{1,90},{18,90},
          {18,-118}},         color={0,0,127}));
  connect(and3.y, swiPum.u2) annotation (Line(points={{90,-82},{90,-100},{-50,-100},
          {-50,-118}}, color={255,0,255}));
  connect(booToReaValDis.y, yValDis)
    annotation (Line(points={{90,-142},{90,-170}}, color={0,0,127}));
  connect(and3.y, booToReaValDis.u) annotation (Line(points={{90,-82},{90,-118}},
                              color={255,0,255}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{130,40},{90,40},{90,22}}, color={255,0,255}));
  connect(andValCha.u1, uRemCha)
    annotation (Line(points={{30,-58},{30,40},{130,40}},color={255,0,255}));
  connect(and3.u3, isValChaClo.y)
    annotation (Line(points={{82,-58},{82,-10},{62,-10}},  color={255,0,255}));
  connect(notRemCha.y, and3.u2)
    annotation (Line(points={{90,-2},{90,-58}}, color={255,0,255}));
  connect(and3.u1, uOnl)
    annotation (Line(points={{98,-58},{98,-40},{130,-40}}, color={255,0,255}));
  connect(booToReaValCha.y, yValCha) annotation (Line(points={{50,-142},{50,-154},
          {30,-154},{30,-170}}, color={0,0,127}));
  connect(andValCha.y, booToReaValCha.u) annotation (Line(points={{30,-82},{30,-110},
          {50,-110},{50,-118}}, color={255,0,255}));
  connect(conPI_pumSecRev.u_m, mTan_flow) annotation (Line(points={{-82,30},{-90,
          30},{-90,70},{-130,70}}, color={0,0,127}));
  connect(conPI_pumSecRev.u_s, mTanSet_flow)
    annotation (Line(points={{-70,42},{-70,90},{-130,90}}, color={0,0,127}));
  connect(conPI_pumSecNor.y, swiPumPri1.u1)
    annotation (Line(points={{-30,19},{-30,-58},{-42,-58}}, color={0,0,127}));
  connect(conPI_pumSecRev.y, swiPumPri1.u3)
    annotation (Line(points={{-70,19},{-70,-58},{-58,-58}}, color={0,0,127}));
  connect(isPos.u, mTanSet_flow)
    annotation (Line(points={{-50,-18},{-50,90},{-130,90}}, color={0,0,127}));
  connect(swiPumPri1.y, swiPum.u1) annotation (Line(points={{-50,-82},{-50,-96},
          {-42,-96},{-42,-118}}, color={0,0,127}));
  connect(isPos.y, swiPumPri1.u2)
    annotation (Line(points={{-50,-42},{-50,-58}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-160},{120,120}})), Icon(
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
end ReversiblePumpValveControl;
