within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater;
block Controller
  "Sequences for control chilled water pump in primary-only plant system"

  parameter Boolean isHeadered = true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated";
  parameter Boolean hasLocalSensor = false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Integer nChi = 2
    "Total number of chillers";
  parameter Integer nSen=2
    "Total number of remote differential pressure sensors";
  parameter Real minPumSpe=0 "Minimum pump speed";
  parameter Real maxPumSpe=1 "Maximum pump speed";
  parameter Integer nPum_nominal=1
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VChiWat_flow_nominal
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Time offTimThr=180
    "Threshold to check lead chiller off time"
    annotation (Dialog(group="Enable dedicate lead pump"), enable=not isHeadered);
  parameter Modelica.SIunits.PressureDifference minLocDp=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor"),enable=hasLocalSensor);
  parameter Modelica.SIunits.PressureDifference maxLocDp
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor"), enable=hasLocalSensor);

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumPri[nPum]
    "Chiller water pump enabling priority"
    annotation (Placement(transformation(extent={{-300,210},{-260,250}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pumps operating status"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna if not isHeadered
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-300,90},{-260,130}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiOn if not isHeadered
    "Lead chiller status"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq if not isHeadered
    "Status indicating if lead chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiIsoVal[nChi] if isHeadered
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-300,0},{-260,40}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    unit="m3/s")
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference") if hasLocalSensor
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-300,-190},{-260,-150}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    each final unit="Pa",
    each final quantity="PressureDifference")
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-300,-230},{-260,-190}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-300,-260},{-260,-220}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe[nPum](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{260,-210},{280,-190}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaDedLeaPum(final offTimThr=offTimThr) if not isHeadered
    "Enable lead pump of dedicated pumps"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered
    enaHeaLeaPum(nChi=nChi) if isHeadered
    "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,220},{40,240}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch leaPumSta[nPum] "Lead pump status"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin = nPum)
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch nexLagPumSta[nPum]
    "Next lag pump status"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep2(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch lasLagPumSta[nPum] "Last lag pump status"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 pumSta[nPum] "Chilled water pump status"
    annotation (Placement(transformation(extent={{200,-40},{220,-20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDP
    pumSpeLocDp(
    final nSen=nSen,
    final nPum=nPum,
    final minLocDp=minLocDp,
    final maxLocDp=maxLocDp,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe) if hasLocalSensor
    "Chilled water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp
    pumSpeRemDp(
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe) if not hasLocalSensor
    "Chilled water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pumSpe[nPum] "Pump speed"
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1[nPum](
    each final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{80,-250},{100,-230}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=nPum)
    "Replicate real input"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nPum]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor leaPum(final nin=nPum) "Lead pump index"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant pumIndCon[nPum](
    final k=pumInd) "Pump index array"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nPum] "Check lead pump"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum) "Next lag pump"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum] "Check next lag pump"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasLagPum(
    final nin=nPum) "Last lag pump"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nPum] "Check next lag pump"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

equation
  connect(enaDedLeaPum.uLeaChiEna, uLeaChiEna) annotation (Line(points={{-102,118},
          {-220,118},{-220,110},{-280,110}},  color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiOn, uLeaChiOn) annotation (Line(points={{-102,110},
          {-210,110},{-210,80},{-280,80}},color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiWatReq, uLeaChiWatReq) annotation (Line(points={{-102,
          102},{-200,102},{-200,50},{-280,50}},  color={255,0,255}));
  connect(enaHeaLeaPum.uChiIsoVal, uChiIsoVal) annotation (Line(points={{-102,70},
          {-190,70},{-190,20},{-280,20}},       color={255,0,255}));
  connect(uPumPri, intToRea.u)
    annotation (Line(points={{-280,230},{-202,230}}, color={255,127,0}));
  connect(intToRea.y, leaPum.u)
    annotation (Line(points={{-179,230},{-62,230}}, color={0,0,127}));
  connect(conInt.y, leaPum.index) annotation (Line(points={{-179,200},{-50,200},
          {-50,218}}, color={255,127,0}));
  connect(leaPum.y, reaToInt.u)
    annotation (Line(points={{-39,230},{-22,230}},color={0,0,127}));
  connect(reaToInt.y, intRep.u)
    annotation (Line(points={{1,230},{18,230}}, color={255,127,0}));
  connect(intRep.y, intEqu1.u1) annotation (Line(points={{41,230},{50,230},{50,190},
          {78,190}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu1.u2) annotation (Line(points={{-179,170},{60,170},
          {60,182},{78,182}}, color={255,127,0}));
  connect(intEqu1.y, leaPumSta.u2)
    annotation (Line(points={{101,190},{138,190}}, color={255,0,255}));
  connect(uChiWatPum, leaPumSta.u3) annotation (Line(points={{-280,140},{120,140},
          {120,182},{138,182}}, color={255,0,255}));
  connect(enaDedLeaPum.yLeaPum, booRep.u)
    annotation (Line(points={{-79,110},{-22,110}},
                                                 color={255,0,255}));
  connect(enaHeaLeaPum.yLeaPum, booRep.u) annotation (Line(points={{-79,70},{-60,
          70},{-60,110},{-22,110}},
                                  color={255,0,255}));
  connect(booRep.y, leaPumSta.u1) annotation (Line(points={{1,110},{110,110},{110,
          198},{138,198}}, color={255,0,255}));
  connect(uChiWatPum, booToInt.u) annotation (Line(points={{-280,140},{-240,140},
          {-240,-140},{-182,-140}}, color={255,0,255}));
  connect(conInt.y, addInt.u1) annotation (Line(points={{-179,200},{-120,200},{-120,
          -64},{-102,-64}},   color={255,127,0}));
  connect(mulSumInt.y, addInt.u2) annotation (Line(points={{-118.3,-140},{-110,-140},
          {-110,-76},{-102,-76}},   color={255,127,0}));
  connect(addInt.y, nexLagPum.index) annotation (Line(points={{-79,-70},{-50,-70},
          {-50,-62}},  color={255,127,0}));
  connect(intToRea.y, nexLagPum.u) annotation (Line(points={{-179,230},{-140,230},
          {-140,-50},{-62,-50}}, color={0,0,127}));
  connect(nexLagPum.y, reaToInt1.u)
    annotation (Line(points={{-39,-50},{-22,-50}}, color={0,0,127}));
  connect(reaToInt1.y, intRep1.u)
    annotation (Line(points={{1,-50},{18,-50}}, color={255,127,0}));
  connect(intRep1.y, intEqu2.u2) annotation (Line(points={{41,-50},{50,-50},{50,
          -38},{78,-38}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu2.u1) annotation (Line(points={{-179,170},{60,170},
          {60,-30},{78,-30}}, color={255,127,0}));
  connect(intEqu2.y, nexLagPumSta.u2)
    annotation (Line(points={{101,-30},{138,-30}}, color={255,0,255}));
  connect(enaLagChiPum.yNexLagPum, booRep1.u) annotation (Line(points={{-79,4},{
          -60,4},{-60,30},{-22,30}},  color={255,0,255}));
  connect(booRep1.y, nexLagPumSta.u1) annotation (Line(points={{1,30},{130,30},{
          130,-22},{138,-22}},
                           color={255,0,255}));
  connect(uChiWatPum, nexLagPumSta.u3) annotation (Line(points={{-280,140},{120,
          140},{120,-38},{138,-38}}, color={255,0,255}));
  connect(mulSumInt.y, lasLagPum.index) annotation (Line(points={{-118.3,-140},{
          -50,-140},{-50,-132}}, color={255,127,0}));
  connect(lasLagPum.y, reaToInt2.u)
    annotation (Line(points={{-39,-120},{-22,-120}}, color={0,0,127}));
  connect(reaToInt2.y, intRep2.u)
    annotation (Line(points={{1,-120},{18,-120}}, color={255,127,0}));
  connect(intRep2.y, intEqu3.u2) annotation (Line(points={{41,-120},{50,-120},{50,
          -108},{78,-108}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu3.u1) annotation (Line(points={{-179,170},{60,170},
          {60,-100},{78,-100}}, color={255,127,0}));
  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{101,-100},{138,-100}}, color={255,0,255}));
  connect(enaLagChiPum.yLasLagPum, booRep2.u) annotation (Line(points={{-79,-4},
          {-60,-4},{-60,-10},{-22,-10}},  color={255,0,255}));
  connect(enaLagChiPum.VChiWat_flow, VChiWat_flow) annotation (Line(points={{-102,4},
          {-220,4},{-220,-10},{-280,-10}},        color={0,0,127}));
  connect(uChiWatPum, enaLagChiPum.uChiWatPum) annotation (Line(points={{-280,140},
          {-240,140},{-240,-3.8},{-102,-3.8}},   color={255,0,255}));
  connect(intToRea.y, lasLagPum.u) annotation (Line(points={{-179,230},{-140,230},
          {-140,-120},{-62,-120}}, color={0,0,127}));
  connect(booRep2.y, lasLagPumSta.u1) annotation (Line(points={{1,-10},{110,-10},
          {110,-92},{138,-92}},   color={255,0,255}));
  connect(booToInt.y, mulSumInt.u) annotation (Line(points={{-159,-140},{-142,-140}},
                                       color={255,127,0}));
  connect(uChiWatPum, lasLagPumSta.u3) annotation (Line(points={{-280,140},{120,
          140},{120,-108},{138,-108}}, color={255,0,255}));
  connect(nexLagPumSta.y, pumSta.u2)
    annotation (Line(points={{161,-30},{198,-30}}, color={255,0,255}));
  connect(leaPumSta.y, pumSta.u1) annotation (Line(points={{161,190},{180,190},{
          180,-22},{198,-22}}, color={255,0,255}));
  connect(lasLagPumSta.y, pumSta.u3) annotation (Line(points={{161,-100},{180,-100},
          {180,-38},{198,-38}}, color={255,0,255}));
  connect(pumSpeLocDp.dpChiWat_local, dpChiWat_local) annotation (Line(points={{
          -42,-192},{-220,-192},{-220,-170},{-280,-170}}, color={0,0,127}));
  connect(pumSpeLocDp.dpChiWat_remote, dpChiWat_remote) annotation (Line(points=
         {{-42,-196},{-220,-196},{-220,-210},{-280,-210}}, color={0,0,127}));
  connect(pumSta.y, pumSpeLocDp.uChiWatPum) annotation (Line(points={{221,-30},{
          240,-30},{240,-150},{-60,-150},{-60,-204},{-42,-204}}, color={255,0,255}));
  connect(pumSpeLocDp.dpChiWatSet, dpChiWatSet) annotation (Line(points={{-42,-208},
          {-200,-208},{-200,-240},{-280,-240}}, color={0,0,127}));
  connect(dpChiWat_remote, pumSpeRemDp.dpChiWat) annotation (Line(points={{-280,
          -210},{-220,-210},{-220,-232},{-42,-232}}, color={0,0,127}));
  connect(pumSta.y, pumSpeRemDp.uChiWatPum) annotation (Line(points={{221,-30},{
          240,-30},{240,-150},{-60,-150},{-60,-240},{-42,-240}}, color={255,0,255}));
  connect(dpChiWatSet, pumSpeRemDp.dpChiWatSet) annotation (Line(points={{-280,-240},
          {-200,-240},{-200,-248},{-42,-248}}, color={0,0,127}));
  connect(pumSpeLocDp.yChiWatPumSpe, reaRep.u)
    annotation (Line(points={{-19,-200},{18,-200}}, color={0,0,127}));
  connect(pumSpeRemDp.yChiWatPumSpe, reaRep.u) annotation (Line(points={{-19,-240},
          {0,-240},{0,-200},{18,-200}}, color={0,0,127}));
  connect(reaRep.y, pumSpe.u1) annotation (Line(points={{41,-200},{60,-200},{60,
          -192},{138,-192}}, color={0,0,127}));
  connect(conInt1.y, pumSpe.u3) annotation (Line(points={{101,-240},{120,-240},{
          120,-208},{138,-208}}, color={0,0,127}));
  connect(pumSta.y, pumSpe.u2) annotation (Line(points={{221,-30},{240,-30},{240,
          -150},{120,-150},{120,-200},{138,-200}}, color={255,0,255}));
  connect(pumSpe.y, yPumSpe)
    annotation (Line(points={{161,-200},{270,-200}}, color={0,0,127}));

annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-260},{260,260}}), graphics={
          Rectangle(
          extent={{-256,256},{176,64}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{86,252},{160,236}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable lead pump"),
          Rectangle(
          extent={{-256,56},{176,-136}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{86,54},{170,40}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next lag pump"),
          Text(
          extent={{90,-116},{172,-134}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable last lag pump"),
          Rectangle(
          extent={{-256,-144},{176,-256}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{96,-156},{166,-168}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Pump speed")}),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}));
end Controller;
