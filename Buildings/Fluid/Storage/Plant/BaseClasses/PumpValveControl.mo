within Buildings.Fluid.Storage.Plant.BaseClasses;
block PumpValveControl
  "Control block for the supply pump and nearby valves"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Type of plant setup";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,10})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={270,108}),                iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,100})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-150,88}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput mTanBot_flow
    "Flow rate measured at the bottom of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnl
    "= true if plant is online (not cut off from the network by valve)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={270,28}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,60})));
  Modelica.Blocks.Interfaces.RealOutput yPumSup
    "Speed input of the supply pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-210}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Modelica.Blocks.Interfaces.RealInput ySup_actual[2]
    "Positions of 1: valSupOut, 2: valSupCha"            annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-150,-10}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-100})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValOutClo(t=0.01)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-170})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValOut
    "True = 1, false = 0"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-170})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-170})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3Out
    "Outputting = plant online AND no remote charging command AND charging valve(s) closed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={230,10})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValChaClo(t=0.01)
    "= true if valve closed"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,70})));
  Buildings.Controls.OBC.CDL.Logical.And andCha
    "Charging = remote charging command AND outputting valve(s) closed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,10})));
  Buildings.Controls.Continuous.LimPID conPI_pumRet(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=10,
    reverseActing=false)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,10})));
  Buildings.Controls.Continuous.LimPID conPI_valOut(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=true)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,10})));

  Modelica.Blocks.Interfaces.RealInput mTanTop_flow
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Flow rate measured at the top of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,68}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
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
        origin={10,-210}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealInput yRet_actual[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of 1: valRetOut, 2: valRetCha"           annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-150,10}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxCha
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Max of charging valve positions"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Modelica.Blocks.Routing.RealPassThrough pasCha if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Real signal pass through"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Modelica.Blocks.Routing.RealPassThrough pasOut if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Real signal pass through"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxOut
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Max of output valve positions"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Modelica.Blocks.Interfaces.RealOutput yRet[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for valves on the return line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,-210}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-170})));
  Modelica.Blocks.Interfaces.RealOutput yPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxilliary pump on the return line" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-210}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValOut
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,-170})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValCha
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,-170})));

