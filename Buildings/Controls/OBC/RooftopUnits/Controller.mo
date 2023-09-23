within Buildings.Controls.OBC.RooftopUnits;
block Controller
  "Controller for rooftop unit heat pump systems"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoiHea(min=1)
    "Number of DX heating coils";

  parameter Integer nCoiCoo(min=1)
    "Number of DX cooling coils";

  parameter Real conCoiLow(
    final min=0,
    final max=1)=0.2
    "Constant lower DX coil signal"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real conCoiHig(
    final min=0,
    final max=1)=0.8
    "Constant higher DX coil signal"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoi(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is staged up"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoi1(
    final min=0,
    final max=1)=0.2
    "Threshold of coil valve position signal below which DX coil staged down"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoi2(
    final min=0,
    final max=1)=0.8
    "Threshold of coil valve position signal above which DX coil is enabled"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrCoi3(
    final min=0,
    final max=1)=0.1
    "Threshold of coil valve position signal below which DX coil is disabled"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 480
    "Delay time period for staging up DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Delay time period for staging down DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling DX coil"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real timPerOut(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling defrost"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real minComSpe(
    final min=0,
    final max=maxComSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(tab="Compressor", group="Compressor parameters"));

  parameter Real maxComSpe(
    final min=minComSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(tab="Compressor", group="Compressor parameters"));

  parameter Real k1=0.9
    "Constant compressor speed gain at demand-limit Level 1"
    annotation (Dialog(tab="Compressor", group="DR parameters"));

  parameter Real k2=0.85
    "Constant compressor speed gain at demand-limit Level 2"
    annotation (Dialog(tab="Compressor", group="DR parameters"));

  parameter Real k3=0.8
    "Constant compressor speed gain at demand-limit Level 3"
    annotation (Dialog(tab="Compressor", group="DR parameters"));

  parameter Real k4=1
    "Gain of auxiliary heating controller 1"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real k5=10
    "Gain of auxiliary heating controller 2"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real TLocOut=273.15 - 12.2
    "Minimum outdoor dry-bulb lockout temperature"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Real TSupSetMin=273.15 + 10
    "Minimum supply air temperature setpoint"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real TSupSetMax=273.15 + 35
    "Maximum supply air temperature setpoint"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real uThrHeaCoi(
    final min=0,
    final max=1)=0.9
    "Threshold of heating coil valve position signal above which auxiliary coil is enabled"
    annotation (Dialog(tab="Auxiliary coil"));

  parameter Boolean have_TFroSen=false
    "True: RTU has frost sensor"
    annotation (__cdl(ValueInReference=false), group="Defrost parameters");

  parameter Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods defTri=
     Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle"
    annotation (Dialog(group="Defrost parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=0
    "Maximum temperature at which defrost operation is activated"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real tDefRun(
    final min=0,
    final max=1)=0.5
    "If defrost operation is timed, timestep fraction for which defrost cycle is run"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 5
    "Predefined outdoor lockout temperature"
    annotation (Dialog(group="Defrost parameters"));

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

  parameter Real timPerSetExc=480
    "Delay time period for staging down DX coil when minimum/maximum setpoint is exceeded"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCooCoi[nCoiCoo]
    "DX cooling coil status"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXHeaCoi[nCoiHea]
    "DX heating coil status"
    annotation (Placement(transformation(extent={{-140,130},{-100,170}}),
      iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCooCoiAva[nCoiCoo]
    "DX cooling coil availability"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,90},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaCoiAva[nCoiHea]
    "DX heating coil availability"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooCoiSeq[nCoiCoo]
    "DX cooling coil available sequence order"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaCoiSeq[nCoiHea]
    "DX heating coil available sequence order"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,-2},{-100,38}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coolign coil valve position"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-140,-82},{-100,-42}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-140,-162},{-100,-122}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-140,-200},{-100,-160}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCooCoi[nCoiCoo]
    "DX cooling coil signal"
    annotation (Placement(transformation(extent={{100,140},{140,180}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXHeaCoi[nCoiHea]
    "DX heating coil signal"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeCoo[nCoiCoo](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Compressor commanded speed for DX cooling coils"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,2},{140,42}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeHea[nCoiHea](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Compressor commanded speed for DX heating coils"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-42},{140,-2}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{100,-120},{140,-80}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefFra[nCoiHea](
    each final unit="1")
    "Defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{100,-180},{140,-140}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiConCoo(
    each final nCoi=nCoiCoo,
    each final conCoiLow=conCoiLow,
    each final conCoiHig=conCoiHig,
    each final uThrCoiUp=uThrCoi,
    each final uThrCoiDow=uThrCoi1,
    each final uThrCoi2=uThrCoi2,
    each final uThrCoi3=uThrCoi3,
    each final timPer=timPer,
    each final timPer1=timPer1,
    each final timPerSetExc=timPerSetExc,
    each final timPer2=timPer2,
    each final timPer3=timPer3,
    each final minComSpe=minComSpe,
    each final maxComSpe=maxComSpe,
    each final dUHys=dUHys)
    "DX cooling coil controller"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRCoo[nCoiCoo](
    each final k1=k1,
    each final k2=k2,
    each final k3=k3)
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRHea[nCoiHea](
    each final k1=k1,
    each final k2=k2,
    each final k3=k3)
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi(
    final nCoi=nCoiHea,
    final TLocOut=TLocOut,
    final dTHys=dTHys,
    final k1=k4,
    final k2=k5,
    final uThrHeaCoi=uThrHeaCoi,
    final dUHys=dUHys)
    "Auxiliary coil controller"
    annotation (Placement(transformation(extent={{-30,-66},{-10,-46}})));

  Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations defTimFra(
    final defTri=defTri,
    final tDefRun=tDefRun,
    final TDefLim=TDefLim,
    final dTHys=dTHys1)
    "Defrost time calculation"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRepCoo(
    final nout=nCoiCoo)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
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
    annotation (Placement(transformation(extent={{10,-118},{30,-98}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Calculate defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nCoiHea](
    each final realTrue=1,
    each final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nCoiHea]
    "Calculate compressor speed for DX heating"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2[nCoiHea]
    "Calculate defrost operation timestep fractions for DX coils"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCoiHea)
    "Real scalar replicator"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoiHea[nCoiHea](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating coil supply air temperature"
    annotation (Placement(transformation(extent={{-140,-280},{-100,-240}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoiCoo[nCoiCoo](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling coil supply air temperature"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}}),
      iconTransformation(extent={{-140,-260},{-100,-220}})));

  DXCoil.Controller DXCoiConHea(
    final nCoi=nCoiHea,
    final conCoiLow=conCoiLow,
    final conCoiHig=conCoiHig,
    final uThrCoiUp=uThrCoi,
    final uThrCoiDow=uThrCoi1,
    final uThrCoi2=uThrCoi2,
    final uThrCoi3=uThrCoi3,
    final timPer=timPer,
    final timPer1=timPer1,
    final timPer2=timPer2,
    final timPer3=timPer3,
    final minComSpe=minComSpe,
    final maxComSpe=maxComSpe,
    final dUHys=dUHys)
    "DX heating coil controller"
    annotation (Placement(transformation(extent={{-30,130},{-10,150}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRepHea(
    final nout=nCoiHea)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-30,42},{-10,62}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo[nCoiCoo]
    annotation (Placement(transformation(extent={{48,-218},{68,-198}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea[nCoiHea]
    annotation (Placement(transformation(extent={{48,-258},{68,-238}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conCoo[nCoiCoo](
    k=fill(TSupSetMin, nCoiCoo))
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHea[nCoiHea](
    k=fill(TSupSetMax, nCoiHea))
    annotation (Placement(transformation(extent={{-80,-260},{-60,-240}})));

equation
  connect(uDemLimLev, intScaRepCoo.u) annotation (Line(points={{-120,0},{-46,0},
          {-46,80},{-32,80}}, color={255,127,0}));
  connect(intScaRepCoo.y, ComSpeDRCoo.uDemLimLev) annotation (Line(points={{-8,80},
          {30,80},{30,76},{38,76}}, color={255,127,0}));
  connect(conAuxCoi.TOut, TOut)
    annotation (Line(points={{-32,-56},{-80,-56},{-80,-100},{-120,-100}}, color={0,0,127}));
  connect(conAuxCoi.uHeaCoi, uHeaCoi)
    annotation (Line(points={{-32,-62},{-120,-62}}, color={0,0,127}));
  if not have_TFroSen then
  connect(defTimFra.TOut, TOut)
    annotation (Line(points={{-71,-138},{-80,-138},{-80,-100},{-120,-100}}, color={0,0,127}));
  end if;
  connect(ComSpeDRCoo.yComSpe, yComSpeCoo)
    annotation (Line(points={{62,70},{80,70},{80,40},{120,40}}, color={0,0,127}));
  connect(conAuxCoi.yAuxHea, yAuxHea)
    annotation (Line(points={{-8,-56},{60,-56},{60,-100},{120,-100}}, color={0,0,127}));
  connect(yAuxHea, yAuxHea)
    annotation (Line(points={{120,-100},{120,-100}}, color={0,0,127}));
  connect(TFroSen, defTimFra.TOut)
    annotation (Line(points={{-120,-180},{-80,-180},{-80,-138},{-71,-138}}, color={0,0,127}));
  connect(uCooCoi, DXCoiConCoo.uCoi) annotation (Line(points={{-120,-30},{-60,
          -30},{-60,176},{-32,176}}, color={0,0,127}));
  connect(DXCoiConCoo.yComSpe, ComSpeDRCoo.uComSpe) annotation (Line(points={{-8,176},
          {20,176},{20,64},{38,64}},          color={0,0,127}));
  connect(ComSpeDRHea.yComSpe, yComSpeHea)
    annotation (Line(points={{62,-40},{120,-40}}, color={0,0,127}));
  connect(DXCoiConCoo.yDXCoi, yDXCooCoi) annotation (Line(points={{-8,184},{56,
          184},{56,160},{120,160}}, color={255,0,255}));
  connect(lesThr.y,tim. u)
    annotation (Line(points={{-48,-100},{-32,-100}}, color={255,0,255}));
  connect(tim.passed,booToRea. u)
    annotation (Line(points={{-8,-108},{8,-108}}, color={255,0,255}));
  connect(TOut, lesThr.u)
    annotation (Line(points={{-120,-100},{-72,-100}}, color={0,0,127}));
  connect(defTimFra.tDefFra, mul1.u2)
    annotation (Line(points={{-49,-136},{-40,-136},{-40,-176},{-22,-176}}, color={0,0,127}));
  connect(defTimFra.XOut, XOut)
    annotation (Line(points={{-71,-142},{-120,-142}}, color={0,0,127}));
  connect(conAuxCoi.yDXCoi, yDXHeaCoi)
    annotation (Line(points={{-8,-50},{10,-50},{10,100},{120,100}}, color={255,0,255}));
  connect(conAuxCoi.yDXCoi, booToRea1.u)
    annotation (Line(points={{-8,-50},{10,-50},{10,40},{-40,40},{-40,10},{-32,10}}, color={255,0,255}));
  connect(booToRea1.y, mul.u2)
    annotation (Line(points={{-8,10},{14,10},{14,14},{38,14}},
                                               color={0,0,127}));
  connect(mul.y, ComSpeDRHea.uComSpe)
    annotation (Line(points={{62,20},{80,20},{80,-10},{20,-10},{20,-46},{38,-46}}, color={0,0,127}));
  connect(booToRea.y, mul1.u1)
    annotation (Line(points={{32,-108},{40,-108},{40,-140},{-30,-140},{-30,-164},
          {-22,-164}},                                                                        color={0,0,127}));
  connect(ComSpeDRHea.yComSpe, mul2.u1)
    annotation (Line(points={{62,-40},{80,-40},{80,-120},{50,-120},{50,-154},{58,-154}}, color={0,0,127}));
  connect(mul1.y, reaScaRep.u)
    annotation (Line(points={{2,-170},{18,-170}}, color={0,0,127}));
  connect(reaScaRep.y, mul2.u2)
    annotation (Line(points={{42,-170},{50,-170},{50,-166},{58,-166}},
                                                   color={0,0,127}));
  connect(mul2.y, yDefFra)
    annotation (Line(points={{82,-160},{120,-160}}, color={0,0,127}));
  connect(uDXCooCoi, DXCoiConCoo.uDXCoi) annotation (Line(points={{-120,180},
          {-80,180},{-80,188},{-32,188}}, color={255,0,255}));
  connect(uCooCoiAva, DXCoiConCoo.uDXCoiAva) annotation (Line(points={{-120,120},
          {-72,120},{-72,184},{-32,184}}, color={255,0,255}));
  connect(uCooCoiSeq, DXCoiConCoo.uCoiSeq) annotation (Line(points={{-120,60},
          {-66,60},{-66,180},{-32,180}}, color={255,127,0}));

  connect(DXCoiConHea.yDXCoi, conAuxCoi.uDXCoi) annotation (Line(points={{-8,144},
          {0,144},{0,-30},{-40,-30},{-40,-50},{-32,-50}}, color={255,0,255}));
  connect(uDXHeaCoi, DXCoiConHea.uDXCoi) annotation (Line(points={{-120,150},{-40,
          150},{-40,148},{-32,148}}, color={255,0,255}));
  connect(uHeaCoiAva, DXCoiConHea.uDXCoiAva) annotation (Line(points={{-120,90},
          {-40,90},{-40,144},{-32,144}}, color={255,0,255}));
  connect(uHeaCoiSeq, DXCoiConHea.uCoiSeq) annotation (Line(points={{-120,30},{-80,
          30},{-80,140},{-32,140}}, color={255,127,0}));
  connect(uHeaCoi, DXCoiConHea.uCoi) annotation (Line(points={{-120,-62},{-50,-62},
          {-50,136},{-32,136}}, color={0,0,127}));
  connect(DXCoiConHea.yComSpe, mul.u1) annotation (Line(points={{-8,136},{14,136},
          {14,26},{38,26}}, color={0,0,127}));
  connect(uDemLimLev, intScaRepHea.u) annotation (Line(points={{-120,0},{-46,0},
          {-46,56},{-32,56},{-32,52}}, color={255,127,0}));
  connect(intScaRepHea.y, ComSpeDRHea.uDemLimLev) annotation (Line(points={{-8,52},
          {32,52},{32,-34},{38,-34}}, color={255,127,0}));
  connect(conCoo.y, subCoo.u1) annotation (Line(points={{-58,-200},{20,-200},{20,
          -202},{46,-202}}, color={0,0,127}));
  connect(conHea.y, subHea.u2) annotation (Line(points={{-58,-250},{40,-250},{40,
          -254},{46,-254}}, color={0,0,127}));
  connect(TSupCoiCoo, subCoo.u2) annotation (Line(points={{-120,-220},{20,-220},
          {20,-214},{46,-214}}, color={0,0,127}));
  connect(TSupCoiHea, subHea.u1) annotation (Line(points={{-120,-260},{20,-260},
          {20,-242},{46,-242}}, color={0,0,127}));
  connect(subCoo.y, DXCoiConCoo.TSupCoiDif) annotation (Line(points={{70,-208},
          {80,-208},{80,-178},{-90,-178},{-90,172},{-32,172}}, color={0,0,127}));
  connect(subHea.y, DXCoiConHea.TSupCoiDif) annotation (Line(points={{70,-248},
          {84,-248},{84,-174},{-84,-174},{-84,132},{-32,132}}, color={0,0,127}));
  annotation (defaultComponentName="RTUCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-280},{100,200}}),
        graphics={
          Rectangle(
            extent={{100,180},{-100,-280}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,202},{100,180}},
            textString="%name",
            textColor={0,0,255}),
          Text(
            extent={{-100,180},{100,180}},
            textColor={0,0,255}),
          Text(
            extent={{-92,176},{-30,162}},
            textColor={255,0,255},
            textString="uDXCooCoi"),
          Text(
            extent={{-92,118},{-26,102}},
            textColor={255,0,255},
            textString="uCooCoiAva"),
          Text(
            extent={{-92,24},{-24,8}},
            textColor={255,127,0},
            textString="uHeaCoiSeq"),
          Text(
            extent={{-92,-10},{-22,-34}},
            textColor={255,127,0},
            textString="uDemLimLev"),
          Text(
            extent={{-94,-40},{-48,-62}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCooCoi"),
          Text(
            extent={{-96,-74},{-44,-88}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uHeaCoi"),
          Text(
            extent={{-98,-104},{-62,-118}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TOut"),
          Text(
            extent={{-92,-160},{-46,-180}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TFroSen"),
          Text(
            extent={{32,92},{94,68}},
            textColor={255,0,255},
            textString="yDXHeaCoi"),
          Text(
            extent={{40,-66},{92,-92}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yAuxHea"),
          Text(
            extent={{26,36},{94,8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpeCoo"),
          Text(
            extent={{48,-132},{94,-148}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yDefFra"),
          Text(
            extent={{32,152},{94,128}},
            textColor={255,0,255},
            textString="yDXCooCoi"),
          Text(
            extent={{26,-8},{94,-36}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpeHea"),
          Text(
            extent={{-98,-134},{-62,-148}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="XOut"),
          Text(
            extent={{-92,56},{-24,40}},
            textColor={255,127,0},
            textString="uCooCoiSeq"),
          Text(
            extent={{-92,88},{-26,72}},
            textColor={255,0,255},
            textString="uHeaCoiAva"),
          Text(
            extent={{-92,146},{-30,132}},
            textColor={255,0,255},
            textString="uDXHeaCoi"),
          Text(
            extent={{-92,-188},{-28,-216}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="TSupCoiHea"),
          Text(
            extent={{-90,-226},{-26,-254}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="TSupCoiCoo")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-280},{100,
            200}})),
  Documentation(info="<html>
  <p>
  This is control sequences for rooftop unit heat pump systems. 
  The control module consists of: 
  </p>
  <ul>
  <li>
  Subsequences to stage DX coils and corresponding compressor speeds 
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller\">
  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller</a>.
  </li>
  <li>
  Subsequences to control auxiliary coil 
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
