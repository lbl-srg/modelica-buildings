within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater;
block Controller
  "Sequences to control chilled water pumps in primary-only plant system"

  parameter Boolean have_heaPum = true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated";
  parameter Boolean have_locSen = false
    "Flag of local DP sensor: true=local DP sensor hardwired to controller";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Integer nChi = 2
    "Total number of chillers";
  parameter Integer nSen=2
    "Total number of remote differential pressure sensors";
  parameter Real minPumSpe=0.1 "Minimum pump speed";
  parameter Real maxPumSpe=1 "Maximum pump speed";
  parameter Integer nPum_nominal(
    final max=nPum,
    final min=1)=nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real maxLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=15*6894.75
    "Maximum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor", enable=have_locSen));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time",
    displayUnit="s")=0.5 "Time constant of integrator block"
      annotation (Dialog(group="Speed controller"));
  parameter Real Td(
    final unit="s",
    final quantity="Time",
    displayUnit="s")=0.1 "Time constant of derivative block"
      annotation (Dialog(group="Speed controller",
    enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumLeaLag[nPum] if have_heaPum
    "Index of chilled water pumps in lead-lag order: lead pump, first lag pump, second lag pump, etc."
    annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla if not have_heaPum
    "True: plant is enabled"
    annotation (Placement(transformation(extent={{-320,160},{-280,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pumps proven on status"
    annotation (Placement(transformation(extent={{-320,120},{-280,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna if not have_heaPum
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-320,90},{-280,130}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta if not have_heaPum
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-320,60},{-280,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq if not have_heaPum
    "Status indicating if lead chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) if have_heaPum
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-320,0},{-280,40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s") if have_heaPum
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-320,-70},{-280,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference") if have_locSen
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-320,-180},{-280,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-320,-220},{-280,-180}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference",nSen))
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,-270},{-280,-230}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{280,60},{320,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nPum]
    if have_heaPum
    "Chilled water pump status setpoint"
    annotation (Placement(transformation(extent={{280,20},{320,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Enabled chilled water pump speed"
    annotation (Placement(transformation(extent={{280,-220},{320,-180}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet_local(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="Pa") if have_locSen
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{280,-260},{320,-220}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaDedLeaPum if not have_heaPum
    "Enable lead pump of dedicated pumps"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered
    enaHeaLeaPum(final nChi=nChi) if have_heaPum
    "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal) if have_heaPum
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
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
    final Td=Td) if have_locSen
    "Chilled water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp
    pumSpeRemDp(
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if not have_locSen
    "Chilled water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));

protected
  final parameter Real minLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor", enable=have_locSen));
  final parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1) if have_heaPum
    "Constant one"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nPum) if have_heaPum
    "Replicate integer input"
    annotation (Placement(transformation(extent={{0,220},{20,240}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nPum) if have_heaPum
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nPum) if have_heaPum
    "Replicate integer input"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nPum) if have_heaPum
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep2(
    final nout=nPum) if have_heaPum
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nPum) if have_heaPum
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nPum]
    if have_heaPum
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor leaPum(
    final nin=nPum) if have_heaPum
    "Lead pump index"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt if have_heaPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant pumIndCon[nPum](
    final k=pumInd) if have_heaPum
    "Pump index array"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nPum] if have_heaPum
    "Check lead pump"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum) if have_heaPum
    "Next lag pump"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 if have_heaPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum] if have_heaPum
    "Check next lag pump"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor lasLagPum(
    final nin=nPum) if have_heaPum
    "Last lag pump"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2 if have_heaPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nPum] if have_heaPum
    "Check next lag pump"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    if have_heaPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-240,-130},{-220,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nPum) if have_heaPum
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt if have_heaPum
    "Integer add"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4[nPum] if have_heaPum
    "Check if all the pumps have achieved the setpoint status"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nPum] if have_heaPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nPum] if have_heaPum
    "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{220,-130},{240,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch leaPumSta[nPum] if have_heaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch nexLagPumSta[nPum] if have_heaPum
    "Next lag pump status"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch lasLagPumSta[nPum] if have_heaPum
    "Last lag pump status"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaPum[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And pumSta[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch addPum[nPum] if have_heaPum
    "Add pump"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch remPum[nPum] if have_heaPum
    "Remove pump"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nPum) if have_heaPum
    "Check if all the pumps have achieved the setpoint status"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaNexLag if have_heaPum
    "Hold the enabling signal till the pump is proven on"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch disLasLag if have_heaPum
    "Hold the disabling signal till the pump is proven off"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_heaPum
    "Logical not"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And pumSta1[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if there is any enabled pump"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the lead pump is enabled"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr if have_heaPum
    "Check if there is any pump running"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=1)
    if have_heaPum
    "Dummy index"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi if have_heaPum
    "Output 1 when there is no pump running, to avoid warning downstream"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt if have_heaPum
    "Output zero when there is no pump running"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    if have_heaPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));

equation
  connect(enaDedLeaPum.uLeaChiEna, uLeaChiEna)
    annotation (Line(points={{-202,113},{-240,113},{-240,110},{-300,110}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{-202,107},{-240,107},{-240,80},{-300,80}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiWatReq, uLeaChiWatReq)
    annotation (Line(points={{-202,102},{-230,102},{-230,50},{-300,50}},
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
    annotation (Line(points={{-198,170},{50,170},{50,182},{58,182}},
      color={255,127,0}));
  connect(intEqu1.y, leaPumSta.u2)
    annotation (Line(points={{82,190},{118,190}},  color={255,0,255}));
  connect(uChiWatPum, leaPumSta.u3)
    annotation (Line(points={{-300,140},{100,140},{100,182},{118,182}},
      color={255,0,255}));
  connect(booRep.y, leaPumSta.u1)
    annotation (Line(points={{22,100},{90,100},{90,198},{118,198}},
      color={255,0,255}));
  connect(intToRea.y, nexLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-50},{-82,-50}},
      color={0,0,127}));
  connect(nexLagPum.y, reaToInt1.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={0,0,127}));
  connect(reaToInt1.y, intRep1.u)
    annotation (Line(points={{-18,-50},{-2,-50}}, color={255,127,0}));
  connect(intRep1.y, intEqu2.u2)
    annotation (Line(points={{22,-50},{40,-50},{40,-38},{58,-38}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu2.u1)
    annotation (Line(points={{-198,170},{50,170},{50,-30},{58,-30}},
      color={255,127,0}));
  connect(intEqu2.y, nexLagPumSta.u2)
    annotation (Line(points={{82,-30},{118,-30}},  color={255,0,255}));
  connect(booRep1.y, nexLagPumSta.u1)
    annotation (Line(points={{82,30},{110,30},{110,-22},{118,-22}},
      color={255,0,255}));
  connect(uChiWatPum, nexLagPumSta.u3)
    annotation (Line(points={{-300,140},{100,140},{100,-38},{118,-38}},
      color={255,0,255}));
  connect(lasLagPum.y, reaToInt2.u)
    annotation (Line(points={{-58,-90},{-52,-90}},   color={0,0,127}));
  connect(intRep2.y, intEqu3.u2)
    annotation (Line(points={{42,-90},{46,-90},{46,-98},{58,-98}},
      color={255,127,0}));
  connect(pumIndCon.y, intEqu3.u1)
    annotation (Line(points={{-198,170},{50,170},{50,-90},{58,-90}},
      color={255,127,0}));
  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{82,-90},{118,-90}},    color={255,0,255}));
  connect(enaLagChiPum.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{-242,4},{-250,4},{-250,-50},{-300,-50}},
      color={0,0,127}));
  connect(uChiWatPum, enaLagChiPum.uChiWatPum)
    annotation (Line(points={{-300,140},{-260,140},{-260,-3.8},{-242,-3.8}},
      color={255,0,255}));
  connect(intToRea.y, lasLagPum.u)
    annotation (Line(points={{-198,230},{-160,230},{-160,-90},{-82,-90}},
      color={0,0,127}));
  connect(booRep2.y, lasLagPumSta.u1)
    annotation (Line(points={{82,0},{90,0},{90,-82},{118,-82}},
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
    annotation (Line(points={{-2,-202},{-240,-202},{-240,-160},{-300,-160}},
      color={0,0,127}));
  connect(pumSpeLocDp.dpChiWat_remote, dpChiWat_remote)
    annotation (Line(points={{-2,-214},{-270,-214},{-270,-200},{-300,-200}},
      color={0,0,127}));
  connect(pumSpeLocDp.dpChiWatSet_remote, dpChiWatSet_remote) annotation (Line(
        points={{-2,-218},{-220,-218},{-220,-250},{-300,-250}},  color={0,0,127}));
  connect(dpChiWat_remote, pumSpeRemDp.dpChiWat_remote) annotation (Line(points={{-300,
          -200},{-270,-200},{-270,-240},{-62,-240}},       color={0,0,127}));
  connect(dpChiWatSet_remote, pumSpeRemDp.dpChiWatSet_remote) annotation (Line(
        points={{-300,-250},{-220,-250},{-220,-248},{-62,-248}}, color={0,0,127}));
  connect(enaPum.y, pumSta.u2)
    annotation (Line(points={{202,-30},{210,-30},{210,-50},{150,-50},{150,-98},
      {178,-98}},  color={255,0,255}));
  connect(lasLagPumSta.y, pumSta.u1)
    annotation (Line(points={{142,-90},{178,-90}}, color={255,0,255}));
  connect(booRep2.y, remPum.u2)
    annotation (Line(points={{82,0},{90,0},{90,-70},{218,-70}},
      color={255,0,255}));
  connect(pumSta.y, remPum.u3)
    annotation (Line(points={{202,-90},{210,-90},{210,-78},{218,-78}},
      color={255,0,255}));
  connect(leaPumSta.y, remPum.u1)
    annotation (Line(points={{142,190},{160,190},{160,-62},{218,-62}}, color={255,0,255}));
  connect(enaPum.y, addPum.u1)
    annotation (Line(points={{202,-30},{210,-30},{210,8},{238,8}}, color={255,0,255}));
  connect(booRep1.y, addPum.u2)
    annotation (Line(points={{82,30},{110,30},{110,0},{238,0}},  color={255,0,255}));
  connect(remPum.y, addPum.u3)
    annotation (Line(points={{242,-70},{250,-70},{250,-20},{220,-20},{220,-8},
      {238,-8}},  color={255,0,255}));
  connect(uChiWatPum, booToInt.u)
    annotation (Line(points={{-300,140},{-260,140},{-260,-120},{-242,-120}},
      color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-218,-120},{-202,-120}}, color={255,127,0}));
  connect(addInt.y, nexLagPum.index)
    annotation (Line(points={{-118,-70},{-70,-70},{-70,-62}},color={255,127,0}));
  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-178,-120},{-170,-120},{-170,-76},{-142,-76}},
      color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-198,200},{-150,200},{-150,-64},{-142,-64}},
      color={255,127,0}));
  connect(enaDedLeaPum.uPla, uPla)
    annotation (Line(points={{-202,118},{-240,118},{-240,180},{-300,180}},
      color={255,0,255}));
  connect(uChiWatPum, pumSpeLocDp.uChiWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-206},{-2,-206}},  color={255,0,255}));
  connect(uChiWatPum, pumSpeRemDp.uChiWatPum) annotation (Line(points={{-300,140},
          {-260,140},{-260,-232},{-62,-232}}, color={255,0,255}));
  connect(pumSpeLocDp.yChiWatPumSpe, yPumSpe)
    annotation (Line(points={{22,-210},{162,-210},{162,-200},{300,-200}},
          color={0,0,127}));
  connect(pumSpeRemDp.yChiWatPumSpe, yPumSpe) annotation (Line(points={{-39,-240},
          {40,-240},{40,-200},{300,-200}},   color={0,0,127}));
  connect(enaLagChiPum.yUp, enaNexLag.u) annotation (Line(points={{-218,4},{-210,
          4},{-210,30},{-2,30}}, color={255,0,255}));
  connect(enaNexLag.y, booRep1.u)
    annotation (Line(points={{22,30},{58,30}}, color={255,0,255}));
  connect(booToInt1.y, intEqu4.u1)
    annotation (Line(points={{-218,-70},{-202,-70}}, color={255,127,0}));
  connect(booToInt.y, intEqu4.u2) annotation (Line(points={{-218,-120},{-210,-120},
          {-210,-78},{-202,-78}}, color={255,127,0}));
  connect(intEqu4.y, mulAnd.u) annotation (Line(points={{-178,-70},{-170,-70},{-170,
          -20},{-142,-20}}, color={255,0,255}));
  connect(disLasLag.y, not2.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(not2.y, booRep2.u)
    annotation (Line(points={{22,0},{58,0}}, color={255,0,255}));
  connect(pumSpeLocDp.dpChiWatPumSet_local, dpChiWatPumSet_local) annotation (
      Line(points={{22,-216},{200,-216},{200,-240},{300,-240}},  color={0,0,127}));
  connect(booRep.y, pumSta1.u1) annotation (Line(points={{22,100},{90,100},{90,40},
          {238,40}}, color={255,0,255}));
  connect(addPum.y, pumSta1.u2) annotation (Line(points={{262,0},{268,0},{268,20},
          {220,20},{220,32},{238,32}}, color={255,0,255}));
  connect(pumSta1.y, yChiWatPum)
    annotation (Line(points={{262,40},{300,40}}, color={255,0,255}));
  connect(pumSta1.y, pre1.u) annotation (Line(points={{262,40},{272,40},{272,-100},
          {210,-100},{210,-120},{218,-120}}, color={255,0,255}));
  connect(uChiWatIsoVal, enaHeaLeaPum.uChiWatIsoVal) annotation (Line(points={{-300,
          20},{-222,20},{-222,70},{-202,70}}, color={0,0,127}));
  connect(uChiWatPum, mulOr.u) annotation (Line(points={{-300,140},{-140,140},{-140,
          120},{-102,120}}, color={255,0,255}));
  connect(mulOr.y, or2.u1) annotation (Line(points={{-78,120},{-70,120},{-70,100},
          {-62,100}}, color={255,0,255}));
  connect(enaDedLeaPum.yLea, or2.u2) annotation (Line(points={{-178,110},{-120,110},
          {-120,92},{-62,92}}, color={255,0,255}));
  connect(enaHeaLeaPum.yLea, or2.u2) annotation (Line(points={{-178,70},{-120,70},
          {-120,92},{-62,92}}, color={255,0,255}));
  connect(or2.y, yLea) annotation (Line(points={{-38,100},{-20,100},{-20,80},{300,
          80}}, color={255,0,255}));
  connect(or2.y, booRep.u)
    annotation (Line(points={{-38,100},{-2,100}}, color={255,0,255}));
  connect(mulSumInt.y, intGreThr.u) annotation (Line(points={{-178,-120},{-170,-120},
          {-170,-160},{-162,-160}}, color={255,127,0}));
  connect(intGreThr.y, intSwi.u2)
    annotation (Line(points={{-138,-160},{-102,-160}}, color={255,0,255}));
  connect(intSwi.y, lasLagPum.index) annotation (Line(points={{-78,-160},{-70,-160},
          {-70,-102}}, color={255,127,0}));
  connect(mulSumInt.y, intSwi.u1) annotation (Line(points={{-178,-120},{-130,-120},
          {-130,-152},{-102,-152}}, color={255,127,0}));
  connect(conInt1.y, intSwi.u3) annotation (Line(points={{-178,-180},{-130,-180},
          {-130,-168},{-102,-168}}, color={255,127,0}));
  connect(intGreThr.y, booToInt2.u) annotation (Line(points={{-138,-160},{-120,-160},
          {-120,-120},{-52,-120}}, color={255,0,255}));
  connect(booToInt2.y, mulInt.u2) annotation (Line(points={{-28,-120},{-20,-120},
          {-20,-96},{-12,-96}}, color={255,127,0}));
  connect(reaToInt2.y, mulInt.u1) annotation (Line(points={{-28,-90},{-20,-90},{
          -20,-84},{-12,-84}}, color={255,127,0}));
  connect(mulInt.y, intRep2.u)
    annotation (Line(points={{12,-90},{18,-90}}, color={255,127,0}));
  connect(mulAnd.y, disLasLag.clr) annotation (Line(points={{-118,-20},{-100,
          -20},{-100,-6},{-42,-6}}, color={255,0,255}));
  connect(mulAnd.y, enaNexLag.clr) annotation (Line(points={{-118,-20},{-100,
          -20},{-100,24},{-2,24}}, color={255,0,255}));
  connect(pre1.y, booToInt1.u) annotation (Line(points={{242,-120},{260,-120},{
          260,-140},{-250,-140},{-250,-70},{-242,-70}}, color={255,0,255}));
  connect(enaLagChiPum.yDown, disLasLag.u) annotation (Line(points={{-218,-4},{
          -210,-4},{-210,0},{-42,0}}, color={255,0,255}));
annotation (
  defaultComponentName="chiWatPum",
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
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable lead pump"),
          Rectangle(
          extent={{-276,56},{156,-136}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{70,58},{154,44}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next lag pump"),
          Text(
          extent={{70,-116},{152,-134}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable last lag pump"),
          Rectangle(
          extent={{-276,-146},{156,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{70,-154},{152,-168}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enabled pump speed")}),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
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
Primary chilled water pump control sequence per ASHRAE Guideline36-2021, 
section 5.20.6.1 to section 5.20.6.11, except section 3 and 4. It includes:
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
Subsequence to stage lag pumps of primary-only plants with headed varable-speed chilled water pump
using differential pressure pump speed control 
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
