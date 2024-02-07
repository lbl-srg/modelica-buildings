within Buildings.Controls.OBC.RooftopUnits;
block Controller
  "Controller for rooftop unit heat pump systems"

  parameter Integer nCoiHea(min=1)
    "Number of DX heating coils";

  parameter Integer nCoiCoo(min=1)
    "Number of DX cooling coils";

  parameter Real uThrCoiUp(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoiDow(
    final min=0,
    final max=1)=0.2
    "Threshold of coil valve position signal below which DX coil staged down"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoiEna(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is enabled"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoiDis(
    final min=0,
    final max=1)=0.1
    "Threshold of coil valve position signal below which DX coil is disabled"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPerUp(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPerDow(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPerEna(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPerDis(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Real timPerOut(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling defrost"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Real minComHeaSpe(
    final min=0,
    final max=maxComHeaSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Real maxComHeaSpe(
    final min=minComHeaSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Modelica.Blocks.Types.SimpleController controllerTypeHeaSpe=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Real kHeaSpe=0.1
    "Gain of controller"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Modelica.Units.SI.Time TiHeaSpe=1000
    "Time constant of Integrator block"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Modelica.Units.SI.Time TdHeaSpe=0.1
    "Time constant of Derivative block"
    annotation (Dialog(tab="Compressor speed", group="Heating mode"));

  parameter Real minComCooSpe(
    final min=0,
    final max=maxComCooSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Real maxComCooSpe(
    final min=minComCooSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Modelica.Blocks.Types.SimpleController controllerTypeCooSpe=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of heating coil speed controller"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Real kCooSpe=0.1
    "Gain of controller"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Modelica.Units.SI.Time TiCooSpe=1000
    "Time constant of Integrator block"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Modelica.Units.SI.Time TdCooSpe=0.1
    "Time constant of Derivative block"
    annotation (Dialog(tab="Compressor speed", group="Cooling mode"));

  parameter Real kDR1=0.9
    "Constant compressor speed gain at demand-limit Level 1"
    annotation (Dialog(tab="Compressor speed", group="DR parameters"));

  parameter Real kDR2=0.85
    "Constant compressor speed gain at demand-limit Level 2"
    annotation (Dialog(tab="Compressor speed", group="DR parameters"));

  parameter Real kDR3=0.8
    "Constant compressor speed gain at demand-limit Level 3"
    annotation (Dialog(tab="Compressor speed", group="DR parameters"));

  parameter Real kLocOut=1
    "Gain of auxiliary heating controller 1"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real kOpe=10
    "Gain of auxiliary heating controller 2"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real TLocOut=273.15 - 12.2
    "Minimum outdoor dry-bulb lockout temperature"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real uThrHeaCoi(
    final min=0,
    final max=1)=0.9
    "Threshold of heating coil valve position signal above which auxiliary coil is enabled"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Boolean have_TFroSen=false
    "True: RTU has frost sensor"
    annotation (tab="Defrost parameters");

  parameter Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods defTri=
     Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=0
    "Maximum temperature at which defrost operation is activated"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Real tDefRun(
    final min=0,
    final max=1)=0.5
    "If defrost operation is timed, timestep fraction for which defrost cycle is run"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 5
    "Predefined outdoor lockout temperature"
    annotation (Dialog(tab="Defrost parameters"));

  parameter Real dUHys=0.01
    "Small coil valve position signal difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dTHys1(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced", group="Defrost parameter"));

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa")=101325
    "Atmospheric pressure";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCooCoi[nCoiCoo]
    "DX cooling coil status"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXHeaCoi[nCoiHea]
    "DX heating coil status"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCooCoiAva[nCoiCoo]
    "DX cooling coil availability"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoiAva[nCoiHea]
    "DX heating coil availability"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooCoiSeq[nCoiCoo]
    "DX cooling coil available sequence order"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaCoiSeq[nCoiHea]
    "DX heating coil available sequence order"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coolign coil valve position"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-140,-200},{-100,-160}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoiSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-330},{-100,-290}}),
      iconTransformation(extent={{-140,-270},{-100,-230}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoiHea[nCoiHea](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating coil supply air temperature"
    annotation (Placement(transformation(extent={{-140,-280},{-100,-240}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoiCoo[nCoiCoo](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling coil supply air temperature"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}}),
      iconTransformation(extent={{-140,-240},{-100,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCooCoi[nCoiCoo]
    "DX cooling coil signal"
    annotation (Placement(transformation(extent={{100,140},{140,180}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXHeaCoi[nCoiHea]
    "DX heating coil signal"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,42},{140,82}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeCoo[nCoiCoo](
    final min=fill(0,nCoiCoo),
    final max=fill(1,nCoiCoo),
    final unit=fill("1",nCoiCoo))
    "Compressor commanded speed for DX cooling coils"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeHea[nCoiHea](
    final min=fill(0,nCoiHea),
    final max=fill(1,nCoiHea),
    final unit=fill("1",nCoiHea))
    "Compressor commanded speed for DX heating coils"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-78},{140,-38}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-158},{140,-118}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefFra[nCoiHea](
    final unit=fill("1",nCoiHea))
    "Defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{100,-180},{140,-140}}),
      iconTransformation(extent={{100,-240},{140,-200}})));

protected
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiConCoo(
    final nCoi=nCoiCoo,
    final uThrCoiUp=uThrCoiUp,
    final uThrCoiDow=uThrCoiDow,
    final uThrCoiEna=uThrCoiEna,
    final uThrCoiDis=uThrCoiDis,
    final timPerUp=timPerUp,
    final timPerDow=timPerDow,
    final timPerEna=timPerEna,
    final timPerDis=timPerDis,
    final dUHys=dUHys)
    "DX cooling coil controller"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRCoo[nCoiCoo](
    final kDR1=fill(kDR1,nCoiCoo),
    final kDR2=fill(kDR2,nCoiCoo),
    final kDR3=fill(kDR3,nCoiCoo))
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRHea[nCoiHea](
    final kDR1=fill(kDR1,nCoiHea),
    final kDR2=fill(kDR2,nCoiHea),
    final kDR3=fill(kDR3,nCoiHea))
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi(
    final nCoi=nCoiHea,
    final TLocOut=TLocOut,
    final dTHys=dTHys,
    final kLocOut=kLocOut,
    final kOpe=kOpe,
    final uThrHeaCoi=uThrHeaCoi,
    final dUHys=dUHys)
    "Auxiliary coil controller"
    annotation (Placement(transformation(extent={{-30,-64},{-10,-44}})));

  Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations defTimFra(
    final defTri=defTri,
    final tDefRun=tDefRun,
    final TDefLim=TDefLim,
    final dTHys=dTHys1)
    "Defrost time calculation"
    annotation (Placement(transformation(extent={{-70,-148},{-50,-128}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRepCoo(
    final nout=nCoiCoo)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=TOutLoc,
    final h=dTHys1)
    "Check if outdoor air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPerOut)
    "Count time when outdoor air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{0,-118},{20,-98}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Calculate defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{-32,-176},{-12,-156}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nCoiHea](
    final realTrue=fill(1,nCoiHea),
    final realFalse=fill(0,nCoiHea))
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-30,4},{-10,24}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul[nCoiHea]
    "Calculate compressor speed for DX heating"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul2[nCoiHea]
    "Calculate defrost operation timestep fractions for DX coils"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCoiHea)
    "Real scalar replicator"
    annotation (Placement(transformation(extent={{0,-176},{20,-156}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiConHea(
    final nCoi=nCoiHea,
    final uThrCoiUp=uThrCoiUp,
    final uThrCoiDow=uThrCoiDow,
    final uThrCoiEna=uThrCoiEna,
    final uThrCoiDis=uThrCoiDis,
    final timPerUp=timPerUp,
    final timPerDow=timPerDow,
    final timPerEna=timPerEna,
    final timPerDis=timPerDis,
    final dUHys=dUHys)
    "DX heating coil controller"
    annotation (Placement(transformation(extent={{-30,130},{-10,150}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRepHea(
    final nout=nCoiHea)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupCooSet(
    final nout=nCoiCoo)
    "Replicate AHU cooling supply temperature setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-62,-280})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupHeaSet(
    final nout=nCoiHea)
    "Replicate AHU heating supply temperature setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-62,-320})));

  Buildings.Controls.Continuous.LimPID conPCoo[nCoiCoo](
    final controllerType=fill(controllerTypeCooSpe, nCoiCoo),
    final k=fill(kCooSpe, nCoiCoo),
    final Ti=fill(TiCooSpe, nCoiCoo),
    final Td=fill(TdCooSpe, nCoiCoo),
    final yMax=fill(maxComCooSpe, nCoiCoo),
    final yMin=fill(minComCooSpe, nCoiCoo),
    final reverseActing=fill(false,nCoiCoo))
    "Regulate cooling supply air temperature"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));

  Buildings.Controls.Continuous.LimPID conPHea[nCoiHea](
    final controllerType=fill(controllerTypeHeaSpe, nCoiHea),
    final k=fill(kHeaSpe, nCoiHea),
    final Ti=fill(TiHeaSpe, nCoiHea),
    final Td=fill(TdHeaSpe, nCoiHea),
    final yMax=fill(maxComHeaSpe, nCoiHea),
    final yMin=fill(minComHeaSpe, nCoiHea),
    final reverseActing=fill(true,nCoiHea))
    "Regulate heating supply air temperature"
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));

equation
  connect(uDemLimLev, intScaRepCoo.u) annotation (Line(points={{-120,0},{-46,0},
          {-46,80},{-32,80}}, color={255,127,0}));
  connect(intScaRepCoo.y, ComSpeDRCoo.uDemLimLev) annotation (Line(points={{-8,80},
          {58,80}},                 color={255,127,0}));
  connect(conAuxCoi.TOut, TOut)
    annotation (Line(points={{-32,-54},{-80,-54},{-80,-100},{-120,-100}}, color={0,0,127}));
  connect(conAuxCoi.uHeaCoi, uHeaCoi)
    annotation (Line(points={{-32,-60},{-120,-60}}, color={0,0,127}));
  if not have_TFroSen then
  connect(defTimFra.TOut, TOut)
    annotation (Line(points={{-71,-136},{-80,-136},{-80,-100},{-120,-100}}, color={0,0,127}));
  end if;
  connect(ComSpeDRCoo.yComSpe, yComSpeCoo)
    annotation (Line(points={{82,74},{90,74},{90,40},{120,40}}, color={0,0,127}));
  connect(conAuxCoi.yAuxHea, yAuxHea)
    annotation (Line(points={{-8,-56},{80,-56},{80,-80},{120,-80}},   color={0,0,127}));
  connect(yAuxHea, yAuxHea)
    annotation (Line(points={{120,-80},{120,-80}},   color={0,0,127}));
  connect(TFroSen, defTimFra.TOut)
    annotation (Line(points={{-120,-180},{-80,-180},{-80,-136},{-71,-136}}, color={0,0,127}));
  connect(uCooCoi, DXCoiConCoo.uCoi) annotation (Line(points={{-120,-30},{-60,
          -30},{-60,176},{-32,176}}, color={0,0,127}));
  connect(ComSpeDRHea.yComSpe, yComSpeHea)
    annotation (Line(points={{82,-40},{120,-40}}, color={0,0,127}));
  connect(DXCoiConCoo.yDXCoi, yDXCooCoi) annotation (Line(points={{-8,180},{50,
          180},{50,160},{120,160}}, color={255,0,255}));
  connect(lesThr.y,tim. u)
    annotation (Line(points={{-48,-100},{-32,-100}}, color={255,0,255}));
  connect(tim.passed,booToRea. u)
    annotation (Line(points={{-8,-108},{-2,-108}},color={255,0,255}));
  connect(TOut, lesThr.u)
    annotation (Line(points={{-120,-100},{-72,-100}}, color={0,0,127}));
  connect(defTimFra.tDefFra, mul1.u2)
    annotation (Line(points={{-49,-134},{-42,-134},{-42,-172},{-34,-172}}, color={0,0,127}));
  connect(defTimFra.XOut, XOut)
    annotation (Line(points={{-71,-140},{-120,-140}}, color={0,0,127}));
  connect(conAuxCoi.yDXCoi, yDXHeaCoi)
    annotation (Line(points={{-8,-52},{10,-52},{10,100},{120,100}}, color={255,0,255}));
  connect(conAuxCoi.yDXCoi, booToRea1.u)
    annotation (Line(points={{-8,-52},{10,-52},{10,-10},{-40,-10},{-40,14},{-32,
          14}},                                                                     color={255,0,255}));
  connect(booToRea1.y, mul.u2)
    annotation (Line(points={{-8,14},{58,14}}, color={0,0,127}));
  connect(mul.y, ComSpeDRHea.uComSpe)
    annotation (Line(points={{82,20},{92,20},{92,-10},{24,-10},{24,-46},{58,-46}}, color={0,0,127}));
  connect(booToRea.y, mul1.u1)
    annotation (Line(points={{22,-108},{30,-108},{30,-140},{-38,-140},{-38,-160},
          {-34,-160}},                                                                        color={0,0,127}));
  connect(ComSpeDRHea.yComSpe, mul2.u1)
    annotation (Line(points={{82,-40},{90,-40},{90,-120},{54,-120},{54,-154},{58,
          -154}},                                                                        color={0,0,127}));
  connect(mul1.y, reaScaRep.u)
    annotation (Line(points={{-10,-166},{-2,-166}},
                                                  color={0,0,127}));
  connect(reaScaRep.y, mul2.u2)
    annotation (Line(points={{22,-166},{58,-166}}, color={0,0,127}));
  connect(mul2.y, yDefFra)
    annotation (Line(points={{82,-160},{120,-160}}, color={0,0,127}));
  connect(uDXCooCoi, DXCoiConCoo.uDXCoi) annotation (Line(points={{-120,200},{-80,
          200},{-80,184},{-32,184}},      color={255,0,255}));
  connect(uCooCoiAva, DXCoiConCoo.uDXCoiAva) annotation (Line(points={{-120,120},
          {-72,120},{-72,188},{-32,188}}, color={255,0,255}));
  connect(uCooCoiSeq, DXCoiConCoo.uCoiSeq) annotation (Line(points={{-120,60},
          {-66,60},{-66,180},{-32,180}}, color={255,127,0}));

  connect(DXCoiConHea.yDXCoi, conAuxCoi.uDXCoi) annotation (Line(points={{-8,140},
          {0,140},{0,-30},{-40,-30},{-40,-48},{-32,-48}}, color={255,0,255}));
  connect(uDXHeaCoi, DXCoiConHea.uDXCoi) annotation (Line(points={{-120,160},{
          -80,160},{-80,144},{-32,144}},
                                     color={255,0,255}));
  connect(uHeaCoiAva, DXCoiConHea.uDXCoiAva) annotation (Line(points={{-120,90},
          {-40,90},{-40,148},{-32,148}}, color={255,0,255}));
  connect(uHeaCoiSeq, DXCoiConHea.uCoiSeq) annotation (Line(points={{-120,30},{
          -80,30},{-80,140},{-32,140}},
                                    color={255,127,0}));
  connect(uHeaCoi, DXCoiConHea.uCoi) annotation (Line(points={{-120,-60},{-54,
          -60},{-54,136},{-32,136}},
                                color={0,0,127}));
  connect(uDemLimLev, intScaRepHea.u) annotation (Line(points={{-120,0},{-46,0},
          {-46,50},{-32,50}},          color={255,127,0}));
  connect(intScaRepHea.y, ComSpeDRHea.uDemLimLev) annotation (Line(points={{-8,50},
          {26,50},{26,-34},{58,-34}}, color={255,127,0}));
  connect(TSupCoiCoo, conPCoo.u_m) annotation (Line(points={{-120,-220},{0,-220},
          {0,-212}},   color={0,0,127}));
  connect(TSupCoiHea, conPHea.u_m) annotation (Line(points={{-120,-260},{0,-260},
          {0,-252}},   color={0,0,127}));
  connect(TSupCooSet.y, conPCoo.u_s) annotation (Line(points={{-50,-280},{-44,-280},
          {-44,-200},{-12,-200}}, color={0,0,127}));
  connect(TSupCoiSet,TSupCooSet. u) annotation (Line(points={{-120,-310},{-80,-310},
          {-80,-280},{-74,-280}},       color={0,0,127}));
  connect(TSupCoiSet, TSupHeaSet.u) annotation (Line(points={{-120,-310},{-80,-310},
          {-80,-320},{-74,-320}}, color={0,0,127}));
  connect(TSupHeaSet.y, conPHea.u_s) annotation (Line(points={{-50,-320},{-40,-320},
          {-40,-240},{-12,-240}}, color={0,0,127}));
  connect(conPCoo.y, DXCoiConCoo.uComSpe) annotation (Line(points={{11,-200},{36,
          -200},{36,120},{-48,120},{-48,172},{-32,172}}, color={0,0,127}));
  connect(conPHea.y, DXCoiConHea.uComSpe) annotation (Line(points={{11,-240},{
          40,-240},{40,126},{-36,126},{-36,132},{-32,132}},
                                                         color={0,0,127}));
  connect(conPCoo.y, ComSpeDRCoo.uComSpe) annotation (Line(points={{11,-200},{46,
          -200},{46,68},{58,68}}, color={0,0,127}));
  connect(conPHea.y, mul.u1) annotation (Line(points={{11,-240},{50,-240},{50,26},
          {58,26}}, color={0,0,127}));
  annotation (defaultComponentName="RTUCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-280},{100,200}}),
        graphics={
          Rectangle(
            extent={{100,200},{-100,-280}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,224},{100,202}},
            textString="%name",
            textColor={0,0,255}),
          Text(
            extent={{-100,180},{100,180}},
            textColor={0,0,255}),
          Text(
            extent={{-92,188},{-30,174}},
            textColor={255,0,255},
            textString="uDXCooCoi"),
          Text(
            extent={{-92,128},{-26,112}},
            textColor={255,0,255},
            textString="uCooCoiAva"),
          Text(
            extent={{-92,38},{-24,22}},
            textColor={255,127,0},
            textString="uHeaCoiSeq"),
          Text(
            extent={{-92,12},{-22,-12}},
            textColor={255,127,0},
            textString="uDemLimLev"),
          Text(
            extent={{-94,-26},{-48,-48}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCooCoi"),
          Text(
            extent={{-96,-64},{-44,-78}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uHeaCoi"),
          Text(
            extent={{-98,-94},{-62,-108}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TOut"),
          Text(
            extent={{-92,-150},{-46,-170}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TFroSen"),
          Text(
            extent={{32,74},{94,50}},
            textColor={255,0,255},
            textString="yDXHeaCoi"),
          Text(
            extent={{40,-124},{92,-150}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yAuxHea"),
          Text(
            extent={{26,14},{94,-14}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpeCoo"),
          Text(
            extent={{48,-210},{94,-226}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yDefFra"),
          Text(
            extent={{32,152},{94,128}},
            textColor={255,0,255},
            textString="yDXCooCoi"),
          Text(
            extent={{26,-44},{94,-72}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpeHea"),
          Text(
            extent={{-98,-124},{-62,-138}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="XOut"),
          Text(
            extent={{-92,68},{-24,52}},
            textColor={255,127,0},
            textString="uCooCoiSeq"),
          Text(
            extent={{-92,98},{-26,82}},
            textColor={255,0,255},
            textString="uHeaCoiAva"),
          Text(
            extent={{-92,156},{-30,142}},
            textColor={255,0,255},
            textString="uDXHeaCoi"),
          Text(
            extent={{-92,-178},{-28,-206}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="TSupCoiHea"),
          Text(
            extent={{-90,-206},{-26,-234}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="TSupCoiCoo"),
          Text(
            extent={{-92,-236},{-28,-264}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="TSupCoiSet")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-340},{100,
            220}})),
  Documentation(info="<html>
  <p>
  This is control sequences for rooftop unit heat pump systems. 
  The control module consists of: 
  </p>
  <ul>
  <li>
  Subsequences to enable and stage DX coil arrays
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller</a>.
  </li>
  <li>
  Subsequences to control auxiliary heating coil 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil\">
  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil</a>.
  </li>
  <li>
  Subsequences to regulate compressor speed for demand response
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR\">
  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR</a>.
  </li>
  <li>
  Subsequences to calculate defrost time reported in
  <a href=\"modelica://Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations\">
  Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations</a>.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 11, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end Controller;
