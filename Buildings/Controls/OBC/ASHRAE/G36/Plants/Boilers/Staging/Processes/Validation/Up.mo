within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Validation;
model Up
    "Validate sequence of staging up process"

  parameter Integer nBoi=2
    "Total number of boilers in the plant";

  parameter Integer nSta=3
    "Total number of stages";

  parameter Real delBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 180
    "Time delay after boiler change process has been completed before turning off excess valves and pumps";

  parameter Real delEnaMinFloSet(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=60
    "Enable delay after minimum flow setpoint is achieved in bypass valve";

  parameter Real delProSupTemSet(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300
    "Process time-out for hot water supply temperature setpoint reset";

  parameter Real TMinSupNonConBoi(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")=333.2
    "Minimum supply temperature required for non-condensing boilers";

  parameter Real sigDif(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")=0.1
    "Significant difference based on minimum resolution of temperature sensor";

  parameter Real chaIsoValTim(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=60
    "Time to slowly change isolation valve, should be determined in the field";

  parameter Real boiChaProOnTim(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300
    "Enabled boiler operation time to indicate if it is proven on during a staging
    process where one boiler is turned on and the other is turned off";

  parameter Real relFloDif(
    final unit="1",
    final displayUnit="1")=0.05
    "Relative error to the flow setpoint for checking if it has been achieved";

  parameter Real delPreBoiEna(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=30
    "Time delay after valve and pump change process has been completed before
    starting boiler change process";

  parameter Real VNom_flow(
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate") = 1
    "Nominal minimum flow rate";

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon(
    final have_priOnl=false,
    final have_heaPriPum=true,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final delProSupTemSet=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage up process where temperature reset condition is met with headered pumps"
    annotation (Placement(transformation(extent={{-160,170},{-140,210}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon1(
    final have_priOnl=false,
    final have_heaPriPum=true,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final delProSupTemSet=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage up process where temperature reset condition is not met with headered pumps"
    annotation (Placement(transformation(extent={{210,170},{230,210}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon2(
    final have_priOnl=false,
    final have_heaPriPum=false,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final delProSupTemSet=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage up process where temperature reset condition is met with dedicated pumps"
    annotation (Placement(transformation(extent={{-170,-170},{-150,-130}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon3(
    final have_priOnl=false,
    final have_heaPriPum=false,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final delProSupTemSet=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage up process where temperature reset condition is not met with dedicated pumps"
    annotation (Placement(transformation(extent={{410,-172},{430,-132}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up upProCon4(
    final have_priOnl=true,
    final have_heaPriPum=true,
    final nBoi=nBoi,
    final nSta=nSta,
    final delBoiEna=delBoiEna,
    final delPreBoiEna=delPreBoiEna,
    final delEnaMinFloSet=delEnaMinFloSet,
    final delProSupTemSet=delProSupTemSet,
    final TMinSupNonConBoi=TMinSupNonConBoi,
    final sigDif=sigDif,
    final chaIsoValTim=chaIsoValTim,
    final boiChaProOnTim=boiChaProOnTim,
    final relFloDif=relFloDif)
    "Stage up process for primary-only, condensing boiler plants with headered pumps"
    annotation (Placement(transformation(extent={{600,168},{620,208}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{250,190},{270,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-130,-140},{-110,-120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro3(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{450,-140},{470,-120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{640,190},{660,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{250,150},{270,170}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-130,-180},{-110,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro3(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{450,-180},{470,-160}})));

  CDL.Integers.OnCounter onCouInt(y_start=0)
    annotation (Placement(transformation(extent={{-298,170},{-278,190}})));
  CDL.Logical.And and2[nBoi]
    annotation (Placement(transformation(extent={{-208,110},{-188,130}})));
  CDL.Logical.And and1[nBoi]
    annotation (Placement(transformation(extent={{-208,80},{-188,100}})));
  CDL.Logical.And and3[nBoi]
    annotation (Placement(transformation(extent={{-208,50},{-188,70}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-268,130},{-248,150}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-268,90},{-248,110}})));
  CDL.Routing.BooleanScalarReplicator booScaRep(nout=nBoi)
    annotation (Placement(transformation(extent={{-238,130},{-218,150}})));
  CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nBoi)
    annotation (Placement(transformation(extent={{-238,90},{-218,110}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-266,50},{-246,70}})));
  CDL.Routing.BooleanScalarReplicator booScaRep2(nout=nBoi)
    annotation (Placement(transformation(extent={{-236,50},{-216,70}})));
  CDL.Logical.Or or2[nBoi]
    annotation (Placement(transformation(extent={{-158,90},{-138,110}})));
  CDL.Logical.Or or7[nBoi]
    annotation (Placement(transformation(extent={{-118,80},{-98,100}})));
  CDL.Logical.Or or6
    annotation (Placement(transformation(extent={{-330,170},{-310,190}})));
  CDL.Logical.Or or8
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  CDL.Integers.OnCounter onCouInt1(y_start=0)
    annotation (Placement(transformation(extent={{70,200},{90,220}})));
  CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  CDL.Routing.BooleanScalarReplicator booScaRep3(nout=nBoi)
    annotation (Placement(transformation(extent={{130,160},{150,180}})));
  CDL.Routing.BooleanScalarReplicator booScaRep4(nout=nBoi)
    annotation (Placement(transformation(extent={{130,120},{150,140}})));
  CDL.Integers.Equal intEqu4
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  CDL.Integers.Equal intEqu5
    annotation (Placement(transformation(extent={{102,80},{122,100}})));
  CDL.Routing.BooleanScalarReplicator booScaRep5(nout=nBoi)
    annotation (Placement(transformation(extent={{132,80},{152,100}})));
  CDL.Logical.And and4[nBoi]
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  CDL.Logical.And and5[nBoi]
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  CDL.Logical.And and6[nBoi]
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  CDL.Logical.Or or9[nBoi]
    annotation (Placement(transformation(extent={{210,120},{230,140}})));
  CDL.Logical.Or or10[nBoi]
    annotation (Placement(transformation(extent={{250,110},{270,130}})));
  CDL.Logical.And and7[nBoi]
    annotation (Placement(transformation(extent={{550,160},{570,180}})));
  CDL.Logical.And and8[nBoi]
    annotation (Placement(transformation(extent={{550,130},{570,150}})));
  CDL.Logical.And and9[nBoi]
    annotation (Placement(transformation(extent={{550,100},{570,120}})));
  CDL.Integers.Equal intEqu6
    annotation (Placement(transformation(extent={{490,180},{510,200}})));
  CDL.Integers.Equal intEqu7
    annotation (Placement(transformation(extent={{490,140},{510,160}})));
  CDL.Routing.BooleanScalarReplicator booScaRep6(nout=nBoi)
    annotation (Placement(transformation(extent={{520,180},{540,200}})));
  CDL.Routing.BooleanScalarReplicator booScaRep7(nout=nBoi)
    annotation (Placement(transformation(extent={{520,140},{540,160}})));
  CDL.Integers.Equal intEqu8
    annotation (Placement(transformation(extent={{492,100},{512,120}})));
  CDL.Routing.BooleanScalarReplicator booScaRep8(nout=nBoi)
    annotation (Placement(transformation(extent={{522,100},{542,120}})));
  CDL.Integers.OnCounter onCouInt2(y_start=0)
    annotation (Placement(transformation(extent={{460,220},{480,240}})));
  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{430,220},{450,240}})));
  CDL.Logical.Or or5[nBoi]
    annotation (Placement(transformation(extent={{600,140},{620,160}})));
  CDL.Logical.Or or11[nBoi]
    annotation (Placement(transformation(extent={{640,130},{660,150}})));
  CDL.Logical.And and10[nBoi]
    annotation (Placement(transformation(extent={{-228,-200},{-208,-180}})));
  CDL.Logical.And and11[nBoi]
    annotation (Placement(transformation(extent={{-228,-230},{-208,-210}})));
  CDL.Logical.And and12[nBoi]
    annotation (Placement(transformation(extent={{-228,-260},{-208,-240}})));
  CDL.Integers.Equal intEqu9
    annotation (Placement(transformation(extent={{-288,-180},{-268,-160}})));
  CDL.Integers.Equal intEqu10
    annotation (Placement(transformation(extent={{-288,-220},{-268,-200}})));
  CDL.Routing.BooleanScalarReplicator booScaRep9(nout=nBoi)
    annotation (Placement(transformation(extent={{-258,-180},{-238,-160}})));
  CDL.Routing.BooleanScalarReplicator booScaRep10(nout=nBoi)
    annotation (Placement(transformation(extent={{-258,-220},{-238,-200}})));
  CDL.Integers.Equal intEqu11
    annotation (Placement(transformation(extent={{-286,-260},{-266,-240}})));
  CDL.Routing.BooleanScalarReplicator booScaRep11(nout=nBoi)
    annotation (Placement(transformation(extent={{-256,-260},{-236,-240}})));
  CDL.Integers.OnCounter onCouInt3(y_start=0)
    annotation (Placement(transformation(extent={{-318,-140},{-298,-120}})));
  CDL.Logical.Or or3
    annotation (Placement(transformation(extent={{-348,-140},{-328,-120}})));
  CDL.Logical.Or or12[nBoi]
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  CDL.Logical.Or or13[nBoi]
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  CDL.Logical.And and13[nBoi]
    annotation (Placement(transformation(extent={{362,-210},{382,-190}})));
  CDL.Logical.And and14[nBoi]
    annotation (Placement(transformation(extent={{362,-240},{382,-220}})));
  CDL.Logical.And and15[nBoi]
    annotation (Placement(transformation(extent={{362,-270},{382,-250}})));
  CDL.Integers.Equal intEqu12
    annotation (Placement(transformation(extent={{300,-190},{320,-170}})));
  CDL.Integers.Equal intEqu13
    annotation (Placement(transformation(extent={{300,-230},{320,-210}})));
  CDL.Routing.BooleanScalarReplicator booScaRep12(nout=nBoi)
    annotation (Placement(transformation(extent={{332,-190},{352,-170}})));
  CDL.Routing.BooleanScalarReplicator booScaRep13(nout=nBoi)
    annotation (Placement(transformation(extent={{332,-230},{352,-210}})));
  CDL.Integers.Equal intEqu14
    annotation (Placement(transformation(extent={{302,-270},{322,-250}})));
  CDL.Routing.BooleanScalarReplicator booScaRep14(nout=nBoi)
    annotation (Placement(transformation(extent={{334,-270},{354,-250}})));
  CDL.Logical.Or or4[nBoi]
    annotation (Placement(transformation(extent={{410,-220},{430,-200}})));
  CDL.Logical.Or or14[nBoi]
    annotation (Placement(transformation(extent={{460,-260},{480,-240}})));
  CDL.Integers.OnCounter onCouInt4(y_start=0)
    annotation (Placement(transformation(extent={{270,-150},{290,-130}})));
  CDL.Logical.Or or15
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));
protected
  CDL.Logical.Pre pre20[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-370,80},{-350,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-370,50},{-350,70}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nSta](
    final k={1,2,2}) "Stage type vector"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1/3600,
    final period=3600,
    final shift=1) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,220},{-350,240}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,210},{-40,230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,false}) "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-370,110},{-350,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{40,126},{60,146}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{40,96},{60,116}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,150},{300,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{70,140},{90,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{130,220},{150,240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1/1800,
    final period=1800,
    final shift=1) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{0,226},{20,246}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{190,280},{210,300}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{340,150},{360,170}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{310,210},{330,230}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{40,156},{60,176}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{70,170},{90,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-370,-240},{-350,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-368,-280},{-348,-260}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg6
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-330,-260},{-310,-240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-330,-220},{-310,-200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.1/1800,
    final period=1800,
    final shift=1) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con13(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-340,-60},{-320,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9
    "Logical pre block"
    annotation (Placement(transformation(extent={{-38,-140},{-18,-120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg7
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con14[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-368,-200},{-348,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt11(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-330,-180},{-310,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con15[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{210,-250},{230,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{210,-300},{230,-280}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg9
    "Falling edge detector"
    annotation (Placement(transformation(extent={{480,-180},{500,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt12(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{240,-270},{260,-250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt13(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{240,-230},{260,-210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt14[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{360,-80},{380,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.1/1800,
    final period=1800,
    final shift=1) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{200,-80},{220,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con18(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{240,-60},{260,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre11
    "Logical pre block"
    annotation (Placement(transformation(extent={{530,-200},{550,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre12
    "Logical pre block"
    annotation (Placement(transformation(extent={{542,-140},{562,-120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg10
    "Falling edge detector"
    annotation (Placement(transformation(extent={{480,-140},{500,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con19[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{210,-210},{230,-190}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt15(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{240,-200},{260,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{420,140},{440,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{420,100},{440,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{460,110},{480,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{460,150},{480,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt18[nSta](
    final k={1,1,1})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{540,220},{560,240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.1/1800,
    final period=1800,
    final shift=1) "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{390,280},{410,300}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{580,280},{600,300}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{700,210},{720,230}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{670,190},{690,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con24[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{420,180},{440,200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{460,190},{480,210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con17(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{540,260},{560,280}})));

  CDL.Logical.Pre pre21[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{310,170},{330,190}})));

  CDL.Logical.Pre pre22[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{700,170},{720,190}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,210},{-70,230}})));

  CDL.Logical.Sources.Constant con7(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{-370,140},{-350,160}})));
  CDL.Integers.Sources.Constant                        conInt1(final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-340,124},{-320,144}})));
  CDL.Integers.Sources.Constant                        conInt3(final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-340,90},{-320,110}})));
  CDL.Integers.Sources.Constant                        conInt20(final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-340,50},{-320,70}})));
  CDL.Logical.Pre                        pre14
    "Logical pre block"
    annotation (Placement(transformation(extent={{-370,166},{-350,186}})));
  CDL.Logical.Pre                        pre3
    "Logical pre block"
    annotation (Placement(transformation(extent={{10,190},{30,210}})));
  CDL.Logical.Sources.Constant con12(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{8,160},{28,180}})));
  CDL.Logical.Pre                        pre4
    "Logical pre block"
    annotation (Placement(transformation(extent={{390,216},{410,236}})));
  CDL.Logical.Sources.Constant con22(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{380,180},{400,200}})));
  CDL.Logical.Pre                        pre7
    "Logical pre block"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));
  CDL.Logical.Sources.Constant con25(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{-370,-170},{-350,-150}})));
  CDL.Logical.Sources.Constant con26(final k=false) "Constant false signal"
    annotation (Placement(transformation(extent={{200,-180},{220,-160}})));
  CDL.Logical.Pre                        pre10
    "Logical pre block"
    annotation (Placement(transformation(extent={{200,-154},{220,-134}})));
protected
  CDL.Logical.Pre pre13[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{-140,250},{-160,270}})));
protected
  CDL.Logical.Pre pre16[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{230,218},{210,238}})));
protected
  CDL.Logical.Pre pre17[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{620,216},{600,236}})));
protected
  CDL.Logical.Pre pre18[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{-150,-120},{-170,-100}})));
protected
  CDL.Logical.Pre pre19[nBoi]                           "Logical pre block"
    annotation (Placement(transformation(extent={{430,-120},{410,-100}})));
equation

  connect(upProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,178},
          {-130,178},{-130,160},{-122,160}}, color={255,0,255}));

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(conInt2.y, upProCon.uStaTyp) annotation (Line(points={{-218,210},{
          -210,210},{-210,184},{-162,184}},
                                       color={255,127,0}));

  connect(con3.y, upProCon.THotWatSupSet) annotation (Line(points={{-198,250},{
          -172,250},{-172,204},{-162,204}},                       color={0,0,
          127}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-62,160}},
                           color={255,0,255}));

  connect(pre1.y, upProCon.uPumChaPro) annotation (Line(points={{-38,160},{-32,
          160},{-32,144},{-162,144},{-162,168}},
        color={255,0,255}));

  connect(upProCon.yStaChaPro,yStaChaPro. u) annotation (Line(points={{-138,198},
          {-126,198},{-126,220},{-122,220}}, color={255,0,255}));

  connect(upProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{232,178},
          {240,178},{240,160},{248,160}},      color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{272,160},{278,160}}, color={255,0,255}));

  connect(conInt6.y, upProCon1.uStaTyp) annotation (Line(points={{152,230},{192,
          230},{192,184},{208,184}}, color={255,127,0}));

  connect(con8.y, upProCon1.THotWatSupSet) annotation (Line(points={{212,290},{
          220,290},{220,270},{200,270},{200,204},{208,204}}, color={0,0,127}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{302,160},{338,160}},
                      color={255,0,255}));

  connect(pre5.y, upProCon1.uPumChaPro) annotation (Line(points={{362,160},{364,
          160},{364,120},{320,120},{320,140},{202,140},{202,168},{208,168}},
        color={255,0,255}));
  connect(upProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{232,198},
          {244,198},{244,200},{248,200}},      color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{272,200},{278,200}}, color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{302,200},{306,200},{306,220},{308,220}},
                                                   color={255,0,255}));

  connect(upProCon2.yPumChaPro, yPumChaPro2.u) annotation (Line(points={{-148,-162},
          {-140,-162},{-140,-170},{-132,-170}}, color={255,0,255}));

  connect(yPumChaPro2.y, falEdg6.u)
    annotation (Line(points={{-108,-170},{-102,-170}}, color={255,0,255}));

  connect(conInt10.y, upProCon2.uStaTyp) annotation (Line(points={{-198,-70},{
          -192,-70},{-192,-156},{-172,-156}},
                                          color={255,127,0}));

  connect(con13.y, upProCon2.THotWatSupSet) annotation (Line(points={{-318,-50},
          {-180,-50},{-180,-136},{-172,-136}}, color={0,0,127}));

  connect(falEdg6.y, pre8.u) annotation (Line(points={{-78,-170},{-62,-170}},
                             color={255,0,255}));

  connect(pre8.y, upProCon2.uPumChaPro) annotation (Line(points={{-38,-170},{
          -32,-170},{-32,-188},{-176,-188},{-176,-172},{-172,-172}},
                  color={255,0,255}));

  connect(upProCon2.yStaChaPro, yStaChaPro2.u) annotation (Line(points={{-148,-142},
          {-136,-142},{-136,-130},{-132,-130}}, color={255,0,255}));

  connect(yStaChaPro2.y, falEdg7.u)
    annotation (Line(points={{-108,-130},{-102,-130}}, color={255,0,255}));

  connect(falEdg7.y,pre9. u)
    annotation (Line(points={{-78,-130},{-40,-130}},
                                                   color={255,0,255}));

  connect(upProCon3.yPumChaPro, yPumChaPro3.u) annotation (Line(points={{432,-164},
          {440,-164},{440,-170},{448,-170}}, color={255,0,255}));

  connect(yPumChaPro3.y, falEdg9.u)
    annotation (Line(points={{472,-170},{478,-170}}, color={255,0,255}));

  connect(conInt14.y, upProCon3.uStaTyp) annotation (Line(points={{382,-70},{
          396,-70},{396,-158},{408,-158}},
                                        color={255,127,0}));

  connect(con18.y, upProCon3.THotWatSupSet) annotation (Line(points={{262,-50},
          {400,-50},{400,-138},{408,-138}}, color={0,0,127}));

  connect(falEdg9.y, pre11.u) annotation (Line(points={{502,-170},{524,-170},{524,
          -190},{528,-190}}, color={255,0,255}));

  connect(pre11.y, upProCon3.uPumChaPro) annotation (Line(points={{552,-190},{
          564,-190},{564,-210},{510,-210},{510,-188},{402,-188},{402,-174},{408,
          -174}},
        color={255,0,255}));
  connect(upProCon3.yStaChaPro, yStaChaPro3.u) annotation (Line(points={{432,-144},
          {441,-144},{441,-130},{448,-130}}, color={255,0,255}));

  connect(yStaChaPro3.y, falEdg10.u)
    annotation (Line(points={{472,-130},{478,-130}}, color={255,0,255}));

  connect(falEdg10.y, pre12.u)
    annotation (Line(points={{502,-130},{540,-130}}, color={255,0,255}));

  connect(conInt18.y, upProCon4.uStaTyp) annotation (Line(points={{562,230},{
          568,230},{568,182},{598,182}},
                                     color={255,127,0}));

  connect(upProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{622,196},
          {632,196},{632,200},{638,200}},      color={255,0,255}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{662,200},{668,200}}, color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{692,200},{696,200},{696,220},{698,220}},
                                                   color={255,0,255}));

  connect(con23.y, upProCon4.VMinHotWatSet_flow) annotation (Line(points={{602,290},
          {610,290},{610,268},{590,268},{590,206},{598,206}},      color={0,0,
          127}));

  connect(pre2.y, upProCon.uStaChaPro) annotation (Line(points={{-38,220},{0,
          220},{0,132},{-172,132},{-172,172},{-162,172}},
                                                     color={255,0,255}));
  connect(pre6.y, upProCon1.uStaChaPro) annotation (Line(points={{332,220},{370,
          220},{370,100},{186,100},{186,172},{208,172}}, color={255,0,255}));
  connect(pre15.y, upProCon4.uStaChaPro) annotation (Line(points={{722,220},{
          760,220},{760,100},{574,100},{574,170},{598,170}},
                                                         color={255,0,255}));
  connect(pre9.y, upProCon2.uStaChaPro) annotation (Line(points={{-16,-130},{
          -10,-130},{-10,-230},{-196,-230},{-196,-168},{-172,-168}},
                                                                 color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,220},{-62,220}}, color={255,0,255}));
  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,220},{-92,220}}, color={255,0,255}));
  connect(con17.y, upProCon4.VHotWat_flow) annotation (Line(points={{562,270},{
          580,270},{580,210},{598,210}}, color={0,0,127}));
  connect(upProCon.yHotWatIsoVal, pre20.u) annotation (Line(points={{-138,194},
          {-72,194},{-72,190},{-62,190}},color={255,0,255}));
  connect(pre20.y, upProCon.uHotWatIsoVal) annotation (Line(points={{-38,190},{
          -30,190},{-30,240},{-176,240},{-176,200},{-162,200}},
                                                            color={255,0,255}));
  connect(upProCon1.yHotWatIsoVal, pre21.u) annotation (Line(points={{232,194},{
          232,196},{244,196},{244,180},{308,180}}, color={255,0,255}));
  connect(pre21.y, upProCon1.uHotWatIsoVal) annotation (Line(points={{332,180},
          {340,180},{340,240},{196,240},{196,200},{208,200}},color={255,0,255}));
  connect(upProCon4.yHotWatIsoVal, pre22.u) annotation (Line(points={{622,192},{
          632,192},{632,180},{698,180}}, color={255,0,255}));
  connect(pre22.y, upProCon4.uHotWatIsoVal) annotation (Line(points={{722,180},
          {732,180},{732,240},{572,240},{572,198},{598,198}},color={255,0,255}));
  connect(con7.y, onCouInt.reset) annotation (Line(points={{-348,150},{-288,150},
          {-288,168}}, color={255,0,255}));
  connect(onCouInt.y, upProCon.uStaSet) annotation (Line(points={{-276,180},{
          -220,180},{-220,180},{-162,180}}, color={255,127,0}));
  connect(con4.y, and2.u2) annotation (Line(points={{-348,120},{-306,120},{-306,
          112},{-210,112}}, color={255,0,255}));
  connect(con1.y, and1.u2) annotation (Line(points={{-348,90},{-306,90},{-306,
          76},{-224,76},{-224,82},{-210,82}}, color={255,0,255}));
  connect(con2.y, and3.u2) annotation (Line(points={{-348,60},{-348,44},{-210,
          44},{-210,52}}, color={255,0,255}));
  connect(onCouInt.y, intEqu.u1) annotation (Line(points={{-276,180},{-276,140},
          {-270,140}}, color={255,127,0}));
  connect(conInt1.y, intEqu.u2) annotation (Line(points={{-318,134},{-296,134},
          {-296,132},{-270,132}}, color={255,127,0}));
  connect(intEqu.y, booScaRep.u)
    annotation (Line(points={{-246,140},{-240,140}}, color={255,0,255}));
  connect(booScaRep.y, and2.u1) annotation (Line(points={{-216,140},{-212,140},
          {-212,120},{-210,120}}, color={255,0,255}));
  connect(conInt3.y, intEqu1.u2) annotation (Line(points={{-318,100},{-296,100},
          {-296,92},{-270,92}}, color={255,127,0}));
  connect(onCouInt.y, intEqu1.u1) annotation (Line(points={{-276,180},{-276,100},
          {-270,100}}, color={255,127,0}));
  connect(intEqu1.y, booScaRep1.u)
    annotation (Line(points={{-246,100},{-240,100}}, color={255,0,255}));
  connect(booScaRep1.y, and1.u1) annotation (Line(points={{-216,100},{-214,100},
          {-214,90},{-210,90}}, color={255,0,255}));
  connect(conInt20.y, intEqu2.u2) annotation (Line(points={{-318,60},{-280,60},
          {-280,52},{-268,52}}, color={255,127,0}));
  connect(intEqu2.y, booScaRep2.u)
    annotation (Line(points={{-244,60},{-238,60}}, color={255,0,255}));
  connect(booScaRep2.y, and3.u1)
    annotation (Line(points={{-214,60},{-210,60}}, color={255,0,255}));
  connect(onCouInt.y, intEqu2.u1) annotation (Line(points={{-276,180},{-276,60},
          {-268,60}}, color={255,127,0}));
  connect(and2.y, or2.u1) annotation (Line(points={{-186,120},{-168,120},{-168,
          100},{-160,100}}, color={255,0,255}));
  connect(and1.y, or2.u2) annotation (Line(points={{-186,90},{-186,92},{-160,92}},
        color={255,0,255}));
  connect(and3.y, or7.u2) annotation (Line(points={{-186,60},{-132,60},{-132,82},
          {-120,82}}, color={255,0,255}));
  connect(or2.y, or7.u1) annotation (Line(points={{-136,100},{-132,100},{-132,
          90},{-120,90}}, color={255,0,255}));
  connect(or7.y, upProCon.uBoiSet) annotation (Line(points={{-96,90},{-92,90},{
          -92,126},{-188,126},{-188,192},{-162,192}}, color={255,0,255}));
  connect(or6.y, onCouInt.trigger)
    annotation (Line(points={{-308,180},{-300,180}}, color={255,0,255}));
  connect(booPul.y, or6.u1) annotation (Line(points={{-348,230},{-340,230},{
          -340,180},{-332,180}}, color={255,0,255}));
  connect(booPul.y, upProCon.uPlaEna) annotation (Line(points={{-348,230},{-200,
          230},{-200,176},{-162,176}}, color={255,0,255}));
  connect(pre2.y, pre14.u) annotation (Line(points={{-38,220},{0,220},{0,132},{
          -172,132},{-172,162},{-374,162},{-374,176},{-372,176}}, color={255,0,
          255}));
  connect(pre14.y, or6.u2) annotation (Line(points={{-348,176},{-348,172},{-332,
          172}}, color={255,0,255}));
  connect(pre14.y, upProCon.uStaUpPro) annotation (Line(points={{-348,176},{
          -344,176},{-344,194},{-240,194},{-240,188},{-162,188}}, color={255,0,
          255}));
  connect(or8.u2, pre3.y)
    annotation (Line(points={{38,202},{40,200},{32,200}}, color={255,0,255}));
  connect(booPul1.y, or8.u1) annotation (Line(points={{22,236},{32,236},{32,228},
          {38,228},{38,210}}, color={255,0,255}));
  connect(or8.y, onCouInt1.trigger)
    annotation (Line(points={{62,210},{68,210}}, color={255,0,255}));
  connect(con12.y, onCouInt1.reset) annotation (Line(points={{30,170},{32,170},
          {32,152},{-4,152},{-4,216},{-8,216},{-8,256},{44,256},{44,228},{100,
          228},{100,198},{80,198}}, color={255,0,255}));
  connect(onCouInt1.y, upProCon1.uStaSet) annotation (Line(points={{92,210},{
          184,210},{184,180},{208,180}}, color={255,127,0}));
  connect(conInt7.y, intEqu3.u1)
    annotation (Line(points={{92,180},{98,180},{98,170}}, color={255,127,0}));
  connect(conInt5.y, intEqu4.u1) annotation (Line(points={{92,150},{92,144},{98,
          144},{98,130}}, color={255,127,0}));
  connect(conInt4.y, intEqu5.u1) annotation (Line(points={{92,110},{92,104},{
          100,104},{100,90}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu3.u2) annotation (Line(points={{92,210},{96,210},{
          96,162},{98,162}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu4.u2) annotation (Line(points={{92,210},{96,210},{
          96,122},{98,122}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu5.u2) annotation (Line(points={{92,210},{184,210},
          {184,168},{192,168},{192,72},{92,72},{92,82},{100,82}}, color={255,
          127,0}));
  connect(intEqu3.y, booScaRep3.u)
    annotation (Line(points={{122,170},{128,170}}, color={255,0,255}));
  connect(intEqu4.y, booScaRep4.u)
    annotation (Line(points={{122,130},{128,130}}, color={255,0,255}));
  connect(intEqu5.y, booScaRep5.u)
    annotation (Line(points={{124,90},{130,90}}, color={255,0,255}));
  connect(booScaRep3.y, and4.u1) annotation (Line(points={{152,170},{152,164},{
          158,164},{158,150}}, color={255,0,255}));
  connect(booScaRep4.y, and5.u1) annotation (Line(points={{152,130},{152,124},{
          158,124},{158,120}}, color={255,0,255}));
  connect(booScaRep5.y, and6.u1)
    annotation (Line(points={{154,90},{158,90}}, color={255,0,255}));
  connect(con9.y, and4.u2) annotation (Line(points={{62,166},{62,196},{158,196},
          {158,142}}, color={255,0,255}));
  connect(con5.y, and5.u2) annotation (Line(points={{62,136},{110,136},{110,112},
          {158,112}}, color={255,0,255}));
  connect(con6.y, and6.u2) annotation (Line(points={{62,106},{64,106},{64,64},{
          158,64},{158,82}}, color={255,0,255}));
  connect(and4.y, or9.u1) annotation (Line(points={{182,150},{200,150},{200,130},
          {208,130}}, color={255,0,255}));
  connect(and5.y, or9.u2) annotation (Line(points={{182,120},{184,122},{208,122}},
        color={255,0,255}));
  connect(and6.y, or10.u2) annotation (Line(points={{182,90},{200,90},{200,112},
          {248,112}}, color={255,0,255}));
  connect(or9.y, or10.u1) annotation (Line(points={{232,130},{232,120},{248,120}},
        color={255,0,255}));
  connect(or10.y, upProCon1.uBoiSet) annotation (Line(points={{272,120},{280,
          120},{280,144},{240,144},{240,156},{200,156},{200,192},{208,192}},
        color={255,0,255}));
  connect(pre6.y, pre3.u) annotation (Line(points={{332,220},{350,220},{350,260},
          {4,260},{4,200},{8,200}}, color={255,0,255}));
  connect(pre3.y, upProCon1.uStaUpPro) annotation (Line(points={{32,200},{36,
          200},{36,192},{180,192},{180,188},{208,188}}, color={255,0,255}));
  connect(booPul1.y, upProCon1.uPlaEna) annotation (Line(points={{22,236},{32,
          236},{32,228},{40,228},{40,232},{120,232},{120,208},{188,208},{188,
          176},{208,176}}, color={255,0,255}));
  connect(booPul4.y, upProCon4.uPlaEna) annotation (Line(points={{412,290},{532,
          290},{532,248},{584,248},{584,174},{598,174}}, color={255,0,255}));
  connect(intEqu6.y, booScaRep6.u)
    annotation (Line(points={{512,190},{518,190}}, color={255,0,255}));
  connect(booScaRep6.y, and7.u1) annotation (Line(points={{542,190},{546,190},{
          546,170},{548,170}}, color={255,0,255}));
  connect(intEqu7.y, booScaRep7.u)
    annotation (Line(points={{512,150},{518,150}}, color={255,0,255}));
  connect(booScaRep7.y, and8.u1) annotation (Line(points={{542,150},{544,150},{
          544,140},{548,140}}, color={255,0,255}));
  connect(intEqu8.y, booScaRep8.u)
    annotation (Line(points={{514,110},{520,110}}, color={255,0,255}));
  connect(booScaRep8.y, and9.u1)
    annotation (Line(points={{544,110},{548,110}}, color={255,0,255}));
  connect(or1.y, onCouInt2.trigger)
    annotation (Line(points={{452,230},{458,230}}, color={255,0,255}));
  connect(booPul4.y, or1.u1) annotation (Line(points={{412,290},{424,290},{424,
          240},{420,240},{420,230},{428,230}}, color={255,0,255}));
  connect(pre4.y, or1.u2) annotation (Line(points={{412,226},{412,228},{420,228},
          {420,222},{428,222}}, color={255,0,255}));
  connect(and7.y, or5.u1) annotation (Line(points={{572,170},{580,170},{580,156},
          {592,156},{592,150},{598,150}}, color={255,0,255}));
  connect(and8.y, or5.u2) annotation (Line(points={{572,140},{572,142},{598,142}},
        color={255,0,255}));
  connect(or5.y, or11.u1) annotation (Line(points={{622,150},{624,150},{624,140},
          {638,140}}, color={255,0,255}));
  connect(and9.y, or11.u2) annotation (Line(points={{572,110},{638,110},{638,
          132}}, color={255,0,255}));
  connect(conInt19.y, intEqu6.u1) annotation (Line(points={{482,200},{484,200},
          {484,190},{488,190}}, color={255,127,0}));
  connect(conInt17.y, intEqu7.u1) annotation (Line(points={{482,160},{484,160},
          {484,150},{488,150}}, color={255,127,0}));
  connect(conInt16.y, intEqu8.u1) annotation (Line(points={{482,120},{484,120},
          {484,116},{490,116},{490,110}}, color={255,127,0}));
  connect(onCouInt2.y, intEqu6.u2) annotation (Line(points={{482,230},{492,230},
          {492,312},{376,312},{376,168},{448,168},{448,182},{488,182}}, color={
          255,127,0}));
  connect(onCouInt2.y, intEqu7.u2) annotation (Line(points={{482,230},{492,230},
          {492,312},{376,312},{376,168},{448,168},{448,160},{452,160},{452,142},
          {488,142}}, color={255,127,0}));
  connect(onCouInt2.y, intEqu8.u2) annotation (Line(points={{482,230},{492,230},
          {492,312},{376,312},{376,168},{448,168},{448,160},{452,160},{452,102},
          {490,102}}, color={255,127,0}));
  connect(con24.y, and7.u2) annotation (Line(points={{442,190},{448,190},{448,
          208},{412,208},{412,92},{580,92},{580,152},{584,152},{584,162},{548,
          162}}, color={255,0,255}));
  connect(con20.y, and8.u2) annotation (Line(points={{442,150},{448,150},{448,
          140},{488,140},{488,132},{548,132}}, color={255,0,255}));
  connect(con21.y, and9.u2) annotation (Line(points={{442,110},{448,110},{448,
          88},{548,88},{548,102}}, color={255,0,255}));
  connect(or11.y, upProCon4.uBoiSet) annotation (Line(points={{662,140},{736,
          140},{736,244},{588,244},{588,190},{598,190}}, color={255,0,255}));
  connect(pre15.y, pre4.u) annotation (Line(points={{722,220},{760,220},{760,
          100},{584,100},{584,80},{408,80},{408,208},{384,208},{384,220},{380,
          220},{380,226},{388,226}}, color={255,0,255}));
  connect(con22.y, onCouInt2.reset) annotation (Line(points={{402,190},{404,190},
          {404,172},{368,172},{368,232},{380,232},{380,252},{496,252},{496,218},
          {470,218}}, color={255,0,255}));
  connect(pre4.y, upProCon4.uStaUpPro) annotation (Line(points={{412,226},{416,
          226},{416,256},{528,256},{528,252},{576,252},{576,186},{598,186}},
        color={255,0,255}));
  connect(onCouInt2.y, upProCon4.uStaSet) annotation (Line(points={{482,230},{
          542,230},{542,178},{598,178}}, color={255,127,0}));
  connect(intEqu9.y, booScaRep9.u)
    annotation (Line(points={{-266,-170},{-260,-170}}, color={255,0,255}));
  connect(booScaRep9.y, and10.u1) annotation (Line(points={{-236,-170},{-232,
          -170},{-232,-190},{-230,-190}}, color={255,0,255}));
  connect(intEqu10.y, booScaRep10.u)
    annotation (Line(points={{-266,-210},{-260,-210}}, color={255,0,255}));
  connect(booScaRep10.y, and11.u1) annotation (Line(points={{-236,-210},{-234,
          -210},{-234,-220},{-230,-220}}, color={255,0,255}));
  connect(intEqu11.y, booScaRep11.u)
    annotation (Line(points={{-264,-250},{-258,-250}}, color={255,0,255}));
  connect(booScaRep11.y, and12.u1)
    annotation (Line(points={{-234,-250},{-230,-250}}, color={255,0,255}));
  connect(booPul2.y, upProCon2.uPlaEna) annotation (Line(points={{-358,-70},{
          -226,-70},{-226,-164},{-172,-164}}, color={255,0,255}));
  connect(conInt11.y, intEqu9.u1)
    annotation (Line(points={{-308,-170},{-290,-170}}, color={255,127,0}));
  connect(conInt9.y, intEqu10.u1)
    annotation (Line(points={{-308,-210},{-290,-210}}, color={255,127,0}));
  connect(conInt8.y, intEqu11.u1)
    annotation (Line(points={{-308,-250},{-288,-250}}, color={255,127,0}));
  connect(con14.y, and10.u2) annotation (Line(points={{-346,-190},{-340,-190},{
          -340,-268},{-200,-268},{-200,-198},{-230,-198}}, color={255,0,255}));
  connect(con10.y, and11.u2) annotation (Line(points={{-348,-230},{-348,-232},{
          -240,-232},{-240,-228},{-230,-228}}, color={255,0,255}));
  connect(con11.y, and12.u2) annotation (Line(points={{-346,-270},{-230,-270},{
          -230,-258}}, color={255,0,255}));
  connect(onCouInt3.y, intEqu9.u2) annotation (Line(points={{-296,-130},{-294,
          -130},{-294,-178},{-290,-178}}, color={255,127,0}));
  connect(onCouInt3.y, intEqu10.u2) annotation (Line(points={{-296,-130},{-294,
          -130},{-294,-218},{-290,-218}}, color={255,127,0}));
  connect(onCouInt3.y, intEqu11.u2) annotation (Line(points={{-296,-130},{-294,
          -130},{-294,-258},{-288,-258}}, color={255,127,0}));
  connect(and10.y, or12.u1) annotation (Line(points={{-206,-190},{-192,-190},{
          -192,-210},{-182,-210}}, color={255,0,255}));
  connect(and11.y, or12.u2) annotation (Line(points={{-206,-220},{-204,-218},{
          -182,-218}}, color={255,0,255}));
  connect(and12.y, or13.u2) annotation (Line(points={{-206,-250},{-184,-250},{
          -184,-228},{-142,-228},{-142,-218}}, color={255,0,255}));
  connect(or12.y, or13.u1)
    annotation (Line(points={{-158,-210},{-142,-210}}, color={255,0,255}));
  connect(or13.y, upProCon2.uBoiSet) annotation (Line(points={{-118,-210},{-112,
          -210},{-112,-192},{-184,-192},{-184,-148},{-172,-148}}, color={255,0,
          255}));
  connect(onCouInt3.y, upProCon2.uStaSet) annotation (Line(points={{-296,-130},
          {-294,-130},{-294,-152},{-200,-152},{-200,-160},{-172,-160}}, color={
          255,127,0}));
  connect(or3.y, onCouInt3.trigger)
    annotation (Line(points={{-326,-130},{-320,-130}}, color={255,0,255}));
  connect(pre7.y, or3.u2) annotation (Line(points={{-358,-130},{-356,-130},{
          -356,-138},{-350,-138}}, color={255,0,255}));
  connect(booPul2.y, or3.u1) annotation (Line(points={{-358,-70},{-354,-70},{
          -354,-130},{-350,-130}}, color={255,0,255}));
  connect(con25.y, onCouInt3.reset) annotation (Line(points={{-348,-160},{-340,
          -160},{-340,-152},{-308,-152},{-308,-142}}, color={255,0,255}));
  connect(pre7.y, upProCon2.uStaUpPro) annotation (Line(points={{-358,-130},{
          -360,-130},{-360,-112},{-188,-112},{-188,-152},{-172,-152}}, color={
          255,0,255}));
  connect(pre9.y, pre7.u) annotation (Line(points={{-16,-130},{-10,-130},{-10,
          -230},{-196,-230},{-196,-288},{-392,-288},{-392,-130},{-382,-130}},
        color={255,0,255}));
  connect(intEqu12.y, booScaRep12.u)
    annotation (Line(points={{322,-180},{330,-180}}, color={255,0,255}));
  connect(booScaRep12.y, and13.u1) annotation (Line(points={{354,-180},{358,
          -180},{358,-200},{360,-200}}, color={255,0,255}));
  connect(intEqu13.y, booScaRep13.u)
    annotation (Line(points={{322,-220},{330,-220}}, color={255,0,255}));
  connect(booScaRep13.y, and14.u1) annotation (Line(points={{354,-220},{356,
          -220},{356,-230},{360,-230}}, color={255,0,255}));
  connect(intEqu14.y, booScaRep14.u)
    annotation (Line(points={{324,-260},{332,-260}}, color={255,0,255}));
  connect(booScaRep14.y, and15.u1)
    annotation (Line(points={{356,-260},{360,-260}}, color={255,0,255}));
  connect(or4.y, or14.u1) annotation (Line(points={{432,-210},{432,-212},{444,
          -212},{444,-250},{458,-250}}, color={255,0,255}));
  connect(and15.y, or14.u2) annotation (Line(points={{384,-260},{388,-258},{458,
          -258}}, color={255,0,255}));
  connect(or14.y, upProCon3.uBoiSet) annotation (Line(points={{482,-250},{492,
          -250},{492,-192},{392,-192},{392,-172},{384,-172},{384,-150},{408,
          -150}}, color={255,0,255}));
  connect(and13.y, or4.u1) annotation (Line(points={{384,-200},{392,-200},{392,
          -210},{408,-210}}, color={255,0,255}));
  connect(and14.y, or4.u2) annotation (Line(points={{384,-230},{384,-232},{392,
          -232},{392,-218},{408,-218}}, color={255,0,255}));
  connect(con26.y, onCouInt4.reset) annotation (Line(points={{222,-170},{240,
          -170},{240,-160},{280,-160},{280,-152}}, color={255,0,255}));
  connect(or15.y, onCouInt4.trigger)
    annotation (Line(points={{262,-140},{268,-140}}, color={255,0,255}));
  connect(pre10.y, or15.u1) annotation (Line(points={{222,-144},{224,-140},{238,
          -140}}, color={255,0,255}));
  connect(booPul3.y, upProCon3.uPlaEna) annotation (Line(points={{222,-70},{340,
          -70},{340,-140},{388,-140},{388,-166},{408,-166}}, color={255,0,255}));
  connect(onCouInt4.y, upProCon3.uStaSet) annotation (Line(points={{292,-140},{
          336,-140},{336,-144},{392,-144},{392,-162},{408,-162}}, color={255,
          127,0}));
  connect(onCouInt4.y, intEqu12.u2) annotation (Line(points={{292,-140},{300,
          -140},{300,-164},{264,-164},{264,-200},{298,-200},{298,-188}}, color=
          {255,127,0}));
  connect(onCouInt4.y, intEqu13.u2) annotation (Line(points={{292,-140},{300,
          -140},{300,-164},{264,-164},{264,-200},{288,-200},{288,-228},{298,
          -228}}, color={255,127,0}));
  connect(onCouInt4.y, intEqu14.u2) annotation (Line(points={{292,-140},{300,
          -140},{300,-164},{264,-164},{264,-200},{288,-200},{288,-268},{300,
          -268}}, color={255,127,0}));
  connect(conInt15.y, intEqu12.u1) annotation (Line(points={{262,-190},{288,
          -190},{288,-180},{298,-180}}, color={255,127,0}));
  connect(conInt13.y, intEqu13.u1)
    annotation (Line(points={{262,-220},{298,-220}}, color={255,127,0}));
  connect(conInt12.y, intEqu14.u1)
    annotation (Line(points={{262,-260},{300,-260}}, color={255,127,0}));
  connect(con19.y, and13.u2) annotation (Line(points={{232,-200},{232,-168},{
          280,-168},{280,-204},{360,-204},{360,-208}}, color={255,0,255}));
  connect(con15.y, and14.u2) annotation (Line(points={{232,-240},{236,-238},{
          360,-238}}, color={255,0,255}));
  connect(con16.y, and15.u2) annotation (Line(points={{232,-290},{232,-292},{
          360,-292},{360,-268}}, color={255,0,255}));
  connect(booPul3.y, or15.u2) annotation (Line(points={{222,-70},{236,-70},{236,
          -148},{238,-148}}, color={255,0,255}));
  connect(pre12.y, pre10.u) annotation (Line(points={{564,-130},{572,-130},{572,
          -232},{404,-232},{404,-308},{188,-308},{188,-144},{198,-144}}, color=
          {255,0,255}));
  connect(pre12.y, upProCon3.uStaChaPro) annotation (Line(points={{564,-130},{
          564,-132},{572,-132},{572,-232},{400,-232},{400,-170},{408,-170}},
        color={255,0,255}));
  connect(pre10.y, upProCon3.uStaUpPro) annotation (Line(points={{222,-144},{
          228,-144},{228,-124},{392,-124},{392,-144},{400,-144},{400,-154},{408,
          -154}}, color={255,0,255}));
  connect(upProCon.yBoi, pre13.u) annotation (Line(points={{-138,202},{-132,202},
          {-132,260},{-138,260}}, color={255,0,255}));
  connect(pre13.y, upProCon.uBoi) annotation (Line(points={{-162,260},{-180,260},
          {-180,196},{-162,196}}, color={255,0,255}));
  connect(upProCon1.yBoi, pre16.u)
    annotation (Line(points={{232,202},{232,228}}, color={255,0,255}));
  connect(pre16.y, upProCon1.uBoi)
    annotation (Line(points={{208,228},{208,196}}, color={255,0,255}));
  connect(upProCon4.yBoi, pre17.u)
    annotation (Line(points={{622,200},{622,226}}, color={255,0,255}));
  connect(pre17.y, upProCon4.uBoi)
    annotation (Line(points={{598,226},{598,194}}, color={255,0,255}));
  connect(upProCon2.yBoi, pre18.u)
    annotation (Line(points={{-148,-138},{-148,-110}}, color={255,0,255}));
  connect(pre18.y, upProCon2.uBoi) annotation (Line(points={{-172,-110},{-172,
          -112},{-184,-112},{-184,-144},{-172,-144}}, color={255,0,255}));
  connect(upProCon3.yBoi, pre19.u)
    annotation (Line(points={{432,-140},{432,-110}}, color={255,0,255}));
  connect(pre19.y, upProCon3.uBoi)
    annotation (Line(points={{408,-110},{408,-146}}, color={255,0,255}));
annotation (
 experiment(
      StopTime=900,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Staging/Processes/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Up</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2020 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-380,-340},{780,340}})));
end Up;
