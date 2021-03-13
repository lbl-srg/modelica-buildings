within Buildings.Templates.BaseClasses;
package Fans
  extends Modelica.Icons.Package;
  model MultipleVariable
    "Multiple fans (identical) - Variable speed"
    extends Buildings.Templates.Interfaces.Fan(
      final typ=AHUs.Types.Fan.MultipleVariable);

    parameter Integer nFan = 1
      "Number of fans"
      annotation(Evaluate=true,
        Dialog(group="Configuration"));

    replaceable Fluid.Movers.SpeedControlled_y fan[nFan](
      each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
        redeclare each final package Medium=Medium,
        each final inputType=Buildings.Fluid.Types.InputType.Continuous,
        each final per=per)
      "Fan"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,10},{10,30}})));

    Modelica.Blocks.Routing.RealPassThrough  speSup if braStr=="Supply"
      "Supply fan speed"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,80})));
    Modelica.Blocks.Routing.RealPassThrough speRet if braStr=="Return"
      "Return fan speed"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={20,80})));
    Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
      redeclare final package Medium=Medium,
      final mCon_flow_nominal=fill(m_flow_nominal, nFan),
      final nCon=nFan)
      annotation (Placement(transformation(extent={{-20,-30},{20,-10}})));
    Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
      final nout=nFan)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,50})));
    Fluid.Sources.MassFlowSource_T floZer(
      redeclare final package Medium=Medium,
      final m_flow=0,
      nPorts=1)
      "Zero flow boundary condition"
      annotation (Placement(transformation(extent={{-52,-36},{-32,-16}})));
    Fluid.Sources.MassFlowSource_T floZer1(
      redeclare final package Medium=Medium,
      final m_flow=0,
      nPorts=1)
      "Zero flow boundary condition"
      annotation (Placement(transformation(extent={{54,-30},{34,-10}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comSup if braStr=="Supply"
      "Supply fan start/stop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-46,80})));
    Buildings.Controls.OBC.CDL.Continuous.Product conSup1 if
                                                            braStr=="Supply"
      "Resulting control signal" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-40,50})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comRet if braStr=="Return"
      "Return fan start/stop"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={46,80})));
    Buildings.Controls.OBC.CDL.Continuous.Product conRet1 if braStr=="Return"
      "Resulting control signal"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,50})));
    Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
      nin=nFan)
      "Minimum of all return signals"
      annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-50})));
    Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
      t=1E-2,
      h=0.5E-2) if braStr=="Supply"
      "Evaluate fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-80})));
    Modelica.Blocks.Routing.BooleanPassThrough staSup if braStr=="Supply"
      "Supply fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-40,-80})));
    Modelica.Blocks.Routing.BooleanPassThrough staRet if braStr=="Return"
      "Return fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={40,-80})));
  equation
    connect(port_a, colDis.port_aDisSup) annotation (Line(points={{-100,0},{-28,0},
            {-28,-20},{-20,-20}}, color={0,127,255}));
    connect(fan.port_b, colDis.ports_aCon) annotation (Line(points={{10,20},{20,20},
            {20,0},{12,0},{12,-10}}, color={0,127,255}));
    connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-26},{28,
            -26},{28,0},{100,0}},
                             color={0,127,255}));
    connect(colDis.ports_bCon, fan.port_a) annotation (Line(points={{-12,-10},{-12,
            0},{-20,0},{-20,20},{-10,20}}, color={0,127,255}));
    connect(reaRep.y, fan.y)
      annotation (Line(points={{0,38},{0,32}}, color={0,0,127}));
    connect(floZer.ports[1], colDis.port_bDisRet) annotation (Line(points={{-32,-26},
            {-20,-26}},                     color={0,127,255}));
    connect(colDis.port_bDisSup, floZer1.ports[1])
      annotation (Line(points={{20,-20},{34,-20}}, color={0,127,255}));
    connect(comSup.y, conSup1.u2)
      annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
    connect(speSup.y, conSup1.u1) annotation (Line(points={{-20,69},{-20,64},{-34,
            64},{-34,62}}, color={0,0,127}));
    connect(comRet.y, conRet1.u1)
      annotation (Line(points={{46,68},{46,62}}, color={0,0,127}));
    connect(speRet.y, conRet1.u2) annotation (Line(points={{20,69},{20,64},{34,64},
            {34,62}}, color={0,0,127}));
    connect(busCon.out.yFanSup, comSup.u) annotation (Line(
        points={{0.1,100.1},{-46,100.1},{-46,92}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.ySpeFanSup, speSup.u) annotation (Line(
        points={{0.1,100.1},{-20,100.1},{-20,92}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.ySpeFanRet, speRet.u) annotation (Line(
        points={{0.1,100.1},{20,100.1},{20,92}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.yFanRet, comRet.u) annotation (Line(
        points={{0.1,100.1},{46,100.1},{46,92}},
        color={255,204,51},
        thickness=0.5));
    connect(conSup1.y, reaRep.u) annotation (Line(points={{-40,38},{-40,30},{-16,
            30},{-16,64},{0,64},{0,62}}, color={0,0,127}));
    connect(conRet1.y, reaRep.u) annotation (Line(points={{40,38},{40,30},{16,30},
            {16,64},{0,64},{0,62}}, color={0,0,127}));
    connect(fan.y_actual, mulMin.u) annotation (Line(points={{11,27},{24,27},{24,
            -36},{0,-36},{0,-38}}, color={0,0,127}));
    connect(evaSta.y, staRet.u) annotation (Line(points={{0,-92},{0,-94},{16,-94},
            {16,-80},{28,-80}}, color={255,0,255}));
    connect(evaSta.y, staSup.u) annotation (Line(points={{0,-92},{0,-94},{-14,-94},
            {-14,-80},{-28,-80}}, color={255,0,255}));
    connect(mulMin.y, evaSta.u)
      annotation (Line(points={{0,-62},{0,-68}}, color={0,0,127}));
    connect(staRet.y,busCon.inp.staFanRet)  annotation (Line(points={{51,-80},{
            60,-80},{60,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
    connect(staSup.y,busCon.inp.staFanSup)  annotation (Line(points={{-51,-80},
            {-60,-80},{-60,96},{0.1,96},{0.1,100.1}},color={255,0,255}));
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false), graphics={Text(
            extent={{-94,-10},{80,-68}},
            lineColor={238,46,47},
            horizontalAlignment=TextAlignment.Left,
            textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
  end MultipleVariable;

  model None "No fan"
    extends Buildings.Templates.Interfaces.Fan(
      final typ=AHUs.Types.Fan.None);
  equation
    connect(port_a, port_b)
    annotation (Line(points={{-100,0},{6,0},{6,0},{100,0}}, color={0,127,255}));
    annotation (
      defaultComponentName="fan",
      Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={Line(
            points={{-100,0},{100,0}},
            color={28,108,200},
            thickness=1)}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
  end None;

  model SingleConstant "Single fan - Constant speed"
    extends Buildings.Templates.Interfaces.Fan(
      final typ=AHUs.Types.Fan.SingleConstant);

    replaceable Fluid.Movers.SpeedControlled_y fan(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
        redeclare final package Medium =Medium,
        final inputType=Buildings.Fluid.Types.InputType.Continuous,
        final per=per)
      "Fan"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-10},{10,10}})));

    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
      annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,30})));
    Modelica.Blocks.Routing.BooleanPassThrough comSup if braStr=="Supply"
      "Supply fan start/stop"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-60,70})));
    Modelica.Blocks.Routing.BooleanPassThrough comRet if braStr=="Return"
      "Return fan start/stop"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={60,70})));
    Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
          0.5E-2) if                                               braStr=="Supply"
      "Evaluate fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-30})));
    Modelica.Blocks.Routing.BooleanPassThrough staSup if
                                                      braStr=="Supply"
      "Supply fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,-70})));
    Modelica.Blocks.Routing.BooleanPassThrough staRet if
                                                      braStr=="Return"
      "Return fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={20,-70})));
  equation
    connect(booToRea.y, fan.y)
      annotation (Line(points={{0,18},{0,12}}, color={0,0,127}));
    connect(port_a, fan.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(fan.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(busCon.out.yFanSup,comSup. u) annotation (Line(
        points={{0.1,100.1},{-60,100.1},{-60,82}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(comSup.y, booToRea.u) annotation (Line(points={{-60,59},{-60,50},{0,
            50},{0,42}},
                     color={255,0,255}));
    connect(busCon.out.yFanRet,comRet. u) annotation (Line(
        points={{0.1,100.1},{60,100.1},{60,82}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(comRet.y, booToRea.u) annotation (Line(points={{60,59},{60,50},{0,50},
            {0,42},{2.22045e-15,42}}, color={255,0,255}));
    connect(evaSta.y, staRet.u) annotation (Line(points={{0,-42},{0,-50},{20,-50},
            {20,-58}}, color={255,0,255}));
    connect(evaSta.y, staSup.u) annotation (Line(points={{0,-42},{0,-50},{-20,-50},
            {-20,-58}}, color={255,0,255}));
    connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
            -16},{0,-16},{0,-18}}, color={0,0,127}));
    connect(staSup.y,busCon.inp.staFanSup)  annotation (Line(points={{-20,-81},
            {-20,-90},{-40,-90},{-40,96},{0.1,96},{0.1,100.1}},color={255,0,255}));
    connect(staRet.y,busCon.inp.staFanRet)  annotation (Line(points={{20,-81},{
            20,-90},{40,-90},{40,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SingleConstant;

  model SingleVariable "Single fan - Variable speed"
    extends Buildings.Templates.Interfaces.Fan(
      final typ=AHUs.Types.Fan.SingleVariable);

    replaceable Fluid.Movers.SpeedControlled_y fan(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
        redeclare final package Medium =Medium,
        final inputType=Buildings.Fluid.Types.InputType.Continuous,
        final per=per)
      "Fan"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-10},{10,10}})));

    Modelica.Blocks.Routing.RealPassThrough speSup if braStr=="Supply"
      "Supply fan speed"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,70})));
    Modelica.Blocks.Routing.RealPassThrough speRet if braStr=="Return"
      "Return fan speed"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={20,70})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comSup if braStr=="Supply"
      "Supply fan start/stop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-46,70})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comRet if braStr=="Return"
      "Return fan start/stop" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={46,70})));
    Buildings.Controls.OBC.CDL.Continuous.Product conSup if braStr=="Supply"
      "Resulting control signal" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-40,40})));
    Buildings.Controls.OBC.CDL.Continuous.Product conRet if braStr=="Return"
      "Resulting control signal" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,40})));
    Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
          0.5E-2) if                                               braStr=="Supply"
      "Evaluate fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-30})));
    Modelica.Blocks.Routing.BooleanPassThrough staSup if
                                                      braStr=="Supply"
      "Supply fan status" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-30,-80})));
    Modelica.Blocks.Routing.BooleanPassThrough staRet if
                                                      braStr=="Return"
      "Return fan status" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={30,-80})));
  equation
    connect(port_a, fan.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(fan.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(comSup.y, conSup.u2) annotation (Line(points={{-46,58},{-46,52}},
                       color={0,0,127}));
    connect(speSup.y, conSup.u1) annotation (Line(points={{-20,59},{-20,54},{-34,
            54},{-34,52}},
                       color={0,0,127}));
    connect(busCon.out.ySpeFanSup, speSup.u) annotation (Line(
        points={{0.1,100.1},{-20,100.1},{-20,82}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.yFanSup, comSup.u) annotation (Line(
        points={{0.1,100.1},{-46,100.1},{-46,82}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.ySpeFanRet, speRet.u) annotation (Line(
        points={{0.1,100.1},{20,100.1},{20,82}},
        color={255,204,51},
        thickness=0.5));
    connect(busCon.out.yFanRet, comRet.u) annotation (Line(
        points={{0.1,100.1},{46,100.1},{46,82}},
        color={255,204,51},
        thickness=0.5));
    connect(conSup.y, fan.y) annotation (Line(points={{-40,28},{-40,20},{0,20},{0,
            12}}, color={0,0,127}));
    connect(speRet.y, conRet.u2) annotation (Line(points={{20,59},{20,54},{34,54},
            {34,52}}, color={0,0,127}));
    connect(comRet.y, conRet.u1) annotation (Line(points={{46,58},{46,52}},
                      color={0,0,127}));
    connect(conRet.y, fan.y)
      annotation (Line(points={{40,28},{40,20},{0,20},{0,12}}, color={0,0,127}));
    connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
            -16},{0,-16},{0,-18}}, color={0,0,127}));
    connect(evaSta.y, staRet.u)
      annotation (Line(points={{0,-42},{0,-80},{18,-80}}, color={255,0,255}));
    connect(evaSta.y, staSup.u)
      annotation (Line(points={{0,-42},{0,-80},{-18,-80}}, color={255,0,255}));
    connect(staSup.y,busCon.inp.staFanSup)  annotation (Line(points={{-41,-80},
            {-60,-80},{-60,96},{0,96},{0,98},{0,100.1},{0.1,100.1}},
                                                                   color={255,0,
            255}));
    connect(staRet.y,busCon.inpt.staFanRet)  annotation (Line(points={{41,-80},{60,
            -80},{60,96},{0,96},{0,100}},          color={255,0,255}));
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SingleVariable;
end Fans;