initial equation
  assert(plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
  or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote,
  "To use this block, the only values allowed for plaTyp is
  .Open or .ClosedRemote");
equation
  connect(conPI_valCha.u_s,mTanSet_flow)  annotation (Line(points={{30,22},{30,88},
          {-150,88}},              color={0,0,127}));
  connect(conPI_valCha.u_m, mTanBot_flow) annotation (Line(points={{18,10},{10,10},
          {10,50},{-150,50}}, color={0,0,127}));
  connect(swiPumSup.y, yPumSup)
    annotation (Line(points={{-70,-182},{-70,-210}}, color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-99,-110},{-78,-110},{
          -78,-158}}, color={0,0,127}));
  connect(zero.y, swiValCha.u3) annotation (Line(points={{-99,-110},{22,-110},{22,
          -158}}, color={0,0,127}));
  connect(isValOutClo.y, andCha.u2)
    annotation (Line(points={{62,130},{182,130},{182,22}}, color={255,0,255}));
  connect(conPI_valCha.y, swiValCha.u1) annotation (Line(points={{30,-1},{30,-20},
          {38,-20},{38,-158}},color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{270,108},{240,108},{240,82}},
                                                        color={255,0,255}));
  connect(andCha.u1, uRemCha) annotation (Line(points={{190,22},{190,108},{270,108}},
        color={255,0,255}));
  connect(and3Out.u3, isValChaClo.y)
    annotation (Line(points={{222,22},{222,210},{62,210}}, color={255,0,255}));
  connect(notRemCha.y, and3Out.u2) annotation (Line(points={{240,58},{240,40},{230,
          40},{230,22}}, color={255,0,255}));
  connect(conPI_pumRet.u_s, mTanSet_flow)
    annotation (Line(points={{90,22},{90,88},{-150,88}}, color={0,0,127}));

  connect(and3Out.u1, uOnl)
    annotation (Line(points={{238,22},{238,28},{270,28}}, color={255,0,255}));
  connect(mTanSet_flow, conPI_valOut.u_s)
    annotation (Line(points={{-150,88},{130,88},{130,22}}, color={0,0,127}));

  connect(conPI_pumSup.u_s, mTanSet_flow)
    annotation (Line(points={{-70,22},{-70,88},{-150,88}}, color={0,0,127}));
  connect(conPI_pumSup.u_m, mTanBot_flow) annotation (Line(points={{-82,10},{-90,
          10},{-90,50},{-150,50}}, color={0,0,127}));
  connect(mTanTop_flow, conPI_valOut.u_m) annotation (Line(points={{-150,68},{110,
          68},{110,10},{118,10}}, color={0,0,127}));
  connect(pasCha.y, isValChaClo.u) annotation (Line(points={{-39,190},{32,190},{
          32,210},{38,210}}, color={0,0,127}));
  connect(maxCha.y, isValChaClo.u) annotation (Line(points={{-38,230},{32,230},{
          32,210},{38,210}}, color={0,0,127}));
  connect(pasOut.y, isValOutClo.u) annotation (Line(points={{-39,110},{32,110},{
          32,130},{38,130}}, color={0,0,127}));
  connect(maxOut.y, isValOutClo.u) annotation (Line(points={{-38,150},{32,150},
          {32,130},{38,130}}, color={0,0,127}));
  connect(and3Out.y, swiPumSup.u2) annotation (Line(points={{230,-2},{230,-120},
          {-70,-120},{-70,-158}}, color={255,0,255}));
  connect(yRet_actual[2], maxCha.u1) annotation (Line(points={{-150,12.5},{-150,
          12},{-120,12},{-120,236},{-62,236}},
                                       color={0,0,127}));
  connect(maxOut.u1, yRet_actual[1]) annotation (Line(points={{-62,156},{-120,
          156},{-120,7.5},{-150,7.5}}, color={0,0,127}));
  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{-70,-1},{-70,-20},
          {-62,-20},{-62,-158}}, color={0,0,127}));
  connect(andCha.y, swiPumRet.u2) annotation (Line(points={{190,-2},{190,-136},
          {90,-136},{90,-158}}, color={255,0,255}));
  connect(conPI_pumRet.y, swiPumRet.u1) annotation (Line(points={{90,-1},{90,-20},
          {98,-20},{98,-158}}, color={0,0,127}));
  connect(swiPumRet.u3, zero.y) annotation (Line(points={{82,-158},{82,-110},{-99,
          -110}}, color={0,0,127}));
  connect(swiPumRet.y, yPumRet)
    annotation (Line(points={{90,-182},{90,-210}}, color={0,0,127}));
  connect(booToReaValCha.u, andCha.y)
    annotation (Line(points={{190,-158},{190,-2}}, color={255,0,255}));
  connect(swiValOut.u2, and3Out.y) annotation (Line(points={{150,-158},{150,
          -120},{230,-120},{230,-2}},
                                color={255,0,255}));
  connect(conPI_valOut.y, swiValOut.u1) annotation (Line(points={{130,-1},{130,-20},
          {158,-20},{158,-158}}, color={0,0,127}));
  connect(swiValOut.u3, zero.y) annotation (Line(points={{142,-158},{142,-110},{
          -99,-110}}, color={0,0,127}));
  connect(booToReaValOut.u, and3Out.y) annotation (Line(points={{-10,-158},{-8,
          -158},{-8,-120},{230,-120},{230,-2}}, color={255,0,255}));
  connect(swiValCha.u2, andCha.y) annotation (Line(points={{30,-158},{30,-136},
          {190,-136},{190,-2}}, color={255,0,255}));
  connect(maxCha.u2, ySup_actual[2]) annotation (Line(points={{-62,224},{-100,
          224},{-100,-7.5},{-150,-7.5}}, color={0,0,127}));
  connect(pasCha.u, ySup_actual[2]) annotation (Line(points={{-62,190},{-100,
          190},{-100,-7.5},{-150,-7.5}}, color={0,0,127}));
  connect(maxOut.u2, ySup_actual[1]) annotation (Line(points={{-62,144},{-100,
          144},{-100,-12.5},{-150,-12.5}}, color={0,0,127}));
  connect(pasOut.u, ySup_actual[1]) annotation (Line(points={{-62,110},{-100,
          110},{-100,-12.5},{-150,-12.5}}, color={0,0,127}));
  connect(booToReaValOut.y, yValSup[1]) annotation (Line(points={{-10,-182},{
          -10,-194},{10,-194},{10,-212.5}}, color={0,0,127}));
  connect(swiValCha.y, yValSup[2]) annotation (Line(points={{30,-182},{30,-194},
          {10,-194},{10,-207.5}}, color={0,0,127}));
  connect(swiValOut.y, yRet[1]) annotation (Line(points={{150,-182},{150,-194},
          {170,-194},{170,-212.5}}, color={0,0,127}));
  connect(booToReaValCha.y, yRet[2]) annotation (Line(points={{190,-182},{190,
          -194},{170,-194},{170,-207.5}}, color={0,0,127}));
  connect(conPI_pumRet.u_m, mTanTop_flow) annotation (Line(points={{78,10},{70,
          10},{70,68},{-150,68}}, color={0,0,127}));
  annotation (
  defaultComponentName="conPumVal",
  Diagram(coordinateSystem(extent={{-140,-200},{260,240}})), Icon(
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
