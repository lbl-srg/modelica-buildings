within Buildings.ThermalZones.ReducedOrder.RC;
model ThreeElements "Thermal Zone with three elements for exterior walls,
  interior walls and floor plate"
    extends TwoElements(AArray={ATotExt,ATotWin,AInt,AFloor});

  parameter Modelica.Units.SI.Area AFloor "Area of floor plate"
    annotation (Dialog(group="Floor plate"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConFloor
    "Convective coefficient of heat transfer of floor plate (indoor)"
    annotation (Dialog(group="Floor plate"));
  parameter Integer nFloor(min = 1) "Number of RC-elements of floor plate"
    annotation(Dialog(group="Floor plate"));
  parameter Modelica.Units.SI.ThermalResistance RFloor[nFloor](each min=
        Modelica.Constants.small)
    "Vector of resistances of floor plate, from inside to outside"
    annotation (Dialog(group="Floor plate"));
  parameter Modelica.Units.SI.ThermalResistance RFloorRem(min=Modelica.Constants.small)
    "Resistance of remaining resistor RFloorRem between capacity n and outside"
    annotation (Dialog(group="Floor plate"));
  parameter Modelica.Units.SI.HeatCapacity CFloor[nFloor](each min=Modelica.Constants.small)
    "Vector of heat capacities of floor plate, from inside to outside"
    annotation (Dialog(group="Floor plate"));
  parameter Boolean indoorPortFloor = false
    "Additional heat port at indoor surface of floor plate"
    annotation(Dialog(group="Floor plate"),choices(checkBox = true));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a floor  if AFloor > 0
    "Ambient port for floor plate"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}}),
    iconTransformation(extent={{-10,-190},{10,-170}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a floorIndoorSurface
 if indoorPortFloor "Auxiliary port at indoor surface of floor plate"
    annotation (Placement(
    transformation(extent={{-90,-190},{-70,-170}}), iconTransformation(
    extent={{-90,-190},{-70,-170}})));
  BaseClasses.ExteriorWall floorRC(
    final n=nFloor,
    final RExt=RFloor,
    final RExtRem=RFloorRem,
    final CExt=CFloor,
    final T_start=T_start) if AFloor > 0 "RC-element for floor plate"
    annotation (Placement(transformation(
    extent={{9,-12},{-9,12}},
    rotation=90,
    origin={-12,-145})));

protected
  Modelica.Thermal.HeatTransfer.Components.Convection convFloor if AFloor > 0
    "Convective heat transfer of floor"
    annotation (Placement(transformation(
    extent={{-8,8},{8,-8}},
    rotation=90,
    origin={-12,-116})));
  Modelica.Blocks.Sources.Constant hConFloor_const(final k=AFloor*hConFloor)
 if AFloor > 0 "Coefficient of convective heat transfer for floor"
    annotation (Placement(transformation(
      extent={{-5,-5},{5,5}},
      rotation=180,
      origin={12,-116})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallFloor(
      final G=min(ATotExt, AFloor)*hRad) if ATotExt > 0 and AFloor > 0
    "Resistor between exterior walls and floor"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-144,-111})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIntWallFloor(
      final G=min(AFloor, AInt)*hRad) if AInt > 0 and AFloor > 0
    "Resistor between interior walls and floor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={204,-106})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resFloorWin(
    final G=min(ATotWin, AFloor)*hRad) if ATotWin > 0 and AFloor > 0
    "Resistor between floor plate and windows"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-110})));

