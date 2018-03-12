within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChilledWaterPump "Sequences to control chilled water pumps"

  parameter Integer num "Total number of chilled pumps";


  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla "Plant enable-disable status"
                                                  annotation (Placement(
        transformation(extent={{-160,80},{-120,120}}),  iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VEva_flow "Chilled water flow" annotation (Placement(
        transformation(extent={{-160,-70},{-120,-30}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet
    "Chilled water pump differential static pressure setpoint" annotation (
      Placement(transformation(extent={{-160,10},{-120,50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum
    "Chilled water differential static pressure" annotation (Placement(
        transformation(extent={{-160,-30},{-120,10}}),  iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[num] "Chilled water pumps status"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomChiWatFlo(k=VEva_nominal)
    "Total plant design flow"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division chiWatFloRat "Chilled water flow ratio"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiWatFloRat(uLow=chiWatFloRatSet - 0.05, uHigh=
        chiWatFloRatSet + 0.05)
    "Check if chilled water flow ratio is above setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer onTimer
    "Count the time when chilled water flow ratio becomes above setpoint"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer offTimer
    "Count the time when chilled water flow ratio becomes below setpoint"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold staLagPum(threshold=tStaLagPum)
    "Duration time threshold to check if flow ratio has been above setpoint for enough long time"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold shuLagPum(threshold=tShuLagPum)
    "Duration time threshold to check if flow ratio has been below setpoint for enough long time"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latLagPum "Lag pump control"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID "Pumps controller"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max "Ensure pump speed being more than minimum speed"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPumSpeCon(k=minPumSpeCon)
    "Minimum speed setpoint in VFDs"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLagPum "Status of lag pump" annotation (
      Placement(transformation(extent={{120,-70},{140,-50}}),
        iconTransformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe "Chilled water pump speed"
    annotation (Placement(transformation(extent={{120,20},{140,40}}),
        iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum "Status of lead pump" annotation (
      Placement(transformation(extent={{120,90},{140,110}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPum(k=0) "Pump not running"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[num] "Logical not"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd( final nu=num) "Check if all pumps are proven off"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

equation
  connect(not2.y, mulAnd.u)
    annotation (Line(points={{-79,70},{-62,70}},    color={255,0,255}));

  connect(VEva_flow, chiWatFloRat.u1) annotation (Line(points={{-140,-50},{-100,
          -50},{-100,-54},{-82,-54}},
                                    color={0,0,127}));
  connect(nomChiWatFlo.y, chiWatFloRat.u2) annotation (Line(points={{-99,-90},{-88,
          -90},{-88,-66},{-82,-66}},     color={0,0,127}));
  connect(chiWatFloRat.y, hysChiWatFloRat.u)
    annotation (Line(points={{-59,-60},{-42,-60}},color={0,0,127}));
  connect(not1.y, offTimer.u)
    annotation (Line(points={{-19,-100},{-2,-100}},
                                                 color={255,0,255}));
  connect(onTimer.y, staLagPum.u)
    annotation (Line(points={{21,-60},{38,-60}},
                                               color={0,0,127}));
  connect(offTimer.y, shuLagPum.u)
    annotation (Line(points={{21,-100},{38,-100}},
                                               color={0,0,127}));
  connect(staLagPum.y, latLagPum.u)
    annotation (Line(points={{61,-60},{79,-60}}, color={255,0,255}));
  connect(shuLagPum.y, latLagPum.u0) annotation (Line(points={{61,-100},{70,-100},
          {70,-66},{79,-66}}, color={255,0,255}));
  connect(dpChiWatPumSet, conPID.u_s)
    annotation (Line(points={{-140,30},{-82,30}}, color={0,0,127}));
  connect(dpChiWatPum, conPID.u_m)
    annotation (Line(points={{-140,-10},{-70,-10},{-70,18}},color={0,0,127}));
  connect(conPID.y, max.u1) annotation (Line(points={{-59,30},{-40,30},{-40,36},
          {-2,36}}, color={0,0,127}));
  connect(minPumSpeCon.y, max.u2) annotation (Line(points={{-19,-10},{-10,-10},{
          -10,24},{-2,24}}, color={0,0,127}));
  connect(latLagPum.y, yLagPum)
    annotation (Line(points={{101,-60},{130,-60}}, color={255,0,255}));
  connect(zerPum.y, swi.u3) annotation (Line(points={{21,-10},{40,-10},{40,22},{
          58,22}}, color={0,0,127}));
  connect(max.y, swi.u1) annotation (Line(points={{21,30},{40,30},{40,38},{58,38}},
        color={0,0,127}));
  connect(uChiWatPum, not2.u)
    annotation (Line(points={{-140,70},{-102,70}}, color={255,0,255}));
  connect(mulAnd.y, not3.u)
    annotation (Line(points={{-38.3,70},{-22,70}}, color={255,0,255}));
  connect(not3.y, swi.u2) annotation (Line(points={{1,70},{48,70},{48,30},{58,30}},
        color={255,0,255}));
  connect(uPla, yLeaPum)
    annotation (Line(points={{-140,100},{130,100}}, color={255,0,255}));
  connect(swi.y, yChiWatPumSpe)
    annotation (Line(points={{81,30},{130,30}}, color={0,0,127}));
  connect(hysChiWatFloRat.y, onTimer.u)
    annotation (Line(points={{-19,-60},{-2,-60}}, color={255,0,255}));
  connect(hysChiWatFloRat.y, not1.u) annotation (Line(points={{-19,-60},{-10,-60},
          {-10,-80},{-60,-80},{-60,-100},{-42,-100}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-120,-120},{120,120}}), graphics={Rectangle(
          extent={{-118,78},{118,-18}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-118,-42},{118,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}), Icon(graphics={
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,90},{-66,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uPla"),
        Text(
          extent={{-94,56},{-24,28}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-94,16},{-24,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPum"),
        Text(
          extent={{-94,-22},{-6,-50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet"),
        Text(
          extent={{-96,-70},{-42,-92}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VEva_flow"),
        Text(
          extent={{50,-58},{96,-80}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yLagPum"),
        Text(
          extent={{50,12},{96,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{26,86},{96,58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPumSpe")}));
end ChilledWaterPump;
