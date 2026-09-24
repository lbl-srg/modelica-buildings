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
    annotation (Placement(transformation(extent={{-460,210},{-440,250}})));

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
    annotation (Placement(transformation(extent={{16,220},{36,260}})));

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
    annotation (Placement(transformation(extent={{502,-138},{522,-98}})));

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
    annotation (Placement(transformation(extent={{-420,250},{-400,270}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{56,240},{76,260}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro3(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{540,-120},{560,-100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{640,180},{660,200}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-420,190},{-400,210}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{56,200},{76,220}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-130,-180},{-110,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro3(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{540,-150},{560,-130}})));

protected
  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{-690,210},{-670,230}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{-580,160},{-560,180}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{-580,120},{-560,140}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{-580,80},{-560,100}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{-650,170},{-630,190}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{-650,130},{-630,150}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-620,170},{-600,190}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-620,130},{-600,150}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{-646,80},{-626,100}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-620,80},{-600,100}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-540,140},{-520,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or7[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-500,120},{-480,140}})));

  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Generate stage change signal when simulation is initiated or previous
    change is completed"
    annotation (Placement(transformation(extent={{-720,210},{-700,230}})));

  Buildings.Controls.OBC.CDL.Logical.Or or8
    "Generate stage change signal when simulation is initiated or previous
    change is completed"
    annotation (Placement(transformation(extent={{-250,220},{-230,240}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt1(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep4(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu5
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep5(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.And and4[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));

  Buildings.Controls.OBC.CDL.Logical.And and5[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Buildings.Controls.OBC.CDL.Logical.And and6[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or9[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.CDL.Logical.Or or10[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));

  Buildings.Controls.OBC.CDL.Logical.And and7[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{480,200},{500,220}})));

  Buildings.Controls.OBC.CDL.Logical.And and8[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{480,150},{500,170}})));

  Buildings.Controls.OBC.CDL.Logical.And and9[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{480,100},{500,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu6
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{380,200},{400,220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu7
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{380,150},{400,170}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep6(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{420,200},{440,220}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep7(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{420,150},{440,170}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu8
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{378,100},{398,120}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep8(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{420,100},{440,120}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt2(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{320,240},{340,260}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Generate stage change signal when simulation is initiated or previous
    change is completed"
    annotation (Placement(transformation(extent={{290,240},{310,260}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{520,160},{540,180}})));

  Buildings.Controls.OBC.CDL.Logical.Or or11[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{560,130},{580,150}})));

  Buildings.Controls.OBC.CDL.Logical.And and10[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{-320,-210},{-300,-190}})));

  Buildings.Controls.OBC.CDL.Logical.And and11[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{-320,-260},{-300,-240}})));

  Buildings.Controls.OBC.CDL.Logical.And and12[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{-320,-310},{-300,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu9
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{-380,-210},{-360,-190}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu10
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{-380,-260},{-360,-240}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep9(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-350,-210},{-330,-190}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep10(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-350,-260},{-330,-240}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu11
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{-380,-310},{-360,-290}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep11(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-350,-310},{-330,-290}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt3(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{-438,-160},{-418,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Generate stage change signal when simulation is initiated or previous
    change is completed"
    annotation (Placement(transformation(extent={{-480,-160},{-460,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Or or12[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-280,-230},{-260,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Or or13[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-230}})));

  Buildings.Controls.OBC.CDL.Logical.And and13[nBoi]
    "Pass stage-1 boiler setpoints only when stage setpoint is 1"
    annotation (Placement(transformation(extent={{380,-210},{400,-190}})));

  Buildings.Controls.OBC.CDL.Logical.And and14[nBoi]
    "Pass stage-2 boiler setpoints only when stage setpoint is 2"
    annotation (Placement(transformation(extent={{380,-250},{400,-230}})));

  Buildings.Controls.OBC.CDL.Logical.And and15[nBoi]
    "Pass stage-3 boiler setpoints only when stage setpoint is 3"
    annotation (Placement(transformation(extent={{380,-300},{400,-280}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu12
    "Check if next stage setpoint is 1"
    annotation (Placement(transformation(extent={{320,-210},{340,-190}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu13
    "Check if next stage setpoint is 2"
    annotation (Placement(transformation(extent={{320,-250},{340,-230}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep12(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{350,-210},{370,-190}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep13(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{350,-250},{370,-230}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu14
    "Check if next stage setpoint is 3"
    annotation (Placement(transformation(extent={{320,-300},{340,-280}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep14(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{350,-300},{370,-280}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{420,-220},{440,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Or or14[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{460,-240},{480,-220}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt4(
    final y_start=0)
    "Count number of stage changes initiated"
    annotation (Placement(transformation(extent={{270,-150},{290,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Or or15
    "Generate stage change signal when simulation is initiated or previous
    change is completed"
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu15
    "Check if next stage setpoint is 0"
    annotation (Placement(transformation(extent={{-648,30},{-628,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep15(
    final nout=nBoi)
    "Replicate stage detection signal"
    annotation (Placement(transformation(extent={{-620,30},{-600,50}})));

  Buildings.Controls.OBC.CDL.Logical.And and16[nBoi]
    "Pass stage-0 boiler setpoints only when stage setpoint is 0"
    annotation (Placement(transformation(extent={{-580,30},{-560,50}})));

  Buildings.Controls.OBC.CDL.Logical.Or or16[nBoi]
    "Consolidate boiler setpoint signals"
    annotation (Placement(transformation(extent={{-540,70},{-520,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre20[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-360,220},{-340,240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-700,110},{-680,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-700,60},{-680,80}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-390,190},{-370,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nSta](
    final k={1,2,2})
    "Stage type vector"
    annotation (Placement(transformation(extent={{-580,240},{-560,260}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1/3600,
    final period=3600,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-760,260},{-740,280}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-580,280},{-560,300}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-352,160},{-372,180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-360,250},{-340,270}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-700,150},{-680,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{86,200},{106,220}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-252,70},{-232,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-252,120},{-232,140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{-120,260},{-100,280}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-290,254},{-270,274}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-160,280},{-140,300}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{146,200},{166,220}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{116,260},{136,280}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{86,240},{106,260}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-250,170},{-230,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-490,-288},{-470,-268}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-488,-330},{-468,-310}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg6
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-440,-310},{-420,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-440,-260},{-420,-240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{-340,-100},{-320,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-520,-100},{-500,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con13(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9
    "Logical pre block"
    annotation (Placement(transformation(extent={{-38,-150},{-18,-130}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg7
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con14[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-492,-240},{-472,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt11(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-440,-210},{-420,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con15[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{220,-280},{240,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{220,-330},{240,-310}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg9
    "Falling edge detector"
    annotation (Placement(transformation(extent={{580,-150},{600,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt12(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{270,-300},{290,-280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt13(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{270,-250},{290,-230}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt14[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{400,-80},{420,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con18(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{240,-60},{260,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre11
    "Logical pre block"
    annotation (Placement(transformation(extent={{640,-180},{620,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre12
    "Logical pre block"
    annotation (Placement(transformation(extent={{630,-120},{650,-100}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg10
    "Falling edge detector"
    annotation (Placement(transformation(extent={{580,-120},{600,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con19[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{220,-230},{240,-210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt15(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{270,-210},{290,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{290,120},{310,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{288,70},{308,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{318,100},{338,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{320,150},{340,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt18[nSta](
    final k={1,1,1})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{420,280},{440,300}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.1/1800,
    final period=1800,
    final shift=1)
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{250,300},{270,320}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{532,210},{552,230}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{712,182},{732,202}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{680,182},{700,202}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con24[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{288,180},{308,200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{320,200},{340,220}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con17(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{500,300},{520,320}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre21[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{116,220},{136,240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre22[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{640,150},{660,170}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-390,250},{-370,270}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{-780,180},{-760,200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-728,170},{-708,190}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-728,130},{-708,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt20(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-730,80},{-710,100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre14
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{-760,210},{-740,230}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{-290,220},{-270,240}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con12(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{-280,190},{-260,210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{240,240},{260,260}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con22(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{200,220},{220,240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{-522,-160},{-502,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con25(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{-490,-190},{-470,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con26(
    final k=false)
    "Constant false signal"
    annotation (Placement(transformation(extent={{200,-180},{220,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre10
    "Logical pre block for additional delay on next stage change process start signal"
    annotation (Placement(transformation(extent={{200,-150},{220,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre13[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-440,290},{-460,310}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre16[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{36,268},{16,288}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre17[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{620,216},{600,236}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre18[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-150,-120},{-170,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre19[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{520,-80},{500,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con27[nBoi](
    final k={false,false})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-700,10},{-680,30}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqual intGreEqu
    "Check if max stage has been reached"
    annotation (Placement(transformation(extent={{310,-100},{330,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Disable signal when max stage has been reached"
    annotation (Placement(transformation(extent={{340,-100},{360,-80}})));

  Buildings.Controls.OBC.CDL.Logical.And and17
    "Disable additional stage change signals when max stage has been reached"
    annotation (Placement(transformation(extent={{380,-110},{400,-90}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqual intGreEqu1
    "Check if max stage has been reached"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Disable signal when max stage has been reached"
    annotation (Placement(transformation(extent={{-350,-140},{-330,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and18
    "Disable additional stage change signals when max stage has been reached"
    annotation (Placement(transformation(extent={{-310,-150},{-290,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt21(final k=0)
    "Stage 0 setpoint"
    annotation (Placement(transformation(extent={{-730,30},{-710,50}})));

equation

  connect(upProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-438,218},
          {-430,218},{-430,200},{-422,200}}, color={255,0,255}));

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-398,200},{-392,200}},
                                                   color={255,0,255}));

  connect(conInt2.y, upProCon.uStaTyp) annotation (Line(points={{-558,250},{-484,
          250},{-484,224},{-462,224}}, color={255,127,0}));

  connect(con3.y, upProCon.THotWatSupSet) annotation (Line(points={{-558,290},{-472,
          290},{-472,244},{-462,244}},                            color={0,0,
          127}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-368,200},{-340,200},{-340,
          170},{-350,170}},color={255,0,255}));

  connect(pre1.y, upProCon.uPumChaPro) annotation (Line(points={{-374,170},{-462,
          170},{-462,208}},
        color={255,0,255}));

  connect(upProCon.yStaChaPro,yStaChaPro. u) annotation (Line(points={{-438,238},
          {-426,238},{-426,260},{-422,260}}, color={255,0,255}));

  connect(upProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{38,228},
          {46,228},{46,210},{54,210}},         color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{78,210},{84,210}},   color={255,0,255}));

  connect(conInt6.y, upProCon1.uStaTyp) annotation (Line(points={{-98,270},{-88,
          270},{-88,234},{14,234}},  color={255,127,0}));

  connect(con8.y, upProCon1.THotWatSupSet) annotation (Line(points={{-138,290},{
          -4,290},{-4,254},{14,254}},                        color={0,0,127}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{108,210},{144,210}},
                      color={255,0,255}));

  connect(pre5.y, upProCon1.uPumChaPro) annotation (Line(points={{168,210},{172,
          210},{172,190},{12,190},{12,218},{14,218}},
        color={255,0,255}));
  connect(upProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{38,248},
          {50,248},{50,250},{54,250}},         color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{78,250},{84,250}},   color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{108,250},{112,250},{112,270},{114,270}},
                                                   color={255,0,255}));

  connect(upProCon2.yPumChaPro, yPumChaPro2.u) annotation (Line(points={{-148,-162},
          {-140,-162},{-140,-170},{-132,-170}}, color={255,0,255}));

  connect(yPumChaPro2.y, falEdg6.u)
    annotation (Line(points={{-108,-170},{-102,-170}}, color={255,0,255}));

  connect(conInt10.y, upProCon2.uStaTyp) annotation (Line(points={{-318,-90},{-220,
          -90},{-220,-156},{-172,-156}},  color={255,127,0}));

  connect(con13.y, upProCon2.THotWatSupSet) annotation (Line(points={{-358,-70},
          {-192,-70},{-192,-136},{-172,-136}}, color={0,0,127}));

  connect(falEdg6.y, pre8.u) annotation (Line(points={{-78,-170},{-62,-170}},
                             color={255,0,255}));

  connect(pre8.y, upProCon2.uPumChaPro) annotation (Line(points={{-38,-170},{
          -32,-170},{-32,-188},{-176,-188},{-176,-172},{-172,-172}},
                  color={255,0,255}));

  connect(upProCon2.yStaChaPro, yStaChaPro2.u) annotation (Line(points={{-148,-142},
          {-140,-142},{-140,-140},{-132,-140}}, color={255,0,255}));

  connect(yStaChaPro2.y, falEdg7.u)
    annotation (Line(points={{-108,-140},{-102,-140}}, color={255,0,255}));

  connect(falEdg7.y,pre9. u)
    annotation (Line(points={{-78,-140},{-40,-140}},
                                                   color={255,0,255}));

  connect(upProCon3.yPumChaPro, yPumChaPro3.u) annotation (Line(points={{524,-130},
          {524,-128},{528,-128},{528,-140},{538,-140}},
                                             color={255,0,255}));

  connect(yPumChaPro3.y, falEdg9.u)
    annotation (Line(points={{562,-140},{578,-140}}, color={255,0,255}));

  connect(conInt14.y, upProCon3.uStaTyp) annotation (Line(points={{422,-70},{484,
          -70},{484,-124},{500,-124}},  color={255,127,0}));

  connect(con18.y, upProCon3.THotWatSupSet) annotation (Line(points={{262,-50},{
          488,-50},{488,-104},{500,-104}},  color={0,0,127}));

  connect(falEdg9.y, pre11.u) annotation (Line(points={{602,-140},{652,-140},{652,
          -170},{642,-170}}, color={255,0,255}));

  connect(pre11.y, upProCon3.uPumChaPro) annotation (Line(points={{618,-170},{496,
          -170},{496,-140},{500,-140}},
        color={255,0,255}));
  connect(upProCon3.yStaChaPro, yStaChaPro3.u) annotation (Line(points={{524,-110},
          {538,-110}},                       color={255,0,255}));

  connect(yStaChaPro3.y, falEdg10.u)
    annotation (Line(points={{562,-110},{578,-110}}, color={255,0,255}));

  connect(falEdg10.y, pre12.u)
    annotation (Line(points={{602,-110},{628,-110}}, color={255,0,255}));

  connect(conInt18.y, upProCon4.uStaTyp) annotation (Line(points={{442,290},{576,
          290},{576,182},{598,182}}, color={255,127,0}));

  connect(upProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{622,196},
          {630,196},{630,190},{638,190}},      color={255,0,255}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{662,190},{662,192},{678,192}},
                                                   color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{702,192},{710,192}}, color={255,0,255}));

  connect(con23.y, upProCon4.VMinHotWatSet_flow) annotation (Line(points={{554,220},
          {572,220},{572,206},{598,206}},                          color={0,0,
          127}));

  connect(pre2.y, upProCon.uStaChaPro) annotation (Line(points={{-338,260},{-320,
          260},{-320,330},{-500,330},{-500,212},{-462,212}},
                                                     color={255,0,255}));
  connect(pre6.y, upProCon1.uStaChaPro) annotation (Line(points={{138,270},{180,
          270},{180,310},{-2,310},{-2,222},{14,222}},    color={255,0,255}));
  connect(pre15.y, upProCon4.uStaChaPro) annotation (Line(points={{734,192},{744,
          192},{744,332},{560,332},{560,170},{598,170}}, color={255,0,255}));
  connect(pre9.y, upProCon2.uStaChaPro) annotation (Line(points={{-16,-140},{-10,
          -140},{-10,-200},{-180,-200},{-180,-168},{-172,-168}}, color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-368,260},{-362,260}},
                                                   color={255,0,255}));
  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-398,260},{-392,260}},
                                                   color={255,0,255}));
  connect(con17.y, upProCon4.VHotWat_flow) annotation (Line(points={{522,310},{580,
          310},{580,276},{592,276},{592,210},{598,210}},
                                         color={0,0,127}));
  connect(upProCon.yHotWatIsoVal, pre20.u) annotation (Line(points={{-438,234},{
          -372,234},{-372,230},{-362,230}},
                                         color={255,0,255}));
  connect(pre20.y, upProCon.uHotWatIsoVal) annotation (Line(points={{-338,230},{
          -330,230},{-330,280},{-476,280},{-476,240},{-462,240}},
                                                            color={255,0,255}));
  connect(upProCon1.yHotWatIsoVal, pre21.u) annotation (Line(points={{38,244},{38,
          246},{50,246},{50,230},{114,230}},       color={255,0,255}));
  connect(pre21.y, upProCon1.uHotWatIsoVal) annotation (Line(points={{138,230},{
          160,230},{160,300},{2,300},{2,250},{14,250}},      color={255,0,255}));
  connect(upProCon4.yHotWatIsoVal, pre22.u) annotation (Line(points={{622,192},{
          626,192},{626,160},{638,160}}, color={255,0,255}));
  connect(pre22.y, upProCon4.uHotWatIsoVal) annotation (Line(points={{662,160},{
          740,160},{740,280},{588,280},{588,198},{598,198}}, color={255,0,255}));
  connect(con7.y, onCouInt.reset) annotation (Line(points={{-758,190},{-736,190},
          {-736,200},{-680,200},{-680,208}},
                       color={255,0,255}));
  connect(onCouInt.y, upProCon.uStaSet) annotation (Line(points={{-668,220},{-462,
          220}},                            color={255,127,0}));
  connect(con4.y, and2.u2) annotation (Line(points={{-678,160},{-592,160},{-592,
          162},{-582,162}}, color={255,0,255}));
  connect(con1.y, and1.u2) annotation (Line(points={{-678,120},{-592,120},{-592,
          122},{-582,122}},                   color={255,0,255}));
  connect(con2.y, and3.u2) annotation (Line(points={{-678,70},{-592,70},{-592,82},
          {-582,82}},     color={255,0,255}));
  connect(intEqu.y, booScaRep.u)
    annotation (Line(points={{-628,180},{-622,180}}, color={255,0,255}));
  connect(booScaRep.y, and2.u1) annotation (Line(points={{-598,180},{-590,180},{
          -590,170},{-582,170}},  color={255,0,255}));
  connect(intEqu1.y, booScaRep1.u)
    annotation (Line(points={{-628,140},{-622,140}}, color={255,0,255}));
  connect(booScaRep1.y, and1.u1) annotation (Line(points={{-598,140},{-592,140},
          {-592,130},{-582,130}},
                                color={255,0,255}));
  connect(intEqu2.y, booScaRep2.u)
    annotation (Line(points={{-624,90},{-622,90}}, color={255,0,255}));
  connect(booScaRep2.y, and3.u1)
    annotation (Line(points={{-598,90},{-582,90}}, color={255,0,255}));
  connect(and2.y, or2.u1) annotation (Line(points={{-558,170},{-546,170},{-546,150},
          {-542,150}},      color={255,0,255}));
  connect(and1.y, or2.u2) annotation (Line(points={{-558,130},{-558,142},{-542,142}},
        color={255,0,255}));
  connect(or2.y, or7.u1) annotation (Line(points={{-518,150},{-510,150},{-510,130},
          {-502,130}},    color={255,0,255}));
  connect(or7.y, upProCon.uBoiSet) annotation (Line(points={{-478,130},{-470,130},
          {-470,232},{-462,232}},                     color={255,0,255}));
  connect(or6.y, onCouInt.trigger)
    annotation (Line(points={{-698,220},{-692,220}}, color={255,0,255}));
  connect(booPul.y, or6.u1) annotation (Line(points={{-738,270},{-728,270},{-728,
          220},{-722,220}},      color={255,0,255}));
  connect(booPul.y, upProCon.uPlaEna) annotation (Line(points={{-738,270},{-588,
          270},{-588,216},{-462,216}}, color={255,0,255}));
  connect(pre2.y, pre14.u) annotation (Line(points={{-338,260},{-320,260},{-320,
          330},{-772,330},{-772,212},{-762,212},{-762,220}},      color={255,0,
          255}));
  connect(pre14.y, or6.u2) annotation (Line(points={{-738,220},{-732,220},{-732,
          212},{-722,212}},
                 color={255,0,255}));
  connect(or8.u2, pre3.y)
    annotation (Line(points={{-252,222},{-260,222},{-260,230},{-268,230}},
                                                          color={255,0,255}));
  connect(booPul1.y, or8.u1) annotation (Line(points={{-268,264},{-256,264},{-256,
          230},{-252,230}},   color={255,0,255}));
  connect(or8.y, onCouInt1.trigger)
    annotation (Line(points={{-228,230},{-222,230}},
                                                 color={255,0,255}));
  connect(con12.y, onCouInt1.reset) annotation (Line(points={{-258,200},{-210,200},
          {-210,218}},              color={255,0,255}));
  connect(onCouInt1.y, upProCon1.uStaSet) annotation (Line(points={{-198,230},{14,
          230}},                         color={255,127,0}));
  connect(intEqu3.y, booScaRep3.u)
    annotation (Line(points={{-158,190},{-142,190}},
                                                   color={255,0,255}));
  connect(intEqu4.y, booScaRep4.u)
    annotation (Line(points={{-158,140},{-142,140}},
                                                   color={255,0,255}));
  connect(intEqu5.y, booScaRep5.u)
    annotation (Line(points={{-158,90},{-142,90}},
                                                 color={255,0,255}));
  connect(booScaRep3.y, and4.u1) annotation (Line(points={{-118,190},{-110,190},
          {-110,170},{-102,170}},
                               color={255,0,255}));
  connect(booScaRep4.y, and5.u1) annotation (Line(points={{-118,140},{-116,140},
          {-116,130},{-102,130}},
                               color={255,0,255}));
  connect(booScaRep5.y, and6.u1)
    annotation (Line(points={{-118,90},{-72,90},{-72,80},{-62,80}},
                                                 color={255,0,255}));
  connect(con9.y, and4.u2) annotation (Line(points={{-198,160},{-196,162},{-102,
          162}},      color={255,0,255}));
  connect(con5.y, and5.u2) annotation (Line(points={{-198,110},{-148,110},{-148,
          122},{-102,122}},
                      color={255,0,255}));
  connect(con6.y, and6.u2) annotation (Line(points={{-198,50},{-72,50},{-72,72},
          {-62,72}},         color={255,0,255}));
  connect(and4.y, or9.u1) annotation (Line(points={{-78,170},{-72,170},{-72,160},
          {-62,160}}, color={255,0,255}));
  connect(and5.y, or9.u2) annotation (Line(points={{-78,130},{-72,130},{-72,152},
          {-62,152}},
        color={255,0,255}));
  connect(and6.y, or10.u2) annotation (Line(points={{-38,80},{-32,80},{-32,132},
          {-22,132}}, color={255,0,255}));
  connect(or9.y, or10.u1) annotation (Line(points={{-38,160},{-30,160},{-30,140},
          {-22,140}},
        color={255,0,255}));
  connect(or10.y, upProCon1.uBoiSet) annotation (Line(points={{2,140},{8,140},{8,
          242},{14,242}},
        color={255,0,255}));
  connect(pre6.y, pre3.u) annotation (Line(points={{138,270},{180,270},{180,310},
          {-304,310},{-304,230},{-292,230}},
                                    color={255,0,255}));
  connect(pre3.y, upProCon1.uStaUpPro) annotation (Line(points={{-268,230},{-260,
          230},{-260,250},{-20,250},{-20,238},{14,238}},color={255,0,255}));
  connect(booPul1.y, upProCon1.uPlaEna) annotation (Line(points={{-268,264},{-172,
          264},{-172,226},{14,226}},
                           color={255,0,255}));
  connect(booPul4.y, upProCon4.uPlaEna) annotation (Line(points={{272,310},{284,
          310},{284,270},{568,270},{568,174},{598,174}}, color={255,0,255}));
  connect(intEqu6.y, booScaRep6.u)
    annotation (Line(points={{402,210},{418,210}}, color={255,0,255}));
  connect(booScaRep6.y, and7.u1) annotation (Line(points={{442,210},{478,210}},
                               color={255,0,255}));
  connect(intEqu7.y, booScaRep7.u)
    annotation (Line(points={{402,160},{418,160}}, color={255,0,255}));
  connect(booScaRep7.y, and8.u1) annotation (Line(points={{442,160},{478,160}},
                               color={255,0,255}));
  connect(intEqu8.y, booScaRep8.u)
    annotation (Line(points={{400,110},{418,110}}, color={255,0,255}));
  connect(booScaRep8.y, and9.u1)
    annotation (Line(points={{442,110},{478,110}}, color={255,0,255}));
  connect(or1.y, onCouInt2.trigger)
    annotation (Line(points={{312,250},{318,250}}, color={255,0,255}));
  connect(booPul4.y, or1.u1) annotation (Line(points={{272,310},{284,310},{284,250},
          {288,250}},                          color={255,0,255}));
  connect(pre4.y, or1.u2) annotation (Line(points={{262,250},{270,250},{270,242},
          {288,242}},           color={255,0,255}));
  connect(and7.y, or5.u1) annotation (Line(points={{502,210},{508,210},{508,170},
          {518,170}},                     color={255,0,255}));
  connect(and8.y, or5.u2) annotation (Line(points={{502,160},{504,162},{518,162}},
        color={255,0,255}));
  connect(or5.y, or11.u1) annotation (Line(points={{542,170},{550,170},{550,140},
          {558,140}}, color={255,0,255}));
  connect(and9.y, or11.u2) annotation (Line(points={{502,110},{558,110},{558,132}},
                 color={255,0,255}));
  connect(con24.y, and7.u2) annotation (Line(points={{310,190},{460,190},{460,202},
          {478,202}},
                 color={255,0,255}));
  connect(con20.y, and8.u2) annotation (Line(points={{312,130},{478,130},{478,152}},
                                               color={255,0,255}));
  connect(con21.y, and9.u2) annotation (Line(points={{310,80},{468,80},{468,102},
          {478,102}},              color={255,0,255}));
  connect(or11.y, upProCon4.uBoiSet) annotation (Line(points={{582,140},{588,140},
          {588,190},{598,190}},                          color={255,0,255}));
  connect(pre15.y, pre4.u) annotation (Line(points={{734,192},{744,192},{744,332},
          {228,332},{228,250},{238,250}},
                                     color={255,0,255}));
  connect(con22.y, onCouInt2.reset) annotation (Line(points={{222,230},{330,230},
          {330,238}}, color={255,0,255}));
  connect(pre4.y, upProCon4.uStaUpPro) annotation (Line(points={{262,250},{270,250},
          {270,276},{528,276},{528,186},{598,186}},
        color={255,0,255}));
  connect(onCouInt2.y, upProCon4.uStaSet) annotation (Line(points={{342,250},{584,
          250},{584,178},{598,178}},     color={255,127,0}));
  connect(intEqu9.y, booScaRep9.u)
    annotation (Line(points={{-358,-200},{-352,-200}}, color={255,0,255}));
  connect(booScaRep9.y, and10.u1) annotation (Line(points={{-328,-200},{-322,-200}},
                                          color={255,0,255}));
  connect(intEqu10.y, booScaRep10.u)
    annotation (Line(points={{-358,-250},{-352,-250}}, color={255,0,255}));
  connect(booScaRep10.y, and11.u1) annotation (Line(points={{-328,-250},{-322,-250}},
                                          color={255,0,255}));
  connect(intEqu11.y, booScaRep11.u)
    annotation (Line(points={{-358,-300},{-352,-300}}, color={255,0,255}));
  connect(booScaRep11.y, and12.u1)
    annotation (Line(points={{-328,-300},{-322,-300}}, color={255,0,255}));
  connect(booPul2.y, upProCon2.uPlaEna) annotation (Line(points={{-498,-90},{-492,
          -90},{-492,-108},{-224,-108},{-224,-164},{-172,-164}},
                                              color={255,0,255}));
  connect(conInt11.y, intEqu9.u1)
    annotation (Line(points={{-418,-200},{-382,-200}}, color={255,127,0}));
  connect(conInt9.y, intEqu10.u1)
    annotation (Line(points={{-418,-250},{-382,-250}}, color={255,127,0}));
  connect(conInt8.y, intEqu11.u1)
    annotation (Line(points={{-418,-300},{-382,-300}}, color={255,127,0}));
  connect(con14.y, and10.u2) annotation (Line(points={{-470,-230},{-322,-230},{-322,
          -208}},                                          color={255,0,255}));
  connect(con10.y, and11.u2) annotation (Line(points={{-468,-278},{-322,-278},{-322,
          -258}},                              color={255,0,255}));
  connect(con11.y, and12.u2) annotation (Line(points={{-466,-320},{-324,-320},{-324,
          -308},{-322,-308}},
                       color={255,0,255}));
  connect(onCouInt3.y, intEqu9.u2) annotation (Line(points={{-416,-150},{-400,-150},
          {-400,-208},{-382,-208}},       color={255,127,0}));
  connect(onCouInt3.y, intEqu10.u2) annotation (Line(points={{-416,-150},{-400,-150},
          {-400,-258},{-382,-258}},       color={255,127,0}));
  connect(onCouInt3.y, intEqu11.u2) annotation (Line(points={{-416,-150},{-400,-150},
          {-400,-308},{-382,-308}},       color={255,127,0}));
  connect(and10.y, or12.u1) annotation (Line(points={{-298,-200},{-290,-200},{-290,
          -220},{-282,-220}},      color={255,0,255}));
  connect(and11.y, or12.u2) annotation (Line(points={{-298,-250},{-290,-250},{-290,
          -228},{-282,-228}},
                       color={255,0,255}));
  connect(and12.y, or13.u2) annotation (Line(points={{-298,-300},{-292,-300},{-292,
          -266},{-242,-266},{-242,-248}},      color={255,0,255}));
  connect(or12.y, or13.u1)
    annotation (Line(points={{-258,-220},{-252,-220},{-252,-240},{-242,-240}},
                                                       color={255,0,255}));
  connect(or13.y, upProCon2.uBoiSet) annotation (Line(points={{-218,-240},{-212,
          -240},{-212,-148},{-172,-148}},                         color={255,0,
          255}));
  connect(onCouInt3.y, upProCon2.uStaSet) annotation (Line(points={{-416,-150},{
          -400,-150},{-400,-160},{-172,-160}},                          color={
          255,127,0}));
  connect(or3.y, onCouInt3.trigger)
    annotation (Line(points={{-458,-150},{-440,-150}}, color={255,0,255}));
  connect(con25.y, onCouInt3.reset) annotation (Line(points={{-468,-180},{-428,-180},
          {-428,-162}},                               color={255,0,255}));
  connect(pre9.y, pre7.u) annotation (Line(points={{-16,-140},{-10,-140},{-10,-48},
          {-532,-48},{-532,-150},{-524,-150}},
        color={255,0,255}));
  connect(intEqu12.y, booScaRep12.u)
    annotation (Line(points={{342,-200},{348,-200}}, color={255,0,255}));
  connect(booScaRep12.y, and13.u1) annotation (Line(points={{372,-200},{378,-200}},
                                        color={255,0,255}));
  connect(intEqu13.y, booScaRep13.u)
    annotation (Line(points={{342,-240},{348,-240}}, color={255,0,255}));
  connect(booScaRep13.y, and14.u1) annotation (Line(points={{372,-240},{378,-240}},
                                        color={255,0,255}));
  connect(intEqu14.y, booScaRep14.u)
    annotation (Line(points={{342,-290},{348,-290}}, color={255,0,255}));
  connect(booScaRep14.y, and15.u1)
    annotation (Line(points={{372,-290},{378,-290}}, color={255,0,255}));
  connect(or4.y, or14.u1) annotation (Line(points={{442,-210},{450,-210},{450,-230},
          {458,-230}},                  color={255,0,255}));
  connect(and15.y, or14.u2) annotation (Line(points={{402,-290},{450,-290},{450,
          -238},{458,-238}},
                  color={255,0,255}));
  connect(or14.y, upProCon3.uBoiSet) annotation (Line(points={{482,-230},{488,-230},
          {488,-116},{500,-116}},
                  color={255,0,255}));
  connect(and13.y, or4.u1) annotation (Line(points={{402,-200},{408,-200},{408,-210},
          {418,-210}},       color={255,0,255}));
  connect(and14.y, or4.u2) annotation (Line(points={{402,-240},{408,-240},{408,-218},
          {418,-218}},                  color={255,0,255}));
  connect(con26.y, onCouInt4.reset) annotation (Line(points={{222,-170},{280,-170},
          {280,-152}},                             color={255,0,255}));
  connect(or15.y, onCouInt4.trigger)
    annotation (Line(points={{262,-140},{268,-140}}, color={255,0,255}));
  connect(pre10.y, or15.u1) annotation (Line(points={{222,-140},{238,-140}},
                  color={255,0,255}));
  connect(booPul3.y, upProCon3.uPlaEna) annotation (Line(points={{222,-100},{232,
          -100},{232,-120},{476,-120},{476,-132},{500,-132}},color={255,0,255}));
  connect(onCouInt4.y, upProCon3.uStaSet) annotation (Line(points={{292,-140},{480,
          -140},{480,-128},{500,-128}},                           color={255,
          127,0}));
  connect(con19.y, and13.u2) annotation (Line(points={{242,-220},{378,-220},{378,
          -208}},                                      color={255,0,255}));
  connect(con15.y, and14.u2) annotation (Line(points={{242,-270},{378,-270},{378,
          -248}},     color={255,0,255}));
  connect(con16.y, and15.u2) annotation (Line(points={{242,-320},{378,-320},{378,
          -298}},                color={255,0,255}));
  connect(booPul3.y, or15.u2) annotation (Line(points={{222,-100},{232,-100},{232,
          -148},{238,-148}}, color={255,0,255}));
  connect(pre12.y, pre10.u) annotation (Line(points={{652,-110},{660,-110},{660,
          -20},{180,-20},{180,-140},{198,-140}},                         color=
          {255,0,255}));
  connect(pre12.y, upProCon3.uStaChaPro) annotation (Line(points={{652,-110},{660,
          -110},{660,-20},{472,-20},{472,-136},{500,-136}},
        color={255,0,255}));
  connect(upProCon.yBoi, pre13.u) annotation (Line(points={{-438,242},{-432,242},
          {-432,300},{-438,300}}, color={255,0,255}));
  connect(pre13.y, upProCon.uBoi) annotation (Line(points={{-462,300},{-488,300},
          {-488,236},{-462,236}}, color={255,0,255}));
  connect(upProCon1.yBoi, pre16.u)
    annotation (Line(points={{38,252},{38,278}},   color={255,0,255}));
  connect(pre16.y, upProCon1.uBoi)
    annotation (Line(points={{14,278},{14,246}},   color={255,0,255}));
  connect(upProCon4.yBoi, pre17.u)
    annotation (Line(points={{622,200},{630,200},{630,226},{622,226}},
                                                   color={255,0,255}));
  connect(pre17.y, upProCon4.uBoi)
    annotation (Line(points={{598,226},{594,226},{594,194},{598,194}},
                                                   color={255,0,255}));
  connect(upProCon2.yBoi, pre18.u)
    annotation (Line(points={{-148,-138},{-148,-110}}, color={255,0,255}));
  connect(pre18.y, upProCon2.uBoi) annotation (Line(points={{-172,-110},{-172,-112},
          {-196,-112},{-196,-144},{-172,-144}},       color={255,0,255}));
  connect(upProCon3.yBoi, pre19.u)
    annotation (Line(points={{524,-106},{536,-106},{536,-70},{522,-70}},
                                                     color={255,0,255}));
  connect(pre19.y, upProCon3.uBoi)
    annotation (Line(points={{498,-70},{492,-70},{492,-112},{500,-112}},
                                                     color={255,0,255}));
  connect(pre14.y, upProCon.uStaUpPro) annotation (Line(points={{-738,220},{-732,
          220},{-732,240},{-660,240},{-660,228},{-462,228}},
        color={255,0,255}));
  connect(and3.y, or16.u1) annotation (Line(points={{-558,90},{-550,90},{-550,80},
          {-542,80}},     color={255,0,255}));
  connect(and16.y, or16.u2) annotation (Line(points={{-558,40},{-542,40},{-542,72}},
                color={255,0,255}));
  connect(booScaRep15.y, and16.u1)
    annotation (Line(points={{-598,40},{-582,40}}, color={255,0,255}));
  connect(intEqu15.y, booScaRep15.u)
    annotation (Line(points={{-626,40},{-622,40}}, color={255,0,255}));
  connect(con27.y, and16.u2) annotation (Line(points={{-678,20},{-582,20},{-582,
          32}},          color={255,0,255}));
  connect(or16.y, or7.u2) annotation (Line(points={{-518,80},{-506,80},{-506,112},
          {-510,112},{-510,122},{-502,122}},
                      color={255,0,255}));
  connect(conInt1.y, intEqu.u1)
    annotation (Line(points={{-706,180},{-652,180}}, color={255,127,0}));
  connect(conInt3.y, intEqu1.u1)
    annotation (Line(points={{-706,140},{-652,140}}, color={255,127,0}));
  connect(conInt20.y, intEqu2.u1)
    annotation (Line(points={{-708,90},{-648,90}}, color={255,127,0}));
  connect(conInt21.y, intEqu15.u1)
    annotation (Line(points={{-708,40},{-650,40}}, color={255,127,0}));
  connect(onCouInt.y, intEqu.u2) annotation (Line(points={{-668,220},{-660,220},
          {-660,172},{-652,172}}, color={255,127,0}));
  connect(onCouInt.y, intEqu1.u2) annotation (Line(points={{-668,220},{-660,220},
          {-660,132},{-652,132}}, color={255,127,0}));
  connect(onCouInt.y, intEqu2.u2) annotation (Line(points={{-668,220},{-660,220},
          {-660,82},{-648,82}}, color={255,127,0}));
  connect(onCouInt.y, intEqu15.u2) annotation (Line(points={{-668,220},{-660,220},
          {-660,32},{-650,32}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu3.u1) annotation (Line(points={{-198,230},{-190,230},
          {-190,190},{-182,190}}, color={255,127,0}));
  connect(conInt7.y, intEqu3.u2) annotation (Line(points={{-228,180},{-182,180},
          {-182,182}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu4.u1) annotation (Line(points={{-198,230},{-190,230},
          {-190,140},{-182,140}}, color={255,127,0}));
  connect(onCouInt1.y, intEqu5.u1) annotation (Line(points={{-198,230},{-190,230},
          {-190,90},{-182,90}}, color={255,127,0}));
  connect(conInt5.y, intEqu4.u2) annotation (Line(points={{-230,130},{-228,132},
          {-182,132}}, color={255,127,0}));
  connect(conInt4.y, intEqu5.u2) annotation (Line(points={{-230,80},{-192,80},{-192,
          82},{-182,82}}, color={255,127,0}));
  connect(conInt17.y, intEqu7.u1)
    annotation (Line(points={{342,160},{378,160}}, color={255,127,0}));
  connect(conInt16.y, intEqu8.u1)
    annotation (Line(points={{340,110},{376,110}}, color={255,127,0}));
  connect(conInt19.y, intEqu6.u1)
    annotation (Line(points={{342,210},{378,210}}, color={255,127,0}));
  connect(onCouInt2.y, intEqu6.u2) annotation (Line(points={{342,250},{370,250},
          {370,202},{378,202}}, color={255,127,0}));
  connect(onCouInt2.y, intEqu7.u2) annotation (Line(points={{342,250},{370,250},
          {370,152},{378,152}}, color={255,127,0}));
  connect(onCouInt2.y, intEqu8.u2) annotation (Line(points={{342,250},{370,250},
          {370,102},{376,102}}, color={255,127,0}));
  connect(conInt12.y, intEqu14.u1)
    annotation (Line(points={{292,-290},{318,-290}}, color={255,127,0}));
  connect(conInt13.y, intEqu13.u1)
    annotation (Line(points={{292,-240},{318,-240}}, color={255,127,0}));
  connect(conInt15.y, intEqu12.u1)
    annotation (Line(points={{292,-200},{318,-200}}, color={255,127,0}));
  connect(onCouInt4.y, intEqu12.u2) annotation (Line(points={{292,-140},{308,-140},
          {308,-208},{318,-208}}, color={255,127,0}));
  connect(onCouInt4.y, intEqu13.u2) annotation (Line(points={{292,-140},{308,-140},
          {308,-248},{318,-248}}, color={255,127,0}));
  connect(onCouInt4.y, intEqu14.u2) annotation (Line(points={{292,-140},{308,-140},
          {308,-298},{318,-298}}, color={255,127,0}));
  connect(onCouInt4.y, intGreEqu.u1) annotation (Line(points={{292,-140},{300,-140},
          {300,-90},{308,-90}}, color={255,127,0}));
  connect(conInt12.y, intGreEqu.u2) annotation (Line(points={{292,-290},{304,-290},
          {304,-98},{308,-98}}, color={255,127,0}));
  connect(intGreEqu.y, not1.u)
    annotation (Line(points={{332,-90},{338,-90}}, color={255,0,255}));
  connect(not1.y, and17.u1) annotation (Line(points={{362,-90},{364,-90},{364,-100},
          {378,-100}}, color={255,0,255}));
  connect(pre10.y, and17.u2) annotation (Line(points={{222,-140},{228,-140},{228,
          -108},{378,-108}}, color={255,0,255}));
  connect(and17.y, upProCon3.uStaUpPro) annotation (Line(points={{402,-100},{480,
          -100},{480,-120},{500,-120}}, color={255,0,255}));
  connect(pre7.y, or3.u1)
    annotation (Line(points={{-500,-150},{-482,-150}}, color={255,0,255}));
  connect(booPul2.y, or3.u2) annotation (Line(points={{-498,-90},{-492,-90},{-492,
          -158},{-482,-158}}, color={255,0,255}));
  connect(onCouInt3.y, intGreEqu1.u1) annotation (Line(points={{-416,-150},{-400,
          -150},{-400,-130},{-382,-130}}, color={255,127,0}));
  connect(conInt8.y, intGreEqu1.u2) annotation (Line(points={{-418,-300},{-392,-300},
          {-392,-138},{-382,-138}}, color={255,127,0}));
  connect(intGreEqu1.y, not2.u)
    annotation (Line(points={{-358,-130},{-352,-130}}, color={255,0,255}));
  connect(not2.y, and18.u1) annotation (Line(points={{-328,-130},{-320,-130},{-320,
          -140},{-312,-140}}, color={255,0,255}));
  connect(pre7.y, and18.u2) annotation (Line(points={{-500,-150},{-488,-150},{-488,
          -132},{-410,-132},{-410,-148},{-312,-148}}, color={255,0,255}));
  connect(and18.y, upProCon2.uStaUpPro) annotation (Line(points={{-288,-140},{-204,
          -140},{-204,-152},{-172,-152}}, color={255,0,255}));
annotation (
 experiment(
      StopTime=1800,
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
        coordinateSystem(preserveAspectRatio=false, extent={{-780,-340},{780,340}})));
end Up;
