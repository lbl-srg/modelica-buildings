within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Chiller
  "Chiller controller"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Temperature TConWatEntMin(
    displayUnit="degC")
    "Minimum value of condenser water entering temperature";
  parameter Modelica.SIunits.Temperature TEvaWatEntMax(
    displayUnit="degC")
    "Maximum value of evaporator water entering temperature";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEnt(
    final unit="K",
    displayUnit="degC")
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-200,-320},{-160,-280}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatEnt(
    final unit="K",
    displayUnit="degC")
    "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-200,-260},{-160,-220}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-300},{200,-260}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-240},{200,-200}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi
    "Chiller enabled signal"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCoo
    "Heating or cooling mode enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  LimPIDEnable                         conValEva(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    y_reset=0,
    k=0.1,
    Ti(
      displayUnit="s")=60,
    final reverseActing=true)
    "Evaporator three-way valve control"
    annotation (Placement(transformation(extent={{50,-230},{70,-210}})));
  LimPIDEnable                         conValCon(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    y_reset=0,
    k=0.1,
    Ti(
      displayUnit="s")=60,
    final reverseActing=false)
    "Condenser three-way valve control"
    annotation (Placement(transformation(extent={{50,-290},{70,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTEvaWatEnt(
    y(final unit="K",
      displayUnit="degC"),
    final k=TEvaWatEntMax)
    "Maximum value of evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-10,-230},{10,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTConWatEnt(
    y(final unit="K",
      displayUnit="degC"),
    final k=TConWatEntMin)
    "Minimum value of condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
equation
  connect(TEvaWatEnt,conValEva.u_m)
    annotation (Line(points={{-180,-240},{60,-240},{60,-232}},color={0,0,127}));
  connect(TConWatEnt,conValCon.u_m)
    annotation (Line(points={{-180,-300},{60,-300},{60,-292}},color={0,0,127}));
  connect(heaOrCoo.y,yChi)
    annotation (Line(points={{-78,0},{140,0},{140,60},{180,60}},color={255,0,255}));
  connect(uHea,heaOrCoo.u1)
    annotation (Line(points={{-180,80},{-140,80},{-140,0},{-102,0}},color={255,0,255}));
  connect(uCoo,heaOrCoo.u2)
    annotation (Line(points={{-180,40},{-120,40},{-120,-8},{-102,-8}},color={255,0,255}));
  connect(maxTEvaWatEnt.y,conValEva.u_s)
    annotation (Line(points={{12,-220},{48,-220}},color={0,0,127}));
  connect(minTConWatEnt.y,conValCon.u_s)
    annotation (Line(points={{12,-280},{48,-280}},color={0,0,127}));
  connect(conValEva.y, yValEva)
    annotation (Line(points={{72,-220},{180,-220}}, color={0,0,127}));
  connect(heaOrCoo.y, conValEva.uEna) annotation (Line(points={{-78,-0},{-40,-0},
          {-40,-236},{56,-236},{56,-232}}, color={255,0,255}));
  connect(heaOrCoo.y, conValCon.uEna) annotation (Line(points={{-78,-0},{-40,-0},
          {-40,-296},{56,-296},{56,-292}}, color={255,0,255}));
  connect(conValCon.y, yValCon) annotation (Line(points={{72,-280},{120,-280},{
          120,-280},{180,-280}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-320},{160,100}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
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
<p>
Optionally, a chilled water supply temperature reset can be activated.
In this case, if there is an actual heating demand, the chilled water
supply temperature is reset with a PI loop controlling the heating
water supply temperature.
This has two effects, which occur in sequence.
</p>
<ol>
<li>
First a \"false load\" is generated on the evaporator: the part load ratio
of the chiller increases, and so does the heat flow rate rejected by the
condenser.
This is true until the volume of the evaporator loop and the chilled
water tank is fully recirculated.
</li>
<li>
Then the temperature difference across the evaporator reaches back its
original value (for an unvarying building load).
However, the evaporator inlet temperature (corresponding to the tank top
temperature) is now lowered. This will eventually trigger a cold
rejection demand by
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1</a>.
The ambient sources are then used to \"false load\" the chiller.
</li>
</ol>
</html>"));
end Chiller;
