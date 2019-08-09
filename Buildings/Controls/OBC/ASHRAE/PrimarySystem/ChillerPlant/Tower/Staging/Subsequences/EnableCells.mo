within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences;
block EnableCells "Sequence for identifying enabing and disabling cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Integer nSta = 3
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real towCelOnSet[2*nSta] = {0,2,2,4,4,4}
    "Number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-520,440},{-480,480}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-520,340},{-480,380}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-520,280},{-480,320}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTowCelPri[nTowCel]
    "Cooling tower cell enabling priority"
    annotation (Placement(transformation(extent={{-520,-160},{-480,-120}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Plant stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-520,-380},{-480,-340}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaUp
    "Cooling tower stage-up command"
    annotation (Placement(transformation(extent={{-520,-420},{-480,-380}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Plant stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-520,-460},{-480,-420}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaDow
    "Cooling tower stage-down command"
    annotation (Placement(transformation(extent={{-520,-500},{-480,-460}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower enabling status"
    annotation (Placement(transformation(extent={{480,410},{520,450}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaCel
    "Enabling cell status: true=start to enable cell"
    annotation (Placement(transformation(extent={{480,360},{522,402}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDisCel
    "Disabling cell status: true=start to disable cell"
    annotation (Placement(transformation(extent={{480,130},{520,170}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yEnaCelInd[nTowCel]
    "Enabling cell index array, non-zero elements indicate enabling cells"
    annotation (Placement(transformation(extent={{480,-120},{520,-80}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDisCelInd[nTowCel]
    "Disabling cell index, non-zero elements indicate disabling cells"
    annotation (Placement(transformation(extent={{480,-230},{520,-190}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  final parameter Integer twoCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nTowCel]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-420,290},{-400,310}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nTowCel)
    "Total number of running tower cells"
    annotation (Placement(transformation(extent={{-380,290},{-360,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-440,-370},{-420,-350}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-440,-450},{-420,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt(final k2=-1)
    "Difference between expected and current number of operating cellls"
    annotation (Placement(transformation(extent={{-220,350},{-200,370}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2[nTowCel]
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-420,-150},{-400,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Check integer equality"
    annotation (Placement(transformation(extent={{-140,350},{-120,370}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=1)
    "Integer constant"
    annotation (Placement(transformation(extent={{-220,320},{-200,340}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=1, final k=1) "Add one"
    annotation (Placement(transformation(extent={{-340,-170},{-320,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    final p=2, final k=1) "Add two"
    annotation (Placement(transformation(extent={{-340,-220},{-320,-200}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=nTowCel) "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nTowCel]
    "Check next enable cell"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nTowCel](
    each final k=true) "Logical true"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(
    final nout=nTowCel) "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nTowCel] "Check next enable cell"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar5(
    final p=-1, final k=1) "Minus one"
    annotation (Placement(transformation(extent={{-340,-320},{-320,-300}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep2(
    final nout=nTowCel) "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,-300},{-120,-280}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep3(
    final nout=nTowCel) "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nTowCel] "Check next enable cell"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4[nTowCel] "Check next enable cell"
    annotation (Placement(transformation(extent={{-80,-300},{-60,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    each final k=false) "Logical false"
    annotation (Placement(transformation(extent={{-80,-340},{-60,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3[nTowCel] "Logical or"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and7[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{80,-320},{100,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nTowCel] "Logical or"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and8[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{80,-270},{100,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu5
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2) "Integer constant"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu6
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=-1) "Integer constant"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=-2) "Integer constant"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu7
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-340,-370},{-320,-350}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Output true when input becomes true"
    annotation (Placement(transformation(extent={{-220,390},{-200,410}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg2 "Output true when input becomes false"
    annotation (Placement(transformation(extent={{-220,420},{-200,440}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha1 "Check if number of condenser water pump is changed"
    annotation (Placement(transformation(extent={{-220,470},{-200,490}})));
  Buildings.Controls.OBC.CDL.Logical.And and9 "Logical and"
    annotation (Placement(transformation(extent={{-40,390},{-20,410}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,390},{60,410}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0) "Integer constant"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu8
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1 "Output true when input becomes true"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and10 "Logical and"
    annotation (Placement(transformation(extent={{-40,270},{-20,290}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,270},{60,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and11 "Logical and"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and12 "Logical and"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat5
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and13 "Logical and"
    annotation (Placement(transformation(extent={{40,420},{60,440}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat6
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{100,420},{120,440}})));
  Buildings.Controls.OBC.CDL.Logical.And and14 "Logical and"
    annotation (Placement(transformation(extent={{40,300},{60,320}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat7
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{100,300},{120,320}})));
  Buildings.Controls.OBC.CDL.Logical.And and15 "Logical and"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat8
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and16 "Logical and"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat9
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,420},{160,440}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,390},{160,410}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep5(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,350},{-20,370}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep6(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,300},{160,320}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep7(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,270},{160,290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,240},{-20,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep8(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep9(
    final nout=nTowCel) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep10(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep11(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep12(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-340,-450},{-320,-430}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep13(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep14(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{300,-110},{320,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3[nTowCel](
    each final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{220,-410},{240,-390}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nTowCel]
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-320,-60},{-300,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{300,-170},{320,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[nTowCel] "Add two inputs"
    annotation (Placement(transformation(extent={{340,-150},{360,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{400,-110},{420,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{400,-158},{420,-138}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{300,-340},{320,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{300,-220},{320,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1[nTowCel] "Add two inputs"
    annotation (Placement(transformation(extent={{340,-260},{360,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{400,-268},{420,-248}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi8[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{400,-220},{420,-200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor towCelOn(
    final nin=2*nSta) "Number of tower cells shoud be on in current stage"
    annotation (Placement(transformation(extent={{-320,450},{-300,470}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1,
    final k=2)
    "Double current stage number"
    annotation (Placement(transformation(extent={{-420,410},{-400,430}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-280,450},{-260,470}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[2*nSta](
    final k=towCelOnSet) "Number of tower cells shoud be on"
    annotation (Placement(transformation(extent={{-360,450},{-340,470}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger pumSpeSta
    "Convert real number to integer"
    annotation (Placement(transformation(extent={{-340,350},{-320,370}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-420,450},{-400,470}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1,
    final k=1)
    "Current stage plus WSE on status"
    annotation (Placement(transformation(extent={{-380,410},{-360,430}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Check if it should consider WSE"
    annotation (Placement(transformation(extent={{-380,350},{-360,370}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-340,290},{-320,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nTowCel](
    final k=twoCelInd)
    "Tower cell array index"
    annotation (Placement(transformation(extent={{-420,-110},{-400,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexTowCel(final nin=nTowCel)
    "Tower cell to be enabled"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexTowCel1(final nin=nTowCel)
    "Tower cell to be enabled"
    annotation (Placement(transformation(extent={{-240,-200},{-220,-180}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,-220},{-280,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt6
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,-270},{-280,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt7
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,-320},{-280,-300}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexTowCel2(final nin=nTowCel)
    "Tower cell to be enabled"
    annotation (Placement(transformation(extent={{-240,-300},{-220,-280}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexTowCel3(final nin=nTowCel)
    "Tower cell to be enabled"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt8
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt9
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-180,-300},{-160,-280}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{0,-300},{20,-280}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{280,440},{300,460}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi5[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{340,420},{360,440}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi6[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{280,390},{300,410}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi7[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{400,420},{420,440}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi8[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{280,270},{300,290}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi9[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{280,320},{300,340}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi10[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{340,300},{360,320}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi11[nTowCel]
    "Check next enabling cell"
    annotation (Placement(transformation(extent={{400,320},{420,340}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi12[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{280,160},{300,180}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi13[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{280,210},{300,230}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi14[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi15[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{400,210},{420,230}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi16[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{280,50},{300,70}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi17[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{280,100},{300,120}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi18[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{340,80},{360,100}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi19[nTowCel]
    "Check next disabling cell"
    annotation (Placement(transformation(extent={{400,80},{420,100}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi20
    "Check if it is time to enable cell"
    annotation (Placement(transformation(extent={{400,370},{420,390}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi21
    "Check if it is time to enable cell"
    annotation (Placement(transformation(extent={{400,250},{420,270}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if it is time to enable cell"
    annotation (Placement(transformation(extent={{452,370},{472,390}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi22
    "Check if it is time to disable cell"
    annotation (Placement(transformation(extent={{400,140},{420,160}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi23
    "Check if it is time to disable cell"
    annotation (Placement(transformation(extent={{400,30},{420,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if it is time to disable cell"
    annotation (Placement(transformation(extent={{452,140},{472,160}})));

equation
  connect(con2.y, towCelOn.u)
    annotation (Line(points={{-338,460},{-322,460}}, color={0,0,127}));
  connect(uWSE,swi. u2)
    annotation (Line(points={{-500,360},{-382,360}},color={255,0,255}));
  connect(addPar.y,swi. u1)
    annotation (Line(points={{-358,420},{-340,420},{-340,390},{-400,390},{-400,
          368},{-382,368}},
                   color={0,0,127}));
  connect(swi.y,pumSpeSta. u)
    annotation (Line(points={{-358,360},{-342,360}}, color={0,0,127}));
  connect(uChiSta,intToRea. u)
    annotation (Line(points={{-500,460},{-422,460}}, color={255,127,0}));
  connect(intToRea.y,addPar1. u)
    annotation (Line(points={{-398,460},{-380,460},{-380,440},{-440,440},{-440,
          420},{-422,420}},
                   color={0,0,127}));
  connect(addPar1.y,addPar. u)
    annotation (Line(points={{-398,420},{-382,420}}, color={0,0,127}));
  connect(addPar1.y,swi. u3)
    annotation (Line(points={{-398,420},{-390,420},{-390,352},{-382,352}},
      color={0,0,127}));
  connect(towCelOn.y, reaToInt.u)
    annotation (Line(points={{-298,460},{-282,460}}, color={0,0,127}));
  connect(pumSpeSta.y, towCelOn.index)
    annotation (Line(points={{-318,360},{-310,360},{-310,448}}, color={255,127,0}));
  connect(uTowSta, booToRea.u)
    annotation (Line(points={{-500,300},{-422,300}}, color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-500,-360},{-442,-360}}, color={255,0,255}));
  connect(uTowStaUp, and2.u2)
    annotation (Line(points={{-500,-400},{-460,-400},{-460,-368},{-442,-368}},
      color={255,0,255}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-500,-440},{-442,-440}}, color={255,0,255}));
  connect(uTowStaDow, and1.u2)
    annotation (Line(points={{-500,-480},{-460,-480},{-460,-448},{-442,-448}},
      color={255,0,255}));
  connect(mulSum.y, reaToInt1.u)
    annotation (Line(points={{-358,300},{-342,300}}, color={0,0,127}));
  connect(reaToInt.y, addInt.u1)
    annotation (Line(points={{-258,460},{-240,460},{-240,366},{-222,366}},
      color={255,127,0}));
  connect(reaToInt1.y, addInt.u2)
    annotation (Line(points={{-318,300},{-240,300},{-240,354},{-222,354}},
      color={255,127,0}));
  connect(uTowCelPri, intToRea2.u)
    annotation (Line(points={{-500,-140},{-422,-140}}, color={255,127,0}));
  connect(conInt1.y, intEqu.u2)
    annotation (Line(points={{-198,330},{-160,330},{-160,352},{-142,352}},
      color={255,127,0}));
  connect(addInt.y, intEqu.u1)
    annotation (Line(points={{-198,360},{-142,360}}, color={255,127,0}));
  connect(mulSum.y, addPar2.u)
    annotation (Line(points={{-358,300},{-350,300},{-350,-160},{-342,-160}},
      color={0,0,127}));
  connect(addPar2.y, reaToInt2.u)
    annotation (Line(points={{-318,-160},{-302,-160}}, color={0,0,127}));
  connect(intToRea2.y, nexTowCel.u)
    annotation (Line(points={{-398,-140},{-242,-140}}, color={0,0,127}));
  connect(reaToInt2.y, nexTowCel.index)
    annotation (Line(points={{-278,-160},{-230,-160},{-230,-152}},
      color={255,127,0}));
  connect(nexTowCel.y, reaToInt3.u)
    annotation (Line(points={{-218,-140},{-182,-140}}, color={0,0,127}));
  connect(reaToInt3.y, intRep.u)
    annotation (Line(points={{-158,-140},{-142,-140}}, color={255,127,0}));
  connect(conInt.y, intEqu1.u2)
    annotation (Line(points={{-398,-100},{-100,-100},{-100,-148},{-82,-148}},
      color={255,127,0}));
  connect(intRep.y, intEqu1.u1)
    annotation (Line(points={{-118,-140},{-82,-140}},color={255,127,0}));
  connect(intEqu1.y, logSwi.u2)
    annotation (Line(points={{-58,-140},{-2,-140}}, color={255,0,255}));
  connect(con.y, logSwi.u1)
    annotation (Line(points={{-58,-100},{-20,-100},{-20,-132},{-2,-132}},
      color={255,0,255}));
  connect(uTowSta, logSwi.u3)
    annotation (Line(points={{-500,300},{-440,300},{-440,-80},{-40,-80},{-40,-148},
      {-2,-148}}, color={255,0,255}));
  connect(mulSum.y, addPar3.u)
    annotation (Line(points={{-358,300},{-350,300},{-350,-210},{-342,-210}},
      color={0,0,127}));
  connect(addPar3.y, reaToInt5.u)
    annotation (Line(points={{-318,-210},{-302,-210}}, color={0,0,127}));
  connect(reaToInt5.y, nexTowCel1.index)
    annotation (Line(points={{-278,-210},{-230,-210},{-230,-202}},
      color={255,127,0}));
  connect(intToRea2.y, nexTowCel1.u)
    annotation (Line(points={{-398,-140},{-380,-140},{-380,-190},{-242,-190}},
      color={0,0,127}));
  connect(nexTowCel1.y, reaToInt4.u)
    annotation (Line(points={{-218,-190},{-182,-190}}, color={0,0,127}));
  connect(reaToInt4.y, intRep1.u)
    annotation (Line(points={{-158,-190},{-142,-190}}, color={255,127,0}));
  connect(intRep1.y, intEqu2.u1)
    annotation (Line(points={{-118,-190},{-82,-190}},color={255,127,0}));
  connect(conInt.y, intEqu2.u2)
    annotation (Line(points={{-398,-100},{-100,-100},{-100,-198},{-82,-198}},
      color={255,127,0}));
  connect(intEqu2.y, logSwi1.u2)
    annotation (Line(points={{-58,-190},{-2,-190}}, color={255,0,255}));
  connect(con.y, logSwi1.u1)
    annotation (Line(points={{-58,-100},{-20,-100},{-20,-182},{-2,-182}},
      color={255,0,255}));
  connect(uTowSta, logSwi1.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-198},{-2,-198}}, color={255,0,255}));
  connect(mulSum.y, reaToInt6.u) annotation (Line(points={{-358,300},{-350,300},
          {-350,-260},{-302,-260}}, color={0,0,127}));
  connect(reaToInt6.y, nexTowCel3.index) annotation (Line(points={{-278,-260},{
          -230,-260},{-230,-252}},
                              color={255,127,0}));
  connect(nexTowCel3.y, reaToInt8.u)
    annotation (Line(points={{-218,-240},{-182,-240}}, color={0,0,127}));
  connect(reaToInt8.y, intRep3.u)
    annotation (Line(points={{-158,-240},{-142,-240}}, color={255,127,0}));
  connect(intRep3.y, intEqu3.u1)
    annotation (Line(points={{-118,-240},{-82,-240}},color={255,127,0}));
  connect(conInt.y, intEqu3.u2) annotation (Line(points={{-398,-100},{-100,-100},
          {-100,-248},{-82,-248}},color={255,127,0}));
  connect(intEqu3.y, logSwi3.u2)
    annotation (Line(points={{-58,-240},{-2,-240}}, color={255,0,255}));
  connect(intToRea2.y, nexTowCel3.u) annotation (Line(points={{-398,-140},{-380,
          -140},{-380,-240},{-242,-240}}, color={0,0,127}));
  connect(mulSum.y, addPar5.u) annotation (Line(points={{-358,300},{-350,300},{
          -350,-310},{-342,-310}},
                              color={0,0,127}));
  connect(addPar5.y, reaToInt7.u)
    annotation (Line(points={{-318,-310},{-302,-310}}, color={0,0,127}));
  connect(reaToInt7.y, nexTowCel2.index) annotation (Line(points={{-278,-310},{
          -230,-310},{-230,-302}},
                              color={255,127,0}));
  connect(intToRea2.y, nexTowCel2.u) annotation (Line(points={{-398,-140},{-380,
          -140},{-380,-290},{-242,-290}}, color={0,0,127}));
  connect(nexTowCel2.y, reaToInt9.u)
    annotation (Line(points={{-218,-290},{-182,-290}}, color={0,0,127}));
  connect(reaToInt9.y, intRep2.u)
    annotation (Line(points={{-158,-290},{-142,-290}}, color={255,127,0}));
  connect(intRep2.y, intEqu4.u1)
    annotation (Line(points={{-118,-290},{-82,-290}},color={255,127,0}));
  connect(conInt.y, intEqu4.u2) annotation (Line(points={{-398,-100},{-100,-100},
          {-100,-298},{-82,-298}},color={255,127,0}));
  connect(intEqu4.y, logSwi2.u2)
    annotation (Line(points={{-58,-290},{-2,-290}}, color={255,0,255}));
  connect(uTowSta, logSwi3.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-248},{-2,-248}}, color={255,0,255}));
  connect(uTowSta, logSwi2.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-298},{-2,-298}}, color={255,0,255}));
  connect(con1.y, logSwi3.u1) annotation (Line(points={{-58,-330},{-20,-330},{
          -20,-232},{-2,-232}},
                            color={255,0,255}));
  connect(con1.y, logSwi2.u1) annotation (Line(points={{-58,-330},{-20,-330},{
          -20,-282},{-2,-282}},
                            color={255,0,255}));
  connect(uTowSta, or3.u1) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-112},{78,-112}}, color={255,0,255}));
  connect(logSwi.y, or3.u2) annotation (Line(points={{22,-140},{40,-140},{40,
          -120},{78,-120}},
                      color={255,0,255}));
  connect(logSwi1.y, or3.u3) annotation (Line(points={{22,-190},{60,-190},{60,
          -128},{78,-128}},
                      color={255,0,255}));
  connect(uTowSta, or2.u1) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{78,-80}}, color={255,0,255}));
  connect(logSwi.y, or2.u2) annotation (Line(points={{22,-140},{40,-140},{40,
          -88},{78,-88}},
                     color={255,0,255}));
  connect(uTowSta, and7.u2) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-310},{78,-310}}, color={255,0,255}));
  connect(logSwi3.y, and7.u1) annotation (Line(points={{22,-240},{60,-240},{60,
          -302},{78,-302}},
                      color={255,0,255}));
  connect(logSwi2.y, and7.u3) annotation (Line(points={{22,-290},{40,-290},{40,
          -318},{78,-318}},
                      color={255,0,255}));
  connect(uTowSta, and8.u2) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-268},{78,-268}}, color={255,0,255}));
  connect(logSwi3.y, and8.u1) annotation (Line(points={{22,-240},{60,-240},{60,
          -260},{78,-260}},
                      color={255,0,255}));
  connect(addInt.y, intEqu5.u1) annotation (Line(points={{-198,360},{-180,360},
          {-180,250},{-142,250}},color={255,127,0}));
  connect(conInt2.y, intEqu5.u2) annotation (Line(points={{-198,230},{-160,230},
          {-160,242},{-142,242}}, color={255,127,0}));
  connect(addInt.y, intEqu6.u1) annotation (Line(points={{-198,360},{-180,360},
          {-180,140},{-142,140}},color={255,127,0}));
  connect(conInt3.y, intEqu6.u2) annotation (Line(points={{-198,120},{-160,120},
          {-160,132},{-142,132}}, color={255,127,0}));
  connect(addInt.y, intEqu7.u1) annotation (Line(points={{-198,360},{-180,360},
          {-180,30},{-142,30}},color={255,127,0}));
  connect(conInt4.y, intEqu7.u2) annotation (Line(points={{-198,10},{-160,10},{
          -160,22},{-142,22}},
                          color={255,127,0}));
  connect(uWSE, edg.u) annotation (Line(points={{-500,360},{-440,360},{-440,340},
          {-280,340},{-280,400},{-222,400}}, color={255,0,255}));
  connect(uWSE, falEdg2.u) annotation (Line(points={{-500,360},{-440,360},{-440,
          340},{-280,340},{-280,430},{-222,430}}, color={255,0,255}));
  connect(uChiSta, cha1.u) annotation (Line(points={{-500,460},{-440,460},{-440,
          480},{-222,480}}, color={255,127,0}));
  connect(edg.y, and9.u1)
    annotation (Line(points={{-198,400},{-42,400}}, color={255,0,255}));
  connect(intEqu.y, and9.u2) annotation (Line(points={{-118,360},{-100,360},{
          -100,392},{-42,392}},
                           color={255,0,255}));
  connect(and9.y, lat2.u)
    annotation (Line(points={{-18,400},{38,400}}, color={255,0,255}));
  connect(addInt.y, intEqu8.u1) annotation (Line(points={{-198,360},{-180,360},
          {-180,-20},{-142,-20}},color={255,127,0}));
  connect(conInt5.y, intEqu8.u2) annotation (Line(points={{-198,-30},{-180,-30},
          {-180,-28},{-142,-28}}, color={255,127,0}));
  connect(intEqu8.y, edg1.u)
    annotation (Line(points={{-118,-20},{-62,-20}},color={255,0,255}));
  connect(edg1.y, lat2.u0) annotation (Line(points={{-39,-20},{20,-20},{20,394},
          {39,394}}, color={255,0,255}));
  connect(intEqu5.y, and10.u2) annotation (Line(points={{-118,250},{-100,250},{
          -100,272},{-42,272}},
                           color={255,0,255}));
  connect(edg.y, and10.u1) annotation (Line(points={{-198,400},{-80,400},{-80,
          280},{-42,280}},
                      color={255,0,255}));
  connect(and10.y, lat3.u)
    annotation (Line(points={{-18,280},{38,280}}, color={255,0,255}));
  connect(edg1.y, lat3.u0) annotation (Line(points={{-39,-20},{20,-20},{20,274},
          {39,274}}, color={255,0,255}));
  connect(falEdg2.y, and12.u1) annotation (Line(points={{-198,430},{-60,430},{
          -60,170},{-42,170}},
                           color={255,0,255}));
  connect(falEdg2.y, and11.u1) annotation (Line(points={{-198,430},{-60,430},{
          -60,60},{-42,60}},
                         color={255,0,255}));
  connect(intEqu6.y, and12.u2) annotation (Line(points={{-118,140},{-100,140},{
          -100,162},{-42,162}},
                           color={255,0,255}));
  connect(intEqu7.y, and11.u2) annotation (Line(points={{-118,30},{-100,30},{
          -100,52},{-42,52}},
                         color={255,0,255}));
  connect(and12.y, lat4.u)
    annotation (Line(points={{-18,170},{38,170}}, color={255,0,255}));
  connect(and11.y, lat5.u)
    annotation (Line(points={{-18,60},{38,60}}, color={255,0,255}));
  connect(edg1.y, lat4.u0) annotation (Line(points={{-39,-20},{20,-20},{20,164},
          {39,164}}, color={255,0,255}));
  connect(edg1.y, lat5.u0) annotation (Line(points={{-39,-20},{20,-20},{20,54},{
          39,54}}, color={255,0,255}));
  connect(cha1.up, and13.u1) annotation (Line(points={{-198,486},{10,486},{10,
          430},{38,430}},
                     color={255,0,255}));
  connect(intEqu.y, and13.u2) annotation (Line(points={{-118,360},{-100,360},{
          -100,422},{38,422}},
                          color={255,0,255}));
  connect(and13.y, lat6.u)
    annotation (Line(points={{62,430},{98,430}},  color={255,0,255}));
  connect(edg1.y, lat6.u0) annotation (Line(points={{-39,-20},{80,-20},{80,424},
          {99,424}},  color={255,0,255}));
  connect(cha1.up, and14.u1) annotation (Line(points={{-198,486},{10,486},{10,
          310},{38,310}},
                     color={255,0,255}));
  connect(intEqu5.y, and14.u2) annotation (Line(points={{-118,250},{-100,250},{
          -100,302},{38,302}},
                          color={255,0,255}));
  connect(and14.y, lat7.u)
    annotation (Line(points={{62,310},{98,310}},  color={255,0,255}));
  connect(edg1.y, lat7.u0) annotation (Line(points={{-39,-20},{80,-20},{80,304},
          {99,304}},  color={255,0,255}));
  connect(cha1.down, and15.u1) annotation (Line(points={{-198,474},{0,474},{0,
          200},{38,200}}, color={255,0,255}));
  connect(intEqu6.y, and15.u2) annotation (Line(points={{-118,140},{-100,140},{
          -100,192},{38,192}},
                          color={255,0,255}));
  connect(and15.y, lat8.u)
    annotation (Line(points={{62,200},{98,200}},  color={255,0,255}));
  connect(edg1.y, lat8.u0) annotation (Line(points={{-39,-20},{80,-20},{80,194},
          {99,194}},  color={255,0,255}));
  connect(intEqu7.y, and16.u2) annotation (Line(points={{-118,30},{-100,30},{
          -100,82},{38,82}},
                        color={255,0,255}));
  connect(cha1.down, and16.u1) annotation (Line(points={{-198,474},{0,474},{0,
          90},{38,90}},
                    color={255,0,255}));
  connect(and16.y, lat9.u)
    annotation (Line(points={{62,90},{98,90}},  color={255,0,255}));
  connect(edg1.y, lat9.u0) annotation (Line(points={{-39,-20},{80,-20},{80,84},{
          99,84}},   color={255,0,255}));
  connect(and2.y, booRep1.u)
    annotation (Line(points={{-418,-360},{-342,-360}}, color={255,0,255}));
  connect(booRep1.y, logSwi4.u2) annotation (Line(points={{-318,-360},{240,-360},
          {240,450},{278,450}}, color={255,0,255}));
  connect(or2.y, logSwi4.u1) annotation (Line(points={{102,-80},{200,-80},{200,
          458},{278,458}},
                      color={255,0,255}));
  connect(uTowSta, logSwi4.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-60},{180,-60},{180,442},{278,442}}, color={255,0,
          255}));
  connect(lat6.y, booRep3.u)
    annotation (Line(points={{122,430},{138,430}}, color={255,0,255}));
  connect(booRep3.y, logSwi5.u2)
    annotation (Line(points={{162,430},{338,430}}, color={255,0,255}));
  connect(logSwi4.y, logSwi5.u1) annotation (Line(points={{302,450},{320,450},{
          320,438},{338,438}},
                           color={255,0,255}));
  connect(lat2.y, booRep4.u)
    annotation (Line(points={{62,400},{138,400}}, color={255,0,255}));
  connect(booRep4.y, logSwi6.u2)
    annotation (Line(points={{162,400},{278,400}}, color={255,0,255}));
  connect(or2.y, logSwi6.u1) annotation (Line(points={{102,-80},{200,-80},{200,
          408},{278,408}},
                      color={255,0,255}));
  connect(uTowSta, logSwi6.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-60},{180,-60},{180,392},{278,392}}, color={255,0,
          255}));
  connect(logSwi6.y, logSwi5.u3) annotation (Line(points={{302,400},{320,400},{
          320,422},{338,422}},
                           color={255,0,255}));
  connect(logSwi5.y, logSwi7.u1) annotation (Line(points={{362,430},{370,430},{
          370,438},{398,438}},
                           color={255,0,255}));
  connect(intEqu.y, booRep5.u)
    annotation (Line(points={{-118,360},{-42,360}},color={255,0,255}));
  connect(booRep5.y, logSwi7.u2) annotation (Line(points={{-18,360},{380,360},{
          380,430},{398,430}},
                           color={255,0,255}));
  connect(lat7.y, booRep6.u)
    annotation (Line(points={{122,310},{138,310}}, color={255,0,255}));
  connect(lat3.y, booRep7.u)
    annotation (Line(points={{62,280},{138,280}}, color={255,0,255}));
  connect(booRep6.y, logSwi10.u2)
    annotation (Line(points={{162,310},{338,310}}, color={255,0,255}));
  connect(booRep1.y, logSwi9.u2) annotation (Line(points={{-318,-360},{240,-360},
          {240,330},{278,330}}, color={255,0,255}));
  connect(or3.y, logSwi9.u1) annotation (Line(points={{102,-120},{206,-120},{
          206,338},{278,338}},
                           color={255,0,255}));
  connect(uTowSta, logSwi9.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-60},{180,-60},{180,322},{278,322}}, color={255,0,
          255}));
  connect(or3.y, logSwi8.u1) annotation (Line(points={{102,-120},{206,-120},{
          206,288},{278,288}},
                           color={255,0,255}));
  connect(uTowSta, logSwi8.u3) annotation (Line(points={{-500,300},{-440,300},{-440,
          -80},{-40,-80},{-40,-60},{180,-60},{180,272},{278,272}}, color={255,0,
          255}));
  connect(booRep7.y, logSwi8.u2)
    annotation (Line(points={{162,280},{278,280}}, color={255,0,255}));
  connect(logSwi9.y, logSwi10.u1) annotation (Line(points={{302,330},{320,330},
          {320,318},{338,318}},color={255,0,255}));
  connect(logSwi8.y, logSwi10.u3) annotation (Line(points={{302,280},{320,280},
          {320,302},{338,302}},color={255,0,255}));
  connect(intEqu7.y, booRep9.u)
    annotation (Line(points={{-118,30},{-42,30}},color={255,0,255}));
  connect(intEqu6.y, booRep8.u)
    annotation (Line(points={{-118,140},{-42,140}},color={255,0,255}));
  connect(intEqu5.y, booRep2.u)
    annotation (Line(points={{-118,250},{-42,250}},color={255,0,255}));
  connect(logSwi10.y, logSwi11.u1) annotation (Line(points={{362,310},{370,310},
          {370,338},{398,338}}, color={255,0,255}));
  connect(booRep2.y, logSwi11.u2) annotation (Line(points={{-18,250},{380,250},
          {380,330},{398,330}},color={255,0,255}));
  connect(logSwi11.y, logSwi7.u3) annotation (Line(points={{422,330},{440,330},
          {440,400},{388,400},{388,422},{398,422}},color={255,0,255}));
  connect(lat8.y, booRep10.u)
    annotation (Line(points={{122,200},{138,200}}, color={255,0,255}));
  connect(lat4.y, booRep11.u)
    annotation (Line(points={{62,170},{138,170}}, color={255,0,255}));
  connect(booRep10.y, logSwi14.u2)
    annotation (Line(points={{162,200},{338,200}}, color={255,0,255}));
  connect(logSwi13.y, logSwi14.u1) annotation (Line(points={{302,220},{320,220},
          {320,208},{338,208}}, color={255,0,255}));
  connect(logSwi12.y, logSwi14.u3) annotation (Line(points={{302,170},{320,170},
          {320,192},{338,192}}, color={255,0,255}));
  connect(logSwi14.y, logSwi15.u1) annotation (Line(points={{362,200},{370,200},
          {370,228},{398,228}}, color={255,0,255}));
  connect(logSwi15.y, logSwi11.u3) annotation (Line(points={{422,220},{440,220},
          {440,300},{390,300},{390,322},{398,322}}, color={255,0,255}));
  connect(booRep8.y, logSwi15.u2) annotation (Line(points={{-18,140},{380,140},
          {380,220},{398,220}},color={255,0,255}));
  connect(and1.y, booRep12.u)
    annotation (Line(points={{-418,-440},{-342,-440}}, color={255,0,255}));
  connect(booRep12.y, logSwi13.u2) annotation (Line(points={{-318,-440},{260,
          -440},{260,220},{278,220}},
                                color={255,0,255}));
  connect(and8.y, logSwi13.u1) annotation (Line(points={{102,-260},{212,-260},{
          212,228},{278,228}},
                           color={255,0,255}));
  connect(uTowSta, logSwi13.u3) annotation (Line(points={{-500,300},{-440,300},{
          -440,-80},{-40,-80},{-40,-60},{180,-60},{180,212},{278,212}}, color={255,
          0,255}));
  connect(and8.y, logSwi12.u1) annotation (Line(points={{102,-260},{212,-260},{
          212,178},{278,178}},
                           color={255,0,255}));
  connect(booRep11.y, logSwi12.u2)
    annotation (Line(points={{162,170},{278,170}}, color={255,0,255}));
  connect(uTowSta, logSwi12.u3) annotation (Line(points={{-500,300},{-440,300},{
          -440,-80},{-40,-80},{-40,-60},{180,-60},{180,162},{278,162}}, color={255,
          0,255}));
  connect(lat5.y, booRep14.u)
    annotation (Line(points={{62,60},{138,60}}, color={255,0,255}));
  connect(lat9.y, booRep13.u)
    annotation (Line(points={{122,90},{138,90}}, color={255,0,255}));
  connect(booRep14.y, logSwi16.u2)
    annotation (Line(points={{162,60},{278,60}}, color={255,0,255}));
  connect(booRep13.y, logSwi18.u2)
    annotation (Line(points={{162,90},{338,90}}, color={255,0,255}));
  connect(logSwi16.y, logSwi18.u3) annotation (Line(points={{302,60},{320,60},{
          320,82},{338,82}},
                         color={255,0,255}));
  connect(logSwi17.y, logSwi18.u1) annotation (Line(points={{302,110},{320,110},
          {320,98},{338,98}}, color={255,0,255}));
  connect(logSwi18.y, logSwi19.u1) annotation (Line(points={{362,90},{370,90},{
          370,98},{398,98}},
                         color={255,0,255}));
  connect(logSwi19.y, logSwi15.u3) annotation (Line(points={{422,90},{440,90},{
          440,200},{390,200},{390,212},{398,212}},
                                               color={255,0,255}));
  connect(booRep12.y, logSwi17.u2) annotation (Line(points={{-318,-440},{260,
          -440},{260,110},{278,110}},
                                color={255,0,255}));
  connect(and7.y, logSwi17.u1) annotation (Line(points={{102,-310},{220,-310},{
          220,118},{278,118}},
                           color={255,0,255}));
  connect(uTowSta, logSwi17.u3) annotation (Line(points={{-500,300},{-440,300},{
          -440,-80},{-40,-80},{-40,-60},{180,-60},{180,102},{278,102}}, color={255,
          0,255}));
  connect(and7.y, logSwi16.u1) annotation (Line(points={{102,-310},{220,-310},{
          220,68},{278,68}},
                         color={255,0,255}));
  connect(uTowSta, logSwi16.u3) annotation (Line(points={{-500,300},{-440,300},{
          -440,-80},{-40,-80},{-40,-60},{180,-60},{180,52},{278,52}}, color={255,
          0,255}));
  connect(booRep9.y, logSwi19.u2) annotation (Line(points={{-18,30},{380,30},{
          380,90},{398,90}},
                         color={255,0,255}));
  connect(uTowSta, logSwi19.u3) annotation (Line(points={{-500,300},{-440,300},{
          -440,-80},{-40,-80},{-40,-60},{390,-60},{390,82},{398,82}}, color={255,
          0,255}));
  connect(logSwi7.y, yTowSta)
    annotation (Line(points={{422,430},{500,430}}, color={255,0,255}));
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-398,300},{-382,300}}, color={0,0,127}));
  connect(conInt.y, intToRea1.u) annotation (Line(points={{-398,-100},{-360,
          -100},{-360,-50},{-322,-50}},
                                  color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-58,-140},{-10,-140},{
          -10,-100},{298,-100}},
                             color={255,0,255}));
  connect(intToRea1.y, swi1.u1) annotation (Line(points={{-298,-50},{280,-50},{
          280,-92},{298,-92}},
                           color={0,0,127}));
  connect(con3.y, swi1.u3) annotation (Line(points={{242,-400},{270,-400},{270,
          -108},{298,-108}},
                       color={0,0,127}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-58,-190},{-10,-190},{
          -10,-160},{298,-160}},
                             color={255,0,255}));
  connect(intToRea1.y, swi2.u1) annotation (Line(points={{-298,-50},{280,-50},{
          280,-152},{298,-152}},
                             color={0,0,127}));
  connect(con3.y, swi2.u3) annotation (Line(points={{242,-400},{270,-400},{270,
          -168},{298,-168}},
                       color={0,0,127}));
  connect(swi1.y, add2.u1) annotation (Line(points={{322,-100},{330,-100},{330,
          -134},{338,-134}},
                       color={0,0,127}));
  connect(swi2.y, add2.u2) annotation (Line(points={{322,-160},{330,-160},{330,
          -146},{338,-146}},
                       color={0,0,127}));
  connect(booRep5.y, swi3.u2) annotation (Line(points={{-18,360},{-10,360},{-10,
          -40},{360,-40},{360,-100},{398,-100}}, color={255,0,255}));
  connect(swi1.y, swi3.u1) annotation (Line(points={{322,-100},{330,-100},{330,
          -92},{398,-92}},
                      color={0,0,127}));
  connect(booRep2.y, swi4.u2) annotation (Line(points={{-18,250},{10,250},{10,
          -30},{368,-30},{368,-148},{398,-148}},
                                            color={255,0,255}));
  connect(add2.y, swi4.u1)
    annotation (Line(points={{362,-140},{398,-140}}, color={0,0,127}));
  connect(swi4.y, swi3.u3) annotation (Line(points={{422,-148},{440,-148},{440,
          -120},{390,-120},{390,-108},{398,-108}},
                                             color={0,0,127}));
  connect(swi3.y, yEnaCelInd)
    annotation (Line(points={{422,-100},{500,-100}}, color={0,0,127}));
  connect(intEqu3.y, swi6.u2) annotation (Line(points={{-58,-240},{-10,-240},{
          -10,-210},{298,-210}},
                             color={255,0,255}));
  connect(intToRea1.y, swi6.u1) annotation (Line(points={{-298,-50},{280,-50},{
          280,-202},{298,-202}},
                             color={0,0,127}));
  connect(intEqu4.y, swi5.u2) annotation (Line(points={{-58,-290},{-10,-290},{
          -10,-330},{298,-330}},
                             color={255,0,255}));
  connect(intToRea1.y, swi5.u1) annotation (Line(points={{-298,-50},{280,-50},{
          280,-322},{298,-322}},
                             color={0,0,127}));
  connect(con3.y, swi6.u3) annotation (Line(points={{242,-400},{270,-400},{270,
          -218},{298,-218}},
                       color={0,0,127}));
  connect(con3.y, swi5.u3) annotation (Line(points={{242,-400},{270,-400},{270,
          -338},{298,-338}},
                       color={0,0,127}));
  connect(swi6.y, add1.u1) annotation (Line(points={{322,-210},{330,-210},{330,
          -244},{338,-244}},
                       color={0,0,127}));
  connect(swi5.y, add1.u2) annotation (Line(points={{322,-330},{330,-330},{330,
          -256},{338,-256}},
                       color={0,0,127}));
  connect(booRep8.y, swi8.u2) annotation (Line(points={{-18,140},{190,140},{190,
          -20},{374,-20},{374,-210},{398,-210}}, color={255,0,255}));
  connect(swi6.y, swi8.u1) annotation (Line(points={{322,-210},{330,-210},{330,
          -202},{398,-202}},
                       color={0,0,127}));
  connect(swi7.y, swi8.u3) annotation (Line(points={{422,-258},{440,-258},{440,
          -230},{388,-230},{388,-218},{398,-218}},
                                             color={0,0,127}));
  connect(con3.y, swi4.u3) annotation (Line(points={{242,-400},{270,-400},{270,
          -180},{360,-180},{360,-156},{398,-156}},
                                             color={0,0,127}));
  connect(booRep9.y, swi7.u2) annotation (Line(points={{-18,30},{230,30},{230,
          -10},{380,-10},{380,-258},{398,-258}},
                                            color={255,0,255}));
  connect(add1.y, swi7.u1)
    annotation (Line(points={{362,-250},{398,-250}}, color={0,0,127}));
  connect(con3.y, swi7.u3) annotation (Line(points={{242,-400},{380,-400},{380,
          -266},{398,-266}},
                       color={0,0,127}));
  connect(swi8.y, yDisCelInd)
    annotation (Line(points={{422,-210},{500,-210}}, color={0,0,127}));

  connect(lat6.y, logSwi20.u2) annotation (Line(points={{122,430},{130,430},{
          130,380},{398,380}},
                           color={255,0,255}));
  connect(and2.y, logSwi20.u1) annotation (Line(points={{-418,-360},{-380,-360},
          {-380,-380},{234,-380},{234,388},{398,388}}, color={255,0,255}));
  connect(lat2.y, logSwi20.u3) annotation (Line(points={{62,400},{100,400},{100,
          372},{398,372}}, color={255,0,255}));
  connect(lat7.y, logSwi21.u2) annotation (Line(points={{122,310},{130,310},{
          130,260},{398,260}},
                           color={255,0,255}));
  connect(and2.y, logSwi21.u1) annotation (Line(points={{-418,-360},{-380,-360},
          {-380,-380},{234,-380},{234,268},{398,268}}, color={255,0,255}));
  connect(lat3.y, logSwi21.u3) annotation (Line(points={{62,280},{100,280},{100,
          252},{398,252}}, color={255,0,255}));
  connect(logSwi20.y, or1.u1)
    annotation (Line(points={{422,380},{450,380}}, color={255,0,255}));
  connect(logSwi21.y, or1.u2) annotation (Line(points={{422,260},{430,260},{430,
          372},{450,372}}, color={255,0,255}));
  connect(or1.y, yEnaCel)
    annotation (Line(points={{474,380},{482,380},{482,381},{501,381}},
                                                   color={255,0,255}));
  connect(lat8.y, logSwi22.u2) annotation (Line(points={{122,200},{130,200},{
          130,150},{398,150}},
                           color={255,0,255}));
  connect(and1.y, logSwi22.u1) annotation (Line(points={{-418,-440},{-380,-440},
          {-380,-460},{254,-460},{254,158},{398,158}}, color={255,0,255}));
  connect(lat4.y, logSwi22.u3) annotation (Line(points={{62,170},{100,170},{100,
          142},{398,142}}, color={255,0,255}));
  connect(lat9.y, logSwi23.u2) annotation (Line(points={{122,90},{130,90},{130,
          40},{398,40}},
                     color={255,0,255}));
  connect(and1.y, logSwi23.u1) annotation (Line(points={{-418,-440},{-380,-440},
          {-380,-460},{254,-460},{254,48},{398,48}}, color={255,0,255}));
  connect(lat5.y, logSwi23.u3) annotation (Line(points={{62,60},{100,60},{100,
          32},{398,32}},
                     color={255,0,255}));
  connect(logSwi22.y, or4.u1)
    annotation (Line(points={{422,150},{450,150}}, color={255,0,255}));
  connect(logSwi23.y, or4.u2) annotation (Line(points={{422,40},{430,40},{430,
          142},{450,142}},
                      color={255,0,255}));
  connect(or4.y, yDisCel)
    annotation (Line(points={{474,150},{500,150}}, color={255,0,255}));
annotation (
  defaultComponentName="enaTowCel",
  Icon(graphics={
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-480,-520},{480,500}}),
        graphics={
          Rectangle(
          extent={{-456,-204},{176,-336}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{242,256},{378,22}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{242,498},{378,264}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-456,-64},{176,-196}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-42,-160},{172,-202}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next one or two cells according 
to tower cell operation priority list"),
          Text(
          extent={{-76,-204},{170,-250}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable current one or two cells according 
to tower cell operation priority list"),
          Rectangle(
          extent={{-58,458},{178,382}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-58,338},{178,262}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{54,464},{176,444}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next one cell due to plant stage-up"),
          Text(
          extent={{64,396},{176,378}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next one cell due to enable WSE"),
          Text(
          extent={{60,276},{172,258}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next two cells due to enable WSE"),
          Rectangle(
          extent={{-58,228},{178,152}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{64,166},{176,148}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable current cell due to disable WSE"),
          Text(
          extent={{66,232},{176,216}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable current cell due to stage-down"),
          Text(
          extent={{52,344},{174,324}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable next two cells due to plant stage-up"),
          Rectangle(
          extent={{-58,118},{178,42}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,122},{176,106}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable two cells due to stage-down"),
          Text(
          extent={{64,56},{176,38}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable two cells due to disable WSE"),
          Text(
          extent={{130,498},{370,462}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="If enable cell due to stage-up, wait for 
the tower stage-up command from plant 
staging sequence"),
          Text(
          extent={{134,256},{374,220}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="If disable cell due to stage-down, wait for 
the tower stage-down command from plant 
staging sequence"),
          Rectangle(
          extent={{244,-62},{458,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{244,-202},{458,-318}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{238,-278},{452,-320}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Identify cells to be disabled, i.e. {0,2,3,0} 
means cell 2 and 3 will be disabled."),
          Text(
          extent={{240,-52},{454,-94}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Identify cells to be disabled, i.e. {0,2,3,0} 
means cell 2 and 3 will be enabled."),
          Rectangle(
          extent={{-458,496},{-262,342}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-414,500},{-292,480}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Identify total number of operation cells")}),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.9 Condenser water pumps, part 5.2.9.5.
</p>

<p>
The number of operating condenser water pumps <code>yConWatPumNum</code> and 
condenser water pump speed <code>yConWatPumSpeSet</code> shall be set by chiller 
stage per the table below.
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Chiller stage </th> 
<th>Number of pump ON</th>  
<th>Pump speed setpoint</th>
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
<td align=\"left\">N/A, Off</td>
</tr>
<tr>
<td align=\"center\">0+WSE</td>
<td align=\"center\">1</td>
<td align=\"left\">Per TAB to provide design flow through HX</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\">1</td>
<td align=\"left\">Per TAB to provide design flow through chiller</td>
</tr>
<tr>
<td align=\"center\">1+WSE</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chiller and WSE</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chillers</td>
</tr>
<tr>
<td align=\"center\">2+WSE</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chillers and WSE, 
or 100% speed if design flow cannot be achieved.</td>
</tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableCells;
