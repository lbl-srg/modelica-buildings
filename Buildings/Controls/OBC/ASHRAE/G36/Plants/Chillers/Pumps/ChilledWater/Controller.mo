within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater;
block Controller
  "Sequences to control chilled water pumps in primary-only plant system"

  parameter Boolean have_heaPum=true
    "Flag of headered chilled water pumps design: true=headered, false=dedicated";
  parameter Boolean have_senDpChiWatRemWir = true
    "True=remote DP sensor hardwired to controller";
  parameter Boolean have_WSE = false
    "True: the plant has waterside economizer";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Integer nChi = 2
    "Total number of chillers";
  parameter Integer nSen=2
    "Total number of remote differential pressure sensors"
    annotation (Dialog(enable=have_senDpChiWatRemWir));
  parameter Real minPumSpe=0.1 "Minimum pump speed";
  parameter Real maxPumSpe=1 "Maximum pump speed";
  parameter Integer nPum_nominal(
    max=nPum,
    min=1)=nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real VChiWat_flow_nominal(
    min=1e-6,
    unit="m3/s")=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Speed controller"));
  parameter Real Ti(
    unit="s",
    displayUnit="s")=0.5 "Time constant of integrator block"
      annotation (Dialog(group="Speed controller"));
  parameter Real Td(
    unit="s",
    displayUnit="s")=0.1 "Time constant of derivative block"
      annotation (Dialog(group="Speed controller",
    enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPumLeaLag[nPum] if have_heaPum
    "Index of chilled water pumps in lead-lag order: lead pump, first lag pump, second lag pump, etc."
    annotation (Placement(transformation(extent={{-320,210},{-280,250}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla if not have_heaPum
    "True: plant is enabled"
    annotation (Placement(transformation(extent={{-320,180},{-280,220}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pumps proven on status"
    annotation (Placement(transformation(extent={{-320,150},{-280,190}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna if not have_heaPum
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-320,120},{-280,160}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta if not have_heaPum
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-320,90},{-280,130}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq
    if not have_heaPum
    "Status indicating if lead chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-320,60},{-280,100}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_heaPum and have_WSE
    "True: the plant has waterside economizer"
    annotation (Placement(transformation(extent={{-320,0},{-280,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiWatIsoVal[nChi] if have_heaPum
    "Chilled water isolation valve commanded position"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s") if have_heaPum
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-320,-32},{-280,8}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_local(
    final unit="Pa",
    final quantity="PressureDifference") if not have_senDpChiWatRemWir
    "Chilled water differential static pressure from local sensor"
    annotation (Placement(transformation(extent={{-320,-180},{-280,-140}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_local(
    final unit="Pa",
    final quantity="PressureDifference")
    if not have_senDpChiWatRemWir
    "Chilled water differential static pressure setpoint for local sensor"
    annotation (Placement(transformation(extent={{-320,-210},{-280,-170}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference", nSen)) if have_senDpChiWatRemWir
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-320,-238},{-280,-198}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet_remote[nSen](
    final unit=fill("Pa", nSen),
    final quantity=fill("PressureDifference",nSen)) if have_senDpChiWatRemWir
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-320,-270},{-280,-230}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{280,80},{320,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nPum]
    if have_heaPum
    "Chilled water pump status setpoint"
    annotation (Placement(transformation(extent={{280,50},{320,90}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Enabled chilled water pump speed"
    annotation (Placement(transformation(extent={{280,-230},{320,-190}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_dedicated
    enaDedLeaPum if not have_heaPum
    "Enable lead pump of dedicated pumps"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_headered
    enaHeaLeaPum(
    final nChi=nChi,
    final have_WSE=have_WSE)
    if have_heaPum
    "Enable lead pump of headered pumps"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP
    enaLagChiPum(
    final nPum=nPum,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=VChiWat_flow_nominal) if have_heaPum
    "Enable lag pump for primary-only plants using differential pressure pump speed control"
    annotation (Placement(transformation(extent={{-260,-26},{-240,-6}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp
    pumSpeLocDp(
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if not have_senDpChiWatRemWir
    "Chilled water pump speed control with local DP sensor"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp
    pumSpeRemDp(
    final nSen=nSen,
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if have_senDpChiWatRemWir
    "Chilled water pump speed control with remote DP sensor"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));

protected
  final parameter Real minLocDp(
    final unit="Pa",
    final quantity="PressureDifference")=5*6894.75
    "Minimum chilled water loop local differential pressure setpoint"
    annotation (Dialog(group="Pump speed control when there is local DP sensor", enable=not have_senDpChiWatRemWir));
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
    final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nPum) if have_heaPum
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nPum) if have_heaPum
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep2(
    final nout=nPum) if have_heaPum
    "Replicate integer input"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nPum) if have_heaPum
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
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
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nPum] if have_heaPum
    "Check lead pump"
    annotation (Placement(transformation(extent={{60,220},{80,240}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexLagPum(
    final nin=nPum) if have_heaPum
    "Next lag pump"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 if have_heaPum
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum] if have_heaPum
    "Check next lag pump"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
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
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nPum) if have_heaPum
    "Sum of integer inputs"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt if have_heaPum
    "Integer add"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4[nPum] if have_heaPum
    "Check if all the pumps have achieved the setpoint status"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nPum] if have_heaPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nPum] if have_heaPum
    "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{220,-130},{240,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch leaPumSta[nPum] if have_heaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{120,220},{140,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch nexLagPumSta[nPum] if have_heaPum
    "Next lag pump status"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch lasLagPumSta[nPum] if have_heaPum
    "Last lag pump status"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaPum[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Buildings.Controls.OBC.CDL.Logical.And pumSta[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch addPum[nPum] if have_heaPum
    "Add pump"
    annotation (Placement(transformation(extent={{240,10},{260,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch remPum[nPum] if have_heaPum
    "Remove pump"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nPum) if have_heaPum
    "Check if all the pumps have achieved the setpoint status"
    annotation (Placement(transformation(extent={{-140,48},{-120,68}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaNexLag if have_heaPum
    "Hold the enabling signal till the pump is proven on"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch disLasLag if have_heaPum
    "Hold the disabling signal till the pump is proven off"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_heaPum
    "Logical not"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.And pumSta1[nPum] if have_heaPum
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if there is any enabled pump"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the lead pump is enabled"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
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
  Buildings.Controls.OBC.CDL.Logical.Edge edg if have_heaPum
    "Achieved setpoint"
    annotation (Placement(transformation(extent={{-100,48},{-80,68}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1 if have_heaPum
    "Output zero when there is no pump running"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
    final t=nPum +1) if have_heaPum
    "Check if it is not greater than pump number"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 if have_heaPum
    "Output 1 when there are too many pumps running, to avoid warning downstream"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=1)
    if have_heaPum
    "Dummy index"
    annotation (Placement(transformation(extent={{-158,-80},{-138,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    if have_heaPum
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));

equation
  connect(enaDedLeaPum.uLeaChiEna, uLeaChiEna)
    annotation (Line(points={{-222,133},{-250,133},{-250,140},{-300,140}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{-222,127},{-250,127},{-250,110},{-300,110}},
      color={255,0,255}));
  connect(enaDedLeaPum.uLeaChiWatReq, uLeaChiWatReq)
    annotation (Line(points={{-222,122},{-240,122},{-240,80},{-300,80}},
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
    annotation (Line(points={{22,230},{58,230}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu1.u2)
    annotation (Line(points={{-18,200},{50,200},{50,222},{58,222}},
      color={255,127,0}));
  connect(intEqu1.y, leaPumSta.u2)
    annotation (Line(points={{82,230},{118,230}},  color={255,0,255}));
  connect(uChiWatPum, leaPumSta.u3)
    annotation (Line(points={{-300,170},{100,170},{100,222},{118,222}},
      color={255,0,255}));
  connect(booRep.y, leaPumSta.u1)
    annotation (Line(points={{22,120},{90,120},{90,238},{118,238}},
      color={255,0,255}));
  connect(intToRea.y, nexLagPum.u)
    annotation (Line(points={{-198,230},{-180,230},{-180,0},{-82,0}},
      color={0,0,127}));
  connect(nexLagPum.y, reaToInt1.u)
    annotation (Line(points={{-58,0},{-52,0}}, color={0,0,127}));
  connect(intRep1.y, intEqu2.u2)
    annotation (Line(points={{42,0},{46,0},{46,-8},{58,-8}}, color={255,127,0}));
  connect(pumIndCon.y, intEqu2.u1)
    annotation (Line(points={{-18,200},{50,200},{50,0},{58,0}},
      color={255,127,0}));
  connect(intEqu2.y, nexLagPumSta.u2)
    annotation (Line(points={{82,0},{118,0}}, color={255,0,255}));
  connect(booRep1.y, nexLagPumSta.u1)
    annotation (Line(points={{82,60},{110,60},{110,8},{118,8}},
      color={255,0,255}));
  connect(uChiWatPum, nexLagPumSta.u3)
    annotation (Line(points={{-300,170},{100,170},{100,-8},{118,-8}},
      color={255,0,255}));
  connect(lasLagPum.y, reaToInt2.u)
    annotation (Line(points={{-58,-90},{-52,-90}},   color={0,0,127}));
  connect(intRep2.y, intEqu3.u2)
    annotation (Line(points={{42,-90},{46,-90},{46,-98},{58,-98}},
      color={255,127,0}));
  connect(pumIndCon.y, intEqu3.u1)
    annotation (Line(points={{-18,200},{50,200},{50,-90},{58,-90}},
      color={255,127,0}));
  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{82,-90},{118,-90}},    color={255,0,255}));
  connect(enaLagChiPum.VChiWat_flow, VChiWat_flow)
    annotation (Line(points={{-262,-12},{-300,-12}},
      color={0,0,127}));
  connect(uChiWatPum, enaLagChiPum.uChiWatPum)
    annotation (Line(points={{-300,170},{-270,170},{-270,-19.8},{-262,-19.8}},
      color={255,0,255}));
  connect(intToRea.y, lasLagPum.u)
    annotation (Line(points={{-198,230},{-180,230},{-180,-90},{-82,-90}},
      color={0,0,127}));
  connect(booRep2.y, lasLagPumSta.u1)
    annotation (Line(points={{82,30},{96,30},{96,-82},{118,-82}},
      color={255,0,255}));
  connect(uChiWatPum, lasLagPumSta.u3)
    annotation (Line(points={{-300,170},{100,170},{100,-98},{118,-98}},
      color={255,0,255}));
  connect(nexLagPumSta.y,enaPum. u2)
    annotation (Line(points={{142,0},{150,0},{150,-18},{178,-18}},
      color={255,0,255}));
  connect(leaPumSta.y,enaPum. u1)
    annotation (Line(points={{142,230},{160,230},{160,-10},{178,-10}},
      color={255,0,255}));
  connect(pumSpeLocDp.dpChiWat_local, dpChiWat_local)
    annotation (Line(points={{-2,-204},{-222,-204},{-222,-160},{-300,-160}},
      color={0,0,127}));
  connect(dpChiWat_remote, pumSpeRemDp.dpChiWat_remote) annotation (Line(points={{-300,
          -218},{-260,-218},{-260,-240},{-2,-240}}, color={0,0,127}));
  connect(dpChiWatSet_remote, pumSpeRemDp.dpChiWatSet_remote) annotation (Line(
        points={{-300,-250},{-220,-250},{-220,-248},{-2,-248}},  color={0,0,127}));
  connect(enaPum.y, pumSta.u2)
    annotation (Line(points={{202,-10},{210,-10},{210,-50},{150,-50},{150,-98},{
          178,-98}}, color={255,0,255}));
  connect(lasLagPumSta.y, pumSta.u1)
    annotation (Line(points={{142,-90},{178,-90}}, color={255,0,255}));
  connect(booRep2.y, remPum.u2)
    annotation (Line(points={{82,30},{96,30},{96,-70},{218,-70}},
      color={255,0,255}));
  connect(pumSta.y, remPum.u3)
    annotation (Line(points={{202,-90},{210,-90},{210,-78},{218,-78}},
      color={255,0,255}));
  connect(leaPumSta.y, remPum.u1)
    annotation (Line(points={{142,230},{160,230},{160,-62},{218,-62}}, color={255,0,255}));
  connect(enaPum.y, addPum.u1)
    annotation (Line(points={{202,-10},{210,-10},{210,28},{238,28}}, color={255,0,255}));
  connect(booRep1.y, addPum.u2)
    annotation (Line(points={{82,60},{110,60},{110,20},{238,20}},color={255,0,255}));
  connect(remPum.y, addPum.u3)
    annotation (Line(points={{242,-70},{250,-70},{250,-20},{220,-20},{220,12},{238,
          12}},   color={255,0,255}));
  connect(uChiWatPum, booToInt.u)
    annotation (Line(points={{-300,170},{-270,170},{-270,-120},{-262,-120}},
      color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-238,-120},{-222,-120}}, color={255,127,0}));
  connect(mulSumInt.y, addInt.u2)
    annotation (Line(points={{-198,-120},{-190,-120},{-190,-26},{-162,-26}},
      color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-198,200},{-170,200},{-170,-14},{-162,-14}},
      color={255,127,0}));
  connect(enaDedLeaPum.uPla, uPla)
    annotation (Line(points={{-222,138},{-240,138},{-240,200},{-300,200}},
      color={255,0,255}));
  connect(pumSpeLocDp.yChiWatPumSpe, yPumSpe)
    annotation (Line(points={{22,-210},{300,-210}},
          color={0,0,127}));
  connect(pumSpeRemDp.yChiWatPumSpe, yPumSpe) annotation (Line(points={{21,-240},
          {100,-240},{100,-210},{300,-210}}, color={0,0,127}));
  connect(enaLagChiPum.yUp, enaNexLag.u) annotation (Line(points={{-238,-12},{-210,
          -12},{-210,80},{-2,80}}, color={255,0,255}));
  connect(enaNexLag.y, booRep1.u)
    annotation (Line(points={{22,80},{40,80},{40,60},{58,60}}, color={255,0,255}));
  connect(booToInt1.y, intEqu4.u1)
    annotation (Line(points={{-238,-70},{-222,-70}}, color={255,127,0}));
  connect(booToInt.y, intEqu4.u2) annotation (Line(points={{-238,-120},{-230,-120},
          {-230,-78},{-222,-78}}, color={255,127,0}));
  connect(intEqu4.y, mulAnd.u) annotation (Line(points={{-198,-70},{-190,-70},{-190,
          58},{-142,58}},   color={255,0,255}));
  connect(disLasLag.y, not2.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(not2.y, booRep2.u)
    annotation (Line(points={{22,40},{40,40},{40,30},{58,30}}, color={255,0,255}));
  connect(booRep.y, pumSta1.u1) annotation (Line(points={{22,120},{90,120},{90,70},
          {238,70}}, color={255,0,255}));
  connect(addPum.y, pumSta1.u2) annotation (Line(points={{262,20},{268,20},{268,
          50},{220,50},{220,62},{238,62}}, color={255,0,255}));
  connect(pumSta1.y, yChiWatPum)
    annotation (Line(points={{262,70},{300,70}}, color={255,0,255}));
  connect(pumSta1.y, pre1.u) annotation (Line(points={{262,70},{272,70},{272,-100},
          {210,-100},{210,-120},{218,-120}}, color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation (Line(points={{-300,170},{-140,170},{-140,
          140},{-102,140}}, color={255,0,255}));
  connect(mulOr.y, or2.u1) annotation (Line(points={{-78,140},{-70,140},{-70,120},
          {-62,120}}, color={255,0,255}));
  connect(enaDedLeaPum.yLea, or2.u2) annotation (Line(points={{-198,130},{-120,130},
          {-120,112},{-62,112}}, color={255,0,255}));
  connect(enaHeaLeaPum.yLea, or2.u2) annotation (Line(points={{-198,100},{-120,100},
          {-120,112},{-62,112}}, color={255,0,255}));
  connect(or2.y, yLea) annotation (Line(points={{-38,120},{-20,120},{-20,100},{300,
          100}},color={255,0,255}));
  connect(or2.y, booRep.u)
    annotation (Line(points={{-38,120},{-2,120}}, color={255,0,255}));
  connect(mulSumInt.y, intGreThr.u) annotation (Line(points={{-198,-120},{-170,-120},
          {-170,-160},{-162,-160}}, color={255,127,0}));
  connect(intGreThr.y, intSwi.u2)
    annotation (Line(points={{-138,-160},{-102,-160}}, color={255,0,255}));
  connect(intSwi.y, lasLagPum.index) annotation (Line(points={{-78,-160},{-70,-160},
          {-70,-102}}, color={255,127,0}));
  connect(mulSumInt.y, intSwi.u1) annotation (Line(points={{-198,-120},{-130,-120},
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
  connect(pre1.y, booToInt1.u) annotation (Line(points={{242,-120},{260,-120},{260,
          -140},{-274,-140},{-274,-70},{-262,-70}},     color={255,0,255}));
  connect(enaLagChiPum.yDown, disLasLag.u) annotation (Line(points={{-238,-20},{
          -200,-20},{-200,40},{-42,40}}, color={255,0,255}));
  connect(uWse, enaHeaLeaPum.uWse) annotation (Line(points={{-300,20},{-228,20},
          {-228,94},{-222,94}}, color={255,0,255}));
  connect(booRep.y, pumSpeLocDp.uChiWatPum) annotation (Line(points={{22,120},{90,
          120},{90,-180},{-18,-180},{-18,-216},{-2,-216}},    color={255,0,255}));
  connect(booRep.y, pumSpeRemDp.uChiWatPum) annotation (Line(points={{22,120},{90,
          120},{90,-180},{-18,-180},{-18,-232},{-2,-232}},    color={255,0,255}));
  connect(dpChiWatSet_local, pumSpeLocDp.dpChiWatSet_local) annotation (Line(
        points={{-300,-190},{-240,-190},{-240,-210},{-2,-210}}, color={0,0,127}));
  connect(mulAnd.y, edg.u)
    annotation (Line(points={{-118,58},{-102,58}},   color={255,0,255}));
  connect(edg.y, enaNexLag.clr) annotation (Line(points={{-78,58},{-60,58},{-60,
          74},{-2,74}}, color={255,0,255}));
  connect(edg.y, disLasLag.clr) annotation (Line(points={{-78,58},{-60,58},{-60,
          34},{-42,34}}, color={255,0,255}));
  connect(u1ChiWatIsoVal, enaHeaLeaPum.u1ChiWatIsoVal) annotation (Line(points={{-300,50},
          {-234,50},{-234,100},{-222,100}}, color={255,0,255}));
  connect(intRep1.u, mulInt1.y)
    annotation (Line(points={{18,0},{12,0}}, color={255,127,0}));
  connect(reaToInt1.y, mulInt1.u1) annotation (Line(points={{-28,0},{-20,0},{-20,
          6},{-12,6}}, color={255,127,0}));
  connect(addInt.y, intLesThr.u) annotation (Line(points={{-138,-20},{-130,-20},
          {-130,-40},{-122,-40}}, color={255,127,0}));
  connect(intLesThr.y, intSwi1.u2)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={255,0,255}));
  connect(addInt.y, intSwi1.u1) annotation (Line(points={{-138,-20},{-90,-20},{-90,
          -32},{-82,-32}}, color={255,127,0}));
  connect(conInt2.y, intSwi1.u3) annotation (Line(points={{-136,-70},{-94,-70},{
          -94,-48},{-82,-48}}, color={255,127,0}));
  connect(intSwi1.y, nexLagPum.index) annotation (Line(points={{-58,-40},{-50,-40},
          {-50,-20},{-70,-20},{-70,-12}}, color={255,127,0}));
  connect(intLesThr.y, booToInt3.u) annotation (Line(points={{-98,-40},{-88,-40},
          {-88,-60},{-52,-60}}, color={255,0,255}));
  connect(booToInt3.y, mulInt1.u2) annotation (Line(points={{-28,-60},{-20,-60},
          {-20,-6},{-12,-6}}, color={255,127,0}));
annotation (
  defaultComponentName="chiWatPum",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-260},{280,260}}), graphics={
          Rectangle(
          extent={{-278,258},{154,104}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,262},{140,246}},
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable lead pump"),
          Rectangle(
          extent={{-278,96},{156,-134}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{60,94},{144,80}},
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next lag pump"),
          Text(
          extent={{70,-116},{152,-134}},
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
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enabled pump speed")}),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}}),
       graphics={
        Rectangle(
          extent={{-100,-140},{100,140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,180},{100,140}},
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
Primary chilled water pump control sequence per ASHRAE Guideline 36-2021, 
section 5.20.6.1 to section 5.20.6.11, except section 3 and 4. It includes:
</p>
<ul>
<li>
Subsequences to enable the lead pump, 
<ul>
<li>
for plants with dedicated pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_dedicated</a>
</li>
<li>
for plants with headered pumps 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLead_headered</a>
</li>
</ul>
</li>
<li>
Subsequence to stage lag pumps of primary-only plants with headed variable-speed chilled water pump
using differential pressure pump speed control 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.EnableLag_primary_dP</a>
</li>
<li>
Subsequences to control pump speed for primary-only plants,
<ul>
<li>
where the remote DP sensor(s) is not hardwired to the plant controller, 
but a local DP sensor is hardwired
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_localDp</a>
</li>
<li>
where the remote DP sensor(s) is hardwired to the plant controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Subsequences.Speed_primary_remoteDp</a>
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
