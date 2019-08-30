within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater;
block Controller
  "Sequences to control chilled water pumps in primary-only plant system"

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
  parameter Real minPumSpe=0.1 "Minimum pump speed";
  parameter Real maxPumSpe=1 "Maximum pump speed";
  parameter Integer nPum_nominal(final max=nPum, final min=1)=nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VChiWat_flow_nominal(final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.PressureDifference maxLocDp=15*6894.75
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor", enable=hasLocalSensor));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Speed controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Speed controller",
    enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  final parameter Modelica.SIunits.PressureDifference minLocDp=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor", enable=hasLocalSensor));
  final parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumLeaLag[nPum]
    "Chilled water pump lead-lag order"
      annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pumps operating status"
    annotation (Placement(transformation(extent={{-320,120},{-280,160}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna if not isHeadered
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-320,90},{-280,130}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta if not isHeadered
    "Lead chiller status"
    annotation (Placement(transformation(extent={{-320,60},{-280,100}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq if not isHeadered
    "Status indicating if lead chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiIsoVal[nChi] if isHeadered
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-320,0},{-280,40}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s")
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-320,-40},{-280,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference") if hasLocalSensor
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-320,-180},{-280,-140}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-320,-220},{-280,-180}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,-260},{-280,-220}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{280,-20},{320,20}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe[nPum](
    final min=fill(0, nPum),
    final max=fill(1, nPum),
    final unit=fill("1", nPum))
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{280,-220},{320,-180}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaDedLeaPum if not isHeadered
    "Enable lead pump of dedicated pumps"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered
    enaHeaLeaPum(final nChi=nChi) if isHeadered
    "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal)
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp
    pumSpeLocDp(
    final nSen=nSen,
    final nPum=nPum,
    final minLocDp=minLocDp,
    final maxLocDp=maxLocDp,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if hasLocalSensor
    "Chilled water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp
    pumSpeRemDp(
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if not hasLocalSensor
    "Chilled water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch leaPumSta[nPum] "Lead pump status"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch nexLagPumSta[nPum]
    "Next lag pump status"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch lasLagPumSta[nPum]
    "Last lag pump status"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaPum[nPum] "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And pumSta[nPum] "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch addPum[nPum] "Add pump"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch remPum[nPum] "Remove pump"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{0,220},{20,240}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep2(final nout=nPum)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pumSpe[nPum] "Pump speed"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1[nPum](
    final k=fill(0, nPum)) "Constant zero"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=nPum)
    "Replicate real input"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nPum]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor leaPum(final nin=nPum) "Lead pump index"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant pumIndCon[nPum](
    final k=pumInd) "Pump index array"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nPum] "Check lead pump"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum) "Next lag pump"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum] "Check next lag pump"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasLagPum(
    final nin=nPum) "Last lag pump"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nPum] "Check next lag pump"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin=nPum)
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Integer add"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

