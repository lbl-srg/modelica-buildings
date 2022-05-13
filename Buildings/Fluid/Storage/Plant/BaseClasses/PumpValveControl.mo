within Buildings.Fluid.Storage.Plant.BaseClasses;
block PumpValveControl
  "Control block for the supply pump and nearby valves that allows remote charging"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Type of plant setup";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=10,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,10})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={230,70}),                 iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,70}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput mTanBot_flow
    "Flow rate measured at the bottom of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,30}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={230,28}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,40})));
  Modelica.Blocks.Interfaces.RealOutput yPumSup
    "Speed input of the supply pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValOut
    "True = 1, false = 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-70})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-70})));
  Buildings.Controls.OBC.CDL.Logical.And andOut
    "Outputting = plant available AND no remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,10})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={182,50})));
  Buildings.Controls.OBC.CDL.Logical.And andCha
    "Charging = plant available AND remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,10})));
  Buildings.Controls.Continuous.LimPID conPI_pumRet(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=10,
    reverseActing=false)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));
  Buildings.Controls.Continuous.LimPID conPI_valOut(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=10,
    reverseActing=true)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,10})));

  Modelica.Blocks.Interfaces.RealInput mTanTop_flow
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Flow rate measured at the top of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));

  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=10,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,10})));
  Modelica.Blocks.Interfaces.RealOutput yValSup[2]
    "Control signals for valves on the supply line"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yRet[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for valves on the return line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-70})));
  Modelica.Blocks.Interfaces.RealOutput yPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxiliary pump on the return line" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValOut
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValCha
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,-70})));

initial equation
  assert(plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
  or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote,
  "To use this block, the only values allowed for plaTyp is
  .Open or .ClosedRemote");
equation
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{-10,22},{
          -10,70},{-110,70}},      color={0,0,127}));
  connect(conPI_valCha.u_m, mTanBot_flow) annotation (Line(points={{-22,10},{-30,
          10},{-30,30},{-110,30}},
                              color={0,0,127}));
  connect(swiPumSup.y, yPumSup)
    annotation (Line(points={{-70,-82},{-70,-110}},  color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-79,-30},{-74,-30},{-74,
          -50},{-78,-50},{-78,-58}},
                      color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-79,-30},{22,-30},{22,
          -58}},  color={0,0,127}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{-10,-1},{-10,-10},
          {38,-10},{38,-58}}, color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{230,70},{182,70},{182,62}},
                                                        color={255,0,255}));
  connect(notRemCha.y, andOut.u2) annotation (Line(points={{182,38},{182,22}},
                         color={255,0,255}));
  connect(conPI_pumRet.u_s, mTanSet_flow)
    annotation (Line(points={{50,22},{50,70},{-110,70}}, color={0,0,127}));

  connect(andOut.u1, uAva)
    annotation (Line(points={{190,22},{190,28},{230,28}}, color={255,0,255}));
  connect(mTanSet_flow, conPI_valOut.u_s)
    annotation (Line(points={{-110,70},{110,70},{110,22}}, color={0,0,127}));

  connect(conPI_pumSup.u_s, mTanSet_flow)
    annotation (Line(points={{-70,22},{-70,70},{-110,70}}, color={0,0,127}));
  connect(conPI_pumSup.u_m, mTanBot_flow) annotation (Line(points={{-82,10},{-90,
          10},{-90,30},{-110,30}}, color={0,0,127}));
  connect(mTanTop_flow, conPI_valOut.u_m) annotation (Line(points={{-110,50},{
          90,50},{90,10},{98,10}},color={0,0,127}));
  connect(andOut.y, swiPumSup.u2) annotation (Line(points={{190,-2},{190,-40},{-70,
          -40},{-70,-58}}, color={255,0,255}));
  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{-70,-1},{-70,-10},
          {-62,-10},{-62,-58}},  color={0,0,127}));
  connect(conPI_pumRet.y, swiPumRet.u1) annotation (Line(points={{50,-1},{50,-10},
          {98,-10},{98,-58}}, color={0,0,127}));
  connect(swiPumRet.u3, zero.y)
    annotation (Line(points={{82,-58},{82,-30},{-79,-30}}, color={0,0,127}));
  connect(swiPumRet.y, yPumRet)
    annotation (Line(points={{90,-82},{90,-110}},  color={0,0,127}));
  connect(swiValOut.u2, andOut.y) annotation (Line(points={{190,-58},{190,-2}},
                              color={255,0,255}));
  connect(conPI_valOut.y, swiValOut.u1) annotation (Line(points={{110,-1},{110,-10},
          {198,-10},{198,-58}},  color={0,0,127}));
  connect(swiValOut.u3, zero.y) annotation (Line(points={{182,-58},{182,-30},{-79,
          -30}},      color={0,0,127}));
  connect(booToReaValOut.u, andOut.y) annotation (Line(points={{-10,-58},{-10,-40},
          {190,-40},{190,-2}}, color={255,0,255}));
  connect(booToReaValOut.y, yValSup[1]) annotation (Line(points={{-10,-82},{-10,
          -94},{10,-94},{10,-112.5}},       color={0,0,127}));
  connect(swiValCha.y, yValSup[2]) annotation (Line(points={{30,-82},{30,-94},{10,
          -94},{10,-107.5}},      color={0,0,127}));
  connect(conPI_pumRet.u_m, mTanTop_flow) annotation (Line(points={{38,10},{30,
          10},{30,50},{-110,50}},
                              color={0,0,127}));
  connect(andCha.u2, uRemCha) annotation (Line(points={{142,22},{142,70},{230,70}},
        color={255,0,255}));
  connect(andCha.u1, uAva)
    annotation (Line(points={{150,22},{150,28},{230,28}}, color={255,0,255}));
  connect(booToReaValCha.u, andCha.y)
    annotation (Line(points={{150,-58},{150,-2}}, color={255,0,255}));
  connect(andCha.y, swiPumRet.u2) annotation (Line(points={{150,-2},{150,-50},{90,
          -50},{90,-58}}, color={255,0,255}));
  connect(swiValCha.u2, andCha.y) annotation (Line(points={{30,-58},{30,-50},{150,
          -50},{150,-2}}, color={255,0,255}));
  connect(booToReaValCha.y, yRet[1]) annotation (Line(points={{150,-82},{150,-94},
          {170,-94},{170,-112.5}}, color={0,0,127}));
  connect(yRet[2], swiValOut.y) annotation (Line(points={{170,-107.5},{170,-94},
          {190,-94},{190,-82}}, color={0,0,127}));
  annotation (
  defaultComponentName="conPumVal",
  Diagram(coordinateSystem(extent={{-100,-100},{220,80}})),  Icon(
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
This is a control block for the group of supply pump(s) and valves in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
whose documentation explains this block's control logic.
It uses <code>plaTyp</code> to select components used for an open or closed tank.
</p>
</html>"));
end PumpValveControl;
