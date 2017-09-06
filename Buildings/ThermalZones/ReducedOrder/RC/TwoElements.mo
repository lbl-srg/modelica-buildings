within Buildings.ThermalZones.ReducedOrder.RC;
model TwoElements
  "Thermal Zone with two elements for exterior and interior walls"
  extends OneElement(AArray={ATotExt,ATotWin,AInt});

  parameter Modelica.SIunits.Area AInt "Area of interior walls"
    annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaInt
    "Convective coefficient of heat transfer of interior walls (indoor)"
    annotation(Dialog(group="Interior walls"));
  parameter Integer nInt(min = 1) "Number of RC-elements of interior walls"
    annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt](
    each min=Modelica.Constants.small)
    "Vector of resistances of interior walls, from port to center"
    annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt](
    each min=Modelica.Constants.small)
    "Vector of heat capacities of interior walls, from port to center"
    annotation(Dialog(group="Interior walls"));
  parameter Boolean indoorPortIntWalls = false
    "Additional heat port at indoor surface of interior walls"
    annotation(Dialog(group="Interior walls"),choices(checkBox = true));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intWallIndoorSurface if
    indoorPortIntWalls "Auxiliary port at indoor surface of interior walls"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}}),
    iconTransformation(extent={{-130,-190},{-110,-170}})));
  BaseClasses.InteriorWall intWallRC(
    final n=nInt,
    final RInt=RInt,
    final CInt=CInt,
    final T_start=T_start) if AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{182,-50},{202,-28}})));

protected
  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall if AInt > 0
    "Convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{148,-30},{128,-50}})));
  Modelica.Blocks.Sources.Constant alphaIntWall(k=AInt*alphaInt) if AInt > 0
    "Coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
    extent={{5,-5},{-5,5}},
    rotation=-90,
    origin={138,-61})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallIntWall(
    final G=min(ATotExt, AInt)*alphaRad) if  ATotExt > 0 and AInt > 0
    "Resistor between exterior walls and interior walls"
    annotation (Placement(transformation(extent={{138,-116},{158,-96}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIntWallWin(
    final G=min(ATotWin, AInt)*alphaRad) if  ATotWin > 0 and AInt > 0
    "Resistor between interior walls and windows"
    annotation (Placement(transformation(extent={{74,-118},{94,-98}})));

equation
  connect(resExtWallIntWall.port_a, convExtWall.solid)
    annotation (Line(
    points={{138,-106},{110,-106},{110,-86},{-144,-86},{-144,-40},{-114,-40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(convIntWall.solid, intWallRC.port_a)
    annotation (Line(
    points={{148,-40},{182,-40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(intWallRC.port_a, resExtWallIntWall.port_b)
    annotation (Line(
    points={{182,-40},{168,-40},{168,-106},{158,-106}},
    color={191,0,0},
    smooth=Smooth.None));
  if not ATotExt > 0 and not ATotWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.portOut[1], intWallRC.port_a);
    connect(thermSplitterSolRad.portOut[1], intWallRC.port_a);
  elseif ATotExt > 0 and not ATotWin > 0 and AInt > 0 or not ATotExt > 0 and ATotWin > 0
    and AInt > 0 then
    connect(thermSplitterIntGains.portOut[2], intWallRC.port_a);
    connect(thermSplitterSolRad.portOut[2], intWallRC.port_a);
  elseif ATotExt > 0 and ATotWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.portOut[3], intWallRC.port_a)
      annotation (Line(
      points={{190,86},{190,86},{190,86},{160,86},{160,-40},{182,-40}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(thermSplitterSolRad.portOut[3], intWallRC.port_a)
      annotation (
      Line(
      points={{-122,146},{-58,146},{-58,96},{160,96},{160,-40},{182,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;
  connect(resIntWallWin.port_b, intWallRC.port_a)
    annotation (Line(
    points={{94,-108},{118,-108},{118,-88},{168,-88},{168,-40},{182,-40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(resIntWallWin.port_a, convWin.solid)
    annotation (Line(
    points={{74,-108},{68,-108},{68,-94},{-46,-94},{-46,20},{-146,20},{-146,40},
    {-116,40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(alphaIntWall.y, convIntWall.Gc)
    annotation (Line(points={{138,-55.5},{138,-53.75},{138,-50}},
    color={0,0,127}));
  connect(intWallRC.port_a, intWallIndoorSurface)
    annotation (Line(points={{182,-40},{168,-40},{168,-82},{-120,-82},{-120,-180}},
    color={191,0,0}));
  connect(convIntWall.fluid, senTAir.port)
    annotation (Line(points={{128,-40},{66,-40},{66,0},{80,0}},
    color={191,0,0}));
  annotation (defaultComponentName="theZon",Diagram(coordinateSystem(
  preserveAspectRatio=false, extent={{-240,-180},{240,180}}), graphics={
  Polygon(
    points={{116,-18},{230,-18},{230,-80},{140,-80},{138,-80},{116,-80},{116,
    -18}},
    lineColor={0,0,255},
    smooth=Smooth.None,
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{173,-65},{224,-82}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Interior Walls")}), Documentation(revisions="<html>
  <ul>
  <li>
  April 18, 2015, by Moritz Lauster:<br/>
  First implementation.
  </li>
  </ul>
  </html>", info="<html>
  <p>This model distinguishes between internal
  thermal masses and exterior walls. While exterior walls contribute to heat
  transfer to the ambient, adiabatic conditions apply to internal masses.
  Parameters for the internal wall element are the length of the RC-chain
  <code>nInt</code>, the vector of the capacities
  <code>CInt[nInt]</code> and the vector of the resistances <code>RInt[nInt]</code>.
  This approach allows considering the dynamic behaviour induced by internal
  heat storage.
  </p>
  <p>
  The image below shows the RC-network of this model.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/TwoElements.png\" alt=\"image\"/>
  </p>
  </html>"),
  Icon(coordinateSystem(extent={{-240,-180},{240,180}},
  preserveAspectRatio=false),
  graphics={Rectangle(
  extent={{-36,40},{32,-54}},
  fillColor={230,230,230},
  fillPattern=FillPattern.Solid,
  pattern=LinePattern.None), Text(
  extent={{-60,60},{64,-64}},
  lineColor={0,0,0},
  textString="2")}));
end TwoElements;