equation
  connect(enaDedLeaPum.uLeaChiEna, uLeaChiEna)
    annotation (Line(points={{-202,118},{-240,118},{-240,110},{-300,110}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{-202,110},{-230,110},{-230,80},{-300,80}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiWatReq, uLeaChiWatReq)
    annotation (Line(points={{-202,102},{-220,102},{-220,50},{-300,50}},
      color={255,0,255}));
  connect(enaHeaLeaPum.uChiIsoVal, uChiIsoVal)
    annotation (Line(points={{-202,70},{-210,70},{-210,20},{-300,20}},
      color={255,0,255}));
  connect(uPumLeaLag, intToRea.u)
    annotation (Line(points={{-300,230},{-222,230}}, color={255,127,0}));
  connect(intToRea.y, leaPum.u)
    annotation (Line(points={{-198,230},{-82,230}}, color={0,0,127}));
  connect(conInt.y, leaPum.index)
    annotation (Line(points={{-198,200},{-70,200},{-70,218}}, color={255,127,0}));
  connect(leaPum.y, reaToInt.u)
    annotation (Line(points={{-58,230},{-42,230}},color={0,0,127}));
  connect(reaToInt.y, intRep.u)
    annotation (Line(points={{-18,230},{-2,230}}, color={255,127,0}));
  connect(intRep.y, intEqu1.u1)
    annotation (Line(points={{22,230},{30,230},{30,190},{58,190}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu1.u2)
    annotation (Line(points={{-198,170},{40,170},{40,182},{58,182}},
      color={255,127,0}));
  connect(intEqu1.y, leaPumSta.u2)
    annotation (Line(points={{82,190},{118,190}},  color={255,0,255}));
  connect(uChiWatPum, leaPumSta.u3)
    annotation (Line(points={{-300,140},{100,140},{100,182},{118,182}},
      color={255,0,255}));
  connect(booRep.y, leaPumSta.u1)
    annotation (Line(points={{22,110},{90,110},{90,198},{118,198}},
      color={255,0,255}));
  connect(intToRea.y, nexLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-50},{-82,-50}},
      color={0,0,127}));
  connect(nexLagPum.y, reaToInt1.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={0,0,127}));
  connect(reaToInt1.y, intRep1.u)
    annotation (Line(points={{-18,-50},{-2,-50}}, color={255,127,0}));
  connect(intRep1.y, intEqu2.u2)
    annotation (Line(points={{22,-50},{30,-50},{30,-38},{58,-38}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu2.u1)
    annotation (Line(points={{-198,170},{40,170},{40,-30},{58,-30}},
      color={255,127,0}));
  connect(intEqu2.y, nexLagPumSta.u2)
    annotation (Line(points={{82,-30},{118,-30}},  color={255,0,255}));
  connect(booRep1.y, nexLagPumSta.u1)
    annotation (Line(points={{-18,30},{110,30},{110,-22},{118,-22}},
      color={255,0,255}));
  connect(uChiWatPum, nexLagPumSta.u3)
    annotation (Line(points={{-300,140},{100,140},{100,-38},{118,-38}},
      color={255,0,255}));
  connect(lasLagPum.y, reaToInt2.u)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={0,0,127}));
  connect(reaToInt2.y, intRep2.u)
    annotation (Line(points={{-18,-100},{-2,-100}}, color={255,127,0}));
  connect(intRep2.y, intEqu3.u2)
    annotation (Line(points={{22,-100},{30,-100},{30,-98},{58,-98}},
      color={255,127,0}));
  connect(pumIndCon.y, intEqu3.u1)
    annotation (Line(points={{-198,170},{40,170},{40,-90},{58,-90}},
      color={255,127,0}));
  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{82,-90},{118,-90}},    color={255,0,255}));
  connect(enaLagChiPum.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{-202,4},{-240,4},{-240,-20},{-300,-20}},
      color={0,0,127}));
  connect(uChiWatPum, enaLagChiPum.uChiWatPum)
    annotation (Line(points={{-300,140},{-260,140},{-260,-3.8},{-202,-3.8}},
      color={255,0,255}));
  connect(intToRea.y, lasLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-100},{-82,-100}},
      color={0,0,127}));
  connect(booRep2.y, lasLagPumSta.u1)
    annotation (Line(points={{-18,-10},{90,-10},{90,-82},{118,-82}},
      color={255,0,255}));
  connect(uChiWatPum, lasLagPumSta.u3)
    annotation (Line(points={{-300,140},{100,140},{100,-98},{118,-98}},
      color={255,0,255}));
  connect(nexLagPumSta.y,enaPum. u2)
    annotation (Line(points={{142,-30},{150,-30},{150,-38},{178,-38}},
      color={255,0,255}));
  connect(leaPumSta.y,enaPum. u1)
    annotation (Line(points={{142,190},{160,190},{160,-30},{178,-30}},
      color={255,0,255}));
  connect(pumSpeLocDp.dpChiWat_local, dpChiWat_local)
    annotation (Line(points={{-62,-192},{-240,-192},{-240,-160},{-300,-160}},
      color={0,0,127}));
  connect(pumSpeLocDp.dpChiWat_remote, dpChiWat_remote)
    annotation (Line(points={{-62,-204},{-200,-204},{-200,-200},{-300,-200}},
      color={0,0,127}));
  connect(pumSpeLocDp.dpChiWatSet, dpChiWatSet)
    annotation (Line(points={{-62,-208},{-220,-208},{-220,-240},{-300,-240}},
      color={0,0,127}));
  connect(dpChiWat_remote, pumSpeRemDp.dpChiWat)
    annotation (Line(points={{-300,-200},{-200,-200},{-200,-240},{-62,-240}},
      color={0,0,127}));
  connect(dpChiWatSet, pumSpeRemDp.dpChiWatSet)
    annotation (Line(points={{-300,-240},{-220,-240},{-220,-248},{-62,-248}},
      color={0,0,127}));
  connect(pumSpeLocDp.yChiWatPumSpe, reaRep.u)
    annotation (Line(points={{-38,-200},{-2,-200}}, color={0,0,127}));
  connect(pumSpeRemDp.yChiWatPumSpe, reaRep.u)
    annotation (Line(points={{-39,-240},{-20,-240},{-20,-200},{-2,-200}},
      color={0,0,127}));
  connect(reaRep.y, pumSpe.u1)
    annotation (Line(points={{22,-200},{40,-200},{40,-192},{118,-192}},
      color={0,0,127}));
  connect(conInt1.y, pumSpe.u3)
    annotation (Line(points={{82,-240},{100,-240},{100,-208},{118,-208}},
      color={0,0,127}));
  connect(pumSpe.y, yPumSpe)
    annotation (Line(points={{142,-200},{300,-200}}, color={0,0,127}));
  connect(enaPum.y, pumSta.u2)
    annotation (Line(points={{202,-30},{210,-30},{210,-50},{150,-50},{150,-98},
      {178,-98}},  color={255,0,255}));
  connect(lasLagPumSta.y, pumSta.u1)
    annotation (Line(points={{142,-90},{178,-90}}, color={255,0,255}));
  connect(enaDedLeaPum.yLea, booRep.u)
    annotation (Line(points={{-178,110},{-2,110}}, color={255,0,255}));
  connect(enaHeaLeaPum.yLea, booRep.u)
    annotation (Line(points={{-178,70},{-20,70},{-20,110},{-2,110}}, color={255,0,255}));
  connect(enaLagChiPum.yUp, booRep1.u)
    annotation (Line(points={{-178,4},{-120,4},{-120,30},{-42,30}}, color={255,0,255}));
  connect(enaLagChiPum.yDown, booRep2.u)
    annotation (Line(points={{-178,-4},{-120,-4},{-120,-10},{-42,-10}},
      color={255,0,255}));
  connect(booRep2.y, remPum.u2)
    annotation (Line(points={{-18,-10},{90,-10},{90,-70},{218,-70}},
      color={255,0,255}));
  connect(pumSta.y, remPum.u3)
    annotation (Line(points={{202,-90},{210,-90},{210,-78},{218,-78}},
      color={255,0,255}));
  connect(leaPumSta.y, remPum.u1)
    annotation (Line(points={{142,190},{160,190},{160,-62},{218,-62}}, color={255,0,255}));
  connect(enaPum.y, addPum.u1)
    annotation (Line(points={{202,-30},{210,-30},{210,8},{238,8}}, color={255,0,255}));
  connect(booRep1.y, addPum.u2)
    annotation (Line(points={{-18,30},{110,30},{110,0},{238,0}}, color={255,0,255}));
  connect(addPum.y, yChiWatPum)
    annotation (Line(points={{262,0},{300,0}}, color={255,0,255}));
  connect(addPum.y, pumSpeLocDp.uChiWatPum)
    annotation (Line(points={{262,0},{270,0},{270,-180},{-80,-180},{-80,-196},
      {-62,-196}},  color={255,0,255}));
  connect(addPum.y, pumSpeRemDp.uChiWatPum)
    annotation (Line(points={{262,0},{270,0},{270,-180},{-80,-180},{-80,-232},
      {-62,-232}},  color={255,0,255}));
  connect(addPum.y, pumSpe.u2)
    annotation (Line(points={{262,0},{270,0},{270,-180},{100,-180},{100,-200},
      {118,-200}},  color={255,0,255}));
  connect(remPum.y, addPum.u3)
    annotation (Line(points={{242,-70},{250,-70},{250,-20},{220,-20},{220,-8},
      {238,-8}},  color={255,0,255}));
  connect(uChiWatPum, booToInt.u)
    annotation (Line(points={{-300,140},{-260,140},{-260,-120},{-202,-120}},
      color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-178,-120},{-162,-120}}, color={255,127,0}));
  connect(addInt.y, nexLagPum.index)
    annotation (Line(points={{-98,-70},{-70,-70},{-70,-62}}, color={255,127,0}));
  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-138,-120},{-128,-120},{-128,-76},{-122,-76}},
      color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-198,200},{-140,200},{-140,-64},{-122,-64}},
      color={255,127,0}));
  connect(mulSumInt.y, lasLagPum.index)
    annotation (Line(points={{-138,-120},{-70,-120},{-70,-112}}, color={255,127,0}));

annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-260},{280,260}}), graphics={
          Rectangle(
          extent={{-276,256},{156,64}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,252},{140,236}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable lead pump"),
          Rectangle(
          extent={{-276,56},{156,-136}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,54},{150,40}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next lag pump"),
          Text(
          extent={{70,-116},{152,-134}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable last lag pump"),
          Rectangle(
          extent={{-276,-144},{156,-256}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{76,-156},{146,-168}},
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
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
Primary chilled water pump control sequence per ASHRAE RP-1711, Draft 6 (July 25, 2019), 
section 5.2.6. It consists:
</p>
<ul>
<li>
Subsequences to enable lead pump, 
<ul>
<li>
for plants with dedicated pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated</a>
</li>
<li>
for plants with headered pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered</a>
</li>
</ul>
</li>
<li>
Subsequence to stage lag pumps
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP</a>
</li>

<li>
Subsequences to control pump speed for primary-only plants,
<ul>
<li>
where the remote DP sensor(s) is not hardwired to the plant controller, 
but a local DP sensor is hardwired
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_localDp</a>
</li>
<li>
where the remote DP sensor(s) is hardwired to the plant controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp</a>
</li>
</ul>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 13, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
