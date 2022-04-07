within Buildings.Fluid.Storage.Plant.BaseClasses;
block ReversiblePumpValveControl
  "Control block for the secondary pump-valve group"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.Continuous.LimPID conPI_pumSec(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50) "PI controller" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-70,30})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) "PI controller" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-10,30})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,40}),                 iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput mTan_flow "Measured tank mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (not cut off from the network by valve)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-40}),
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
        origin={10,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDis "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-110})));
  Modelica.Blocks.Interfaces.RealInput yValCha_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-10}),
                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealInput yValDis_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-50}),
                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValDisClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumPri
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-130})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValDis
    "True = 1, false = 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-130})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
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
        origin={70,-70})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,10})));
  Buildings.Controls.OBC.CDL.Logical.And andValCha
    "Charging remotely AND valDis closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-70})));
equation

  connect(conPI_pumSec.u_s,mTanSet_flow)
    annotation (Line(points={{-82,30},{-88,30},{-88,80},{-110,80}},
                                                  color={0,0,127}));
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{-22,30},{
          -34,30},{-34,80},{-110,80}},
                                   color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow)
    annotation (Line(points={{-10,42},{-10,60},{-110,60}},
                                                       color={0,0,127}));
  connect(conPI_pumSec.u_m, mTan_flow) annotation (Line(points={{-70,42},{-70,
          60},{-110,60}},                 color={0,0,127}));
  connect(yValDis, yValDis)
    annotation (Line(points={{70,-170},{70,-170}}, color={0,0,127}));
  connect(swiPumPri.y, yPum)
    annotation (Line(points={{-50,-142},{-50,-170}}, color={0,0,127}));
  connect(zero.y, swiPumPri.u3) annotation (Line(points={{-79,-110},{-58,-110},{
          -58,-118}}, color={0,0,127}));
  connect(swiValCha.y, yValCha)
    annotation (Line(points={{10,-142},{10,-170}}, color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-79,-110},{2,-110},{2,
          -118}}, color={0,0,127}));
  connect(isValChaClo.u, yValCha_actual)
    annotation (Line(points={{-82,-10},{-110,-10}},
                                                color={0,0,127}));
  connect(isValDisClo.u, yValDis_actual)
    annotation (Line(points={{-82,-50},{-110,-50}},
                                                color={0,0,127}));
  connect(isValDisClo.y, andValCha.u2) annotation (Line(points={{-58,-50},{2,
          -50},{2,-58}},               color={255,0,255}));
  connect(andValCha.y, swiValCha.u2) annotation (Line(points={{10,-82},{10,-100},
          {10,-100},{10,-118}},color={255,0,255}));
  connect(conPI_pumSec.y, swiPumPri.u1) annotation (Line(points={{-59,30},{-42,
          30},{-42,-118}},      color={0,0,127}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{1,30},{30,30},
          {30,-100},{18,-100},{18,-118}},
                              color={0,0,127}));
  connect(and3.y, swiPumPri.u2) annotation (Line(points={{70,-82},{70,-114},{
          -50,-114},{-50,-118}},
                             color={255,0,255}));
  connect(booToReaValDis.y, yValDis)
    annotation (Line(points={{70,-142},{70,-170}}, color={0,0,127}));
  connect(and3.y, booToReaValDis.u) annotation (Line(points={{70,-82},{70,-118}},
                              color={255,0,255}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{110,40},{70,40},{70,22}}, color={255,0,255}));
  connect(andValCha.u1, uRemCha)
    annotation (Line(points={{10,-58},{10,40},{110,40}},color={255,0,255}));
  connect(and3.u3, isValChaClo.y)
    annotation (Line(points={{62,-58},{62,-10},{-58,-10}}, color={255,0,255}));
  connect(notRemCha.y, and3.u2)
    annotation (Line(points={{70,-2},{70,-58}}, color={255,0,255}));
  connect(and3.u1, uOnl)
    annotation (Line(points={{78,-58},{78,-40},{110,-40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-160},{100,100}})), Icon(
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
