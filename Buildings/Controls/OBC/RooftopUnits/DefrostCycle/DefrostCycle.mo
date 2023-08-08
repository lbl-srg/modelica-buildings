within Buildings.Controls.OBC.RooftopUnits.DefrostCycle;
block DefrostCycle "Sequences to control defrost cycle"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi = 2
    "Total number of DX coils"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 5
    "Predefined outdoor lockout temperature"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real TFroTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 0
    "Predefined frost temperature"
    annotation (Dialog(group="Defrost parameters"));

  parameter Integer dTOutHys
    "Small temperature difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if has_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
    iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not has_TFroSen
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoiMod[nCoi]
    "DX coil operation mode"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=TOutLoc,
    final h=dThys)
    "Check if outdoor air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nCoi]
    "Break loop"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nCoi]
    "Logical And"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.DefrostTime DefTim
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTim(
    final k=300)
    "Constant time"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{-10,-36},{10,-16}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal                        booToRea[nCoi]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefTimPer[nCoi](
    final quantity="Time", final unit="s")
    "Defrost time period"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCoi)
    annotation (Placement(transformation(extent={{30,-36},{50,-16}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[nCoi]
    annotation (Placement(transformation(extent={{90,-42},{110,-22}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

protected
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
  final nout=nCoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,22},{0,42}})));

equation
  connect(lesThr.u, TOut)
    annotation (Line(points={{-102,40},{-120,40},{-120,20},{-160,20}},
                                                  color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-78,40},{-62,40}}, color={255,0,255}));
  connect(tim.passed, booRep1.u)
    annotation (Line(points={{-38,32},{-22,32}}, color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{42,40},{58,40}},
        color={255,0,255}));
  connect(TFroSen, lesThr.u) annotation (Line(points={{-160,-20},{-120,-20},{-120,
          40},{-102,40}}, color={0,0,127}));
  connect(conTim.y, mul.u2)
    annotation (Line(points={{-28,-60},{-20,-60},{-20,-32},{-12,-32}},
                                                             color={0,0,127}));
  connect(DefTim.yDefTim, mul.u1)
    annotation (Line(points={{-38,-20},{-12,-20}},           color={0,0,127}));
  connect(pre.y, yDXCoiMod)
    annotation (Line(points={{82,40},{160,40}},   color={255,0,255}));
  connect(pre.y, booToRea.u) annotation (Line(points={{82,40},{100,40},{100,0},{
          20,0},{20,-70},{28,-70}},
                    color={255,0,255}));
  connect(mul.y, reaScaRep.u)
    annotation (Line(points={{12,-26},{28,-26}},
                                              color={0,0,127}));
  connect(reaScaRep.y, mul1.u1)
    annotation (Line(points={{52,-26},{88,-26}},
                                               color={0,0,127}));
  connect(booToRea.y, mul1.u2) annotation (Line(points={{52,-70},{70,-70},{70,-38},
          {88,-38}},color={0,0,127}));
  connect(mul1.y, yDefTimPer) annotation (Line(points={{112,-32},{120,-32},{120,
          -60},{160,-60}},
                     color={0,0,127}));
  connect(TOut, DefTim.TOut) annotation (Line(points={{-160,20},{-80,20},{-80,-14},
          {-62,-14}},color={0,0,127}));
  connect(DefTim.phi, phi) annotation (Line(points={{-62,-26},{-80,-26},{-80,-60},
          {-160,-60}},
                     color={0,0,127}));
  connect(booRep1.y, and2.u2)
    annotation (Line(points={{2,32},{18,32}}, color={255,0,255}));
  connect(and2.u1, uDXCoiAva) annotation (Line(points={{18,40},{10,40},{10,60},{
          -160,60}}, color={255,0,255}));
    annotation (Dialog(group="Defrost parameters"),
    defaultComponentName="DefCyc",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})));
end DefrostCycle;