equation
  connect(floorRC.port_a, convFloor.solid)
    annotation (Line(
    points={{-10.9091,-136},{-10.9091,-130},{-12,-130},{-12,-124}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(floorRC.port_a, resExtWallFloor.port_b)
    annotation (Line(
    points={{-10.9091,-136},{-10.9091,-132},{-144,-132},{-144,-121}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(floorRC.port_a, resIntWallFloor.port_b)
    annotation (Line(
    points={{-10.9091,-136},{-10.9091,-132},{224,-132},{224,-106},{214,-106}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(floorRC.port_b, floor)
    annotation (Line(
    points={{-10.9091,-154},{-10.9091,-180},{0,-180}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(resFloorWin.port_a, convWin.solid)
    annotation (Line(
    points={{-80,-100},{-80,20},{-146,20},{-146,40},{-116,40}},
    color={191,0,0},
    smooth=Smooth.None));
  if not ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.portOut[1], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.portOut[1]);
  elseif ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and AFloor > 0
    or not ATotExt > 0 and ATotWin > 0 and not AInt > 0 and AFloor > 0
    or not ATotExt > 0 and not ATotWin > 0 and AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.portOut[2], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.portOut[2]);
  elseif not ATotExt > 0 and ATotWin > 0 and AInt > 0 and AFloor > 0
    or ATotExt > 0 and not ATotWin > 0 and AInt > 0 and AFloor > 0
    or ATotExt > 0 and ATotWin > 0 and not AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.portOut[3], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.portOut[3]);
  elseif ATotExt > 0 and ATotWin > 0 and AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.portOut[4], floorRC.port_a)
      annotation (
      Line(
      points={{190,86},{190,80},{-38,80},{-38,-132},{-10.9091,-132},{-10.9091,
            -136}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(floorRC.port_a, thermSplitterSolRad.portOut[4])
      annotation (
      Line(
      points={{-10.9091,-136},{-10.9091,-132},{-42,-132},{-42,146},{-122,146}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;
  connect(intWallRC.port_a, resIntWallFloor.port_a)
    annotation (Line(points={{182,-40},{182,-40},{168,-40},{168,-90},{168,-106},
    {194,-106}}, color={191,0,0}));
  connect(resFloorWin.port_b, resExtWallFloor.port_b)
    annotation (Line(points={{-80,-120},{-80,-120},{-80,-132},{-144,-132},{-144,
    -121}}, color={191,0,0}));
  connect(resExtWallFloor.port_a, convExtWall.solid)
    annotation (Line(
    points={{-144,-101},{-144,-40},{-114,-40}}, color={191,0,0}));
  connect(hConFloor_const.y, convFloor.Gc)
    annotation (Line(points={{6.5,-116},{-4,-116},{-4,-116}},
    color={0,0,127}));
  connect(convFloor.fluid, senTAir.port)
    annotation (Line(points={{-12,-108},{-12,-40},{66,-40},{66,0},{80,0}},
    color={191,0,0}));
  connect(floorRC.port_a, floorIndoorSurface)
    annotation (Line(points={{-10.9091,-136},{-10.9091,-136},{-10.9091,-132},{
          -80,-132},{-80,-180}},
                 color={191,0,0}));
  annotation (defaultComponentName="theZon",
  Diagram(coordinateSystem(
    extent={{-240,-180},{240,180}},
    preserveAspectRatio=false), graphics={
  Rectangle(
    extent={{-32,-100},{50,-166}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{6,-152},{48,-166}},
    textColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Floor Plate")}), Icon(coordinateSystem(extent={{-240,
      -180},{240,180}}, preserveAspectRatio=false), graphics={Rectangle(
    extent={{-34,52},{34,-40}},
    pattern=LinePattern.None,
    fillColor={230,230,230},
    fillPattern=FillPattern.Solid), Text(
    extent={{-62,62},{62,-62}},
    textColor={0,0,0},
    textString="3")}),
    Documentation(revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
December 9, 2019, by Moritz Lauster:<br/>
Changes <code>nExt</code> to <code>nFloor</code> for
<code>RFloor</code> and <code>CFloor</code>
</li>
<li>
July 11, 2019, by Katharina Brinkmann:<br/>
Renamed <code>alphaFloor</code> to <code>hConFloor</code>,
<code>alphaFloorConst</code> to <code>hConFloor_const</code>
</li>
<li>
August 31, 2018 by Moritz Lauster:<br/>
Updated schema in documentation to fix
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/997\">
issue 997</a>.
</li>
<li>
July 15, 2015 by Moritz Lauster:<br/>
First Implementation.
</li>
</ul>
</html>",   info="<html>
  <p>This model adds one further element for
  the floor plate. Long-term effects dominate the excitation of the floor plate
  and thus the excitation fundamentally differs from excitation of outer walls.
  Adding an extra element for the floor plate leads to a finer resolution of the
  dynamic behaviour but increases calculation times. The floor plate is
  parameterized via the length of the RC-chain <code>nFloor</code>,
  the vector of the capacities
  <code>CFloor[nFloor]</code>, the vector of the resistances
  <code>RFloor[nFloor]</code>
  and the remaining resistance <code>RFloorRem</code>.
  </p>
  <p>
  The image below shows the RC-network of this model.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/ThreeElements.png\" alt=\"image\"/>
  </p>
  </html>"));
end ThreeElements;
