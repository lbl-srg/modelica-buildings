within Buildings.Applications.DHC.Loads.BaseClasses;
block MixingValveControl "Controller for the mixing valve"
  import typ = Buildings.Applications.DHC.Loads.Types.DistributionType
    "Types of distribution system";
  parameter typ disTyp = typ.HeatingWater
    "Type of distribution system"
    annotation(Evaluate=true);
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-40}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-40})));
  Modelica.Blocks.Interfaces.IntegerInput modChaOve if
    disTyp == typ.ChangeOver
    "Operating mode in change-over (1 for heating, -1 for cooling)"
    annotation (Placement(
      transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,80}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput TSupMes(
    quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Supply temperature (sensed)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealOutput yVal(unit="1")
    "Valve control signal"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea if
    disTyp == typ.ChangeOver
    "Conversion to real"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Modelica.Blocks.Math.IntegerToBoolean toBoo(threshold=0) if
    disTyp == typ.ChangeOver
    "Conversion to boolean (true if heating mode)"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=10,
    yMax=1,
    yMin=-1,
    reverseAction=false,
    reset=if disTyp == typ.ChangeOver then
      Buildings.Controls.OBC.CDL.Types.Reset.Parameter else
      Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Min negPar
    "Negative part of control signal"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Max posPar
    "Positive part of control signal"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Logical.ZeroCrossing zerCro if
    disTyp == typ.ChangeOver
    "Zero crossing yields true signal"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain opp(k=-1)
    "Opposite value"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Sources.BooleanExpression fixMod(
    final y=disTyp == typ.HeatingWater)
    "Fixed operating mode"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  if disTyp == typ.ChangeOver then
    connect(modChaOve, intToRea.u)
      annotation (Line(points={{-120,80},{-72,80}}, color={255,127,0}));
    connect(tru.y, zerCro.enable)
      annotation (Line(points={{-18,60},{10,60},{10,68}},
                                                        color={255,0,255}));
    connect(intToRea.y, zerCro.u)
      annotation (Line(points={{-48,80},{-2,80}},  color={0,0,127}));
    connect(modChaOve, toBoo.u)
      annotation (Line(points={{-120,80},{-90,80},{-90,20},
          {-42,20}},color={255,127,0}));
    connect(toBoo.y, swi.u2)
      annotation (Line(points={{-19,20},{30,20},{30,-40},{38,-40}},
               color={255,0,255}));
    connect(zerCro.y, conTSup.trigger)
      annotation (Line(points={{22,80},{40,80},{40,
          40},{-80,40},{-80,-76},{-68,-76},{-68,-72}}, color={255,0,255}));
  else
    connect(fixMod.y, swi.u2)
      annotation (Line(points={{-19,0},{30,0},{30,-40},{38,-40}},
                     color={255,0,255}));
  end if;
  connect(conTSup.y, posPar.u2) annotation (Line(points={{-48,-60},{-44,-60},{-44,
          -46},{-32,-46}}, color={0,0,127}));
  connect(zer.y, posPar.u1) annotation (Line(points={{-48,-20},{-40,-20},{-40,-34},
          {-32,-34}}, color={0,0,127}));
  connect(zer.y, negPar.u1) annotation (Line(points={{-48,-20},{-40,-20},{-40,-74},
          {-32,-74}}, color={0,0,127}));
  connect(conTSup.y, negPar.u2) annotation (Line(points={{-48,-60},{-44,-60},{-44,
          -86},{-32,-86}}, color={0,0,127}));
  connect(negPar.y, opp.u)
    annotation (Line(points={{-8,-80},{-2,-80}}, color={0,0,127}));
  connect(opp.y, swi.u3) annotation (Line(points={{22,-80},{32,-80},{32,-48},{38,
          -48}}, color={0,0,127}));
  connect(posPar.y, swi.u1) annotation (Line(points={{-8,-40},{20,-40},{20,-32},
          {38,-32}}, color={0,0,127}));
  connect(conTSup.u_s, TSupSet) annotation (Line(points={{-72,-60},{-90,-60},{-90,
          -40},{-120,-40}}, color={0,0,127}));
  connect(TSupMes, conTSup.u_m) annotation (Line(points={{-120,-80},{-60,-80},{-60,
          -72}}, color={0,0,127}));
  connect(swi.y, yVal) annotation (Line(points={{62,-40},{92,-40},{92,0},{120,0}},
        color={0,0,127}));

  annotation (
  defaultComponentName="conVal",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MixingValveControl;
