within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Validation;
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon(
    final primaryOnly=false,
    final isHeadered=true,
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
    annotation (Placement(transformation(extent={{-160,166},{-140,206}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon1(
    final primaryOnly=false,
    final isHeadered=true,
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
    annotation (Placement(transformation(extent={{210,166},{230,206}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon2(
    final primaryOnly=false,
    final isHeadered=false,
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
    annotation (Placement(transformation(extent={{-170,-164},{-150,-124}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon3(
    final primaryOnly=false,
    final isHeadered=false,
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
    annotation (Placement(transformation(extent={{210,-164},{230,-124}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon4(
    final primaryOnly=true,
    final isHeadered=true,
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
    "Stage up process where temperature reset condition is met"
    annotation (Placement(transformation(extent={{600,166},{620,206}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yStaChaPro(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));

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
    annotation (Placement(transformation(extent={{250,-140},{270,-120}})));

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
    annotation (Placement(transformation(extent={{250,-180},{270,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yPumChaPro4(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold true pulse signal for visualization"
    annotation (Placement(transformation(extent={{640,150},{660,170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoi[nBoi](
    final k={true,false})
    "Initial boiler status"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-334,70},{-314,90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nBoi]
    "Pass initial boiler status and switch to signal from controller"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat[nBoi](
    final pre_y_start=fill(false, nBoi))
    "Hold true signal after change in boiler status"
    annotation (Placement(transformation(extent={{-290,190},{-270,210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-368,0},{-348,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi[nBoi]
    "Pass initial valve position and switch to signal from controller"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final startTime=fill(0, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,250},{-350,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nBoi](
    final k={1,0})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{-300,280},{-280,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[nBoi](
    final samplePeriod=fill(10, nBoi))
    "Zero order hold"
    annotation (Placement(transformation(extent={{-60,166},{-40,186}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-28,190},{-8,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,190},{-70,210}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-300,100},{-280,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-334,130},{-314,150}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi1
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-320,20},{-300,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-370,40},{-350,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg2
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-164,110},{-144,130}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha[nBoi]
    "Detect change in boiler status from controller"
    annotation (Placement(transformation(extent={{-330,190},{-310,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1[nBoi](
    final pre_y_start=fill(false, nBoi))
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-130,60},{-110,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoi1[nBoi](
    final k={true,false})
    "Initial boiler status"
    annotation (Placement(transformation(extent={{110,170},{130,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{36,70},{56,90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[nBoi]
    "Pass initial boiler status and switch to signal from controller"
    annotation (Placement(transformation(extent={{150,190},{170,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal after change in boiler status"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{110,220},{130,240}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{150,100},{170,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{110,120},{130,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,150},{300,170}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi2
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{150,140},{170,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nBoi]
    "Pass initial valve position and switch to signal from controller"
    annotation (Placement(transformation(extent={{150,270},{170,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final startTime=fill(0, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{0,250},{20,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7[nBoi](
    final k={1,0})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{70,280},{90,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{190,280},{210,300}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[nBoi](
    final samplePeriod=fill(10, nBoi))
    "Zero order hold"
    annotation (Placement(transformation(extent={{310,166},{330,186}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5
    "Logical pre block"
    annotation (Placement(transformation(extent={{330,130},{350,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6
    "Logical pre block"
    annotation (Placement(transformation(extent={{342,190},{362,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg4
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi5[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{36,130},{56,150}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi3
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg5
    "Falling edge detector"
    annotation (Placement(transformation(extent={{206,110},{226,130}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha1[nBoi]
    "Detect change in boiler status from controller"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{280,60},{300,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoi2[nBoi](
    final k={true,false})
    "Initial boiler status"
    annotation (Placement(transformation(extent={{-270,-160},{-250,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-344,-260},{-324,-240}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi6[nBoi]
    "Pass initial boiler status and switch to signal from controller"
    annotation (Placement(transformation(extent={{-230,-140},{-210,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat4[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal after change in boiler status"
    annotation (Placement(transformation(extent={{-300,-140},{-280,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-270,-110},{-250,-90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi7[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-230,-230},{-210,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-270,-210},{-250,-190}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg6
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi4
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{-230,-300},{-210,-280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{-270,-280},{-250,-260}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{-380,-330},{-360,-310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{-230,-190},{-210,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final startTime=fill(0, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con13(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-340,-60},{-320,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8
    "Logical pre block"
    annotation (Placement(transformation(extent={{-50,-200},{-30,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre9
    "Logical pre block"
    annotation (Placement(transformation(extent={{-38,-140},{-18,-120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg7
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi8[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-310,-230},{-290,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con14[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-344,-200},{-324,-180}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi5
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-330,-310},{-310,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt11(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-380,-290},{-360,-270}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg8
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-174,-220},{-154,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha2[nBoi]
    "Detect change in boiler status from controller"
    annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat5[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoi3[nBoi](
    final k={true,false})
    "Initial boiler status"
    annotation (Placement(transformation(extent={{110,-160},{130,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con15[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{36,-260},{56,-240}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi9[nBoi]
    "Pass initial boiler status and switch to signal from controller"
    annotation (Placement(transformation(extent={{150,-140},{170,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat6[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal after change in boiler status"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre10[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi10[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{150,-230},{170,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{110,-210},{130,-190}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg9
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,-180},{300,-160}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi6
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{150,-300},{170,-280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt12(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{110,-280},{130,-260}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt13(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{0,-330},{20,-310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt14[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{150,-190},{170,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final startTime=fill(0, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con18(
    final k=TMinSupNonConBoi - 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre11
    "Logical pre block"
    annotation (Placement(transformation(extent={{330,-200},{350,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre12
    "Logical pre block"
    annotation (Placement(transformation(extent={{342,-140},{362,-120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg10
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,-140},{300,-120}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi11[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{70,-230},{90,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con19[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{36,-200},{56,-180}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi7
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{50,-310},{70,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt15(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg11
    "Falling edge detector"
    annotation (Placement(transformation(extent={{206,-220},{226,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha3[nBoi]
    "Detect change in boiler status from controller"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat7[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{280,-270},{300,-250}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{240,-270},{260,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uBoi4[nBoi](
    final k={true,false})
    "Initial boiler status"
    annotation (Placement(transformation(extent={{500,170},{520,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{426,70},{446,90}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi12[nBoi]
    "Pass initial boiler status and switch to signal from controller"
    annotation (Placement(transformation(extent={{540,190},{560,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat8[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal after change in boiler status"
    annotation (Placement(transformation(extent={{470,190},{490,210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre13[nBoi]
    "Logical pre block"
    annotation (Placement(transformation(extent={{500,220},{520,240}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi13[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{540,100},{560,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{500,120},{520,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg12
    "Falling edge detector"
    annotation (Placement(transformation(extent={{670,150},{690,170}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi8
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{540,30},{560,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt16(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{500,50},{520,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt17(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{390,0},{410,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt18[nSta](
    final k={1,
        1,1})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{540,140},{560,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{630,110},{650,130}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nBoi]
    "Pass initial valve position and switch to signal from controller"
    annotation (Placement(transformation(extent={{540,270},{560,290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final startTime=fill(0, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{390,250},{410,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con22[nBoi](
    final k={1,0})
    "Initial isolation valve positions"
    annotation (Placement(transformation(extent={{460,280},{480,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con23(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{580,280},{600,300}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4[nBoi](
    final samplePeriod=fill(10, nBoi))
    "Zero order hold"
    annotation (Placement(transformation(extent={{700,166},{720,186}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre14
    "Logical pre block"
    annotation (Placement(transformation(extent={{720,130},{740,150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre15
    "Logical pre block"
    annotation (Placement(transformation(extent={{732,190},{752,210}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg13
    "Falling edge detector"
    annotation (Placement(transformation(extent={{670,190},{690,210}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi14[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{460,100},{480,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant  con24[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{426,130},{446,150}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi9
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{440,20},{460,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{390,40},{410,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg14
    "Falling edge detector"
    annotation (Placement(transformation(extent={{596,110},{616,130}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha4[nBoi]
    "Detect change in boiler status from controller"
    annotation (Placement(transformation(extent={{430,190},{450,210}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat9[nBoi](
    final pre_y_start=fill(false,nBoi))
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{670,60},{690,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{630,60},{650,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con12(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{670,310},{690,330}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con17(
    final k=VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{670,270},{690,290}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{710,290},{730,310}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat10
    annotation (Placement(transformation(extent={{630,290},{650,310}})));

equation

  connect(uBoi.y, logSwi.u3) annotation (Line(points={{-238,180},{-230,180},{
          -230,192},{-222,192}},
                            color={255,0,255}));

  connect(uBoi[2].y, lat[1].clr) annotation (Line(points={{-238,180},{-230,180},
          {-230,160},{-300,160},{-300,194},{-292,194}}, color={255,0,255}));

  connect(uBoi[2].y, lat[2].clr) annotation (Line(points={{-238,180},{-230,180},
          {-230,160},{-300,160},{-300,194},{-292,194}}, color={255,0,255}));

  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-268,200},{-222,200}}, color={255,0,255}));

  connect(logSwi.y, upProCon.uBoi) annotation (Line(points={{-198,200},{-180,
          200},{-180,188},{-162,188}},
                                  color={255,0,255}));

  connect(pre3.y, logSwi.u1) annotation (Line(points={{-238,230},{-230,230},{
          -230,208},{-222,208}}, color={255,0,255}));

  connect(con2.y, logSwi1.u1) annotation (Line(points={{-238,130},{-230,130},{
          -230,118},{-222,118}},
                            color={255,0,255}));

  connect(logSwi1.y, upProCon.uBoiSet) annotation (Line(points={{-198,110},{
          -180,110},{-180,184},{-162,184}},
                                       color={255,0,255}));

  connect(upProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,169},
          {-130,169},{-130,160},{-122,160}}, color={255,0,255}));

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(intSwi.y, upProCon.uStaSet) annotation (Line(points={{-198,40},{-172,
          40},{-172,172},{-162,172}},
                                  color={255,127,0}));

  connect(conInt.y, intSwi.u1) annotation (Line(points={{-238,60},{-230,60},{
          -230,48},{-222,48}},
                          color={255,127,0}));

  connect(conInt2.y, upProCon.uStaTyp) annotation (Line(points={{-198,150},{
          -190,150},{-190,176},{-162,176}},
                                       color={255,127,0}));

  connect(or2.y, upProCon.uStaUpPro) annotation (Line(points={{-108,120},{-104,
          120},{-104,104},{-176,104},{-176,180},{-162,180}},
                                                     color={255,0,255}));

  connect(booPul.y, swi.u2) annotation (Line(points={{-348,260},{-240,260},{
          -240,280},{-222,280}},
                            color={255,0,255}));

  connect(con.y, swi.u1) annotation (Line(points={{-278,290},{-230,290},{-230,
          288},{-222,288}},
                       color={0,0,127}));

  connect(swi.y, upProCon.uHotWatIsoVal) annotation (Line(points={{-198,280},{
          -190,280},{-190,204},{-176,204},{-176,192},{-162,192}},
                                       color={0,0,127}));

  connect(con3.y, upProCon.THotWatSup) annotation (Line(points={{-158,290},{
          -150,290},{-150,270},{-170,270},{-170,196},{-162,196}},
                                                       color={0,0,127}));

  connect(upProCon.yHotWatIsoVal, zerOrdHol.u) annotation (Line(points={{-138,
          190},{-128,190},{-128,176},{-62,176}},
                                         color={0,0,127}));

  connect(zerOrdHol.y, swi.u3) annotation (Line(points={{-38,176},{-34,176},{
          -34,260},{-230,260},{-230,272},{-222,272}},
                                             color={0,0,127}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-46,160},{-46,
          140},{-42,140}}, color={255,0,255}));

  connect(pre1.y, upProCon.uPumChaPro) annotation (Line(points={{-18,140},{-6,
          140},{-6,120},{-90,120},{-90,142},{-168,142},{-168,168},{-162,168}},
        color={255,0,255}));

  connect(upProCon.yStaChaPro,yStaChaPro. u) annotation (Line(points={{-138,197},
          {-129,197},{-129,200},{-122,200}}, color={255,0,255}));

  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,200},{-92,200}}, color={255,0,255}));

  connect(con1.y, logSwi2.u3) annotation (Line(points={{-312,80},{-306,80},{
          -306,102},{-302,102}}, color={255,0,255}));

  connect(con4.y, logSwi2.u1) annotation (Line(points={{-312,140},{-306,140},{
          -306,118},{-302,118}}, color={255,0,255}));

  connect(booPul.y, logSwi2.u2) annotation (Line(points={{-348,260},{-340,260},
          {-340,110},{-302,110}}, color={255,0,255}));

  connect(logSwi2.y, logSwi1.u3) annotation (Line(points={{-278,110},{-272,110},
          {-272,102},{-222,102}}, color={255,0,255}));

  connect(conInt1.y, intSwi1.u3) annotation (Line(points={{-346,10},{-330,10},{-330,
          22},{-322,22}},     color={255,127,0}));

  connect(conInt3.y, intSwi1.u1) annotation (Line(points={{-348,50},{-330,50},{-330,
          38},{-322,38}},      color={255,127,0}));

  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{-298,30},{-230,30},{-230,
          32},{-222,32}},      color={255,127,0}));

  connect(booPul[1].y, intSwi1.u2) annotation (Line(points={{-348,260},{-340,260},
          {-340,30},{-322,30}},      color={255,0,255}));

  connect(upProCon.yBoi, pre3.u) annotation (Line(points={{-138,204},{-130,204},
          {-130,250},{-270,250},{-270,230},{-262,230}}, color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,200},{-30,200}}, color={255,0,255}));

  connect(pre2.y, or2.u2) annotation (Line(points={{-6,200},{0,200},{0,100},{
          -140,100},{-140,112},{-132,112}}, color={255,0,255}));

  connect(booPul[1].y, falEdg2.u) annotation (Line(points={{-348,260},{-340,260},
          {-340,96},{-168,96},{-168,120},{-166,120}}, color={255,0,255}));

  connect(falEdg2.y, or2.u1)
    annotation (Line(points={{-142,120},{-132,120}}, color={255,0,255}));

  connect(cha.y, lat.u)
    annotation (Line(points={{-308,200},{-292,200}}, color={255,0,255}));

  connect(pre3.y, cha.u) annotation (Line(points={{-238,230},{-230,230},{-230,
          218},{-336,218},{-336,200},{-332,200}}, color={255,0,255}));

  connect(booRep.y, lat1.u)
    annotation (Line(points={{-108,70},{-92,70}}, color={255,0,255}));

  connect(pre2.y, booRep.u) annotation (Line(points={{-6,200},{0,200},{0,100},{
          -140,100},{-140,70},{-132,70}}, color={255,0,255}));

  connect(lat1.y, logSwi1.u2) annotation (Line(points={{-68,70},{-60,70},{-60,
          50},{-160,50},{-160,74},{-226,74},{-226,110},{-222,110}}, color={255,
          0,255}));

  connect(lat1[1].y, intSwi.u2) annotation (Line(points={{-68,70},{-60,70},{-60,
          50},{-160,50},{-160,74},{-226,74},{-226,40},{-222,40}}, color={255,0,
          255}));

  connect(con1[1].y, lat1[1].clr) annotation (Line(points={{-312,80},{-150,80},
          {-150,54},{-100,54},{-100,64},{-92,64}}, color={255,0,255}));

  connect(con1[1].y, lat1[2].clr) annotation (Line(points={{-312,80},{-150,80},
          {-150,54},{-100,54},{-100,64},{-92,64}}, color={255,0,255}));

  connect(uBoi1.y, logSwi3.u3) annotation (Line(points={{132,180},{140,180},{140,
          192},{148,192}}, color={255,0,255}));

  connect(uBoi1[2].y, lat2[1].clr) annotation (Line(points={{132,180},{140,180},
          {140,160},{70,160},{70,194},{78,194}}, color={255,0,255}));

  connect(uBoi1[2].y, lat2[2].clr) annotation (Line(points={{132,180},{140,180},
          {140,160},{70,160},{70,194},{78,194}}, color={255,0,255}));

  connect(lat2.y, logSwi3.u2)
    annotation (Line(points={{102,200},{148,200}}, color={255,0,255}));

  connect(logSwi3.y, upProCon1.uBoi) annotation (Line(points={{172,200},{190,200},
          {190,188},{208,188}}, color={255,0,255}));

  connect(pre4.y, logSwi3.u1) annotation (Line(points={{132,230},{140,230},{140,
          208},{148,208}}, color={255,0,255}));

  connect(con6.y,logSwi4. u1) annotation (Line(points={{132,130},{140,130},{140,
          118},{148,118}},  color={255,0,255}));

  connect(logSwi4.y, upProCon1.uBoiSet) annotation (Line(points={{172,110},{190,
          110},{190,184},{208,184}}, color={255,0,255}));

  connect(upProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{232,
          169},{240,169},{240,160},{248,160}}, color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{272,160},{278,160}}, color={255,0,255}));

  connect(intSwi2.y, upProCon1.uStaSet) annotation (Line(points={{172,40},{198,40},
          {198,172},{208,172}}, color={255,127,0}));

  connect(conInt4.y, intSwi2.u1) annotation (Line(points={{132,60},{140,60},{140,
          48},{148,48}}, color={255,127,0}));

  connect(conInt6.y, upProCon1.uStaTyp) annotation (Line(points={{172,150},{180,
          150},{180,176},{208,176}}, color={255,127,0}));

  connect(or1.y, upProCon1.uStaUpPro) annotation (Line(points={{262,120},{266,120},
          {266,104},{194,104},{194,180},{208,180}}, color={255,0,255}));

  connect(booPul1.y, swi1.u2) annotation (Line(points={{22,260},{130,260},{130,280},
          {148,280}}, color={255,0,255}));

  connect(con7.y, swi1.u1) annotation (Line(points={{92,290},{140,290},{140,288},
          {148,288}}, color={0,0,127}));

  connect(swi1.y, upProCon1.uHotWatIsoVal) annotation (Line(points={{172,280},{180,
          280},{180,204},{194,204},{194,192},{208,192}}, color={0,0,127}));

  connect(con8.y, upProCon1.THotWatSup) annotation (Line(points={{212,290},{220,
          290},{220,270},{200,270},{200,196},{208,196}}, color={0,0,127}));

  connect(upProCon1.yHotWatIsoVal, zerOrdHol1.u) annotation (Line(points={{232,190},
          {242,190},{242,176},{308,176}}, color={0,0,127}));

  connect(zerOrdHol1.y, swi1.u3) annotation (Line(points={{332,176},{336,176},{336,
          260},{140,260},{140,272},{148,272}}, color={0,0,127}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{302,160},{324,160},{324,140},
          {328,140}}, color={255,0,255}));

  connect(pre5.y, upProCon1.uPumChaPro) annotation (Line(points={{352,140},{364,
          140},{364,120},{280,120},{280,142},{202,142},{202,168},{208,168}},
        color={255,0,255}));
  connect(upProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{232,
          197},{241,197},{241,200},{248,200}}, color={255,0,255}));

  connect(yStaChaPro1.y, falEdg4.u)
    annotation (Line(points={{272,200},{278,200}}, color={255,0,255}));

  connect(con5.y,logSwi5. u3) annotation (Line(points={{58,80},{64,80},{64,102},
          {68,102}},             color={255,0,255}));

  connect(con9.y,logSwi5. u1) annotation (Line(points={{58,140},{64,140},{64,118},
          {68,118}},             color={255,0,255}));

  connect(booPul1.y, logSwi5.u2) annotation (Line(points={{22,260},{30,260},{30,
          110},{68,110}}, color={255,0,255}));

  connect(logSwi5.y,logSwi4. u3) annotation (Line(points={{92,110},{98,110},{98,
          102},{148,102}},        color={255,0,255}));

  connect(conInt5.y,intSwi3. u3) annotation (Line(points={{22,10},{40,10},{40,22},
          {48,22}},           color={255,127,0}));

  connect(conInt7.y,intSwi3. u1) annotation (Line(points={{22,50},{40,50},{40,38},
          {48,38}},            color={255,127,0}));

  connect(intSwi3.y, intSwi2.u3) annotation (Line(points={{72,30},{140,30},{140,
          32},{148,32}}, color={255,127,0}));

  connect(booPul1[1].y, intSwi3.u2) annotation (Line(points={{22,260},{30,260},{
          30,30},{48,30}}, color={255,0,255}));

  connect(upProCon1.yBoi, pre4.u) annotation (Line(points={{232,204},{240,204},{
          240,250},{100,250},{100,230},{108,230}}, color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{302,200},{340,200}}, color={255,0,255}));

  connect(pre6.y,or1. u2) annotation (Line(points={{364,200},{370,200},{370,100},
          {230,100},{230,112},{238,112}},   color={255,0,255}));

  connect(booPul1[1].y, falEdg5.u) annotation (Line(points={{22,260},{30,260},{30,
          96},{202,96},{202,120},{204,120}}, color={255,0,255}));

  connect(falEdg5.y,or1. u1)
    annotation (Line(points={{228,120},{238,120}},   color={255,0,255}));

  connect(cha1.y, lat2.u)
    annotation (Line(points={{62,200},{78,200}}, color={255,0,255}));

  connect(pre4.y, cha1.u) annotation (Line(points={{132,230},{140,230},{140,218},
          {34,218},{34,200},{38,200}}, color={255,0,255}));

  connect(booRep1.y, lat3.u)
    annotation (Line(points={{262,70},{278,70}}, color={255,0,255}));

  connect(pre6.y, booRep1.u) annotation (Line(points={{364,200},{370,200},{370,100},
          {230,100},{230,70},{238,70}}, color={255,0,255}));

  connect(lat3.y,logSwi4. u2) annotation (Line(points={{302,70},{310,70},{310,50},
          {210,50},{210,74},{144,74},{144,110},{148,110}},          color={255,
          0,255}));
  connect(lat3[1].y, intSwi2.u2) annotation (Line(points={{302,70},{310,70},{310,
          50},{210,50},{210,74},{144,74},{144,40},{148,40}}, color={255,0,255}));

  connect(con5[1].y,lat3 [1].clr) annotation (Line(points={{58,80},{220,80},{220,
          54},{270,54},{270,64},{278,64}},         color={255,0,255}));

  connect(con5[1].y,lat3 [2].clr) annotation (Line(points={{58,80},{220,80},{220,
          54},{270,54},{270,64},{278,64}},         color={255,0,255}));

  connect(uBoi2.y, logSwi6.u3) annotation (Line(points={{-248,-150},{-240,-150},
          {-240,-138},{-232,-138}}, color={255,0,255}));

  connect(uBoi2[2].y, lat4[1].clr) annotation (Line(points={{-248,-150},{-240,-150},
          {-240,-170},{-310,-170},{-310,-136},{-302,-136}}, color={255,0,255}));

  connect(uBoi2[2].y, lat4[2].clr) annotation (Line(points={{-248,-150},{-240,-150},
          {-240,-170},{-310,-170},{-310,-136},{-302,-136}}, color={255,0,255}));

  connect(lat4.y, logSwi6.u2)
    annotation (Line(points={{-278,-130},{-232,-130}}, color={255,0,255}));

  connect(logSwi6.y, upProCon2.uBoi) annotation (Line(points={{-208,-130},{-190,
          -130},{-190,-142},{-172,-142}}, color={255,0,255}));

  connect(pre7.y, logSwi6.u1) annotation (Line(points={{-248,-100},{-240,-100},{
          -240,-122},{-232,-122}}, color={255,0,255}));

  connect(con11.y, logSwi7.u1) annotation (Line(points={{-248,-200},{-240,-200},
          {-240,-212},{-232,-212}}, color={255,0,255}));

  connect(logSwi7.y, upProCon2.uBoiSet) annotation (Line(points={{-208,-220},{-190,
          -220},{-190,-146},{-172,-146}}, color={255,0,255}));

  connect(upProCon2.yPumChaPro, yPumChaPro2.u) annotation (Line(points={{-148,-161},
          {-140,-161},{-140,-170},{-132,-170}}, color={255,0,255}));

  connect(yPumChaPro2.y, falEdg6.u)
    annotation (Line(points={{-108,-170},{-102,-170}}, color={255,0,255}));

  connect(intSwi4.y, upProCon2.uStaSet) annotation (Line(points={{-208,-290},{-182,
          -290},{-182,-158},{-172,-158}}, color={255,127,0}));

  connect(conInt8.y, intSwi4.u1) annotation (Line(points={{-248,-270},{-240,-270},
          {-240,-282},{-232,-282}}, color={255,127,0}));

  connect(conInt10.y, upProCon2.uStaTyp) annotation (Line(points={{-208,-180},{-200,
          -180},{-200,-154},{-172,-154}}, color={255,127,0}));

  connect(or3.y, upProCon2.uStaUpPro) annotation (Line(points={{-118,-210},{-114,
          -210},{-114,-226},{-186,-226},{-186,-150},{-172,-150}}, color={255,0,255}));

  connect(con13.y, upProCon2.THotWatSup) annotation (Line(points={{-318,-50},{-180,
          -50},{-180,-134},{-172,-134}}, color={0,0,127}));

  connect(falEdg6.y, pre8.u) annotation (Line(points={{-78,-170},{-56,-170},{-56,
          -190},{-52,-190}}, color={255,0,255}));

  connect(pre8.y, upProCon2.uPumChaPro) annotation (Line(points={{-28,-190},{-16,
          -190},{-16,-210},{-100,-210},{-100,-188},{-178,-188},{-178,-162},{-172,
          -162}}, color={255,0,255}));

  connect(upProCon2.yStaChaPro, yStaChaPro2.u) annotation (Line(points={{-148,-133},
          {-139,-133},{-139,-130},{-132,-130}}, color={255,0,255}));

  connect(yStaChaPro2.y, falEdg7.u)
    annotation (Line(points={{-108,-130},{-102,-130}}, color={255,0,255}));

  connect(con10.y, logSwi8.u3) annotation (Line(points={{-322,-250},{-316,-250},
          {-316,-228},{-312,-228}}, color={255,0,255}));

  connect(con14.y, logSwi8.u1) annotation (Line(points={{-322,-190},{-316,-190},
          {-316,-212},{-312,-212}}, color={255,0,255}));

  connect(booPul2.y, logSwi8.u2) annotation (Line(points={{-358,-70},{-350,-70},
          {-350,-220},{-312,-220}}, color={255,0,255}));

  connect(logSwi8.y,logSwi7. u3) annotation (Line(points={{-288,-220},{-282,-220},
          {-282,-228},{-232,-228}},
                                  color={255,0,255}));
  connect(conInt9.y,intSwi5. u3) annotation (Line(points={{-358,-320},{-340,-320},
          {-340,-308},{-332,-308}},
                              color={255,127,0}));

  connect(conInt11.y, intSwi5.u1) annotation (Line(points={{-358,-280},{-340,-280},
          {-340,-292},{-332,-292}}, color={255,127,0}));

  connect(intSwi5.y, intSwi4.u3) annotation (Line(points={{-308,-300},{-240,-300},
          {-240,-298},{-232,-298}}, color={255,127,0}));

  connect(booPul2[1].y, intSwi5.u2) annotation (Line(points={{-358,-70},{-350,-70},
          {-350,-300},{-332,-300}}, color={255,0,255}));

  connect(upProCon2.yBoi, pre7.u) annotation (Line(points={{-148,-126},{-140,-126},
          {-140,-80},{-280,-80},{-280,-100},{-272,-100}}, color={255,0,255}));

  connect(falEdg7.y,pre9. u)
    annotation (Line(points={{-78,-130},{-40,-130}},
                                                   color={255,0,255}));

  connect(pre9.y,or3. u2) annotation (Line(points={{-16,-130},{-10,-130},{-10,-230},
          {-150,-230},{-150,-218},{-142,-218}},
                                            color={255,0,255}));

  connect(booPul2[1].y, falEdg8.u) annotation (Line(points={{-358,-70},{-350,-70},
          {-350,-234},{-178,-234},{-178,-210},{-176,-210}}, color={255,0,255}));

  connect(falEdg8.y,or3. u1)
    annotation (Line(points={{-152,-210},{-142,-210}},
                                                     color={255,0,255}));
  connect(cha2.y, lat4.u)
    annotation (Line(points={{-318,-130},{-302,-130}}, color={255,0,255}));

  connect(pre7.y, cha2.u) annotation (Line(points={{-248,-100},{-240,-100},{-240,
          -112},{-346,-112},{-346,-130},{-342,-130}}, color={255,0,255}));

  connect(booRep2.y, lat5.u)
    annotation (Line(points={{-118,-260},{-102,-260}}, color={255,0,255}));

  connect(pre9.y, booRep2.u) annotation (Line(points={{-16,-130},{-10,-130},{-10,
          -230},{-150,-230},{-150,-260},{-142,-260}}, color={255,0,255}));

  connect(lat5.y,logSwi7. u2) annotation (Line(points={{-78,-260},{-70,-260},{-70,
          -280},{-170,-280},{-170,-256},{-236,-256},{-236,-220},{-232,-220}},
                                                                    color={255,
          0,255}));
  connect(lat5[1].y, intSwi4.u2) annotation (Line(points={{-78,-260},{-70,-260},
          {-70,-280},{-170,-280},{-170,-256},{-236,-256},{-236,-290},{-232,-290}},
        color={255,0,255}));
  connect(con10[1].y, lat5[1].clr) annotation (Line(points={{-322,-250},{-160,-250},
          {-160,-276},{-110,-276},{-110,-266},{-102,-266}}, color={255,0,255}));

  connect(con10[1].y, lat5[2].clr) annotation (Line(points={{-322,-250},{-160,-250},
          {-160,-276},{-110,-276},{-110,-266},{-102,-266}}, color={255,0,255}));

  connect(uBoi3.y, logSwi9.u3) annotation (Line(points={{132,-150},{140,-150},{140,
          -138},{148,-138}}, color={255,0,255}));

  connect(uBoi3[2].y, lat6[1].clr) annotation (Line(points={{132,-150},{140,-150},
          {140,-170},{70,-170},{70,-136},{78,-136}}, color={255,0,255}));

  connect(uBoi3[2].y, lat6[2].clr) annotation (Line(points={{132,-150},{140,-150},
          {140,-170},{70,-170},{70,-136},{78,-136}}, color={255,0,255}));

  connect(lat6.y, logSwi9.u2)
    annotation (Line(points={{102,-130},{148,-130}}, color={255,0,255}));

  connect(logSwi9.y, upProCon3.uBoi) annotation (Line(points={{172,-130},{190,-130},
          {190,-142},{208,-142}}, color={255,0,255}));

  connect(pre10.y, logSwi9.u1) annotation (Line(points={{132,-100},{140,-100},{140,
          -122},{148,-122}}, color={255,0,255}));

  connect(con16.y, logSwi10.u1) annotation (Line(points={{132,-200},{140,-200},{
          140,-212},{148,-212}}, color={255,0,255}));

  connect(logSwi10.y, upProCon3.uBoiSet) annotation (Line(points={{172,-220},{190,
          -220},{190,-146},{208,-146}}, color={255,0,255}));

  connect(upProCon3.yPumChaPro, yPumChaPro3.u) annotation (Line(points={{232,-161},
          {240,-161},{240,-170},{248,-170}}, color={255,0,255}));

  connect(yPumChaPro3.y, falEdg9.u)
    annotation (Line(points={{272,-170},{278,-170}}, color={255,0,255}));

  connect(intSwi6.y, upProCon3.uStaSet) annotation (Line(points={{172,-290},{198,
          -290},{198,-158},{208,-158}}, color={255,127,0}));

  connect(conInt12.y, intSwi6.u1) annotation (Line(points={{132,-270},{140,-270},
          {140,-282},{148,-282}}, color={255,127,0}));

  connect(conInt14.y, upProCon3.uStaTyp) annotation (Line(points={{172,-180},{180,
          -180},{180,-154},{208,-154}}, color={255,127,0}));

  connect(or4.y, upProCon3.uStaUpPro) annotation (Line(points={{262,-210},{266,-210},
          {266,-226},{194,-226},{194,-150},{208,-150}}, color={255,0,255}));

  connect(con18.y, upProCon3.THotWatSup) annotation (Line(points={{62,-50},{200,
          -50},{200,-134},{208,-134}}, color={0,0,127}));

  connect(falEdg9.y, pre11.u) annotation (Line(points={{302,-170},{324,-170},{324,
          -190},{328,-190}}, color={255,0,255}));

  connect(pre11.y, upProCon3.uPumChaPro) annotation (Line(points={{352,-190},{364,
          -190},{364,-210},{280,-210},{280,-188},{202,-188},{202,-162},{208,-162}},
        color={255,0,255}));
  connect(upProCon3.yStaChaPro, yStaChaPro3.u) annotation (Line(points={{232,-133},
          {241,-133},{241,-130},{248,-130}}, color={255,0,255}));

  connect(yStaChaPro3.y, falEdg10.u)
    annotation (Line(points={{272,-130},{278,-130}}, color={255,0,255}));

  connect(con15.y, logSwi11.u3) annotation (Line(points={{58,-250},{64,-250},{64,
          -228},{68,-228}}, color={255,0,255}));

  connect(con19.y, logSwi11.u1) annotation (Line(points={{58,-190},{64,-190},{64,
          -212},{68,-212}}, color={255,0,255}));

  connect(booPul3.y, logSwi11.u2) annotation (Line(points={{22,-70},{30,-70},{30,
          -220},{68,-220}}, color={255,0,255}));

  connect(logSwi11.y, logSwi10.u3) annotation (Line(points={{92,-220},{98,-220},
          {98,-228},{148,-228}}, color={255,0,255}));

  connect(conInt13.y, intSwi7.u3) annotation (Line(points={{22,-320},{40,-320},{
          40,-308},{48,-308}}, color={255,127,0}));

  connect(conInt15.y, intSwi7.u1) annotation (Line(points={{22,-280},{40,-280},{
          40,-292},{48,-292}}, color={255,127,0}));

  connect(intSwi7.y, intSwi6.u3) annotation (Line(points={{72,-300},{140,-300},{
          140,-298},{148,-298}}, color={255,127,0}));

  connect(booPul3[1].y, intSwi7.u2) annotation (Line(points={{22,-70},{30,-70},{
          30,-300},{48,-300}}, color={255,0,255}));

  connect(upProCon3.yBoi, pre10.u) annotation (Line(points={{232,-126},{240,-126},
          {240,-80},{100,-80},{100,-100},{108,-100}}, color={255,0,255}));

  connect(falEdg10.y, pre12.u)
    annotation (Line(points={{302,-130},{340,-130}}, color={255,0,255}));

  connect(pre12.y, or4.u2) annotation (Line(points={{364,-130},{370,-130},{370,-230},
          {230,-230},{230,-218},{238,-218}}, color={255,0,255}));

  connect(booPul3[1].y, falEdg11.u) annotation (Line(points={{22,-70},{30,-70},{
          30,-234},{202,-234},{202,-210},{204,-210}}, color={255,0,255}));

  connect(falEdg11.y, or4.u1)
    annotation (Line(points={{228,-210},{238,-210}}, color={255,0,255}));

  connect(cha3.y, lat6.u)
    annotation (Line(points={{62,-130},{78,-130}}, color={255,0,255}));

  connect(pre10.y, cha3.u) annotation (Line(points={{132,-100},{140,-100},{140,-112},
          {34,-112},{34,-130},{38,-130}}, color={255,0,255}));

  connect(booRep3.y, lat7.u)
    annotation (Line(points={{262,-260},{278,-260}}, color={255,0,255}));

  connect(pre12.y, booRep3.u) annotation (Line(points={{364,-130},{370,-130},{370,
          -230},{230,-230},{230,-260},{238,-260}}, color={255,0,255}));

  connect(lat7.y, logSwi10.u2) annotation (Line(points={{302,-260},{310,-260},{310,
          -280},{210,-280},{210,-256},{144,-256},{144,-220},{148,-220}}, color={
          255,0,255}));

  connect(lat7[1].y, intSwi6.u2) annotation (Line(points={{302,-260},{310,-260},
          {310,-280},{210,-280},{210,-256},{144,-256},{144,-290},{148,-290}},
        color={255,0,255}));
  connect(con15[1].y, lat7[1].clr) annotation (Line(points={{58,-250},{220,-250},
          {220,-276},{270,-276},{270,-266},{278,-266}}, color={255,0,255}));

  connect(con15[1].y, lat7[2].clr) annotation (Line(points={{58,-250},{220,-250},
          {220,-276},{270,-276},{270,-266},{278,-266}}, color={255,0,255}));

  connect(uBoi4.y, logSwi12.u3) annotation (Line(points={{522,180},{530,180},{530,
          192},{538,192}}, color={255,0,255}));

  connect(uBoi4[2].y, lat8[1].clr) annotation (Line(points={{522,180},{530,180},
          {530,160},{460,160},{460,194},{468,194}}, color={255,0,255}));

  connect(uBoi4[2].y, lat8[2].clr) annotation (Line(points={{522,180},{530,180},
          {530,160},{460,160},{460,194},{468,194}}, color={255,0,255}));

  connect(lat8.y, logSwi12.u2)
    annotation (Line(points={{492,200},{538,200}}, color={255,0,255}));

  connect(logSwi12.y, upProCon4.uBoi) annotation (Line(points={{562,200},{580,200},
          {580,188},{598,188}}, color={255,0,255}));

  connect(pre13.y, logSwi12.u1) annotation (Line(points={{522,230},{530,230},{530,
          208},{538,208}}, color={255,0,255}));

  connect(con21.y, logSwi13.u1) annotation (Line(points={{522,130},{530,130},{530,
          118},{538,118}}, color={255,0,255}));

  connect(logSwi13.y, upProCon4.uBoiSet) annotation (Line(points={{562,110},{580,
          110},{580,184},{598,184}}, color={255,0,255}));

  connect(upProCon4.yPumChaPro, yPumChaPro4.u) annotation (Line(points={{622,
          169},{630,169},{630,160},{638,160}}, color={255,0,255}));

  connect(yPumChaPro4.y, falEdg12.u)
    annotation (Line(points={{662,160},{668,160}}, color={255,0,255}));

  connect(intSwi8.y, upProCon4.uStaSet) annotation (Line(points={{562,40},{588,40},
          {588,172},{598,172}}, color={255,127,0}));

  connect(conInt16.y, intSwi8.u1) annotation (Line(points={{522,60},{530,60},{530,
          48},{538,48}}, color={255,127,0}));

  connect(conInt18.y, upProCon4.uStaTyp) annotation (Line(points={{562,150},{570,
          150},{570,176},{598,176}}, color={255,127,0}));

  connect(or5.y, upProCon4.uStaUpPro) annotation (Line(points={{652,120},{656,120},
          {656,104},{584,104},{584,180},{598,180}}, color={255,0,255}));

  connect(booPul4.y, swi4.u2) annotation (Line(points={{412,260},{520,260},{520,
          280},{538,280}}, color={255,0,255}));

  connect(con22.y, swi4.u1) annotation (Line(points={{482,290},{530,290},{530,288},
          {538,288}}, color={0,0,127}));

  connect(swi4.y, upProCon4.uHotWatIsoVal) annotation (Line(points={{562,280},{570,
          280},{570,204},{584,204},{584,192},{598,192}}, color={0,0,127}));

  connect(upProCon4.yHotWatIsoVal, zerOrdHol4.u) annotation (Line(points={{622,190},
          {632,190},{632,176},{698,176}}, color={0,0,127}));

  connect(zerOrdHol4.y, swi4.u3) annotation (Line(points={{722,176},{726,176},{726,
          260},{530,260},{530,272},{538,272}}, color={0,0,127}));

  connect(falEdg12.y, pre14.u) annotation (Line(points={{692,160},{714,160},{714,
          140},{718,140}}, color={255,0,255}));

  connect(pre14.y, upProCon4.uPumChaPro) annotation (Line(points={{742,140},{754,
          140},{754,120},{670,120},{670,142},{592,142},{592,168},{598,168}},
        color={255,0,255}));
  connect(upProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{622,
          197},{631,197},{631,200},{638,200}}, color={255,0,255}));

  connect(yStaChaPro4.y, falEdg13.u)
    annotation (Line(points={{662,200},{668,200}}, color={255,0,255}));

  connect(con20.y, logSwi14.u3) annotation (Line(points={{448,80},{454,80},{454,
          102},{458,102}}, color={255,0,255}));

  connect(con24.y, logSwi14.u1) annotation (Line(points={{448,140},{454,140},{454,
          118},{458,118}}, color={255,0,255}));

  connect(booPul4.y, logSwi14.u2) annotation (Line(points={{412,260},{420,260},{
          420,110},{458,110}}, color={255,0,255}));

  connect(logSwi14.y, logSwi13.u3) annotation (Line(points={{482,110},{488,110},
          {488,102},{538,102}}, color={255,0,255}));

  connect(conInt17.y, intSwi9.u3) annotation (Line(points={{412,10},{430,10},{430,
          22},{438,22}}, color={255,127,0}));

  connect(conInt19.y, intSwi9.u1) annotation (Line(points={{412,50},{430,50},{430,
          38},{438,38}}, color={255,127,0}));

  connect(intSwi9.y, intSwi8.u3) annotation (Line(points={{462,30},{530,30},{530,
          32},{538,32}}, color={255,127,0}));

  connect(booPul4[1].y, intSwi9.u2) annotation (Line(points={{412,260},{420,260},
          {420,30},{438,30}}, color={255,0,255}));

  connect(upProCon4.yBoi, pre13.u) annotation (Line(points={{622,204},{630,204},
          {630,250},{490,250},{490,230},{498,230}}, color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{692,200},{730,200}}, color={255,0,255}));

  connect(pre15.y, or5.u2) annotation (Line(points={{754,200},{760,200},{760,100},
          {620,100},{620,112},{628,112}}, color={255,0,255}));

  connect(booPul4[1].y, falEdg14.u) annotation (Line(points={{412,260},{420,260},
          {420,96},{592,96},{592,120},{594,120}}, color={255,0,255}));

  connect(falEdg14.y, or5.u1)
    annotation (Line(points={{618,120},{628,120}}, color={255,0,255}));

  connect(cha4.y, lat8.u)
    annotation (Line(points={{452,200},{468,200}}, color={255,0,255}));

  connect(pre13.y, cha4.u) annotation (Line(points={{522,230},{530,230},{530,218},
          {424,218},{424,200},{428,200}}, color={255,0,255}));

  connect(booRep4.y, lat9.u)
    annotation (Line(points={{652,70},{668,70}}, color={255,0,255}));

  connect(pre15.y, booRep4.u) annotation (Line(points={{754,200},{760,200},{760,
          100},{620,100},{620,70},{628,70}}, color={255,0,255}));

  connect(lat9.y, logSwi13.u2) annotation (Line(points={{692,70},{700,70},{700,50},
          {600,50},{600,74},{534,74},{534,110},{538,110}}, color={255,0,255}));

  connect(lat9[1].y, intSwi8.u2) annotation (Line(points={{692,70},{700,70},{700,
          50},{600,50},{600,74},{534,74},{534,40},{538,40}}, color={255,0,255}));

  connect(con20[1].y, lat9[1].clr) annotation (Line(points={{448,80},{610,80},{610,
          54},{660,54},{660,64},{668,64}}, color={255,0,255}));

  connect(con20[1].y, lat9[2].clr) annotation (Line(points={{448,80},{610,80},{610,
          54},{660,54},{660,64},{668,64}}, color={255,0,255}));

  connect(con23.y, upProCon4.VMinHotWatSet_flow) annotation (Line(points={{602,
          290},{610,290},{610,268},{590,268},{590,200},{598,200}}, color={0,0,
          127}));

  connect(con12.y, swi2.u1) annotation (Line(points={{692,320},{700,320},{700,
          308},{708,308}}, color={0,0,127}));

  connect(con17.y, swi2.u3) annotation (Line(points={{692,280},{700,280},{700,
          292},{708,292}}, color={0,0,127}));

  connect(swi2.y, upProCon4.VHotWat_flow) annotation (Line(points={{732,300},{
          740,300},{740,240},{594,240},{594,204},{598,204}}, color={0,0,127}));

  connect(lat10.y, swi2.u2)
    annotation (Line(points={{652,300},{708,300}}, color={255,0,255}));

  connect(pre15.y, lat10.u) annotation (Line(points={{754,200},{760,200},{760,
          256},{620,256},{620,300},{628,300}}, color={255,0,255}));

  connect(booPul4[1].y, lat10.clr) annotation (Line(points={{412,260},{520,260},
          {520,254},{624,254},{624,294},{628,294}}, color={255,0,255}));

annotation (
 experiment(
      StopTime=900,
      Interval=1,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up</a>.
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
