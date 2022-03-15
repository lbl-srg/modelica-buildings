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
        rotation=270,
        origin={-70,70})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false) "PI controller" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-10,68})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    "Flow direction: true = normal; false = reverse" annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-70,110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput um_mTan_flow
      "Measured tank mass flow rate" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={10,110}),  iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (either outputting CHW to the network or being charged remotely)"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput yPumSec "Normalised speed" annotation (
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
        origin={70,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValDis "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-170}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealInput yValCha_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,70}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,40})));
  Modelica.Blocks.Interfaces.RealInput yValDis_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,30}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,80})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValDisClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumPri
    "Switch: true = on (y>0); false = off (y=0)." annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-130})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValDis
    "True to 1, false to 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-130})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    "Switch: true = on (y>0); false = off (y=0)." annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-130})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Plant on AND normal direction AND valCha closed" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-50})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.05)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notFloDirValCha
    "Reverses flow direction signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-16})));
  Buildings.Controls.OBC.CDL.Logical.And andValCha
    "Reverse direction AND valDis closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
equation

  connect(conPI_pumSec.u_s,mTanSet_flow)
    annotation (Line(points={{-70,82},{-70,110}}, color={0,0,127}));
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{-10,80},{-10,
          88},{-70,88},{-70,110}}, color={0,0,127}));
  connect(conPI_valCha.u_m, um_mTan_flow)
    annotation (Line(points={{2,68},{10,68},{10,110}}, color={0,0,127}));
  connect(conPI_pumSec.u_m, um_mTan_flow) annotation (Line(points={{-58,70},{-52,
          70},{-52,94},{10,94},{10,110}}, color={0,0,127}));
  connect(yValDis, yValDis)
    annotation (Line(points={{10,-170},{10,-170}}, color={0,0,127}));
  connect(swiPumPri.y, yPumSec)
    annotation (Line(points={{-50,-142},{-50,-170}}, color={0,0,127}));
  connect(zero.y, swiPumPri.u3) annotation (Line(points={{-79,-110},{-58,-110},{
          -58,-118}}, color={0,0,127}));
  connect(swiValCha.y, yValCha)
    annotation (Line(points={{70,-142},{70,-170}}, color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-79,-110},{62,-110},{62,
          -118}}, color={0,0,127}));
  connect(uOnl, and3.u3)
    annotation (Line(points={{-110,-20},{2,-20},{2,-38}}, color={255,0,255}));
  connect(booFloDir, and3.u2)
    annotation (Line(points={{-110,0},{10,0},{10,-38}}, color={255,0,255}));
  connect(isValChaClo.u, yValCha_actual)
    annotation (Line(points={{82,70},{110,70}}, color={0,0,127}));
  connect(isValChaClo.y, and3.u1)
    annotation (Line(points={{58,70},{18,70},{18,-38}}, color={255,0,255}));
  connect(isValDisClo.u, yValDis_actual)
    annotation (Line(points={{82,30},{110,30}}, color={0,0,127}));
  connect(notFloDirValCha.u, booFloDir)
    annotation (Line(points={{60,-4},{60,0},{-110,0}}, color={255,0,255}));
  connect(notFloDirValCha.y, andValCha.u1)
    annotation (Line(points={{60,-28},{60,-38}}, color={255,0,255}));
  connect(isValDisClo.y, andValCha.u2) annotation (Line(points={{58,30},{46,30},
          {46,-32},{52,-32},{52,-38}}, color={255,0,255}));
  connect(andValCha.y, swiValCha.u2) annotation (Line(points={{60,-62},{60,-70},
          {70,-70},{70,-118}}, color={255,0,255}));
  connect(conPI_pumSec.y, swiPumPri.u1) annotation (Line(points={{-70,59},{-70,10},
          {-42,10},{-42,-118}}, color={0,0,127}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{-10,57},{-10,10},
          {78,10},{78,-118}}, color={0,0,127}));
  connect(and3.y, swiPumPri.u2) annotation (Line(points={{10,-62},{10,-100},{-50,
          -100},{-50,-118}}, color={255,0,255}));
  connect(booToReaValDis.y, yValDis)
    annotation (Line(points={{10,-142},{10,-170}}, color={0,0,127}));
  connect(and3.y, booToReaValDis.u) annotation (Line(points={{10,-62},{10,-90},{
          10,-90},{10,-118}}, color={255,0,255}));
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
