within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls;
model Chiller
  "Chiller controller"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Temperature TConWatEntMin(displayUnit="degC")
    "Minimum value of condenser water entering temperature";
  parameter Modelica.Units.SI.Temperature TEvaWatEntMax(displayUnit="degC")
    "Maximum value of evaporator water entering temperature";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
    iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
    iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEnt(
    final unit="K",
    displayUnit="degC")
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
    iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatEnt(
    final unit="K",
    displayUnit="degC")
    "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
    iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
    iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
    iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi
    "Chiller enable signal"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
    iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCoo
    "Heating or cooling enabled"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  PIDWithEnable conValEva(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    y_reset=0,
    k=0.1,
    Ti(
      displayUnit="s")=60,
    final reverseActing=true)
    "Evaporator three-way valve control"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  PIDWithEnable conValCon(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    y_reset=0,
    k=0.1,
    Ti(
      displayUnit="s")=60,
    final reverseActing=false)
    "Condenser three-way valve control"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTEvaWatEnt(
    y(final unit="K",
      displayUnit="degC"),
    final k=TEvaWatEntMax)
    "Maximum value of evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTConWatEnt(
    y(final unit="K",
      displayUnit="degC"),
    final k=TConWatEntMin)
    "Minimum value of condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(TEvaWatEnt,conValEva.u_m)
    annotation (Line(points={{-180,-20},{60,-20},{60,-12}},color={0,0,127}));
  connect(TConWatEnt,conValCon.u_m)
    annotation (Line(points={{-180,-80},{60,-80},{60,-72}},color={0,0,127}));
  connect(heaOrCoo.y,yChi)
    annotation (Line(points={{-98,60},{180,60}},color={255,0,255}));
  connect(uHea,heaOrCoo.u1)
    annotation (Line(points={{-180,80},{-140,80},{-140,60},{-122,60}},color={255,0,255}));
  connect(uCoo,heaOrCoo.u2)
    annotation (Line(points={{-180,40},{-140,40},{-140,52},{-122,52}},color={255,0,255}));
  connect(maxTEvaWatEnt.y,conValEva.u_s)
    annotation (Line(points={{12,0},{48,0}},color={0,0,127}));
  connect(minTConWatEnt.y,conValCon.u_s)
    annotation (Line(points={{12,-60},{48,-60}},color={0,0,127}));
  connect(conValEva.y,yValEva)
    annotation (Line(points={{72,0},{180,0}},color={0,0,127}));
  connect(heaOrCoo.y,conValEva.uEna)
    annotation (Line(points={{-98,60},{-40,60},{-40,-16},{56,-16},{56,-12}},color={255,0,255}));
  connect(heaOrCoo.y,conValCon.uEna)
    annotation (Line(points={{-98,60},{-40,60},{-40,-76},{56,-76},{56,-72}},color={255,0,255}));
  connect(conValCon.y,yValCon)
    annotation (Line(points={{72,-60},{180,-60}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-120},{160,120}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a controller for the chiller system, which includes the dedicated
condenser and evaporator pumps.
</p>
<p>
The system is enabled if any of the input control signals <code>uHea</code>
or <code>uCoo</code> is <code>true</code>.
When enabled,
</p>
<ul>
<li>
the condenser and evaporator pumps are operated at constant speed,
</li>
<li>
the condenser (resp. evaporator) mixing valve is modulated with a PI
loop controlling the minimum (resp. maximum) inlet temperature.
</li>
</ul>
</html>"));
end Chiller;
