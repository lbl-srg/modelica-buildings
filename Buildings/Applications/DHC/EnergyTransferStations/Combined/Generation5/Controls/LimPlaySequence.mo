within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPlaySequence "Play hysteresis controllers in sequence"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCon = 1
    "Number of controllers in sequence"
    annotation(Evaluate=true);
  parameter Real hys[nCon]
    "Hysteresis of each controller (full width, absolute value)";
  parameter Real dea[nCon]
    "Dead band between each controller (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType[nCon]=
    fill(Buildings.Controls.OBC.CDL.Types.SimpleController.P, nCon)
        "Type of controller (P or PI)"
    annotation(choices(
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real yMax[nCon] = fill(1, nCon)
    "Upper limit of output";
  parameter Real yMin[nCon] = fill(0, nCon)
    "Lower limit of output";
  parameter Real k[nCon](each min=0) = fill(1, nCon)
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti[nCon](
    each min=Buildings.Controls.OBC.CDL.Constants.small) = fill(0.5, nCon)
    "Time constant of integrator block"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      for i in 1:nCon})));
  parameter Boolean reverseActing = false
    "Set to true for control output decreasing with measurement value";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20}, {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(extent={{20,-20},{-20,20}},
        rotation=270, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nCon]
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140, 20}})));

  LimPlay conPla[nCon](
    final controllerType=controllerType,
    final yMax=yMax,
    final yMin=yMin,
    final k=k,
    final Ti=Ti,
    final hys=hys,
    each final reverseActing=reverseActing)
    "Play hysteresis controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nCon)
    "Replicate measurement signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));
  Modelica.Blocks.Sources.RealExpression setOff[nCon](
    final y=uSet)
    "Set-point with offset"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
protected
  final parameter Real sig = if reverseActing then -1 else 1
    "Sign of set-point offset";
  Real uSet1 = u_s + sig * (dea[1] + 0.5 * hys[1])
    "First set-point value (only half hysteresis)";
  Real uSet[nCon] = uSet1 .+ sig * {(i - 1) * (dea[i] + hys[i]) for i in 1:nCon}
    "Set-point values";
equation
  connect(reaRep.y, conPla.u_m)
    annotation (Line(points={{0,-48},{0,-12}}, color={0,0,127}));
  connect(setOff.y, conPla.u_s)
    annotation (Line(points={{-59,0},{-12,0}}, color={0,0,127}));
  connect(u_m, reaRep.u)
    annotation (Line(points={{0,-120},{0,-72}}, color={0,0,127}));
  connect(conPla.y, y)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  annotation (defaultComponentName="conPlaSeq",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
end LimPlaySequence;
