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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon1(
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon2(
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon3(
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Up upProCon4(
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

protected
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel[nBoi](
    final samplePeriod=fill(1, nBoi),
    final y_start={1,0})
    "Unit delay"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-330,70},{-310,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[nBoi](
    final pre_u_start={true,false})
    "Logical pre block"
    annotation (Placement(transformation(extent={{-300,200},{-280,220}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
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
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final shift=fill(1, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-370,250},{-350,270}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=TMinSupNonConBoi + 1)
    "Measured hot water supply temperature signal"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,210},{-40,230}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-290,100},{-270,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-330,130},{-310,150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-320,20},{-300,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-370,40},{-350,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg2
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{36,70},{56,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[nBoi](
    final pre_u_start={true,false})
    "Logical pre block"
    annotation (Placement(transformation(extent={{70,200},{90,220}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{150,100},{170,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{110,120},{130,140}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg3
    "Falling edge detector"
    annotation (Placement(transformation(extent={{280,150},{300,170}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
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
    annotation (Placement(transformation(extent={{270,110},{290,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final shift=fill(1, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{0,250},{20,270}})));

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

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{36,130},{56,150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg5
    "Falling edge detector"
    annotation (Placement(transformation(extent={{230,110},{250,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{310,60},{330,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{270,60},{290,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{-344,-260},{-324,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[nBoi](
    final pre_u_start={true,false})
    "Logical pre block"
    annotation (Placement(transformation(extent={{-320,-140},{-300,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi7[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{-230,-230},{-210,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{-270,-210},{-250,-190}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg6
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4
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
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final shift=fill(1, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con13(
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

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi8[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{-310,-230},{-290,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con14[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{-344,-200},{-324,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{-330,-310},{-310,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt11(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{-380,-290},{-360,-270}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg8
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-174,-220},{-154,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat5[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{-70,-270},{-50,-250}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-110,-270},{-90,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con15[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{236,-260},{256,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre10[nBoi](
    final pre_u_start={true,false})
    "Logical pre block"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi10[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{350,-230},{370,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con16[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{310,-210},{330,-190}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg9
    "Falling edge detector"
    annotation (Placement(transformation(extent={{480,-180},{500,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi6
    "Switch between stage 2 and stage 3 setpoints"
    annotation (Placement(transformation(extent={{350,-300},{370,-280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt12(
    final k=3)
    "Stage 3 setpoint"
    annotation (Placement(transformation(extent={{310,-280},{330,-260}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt13(
    final k=2)
    "Stage 2 setpoint"
    annotation (Placement(transformation(extent={{200,-330},{220,-310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt14[nSta](
    final k={1,2,2})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{350,-190},{370,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{470,-220},{490,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final shift=fill(1, nBoi))
    "Boolean pulse to start initial stage change"
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

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi11[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{270,-230},{290,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con19[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{236,-200},{256,-180}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi7
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{250,-310},{270,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt15(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{200,-290},{220,-270}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg11
    "Falling edge detector"
    annotation (Placement(transformation(extent={{406,-220},{426,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat7[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{510,-270},{530,-250}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{470,-270},{490,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con20[nBoi](
    final k={false,true})
    "Boiler setpoints for stage 2"
    annotation (Placement(transformation(extent={{426,70},{446,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre13[nBoi](
    final pre_u_start={true,false})
    "Logical pre block"
    annotation (Placement(transformation(extent={{460,200},{480,220}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi13[nBoi]
    "Pass boiler setpoints for stage 3 after one stage change"
    annotation (Placement(transformation(extent={{540,100},{560,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con21[nBoi](
    final k={true,true})
    "Boiler setpoints for stage 3"
    annotation (Placement(transformation(extent={{500,120},{520,140}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi8
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
    final k={1,1,1})
    "Stage typer vector"
    annotation (Placement(transformation(extent={{540,140},{560,160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Detect first triggering pulse and subsequent stage change completion signals"
    annotation (Placement(transformation(extent={{650,110},{670,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4[nBoi](
    final width=fill(0.1/1800, nBoi),
    final period=fill(1800, nBoi),
    final shift=fill(1, nBoi))
    "Boolean pulse to start initial stage change"
    annotation (Placement(transformation(extent={{390,250},{410,270}})));

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

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi14[nBoi]
    "Pass boiler setpoints for stage 1 and switch to setpoints for stage 2"
    annotation (Placement(transformation(extent={{460,100},{480,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con24[nBoi](
    final k={true,false})
    "Initial boiler setpoints for stage 1"
    annotation (Placement(transformation(extent={{426,130},{446,150}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi9
    "Switch between stage 1 and stage 2 setpoints"
    annotation (Placement(transformation(extent={{440,20},{460,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt19(
    final k=1)
    "Stage 1 setpoint"
    annotation (Placement(transformation(extent={{390,40},{410,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg14
    "Falling edge detector"
    annotation (Placement(transformation(extent={{596,110},{616,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat9[nBoi]
    "Hold true signal once first stage change is completed"
    annotation (Placement(transformation(extent={{700,60},{720,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{650,60},{670,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con17(
    final k=1.1*VNom_flow)
    "Calculated minimum flow rate signal"
    annotation (Placement(transformation(extent={{540,260},{560,280}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre14
    "Logical pre block"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1[nBoi](
    final samplePeriod=fill(1, nBoi),
    final y_start={1,0})
    "Unit delay"
    annotation (Placement(transformation(extent={{310,170},{330,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre16
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2[nBoi](
    final samplePeriod=fill(1, nBoi),
    final y_start={1,0})
    "Unit delay"
    annotation (Placement(transformation(extent={{700,170},{720,190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre17
    "Logical pre block"
    annotation (Placement(transformation(extent={{620,60},{640,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre18
    "Logical pre block"
    annotation (Placement(transformation(extent={{-150,-270},{-130,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre19
    "Logical pre block"
    annotation (Placement(transformation(extent={{440,-270},{460,-250}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-90,210},{-70,230}})));

equation
  connect(con2.y, logSwi1.u1) annotation (Line(points={{-238,130},{-230,130},{
          -230,118},{-222,118}},
                            color={255,0,255}));

  connect(logSwi1.y, upProCon.uBoiSet) annotation (Line(points={{-198,110},{-180,
          110},{-180,189},{-162,189}}, color={255,0,255}));

  connect(upProCon.yPumChaPro, yPumChaPro.u) annotation (Line(points={{-138,178},
          {-130,178},{-130,160},{-122,160}}, color={255,0,255}));

  connect(yPumChaPro.y, falEdg.u)
    annotation (Line(points={{-98,160},{-92,160}}, color={255,0,255}));

  connect(intSwi.y, upProCon.uStaSet) annotation (Line(points={{-198,40},{-172,40},
          {-172,180},{-162,180}}, color={255,127,0}));

  connect(conInt.y, intSwi.u1) annotation (Line(points={{-238,60},{-230,60},{
          -230,48},{-222,48}},
                          color={255,127,0}));

  connect(conInt2.y, upProCon.uStaTyp) annotation (Line(points={{-198,150},{-190,
          150},{-190,183},{-162,183}}, color={255,127,0}));

  connect(con3.y, upProCon.THotWatSupSet) annotation (Line(points={{-158,290},{
          -150,290},{-150,270},{-170,270},{-170,201},{-162,201}}, color={0,0,
          127}));

  connect(falEdg.y, pre1.u) annotation (Line(points={{-68,160},{-32,160}},
                           color={255,0,255}));

  connect(pre1.y, upProCon.uPumChaPro) annotation (Line(points={{-8,160},{-6,160},
          {-6,140},{-168,140},{-168,171},{-162,171}},
        color={255,0,255}));

  connect(upProCon.yStaChaPro,yStaChaPro. u) annotation (Line(points={{-138,198},
          {-126,198},{-126,220},{-122,220}}, color={255,0,255}));

  connect(con1.y, logSwi2.u3) annotation (Line(points={{-308,80},{-300,80},{-300,
          102},{-292,102}},      color={255,0,255}));

  connect(con4.y, logSwi2.u1) annotation (Line(points={{-308,140},{-300,140},{-300,
          118},{-292,118}},      color={255,0,255}));

  connect(booPul.y, logSwi2.u2) annotation (Line(points={{-348,260},{-340,260},{
          -340,110},{-292,110}},  color={255,0,255}));

  connect(logSwi2.y, logSwi1.u3) annotation (Line(points={{-268,110},{-260,110},
          {-260,102},{-222,102}}, color={255,0,255}));

  connect(conInt1.y, intSwi1.u3) annotation (Line(points={{-346,10},{-330,10},{-330,
          22},{-322,22}},     color={255,127,0}));

  connect(conInt3.y, intSwi1.u1) annotation (Line(points={{-348,50},{-330,50},{-330,
          38},{-322,38}},      color={255,127,0}));

  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{-298,30},{-230,30},{-230,
          32},{-222,32}},      color={255,127,0}));

  connect(booPul[1].y, intSwi1.u2) annotation (Line(points={{-348,260},{-340,260},
          {-340,30},{-322,30}},      color={255,0,255}));

  connect(upProCon.yBoi, pre3.u) annotation (Line(points={{-138,202},{-130,202},
          {-130,250},{-314,250},{-314,210},{-302,210}}, color={255,0,255}));

  connect(booPul[1].y, falEdg2.u) annotation (Line(points={{-348,260},{-340,260},
          {-340,98},{-168,98},{-168,120},{-142,120}}, color={255,0,255}));

  connect(falEdg2.y, or2.u1)
    annotation (Line(points={{-118,120},{-112,120}}, color={255,0,255}));

  connect(booRep.y, lat1.u)
    annotation (Line(points={{-88,70},{-72,70}},  color={255,0,255}));

  connect(lat1.y, logSwi1.u2) annotation (Line(points={{-48,70},{-40,70},{-40,50},
          {-160,50},{-160,74},{-226,74},{-226,110},{-222,110}},     color={255,
          0,255}));

  connect(lat1[1].y, intSwi.u2) annotation (Line(points={{-48,70},{-40,70},{-40,
          50},{-160,50},{-160,74},{-226,74},{-226,40},{-222,40}}, color={255,0,
          255}));

  connect(con1[1].y, lat1[1].clr) annotation (Line(points={{-308,80},{-150,80},{
          -150,54},{-80,54},{-80,64},{-72,64}},    color={255,0,255}));

  connect(con1[1].y, lat1[2].clr) annotation (Line(points={{-308,80},{-150,80},{
          -150,54},{-80,54},{-80,64},{-72,64}},    color={255,0,255}));

  connect(con6.y,logSwi4. u1) annotation (Line(points={{132,130},{140,130},{140,
          118},{148,118}},  color={255,0,255}));

  connect(logSwi4.y, upProCon1.uBoiSet) annotation (Line(points={{172,110},{190,
          110},{190,189},{208,189}}, color={255,0,255}));

  connect(upProCon1.yPumChaPro, yPumChaPro1.u) annotation (Line(points={{232,178},
          {240,178},{240,160},{248,160}},      color={255,0,255}));

  connect(yPumChaPro1.y, falEdg3.u)
    annotation (Line(points={{272,160},{278,160}}, color={255,0,255}));

  connect(intSwi2.y, upProCon1.uStaSet) annotation (Line(points={{172,40},{198,40},
          {198,180},{208,180}}, color={255,127,0}));

  connect(conInt4.y, intSwi2.u1) annotation (Line(points={{132,60},{140,60},{140,
          48},{148,48}}, color={255,127,0}));

  connect(conInt6.y, upProCon1.uStaTyp) annotation (Line(points={{172,150},{180,
          150},{180,183},{208,183}}, color={255,127,0}));

  connect(or1.y, upProCon1.uStaUpPro) annotation (Line(points={{292,120},{310,120},
          {310,104},{194,104},{194,186},{208,186}}, color={255,0,255}));

  connect(con8.y, upProCon1.THotWatSupSet) annotation (Line(points={{212,290},{
          220,290},{220,270},{200,270},{200,201},{208,201}}, color={0,0,127}));

  connect(falEdg3.y, pre5.u) annotation (Line(points={{302,160},{338,160}},
                      color={255,0,255}));

  connect(pre5.y, upProCon1.uPumChaPro) annotation (Line(points={{362,160},{364,
          160},{364,120},{320,120},{320,140},{202,140},{202,171},{208,171}},
        color={255,0,255}));
  connect(upProCon1.yStaChaPro, yStaChaPro1.u) annotation (Line(points={{232,198},
          {244,198},{244,200},{248,200}},      color={255,0,255}));

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

  connect(upProCon1.yBoi, pre4.u) annotation (Line(points={{232,202},{240,202},{
          240,230},{60,230},{60,210},{68,210}},    color={255,0,255}));

  connect(falEdg4.y,pre6. u)
    annotation (Line(points={{302,200},{306,200},{306,220},{308,220}},
                                                   color={255,0,255}));

  connect(booPul1[1].y, falEdg5.u) annotation (Line(points={{22,260},{30,260},{30,
          96},{202,96},{202,120},{228,120}}, color={255,0,255}));

  connect(falEdg5.y,or1. u1)
    annotation (Line(points={{252,120},{268,120}},   color={255,0,255}));

  connect(booRep1.y, lat3.u)
    annotation (Line(points={{292,70},{308,70}}, color={255,0,255}));

  connect(lat3.y,logSwi4. u2) annotation (Line(points={{332,70},{340,70},{340,50},
          {210,50},{210,74},{144,74},{144,110},{148,110}},          color={255,
          0,255}));
  connect(lat3[1].y, intSwi2.u2) annotation (Line(points={{332,70},{340,70},{340,
          50},{210,50},{210,74},{144,74},{144,40},{148,40}}, color={255,0,255}));

  connect(con5[1].y,lat3 [1].clr) annotation (Line(points={{58,80},{220,80},{220,
          54},{300,54},{300,64},{308,64}},         color={255,0,255}));

  connect(con5[1].y,lat3 [2].clr) annotation (Line(points={{58,80},{220,80},{220,
          54},{300,54},{300,64},{308,64}},         color={255,0,255}));

  connect(con11.y, logSwi7.u1) annotation (Line(points={{-248,-200},{-240,-200},
          {-240,-212},{-232,-212}}, color={255,0,255}));

  connect(logSwi7.y, upProCon2.uBoiSet) annotation (Line(points={{-208,-220},{-190,
          -220},{-190,-151},{-172,-151}}, color={255,0,255}));

  connect(upProCon2.yPumChaPro, yPumChaPro2.u) annotation (Line(points={{-148,-162},
          {-140,-162},{-140,-170},{-132,-170}}, color={255,0,255}));

  connect(yPumChaPro2.y, falEdg6.u)
    annotation (Line(points={{-108,-170},{-102,-170}}, color={255,0,255}));

  connect(intSwi4.y, upProCon2.uStaSet) annotation (Line(points={{-208,-290},{-182,
          -290},{-182,-160},{-172,-160}}, color={255,127,0}));

  connect(conInt8.y, intSwi4.u1) annotation (Line(points={{-248,-270},{-240,-270},
          {-240,-282},{-232,-282}}, color={255,127,0}));

  connect(conInt10.y, upProCon2.uStaTyp) annotation (Line(points={{-208,-180},{-200,
          -180},{-200,-157},{-172,-157}}, color={255,127,0}));

  connect(or3.y, upProCon2.uStaUpPro) annotation (Line(points={{-78,-210},{-70,-210},
          {-70,-226},{-186,-226},{-186,-154},{-172,-154}},        color={255,0,255}));

  connect(con13.y, upProCon2.THotWatSupSet) annotation (Line(points={{-318,-50},
          {-180,-50},{-180,-139},{-172,-139}}, color={0,0,127}));

  connect(falEdg6.y, pre8.u) annotation (Line(points={{-78,-170},{-56,-170},{-56,
          -190},{-52,-190}}, color={255,0,255}));

  connect(pre8.y, upProCon2.uPumChaPro) annotation (Line(points={{-28,-190},{-16,
          -190},{-16,-210},{-60,-210},{-60,-188},{-178,-188},{-178,-169},{-172,-169}},
                  color={255,0,255}));

  connect(upProCon2.yStaChaPro, yStaChaPro2.u) annotation (Line(points={{-148,-142},
          {-136,-142},{-136,-130},{-132,-130}}, color={255,0,255}));

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

  connect(upProCon2.yBoi, pre7.u) annotation (Line(points={{-148,-138},{-140,-138},
          {-140,-110},{-332,-110},{-332,-130},{-322,-130}},
                                                          color={255,0,255}));

  connect(falEdg7.y,pre9. u)
    annotation (Line(points={{-78,-130},{-40,-130}},
                                                   color={255,0,255}));

  connect(booPul2[1].y, falEdg8.u) annotation (Line(points={{-358,-70},{-350,-70},
          {-350,-234},{-178,-234},{-178,-210},{-176,-210}}, color={255,0,255}));

  connect(falEdg8.y,or3. u1)
    annotation (Line(points={{-152,-210},{-102,-210}},
                                                     color={255,0,255}));

  connect(booRep2.y, lat5.u)
    annotation (Line(points={{-88,-260},{-72,-260}},   color={255,0,255}));

  connect(lat5.y,logSwi7. u2) annotation (Line(points={{-48,-260},{-30,-260},{-30,
          -280},{-170,-280},{-170,-256},{-236,-256},{-236,-220},{-232,-220}},
                                                                    color={255,
          0,255}));
  connect(lat5[1].y, intSwi4.u2) annotation (Line(points={{-48,-260},{-30,-260},
          {-30,-280},{-170,-280},{-170,-256},{-236,-256},{-236,-290},{-232,-290}},
        color={255,0,255}));
  connect(con10[1].y, lat5[1].clr) annotation (Line(points={{-322,-250},{-160,-250},
          {-160,-276},{-80,-276},{-80,-266},{-72,-266}},    color={255,0,255}));

  connect(con10[1].y, lat5[2].clr) annotation (Line(points={{-322,-250},{-160,-250},
          {-160,-276},{-80,-276},{-80,-266},{-72,-266}},    color={255,0,255}));

  connect(con16.y, logSwi10.u1) annotation (Line(points={{332,-200},{340,-200},{
          340,-212},{348,-212}}, color={255,0,255}));

  connect(logSwi10.y, upProCon3.uBoiSet) annotation (Line(points={{372,-220},{390,
          -220},{390,-153},{408,-153}}, color={255,0,255}));

  connect(upProCon3.yPumChaPro, yPumChaPro3.u) annotation (Line(points={{432,-164},
          {440,-164},{440,-170},{448,-170}}, color={255,0,255}));

  connect(yPumChaPro3.y, falEdg9.u)
    annotation (Line(points={{472,-170},{478,-170}}, color={255,0,255}));

  connect(intSwi6.y, upProCon3.uStaSet) annotation (Line(points={{372,-290},{398,
          -290},{398,-162},{408,-162}}, color={255,127,0}));

  connect(conInt12.y, intSwi6.u1) annotation (Line(points={{332,-270},{340,-270},
          {340,-282},{348,-282}}, color={255,127,0}));

  connect(conInt14.y, upProCon3.uStaTyp) annotation (Line(points={{372,-180},{380,
          -180},{380,-159},{408,-159}}, color={255,127,0}));

  connect(or4.y, upProCon3.uStaUpPro) annotation (Line(points={{492,-210},{500,-210},
          {500,-226},{394,-226},{394,-156},{408,-156}}, color={255,0,255}));

  connect(con18.y, upProCon3.THotWatSupSet) annotation (Line(points={{262,-50},
          {400,-50},{400,-141},{408,-141}}, color={0,0,127}));

  connect(falEdg9.y, pre11.u) annotation (Line(points={{502,-170},{524,-170},{524,
          -190},{528,-190}}, color={255,0,255}));

  connect(pre11.y, upProCon3.uPumChaPro) annotation (Line(points={{552,-190},{564,
          -190},{564,-210},{510,-210},{510,-188},{402,-188},{402,-171},{408,-171}},
        color={255,0,255}));
  connect(upProCon3.yStaChaPro, yStaChaPro3.u) annotation (Line(points={{432,-144},
          {441,-144},{441,-130},{448,-130}}, color={255,0,255}));

  connect(yStaChaPro3.y, falEdg10.u)
    annotation (Line(points={{472,-130},{478,-130}}, color={255,0,255}));

  connect(con15.y, logSwi11.u3) annotation (Line(points={{258,-250},{264,-250},{
          264,-228},{268,-228}},
                            color={255,0,255}));

  connect(con19.y, logSwi11.u1) annotation (Line(points={{258,-190},{264,-190},{
          264,-212},{268,-212}},
                            color={255,0,255}));

  connect(booPul3.y, logSwi11.u2) annotation (Line(points={{222,-70},{230,-70},{
          230,-220},{268,-220}},
                            color={255,0,255}));

  connect(logSwi11.y, logSwi10.u3) annotation (Line(points={{292,-220},{298,-220},
          {298,-228},{348,-228}},color={255,0,255}));

  connect(conInt13.y, intSwi7.u3) annotation (Line(points={{222,-320},{240,-320},
          {240,-308},{248,-308}},
                               color={255,127,0}));

  connect(conInt15.y, intSwi7.u1) annotation (Line(points={{222,-280},{240,-280},
          {240,-292},{248,-292}},
                               color={255,127,0}));

  connect(intSwi7.y, intSwi6.u3) annotation (Line(points={{272,-300},{340,-300},
          {340,-298},{348,-298}},color={255,127,0}));

  connect(booPul3[1].y, intSwi7.u2) annotation (Line(points={{222,-70},{230,-70},
          {230,-300},{248,-300}},
                               color={255,0,255}));

  connect(upProCon3.yBoi, pre10.u) annotation (Line(points={{432,-140},{440,-140},
          {440,-80},{250,-80},{250,-100},{258,-100}}, color={255,0,255}));

  connect(falEdg10.y, pre12.u)
    annotation (Line(points={{502,-130},{540,-130}}, color={255,0,255}));

  connect(booPul3[1].y, falEdg11.u) annotation (Line(points={{222,-70},{230,-70},
          {230,-234},{402,-234},{402,-210},{404,-210}},
                                                      color={255,0,255}));

  connect(falEdg11.y, or4.u1)
    annotation (Line(points={{428,-210},{468,-210}}, color={255,0,255}));

  connect(booRep3.y, lat7.u)
    annotation (Line(points={{492,-260},{508,-260}}, color={255,0,255}));

  connect(lat7.y, logSwi10.u2) annotation (Line(points={{532,-260},{540,-260},{540,
          -280},{410,-280},{410,-256},{344,-256},{344,-220},{348,-220}}, color={
          255,0,255}));

  connect(lat7[1].y, intSwi6.u2) annotation (Line(points={{532,-260},{540,-260},
          {540,-280},{410,-280},{410,-256},{344,-256},{344,-290},{348,-290}},
        color={255,0,255}));
  connect(con15[1].y, lat7[1].clr) annotation (Line(points={{258,-250},{420,-250},
          {420,-276},{500,-276},{500,-266},{508,-266}}, color={255,0,255}));

  connect(con15[1].y, lat7[2].clr) annotation (Line(points={{258,-250},{420,-250},
          {420,-276},{500,-276},{500,-266},{508,-266}}, color={255,0,255}));

  connect(con21.y, logSwi13.u1) annotation (Line(points={{522,130},{530,130},{530,
          118},{538,118}}, color={255,0,255}));

  connect(logSwi13.y, upProCon4.uBoiSet) annotation (Line(points={{562,110},{580,
          110},{580,187},{598,187}}, color={255,0,255}));

  connect(intSwi8.y, upProCon4.uStaSet) annotation (Line(points={{562,40},{588,40},
          {588,178},{598,178}}, color={255,127,0}));

  connect(conInt16.y, intSwi8.u1) annotation (Line(points={{522,60},{530,60},{530,
          48},{538,48}}, color={255,127,0}));

  connect(conInt18.y, upProCon4.uStaTyp) annotation (Line(points={{562,150},{570,
          150},{570,181},{598,181}}, color={255,127,0}));

  connect(or5.y, upProCon4.uStaUpPro) annotation (Line(points={{672,120},{680,120},
          {680,104},{584,104},{584,184},{598,184}}, color={255,0,255}));

  connect(upProCon4.yStaChaPro, yStaChaPro4.u) annotation (Line(points={{622,196},
          {632,196},{632,200},{638,200}},      color={255,0,255}));

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

  connect(upProCon4.yBoi, pre13.u) annotation (Line(points={{622,200},{630,200},
          {630,230},{450,230},{450,210},{458,210}}, color={255,0,255}));

  connect(falEdg13.y, pre15.u)
    annotation (Line(points={{692,200},{696,200},{696,220},{698,220}},
                                                   color={255,0,255}));

  connect(booPul4[1].y, falEdg14.u) annotation (Line(points={{412,260},{420,260},
          {420,96},{592,96},{592,120},{594,120}}, color={255,0,255}));

  connect(falEdg14.y, or5.u1)
    annotation (Line(points={{618,120},{648,120}}, color={255,0,255}));

  connect(booRep4.y, lat9.u)
    annotation (Line(points={{672,70},{698,70}}, color={255,0,255}));

  connect(lat9.y, logSwi13.u2) annotation (Line(points={{722,70},{740,70},{740,50},
          {600,50},{600,74},{534,74},{534,110},{538,110}}, color={255,0,255}));

  connect(lat9[1].y, intSwi8.u2) annotation (Line(points={{722,70},{740,70},{740,
          50},{600,50},{600,74},{534,74},{534,40},{538,40}}, color={255,0,255}));

  connect(con20[1].y, lat9[1].clr) annotation (Line(points={{448,80},{610,80},{610,
          54},{680,54},{680,64},{698,64}}, color={255,0,255}));

  connect(con20[1].y, lat9[2].clr) annotation (Line(points={{448,80},{610,80},{610,
          54},{680,54},{680,64},{698,64}}, color={255,0,255}));

  connect(con23.y, upProCon4.VMinHotWatSet_flow) annotation (Line(points={{602,290},
          {610,290},{610,268},{590,268},{590,203},{598,203}},      color={0,0,
          127}));

  connect(booPul[1].y, upProCon.uPlaEna) annotation (Line(points={{-348,260},{-234,
          260},{-234,240},{-184,240},{-184,177},{-162,177}},      color={255,0,
          255}));
  connect(booPul1[1].y, upProCon1.uPlaEna) annotation (Line(points={{22,260},{186,
          260},{186,177},{208,177}},                         color={255,0,255}));
  connect(booPul4[1].y, upProCon4.uPlaEna) annotation (Line(points={{412,260},{520,
          260},{520,254},{574,254},{574,175},{598,175}},     color={255,0,255}));
  connect(booPul2[1].y, upProCon2.uPlaEna) annotation (Line(points={{-358,-70},{
          -350,-70},{-350,-174},{-236,-174},{-236,-163},{-172,-163}},  color={
          255,0,255}));
  connect(booPul3[1].y, upProCon3.uPlaEna) annotation (Line(points={{222,-70},{230,
          -70},{230,-165},{408,-165}},                         color={255,0,255}));
  connect(pre3.y, upProCon.uBoi) annotation (Line(points={{-278,210},{-180,210},
          {-180,193},{-162,193}}, color={255,0,255}));
  connect(upProCon.yHotWatIsoVal, uniDel.u) annotation (Line(points={{-138,194},
          {-126,194},{-126,180},{-62,180}}, color={0,0,127}));
  connect(uniDel.y, upProCon.uHotWatIsoVal) annotation (Line(points={{-38,180},{
          -30,180},{-30,240},{-176,240},{-176,197},{-162,197}}, color={0,0,127}));
  connect(pre2.y, upProCon.uStaChaPro) annotation (Line(points={{-38,220},{0,220},
          {0,100},{-184,100},{-184,174},{-162,174}}, color={255,0,255}));
  connect(booRep.u, pre14.y)
    annotation (Line(points={{-112,70},{-118,70}}, color={255,0,255}));
  connect(pre2.y, pre14.u) annotation (Line(points={{-38,220},{0,220},{0,100},{-146,
          100},{-146,70},{-142,70}}, color={255,0,255}));
  connect(pre14.y, or2.u2) annotation (Line(points={{-118,70},{-116,70},{-116,112},
          {-112,112}}, color={255,0,255}));
  connect(pre4.y, upProCon1.uBoi) annotation (Line(points={{92,210},{204,210},{204,
          193},{208,193}}, color={255,0,255}));
  connect(upProCon1.yHotWatIsoVal, uniDel1.u) annotation (Line(points={{232,194},
          {240,194},{240,180},{308,180}}, color={0,0,127}));
  connect(uniDel1.y, upProCon1.uHotWatIsoVal) annotation (Line(points={{332,180},
          {340,180},{340,240},{194,240},{194,197},{208,197}}, color={0,0,127}));
  connect(pre6.y, upProCon1.uStaChaPro) annotation (Line(points={{332,220},{370,
          220},{370,100},{186,100},{186,174},{208,174}}, color={255,0,255}));
  connect(pre16.y, booRep1.u)
    annotation (Line(points={{262,70},{268,70}}, color={255,0,255}));
  connect(pre16.y, or1.u2) annotation (Line(points={{262,70},{264,70},{264,112},
          {268,112}}, color={255,0,255}));
  connect(pre6.y, pre16.u) annotation (Line(points={{332,220},{370,220},{370,100},
          {230,100},{230,70},{238,70}}, color={255,0,255}));
  connect(pre13.y, upProCon4.uBoi) annotation (Line(points={{482,210},{588,210},
          {588,191},{598,191}}, color={255,0,255}));
  connect(upProCon4.yHotWatIsoVal, uniDel2.u) annotation (Line(points={{622,192},
          {632,192},{632,180},{698,180}}, color={0,0,127}));
  connect(uniDel2.y, upProCon4.uHotWatIsoVal) annotation (Line(points={{722,180},
          {730,180},{730,160},{590,160},{590,195},{598,195}}, color={0,0,127}));
  connect(pre15.y, upProCon4.uStaChaPro) annotation (Line(points={{722,220},{760,
          220},{760,100},{574,100},{574,172},{598,172}}, color={255,0,255}));
  connect(booRep4.u, pre17.y)
    annotation (Line(points={{648,70},{642,70}}, color={255,0,255}));
  connect(pre15.y, pre17.u) annotation (Line(points={{722,220},{760,220},{760,100},
          {614,100},{614,70},{618,70}}, color={255,0,255}));
  connect(pre17.y, or5.u2) annotation (Line(points={{642,70},{644,70},{644,112},
          {648,112}}, color={255,0,255}));
  connect(pre7.y, upProCon2.uBoi) annotation (Line(points={{-298,-130},{-186,-130},
          {-186,-147},{-172,-147}}, color={255,0,255}));
  connect(pre9.y, upProCon2.uStaChaPro) annotation (Line(points={{-16,-130},{-10,
          -130},{-10,-230},{-196,-230},{-196,-166},{-172,-166}}, color={255,0,255}));
  connect(pre18.y, booRep2.u)
    annotation (Line(points={{-128,-260},{-112,-260}}, color={255,0,255}));
  connect(pre9.y, pre18.u) annotation (Line(points={{-16,-130},{-10,-130},{-10,-230},
          {-156,-230},{-156,-260},{-152,-260}}, color={255,0,255}));
  connect(pre18.y, or3.u2) annotation (Line(points={{-128,-260},{-120,-260},{-120,
          -218},{-102,-218}}, color={255,0,255}));
  connect(pre10.y, upProCon3.uBoi) annotation (Line(points={{282,-100},{396,-100},
          {396,-149},{408,-149}}, color={255,0,255}));
  connect(pre12.y, upProCon3.uStaChaPro) annotation (Line(points={{564,-130},{570,
          -130},{570,-230},{386,-230},{386,-168},{408,-168}}, color={255,0,255}));
  connect(pre19.y, booRep3.u)
    annotation (Line(points={{462,-260},{468,-260}}, color={255,0,255}));
  connect(pre19.y, or4.u2) annotation (Line(points={{462,-260},{466,-260},{466,-218},
          {468,-218}}, color={255,0,255}));
  connect(pre12.y, pre19.u) annotation (Line(points={{564,-130},{570,-130},{570,
          -230},{430,-230},{430,-260},{438,-260}}, color={255,0,255}));

  connect(falEdg1.y, pre2.u)
    annotation (Line(points={{-68,220},{-62,220}}, color={255,0,255}));
  connect(yStaChaPro.y, falEdg1.u)
    annotation (Line(points={{-98,220},{-92,220}}, color={255,0,255}));
  connect(or2.y, upProCon.uStaUpPro) annotation (Line(points={{-88,120},{-80,120},
          {-80,104},{-176,104},{-176,186},{-162,186}}, color={255,0,255}));
  connect(con17.y, upProCon4.VHotWat_flow) annotation (Line(points={{562,270},{
          580,270},{580,207},{598,207}}, color={0,0,127}));
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
