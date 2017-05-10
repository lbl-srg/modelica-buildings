within Buildings.ThermalZones.ReducedOrder.RC;
model FourElements "Thermal Zone with four elements for exterior walls,
  interior walls, floor plate and roof"
  extends ThreeElements(AArray={ATotExt,ATotWin,AInt,AFloor,ARoof});

  parameter Modelica.SIunits.Area ARoof "Area of roof"
    annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRoof
    "Convective coefficient of heat transfer of roof (indoor)"
    annotation(Dialog(group="Roof"));
  parameter Integer nRoof(min = 1) "Number of RC-elements of roof"
    annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.ThermalResistance RRoof[nExt](
    each min=Modelica.Constants.small)
    "Vector of resistances of roof, from inside to outside"
    annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.ThermalResistance RRoofRem(
    min=Modelica.Constants.small)
    "Resistance of remaining resistor RRoofRem between capacity n and outside"
    annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.HeatCapacity CRoof[nExt](
    each min=Modelica.Constants.small)
    "Vector of heat capacities of roof, from inside to outside"
    annotation(Dialog(group="Roof"));
  parameter Boolean indoorPortRoof = false
    "Additional heat port at indoor surface of roof"
    annotation(Dialog(group="Roof"),choices(checkBox = true));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a roof if ARoof > 0
    "Ambient port for roof"
      annotation (Placement(transformation(extent={{-21,170},{-1,190}}),
                       iconTransformation(extent={{-21,170},{-1,190}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a roofIndoorSurface if
     indoorPortRoof "Auxiliary port at indoor surface of roof"
      annotation (Placement(
      transformation(extent={{-50,-190},{-30,-170}}), iconTransformation(
      extent={{-50,-190},{-30,-170}})));
  BaseClasses.ExteriorWall roofRC(
    final RExt=RRoof,
    final RExtRem=RRoofRem,
    final CExt=CRoof,
    final n=nRoof,
    final T_start=T_start) if ARoof > 0 "RC-element for roof"
    annotation (Placement(
    transformation(
    extent={{10,-11},{-10,11}},
    rotation=90,
    origin={-12,155})));

protected
  Modelica.Thermal.HeatTransfer.Components.Convection convRoof if
     ARoof > 0 "Convective heat transfer of roof"
    annotation (Placement(transformation(
    extent={{10,10},{-10,-10}},
    rotation=90,
    origin={-12,120})));
  Modelica.Blocks.Sources.Constant alphaRoofConst(
    final k=ARoof*alphaRoof) if
       ARoof > 0 "Coefficient of convective heat transfer for roof"
     annotation (Placement(transformation(
     extent={{-5,-5},{5,5}},
     rotation=180,
     origin={22,120})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIntRoof(
    final G=min(AInt, ARoof)*alphaRad) if
       AInt > 0 and ARoof > 0 "Resistor between interior walls and roof"
      annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={186,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resRoofWin(
    final G=min(ARoof, ATotWin)*alphaRad) if
       ARoof > 0 and ATotWin > 0 "Resistor between roof and windows"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      origin={-154,100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resRoofFloor(
    final G=min(ARoof, AFloor)*alphaRad) if
       ARoof > 0 and AFloor > 0 "Resistor between floor plate and roof"
      annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-56,-112})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallRoof(
    final G=min(ATotExt, ARoof)*alphaRad) if    ATotExt > 0 and ARoof > 0
    "Resistor between exterior walls and roof"
      annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      origin={-108,6})));

equation
  connect(convRoof.solid, roofRC.port_b)
    annotation (Line(points={{-12,130},{-12,138},{-12,145},{-11,145}},
                                                     color={191,0,0}));
  connect(roofRC.port_a, roof)
    annotation (Line(points={{-11,165},{-11,168},{-11,180}},
                                                     color={191,0,0}));
  connect(resRoofWin.port_a, convWin.solid)
    annotation (Line(points={{-164,100},{-174,100},{-174,82},{-146,82},{-146,40},
          {-116,40}},                                         color={191,
    0,0}));
  connect(resRoofWin.port_b, convRoof.solid)
    annotation (Line(points={{-144,100},
    {-114,100},{-82,100},{-82,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resRoofFloor.port_a, convRoof.solid)
    annotation (Line(points={{-56,-102},
    {-54,-102},{-54,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resRoofFloor.port_b, resExtWallFloor.port_b)
    annotation (Line(
    points={{-56,-122},{-56,-132},{-144,-132},{-144,-121}}, color={191,0,0}));
  connect(resIntRoof.port_b, intWallRC.port_a)
    annotation (Line(points={{186,0},{186,-10},{168,-10},{168,-40},{182,-40}},
                                               color={191,0,0}));
  connect(resIntRoof.port_a, convRoof.solid)
    annotation (Line(points={{186,20},
    {186,20},{186,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resExtWallRoof.port_a, convExtWall.solid)
    annotation (Line(points={{-118,6},{-130,6},{-130,-12},{-144,-12},{-144,-40},
          {-114,-40}},                                        color={191,
    0,0}));
  connect(resExtWallRoof.port_b, convRoof.solid)
    annotation (Line(points={{-98,
    6},{-54,6},{-54,132},{-12,132},{-12,130}}, color={191,0,0}));
  if not ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and not AFloor > 0
    and ARoof > 0 then
    connect(thermSplitterIntGains.portOut[1], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.portOut[1]);
  elseif ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and not AFloor > 0
    and ARoof > 0
     or not ATotExt > 0 and ATotWin > 0 and not AInt > 0 and not AFloor > 0
     and ARoof > 0
     or not ATotExt > 0 and not ATotWin > 0 and AInt > 0 and not AFloor > 0
     and ARoof > 0
     or not ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and AFloor > 0
     and ARoof > 0 then
    connect(thermSplitterIntGains.portOut[2], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.portOut[2]);
  elseif ATotExt > 0 and ATotWin > 0 and not AInt > 0 and not AFloor > 0 and ARoof > 0
     or ATotExt > 0 and not ATotWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0
     or ATotExt > 0 and not ATotWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or not ATotExt > 0 and ATotWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0
     or not ATotExt > 0 and ATotWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or not ATotExt > 0 and not ATotWin > 0 and AInt > 0 and AFloor > 0
     and ARoof > 0 then
    connect(thermSplitterIntGains.portOut[3], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.portOut[3]);
  elseif not ATotExt > 0 and ATotWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0
     or ATotExt > 0 and not ATotWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0
     or ATotExt > 0 and ATotWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or ATotExt > 0 and ATotWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0 then
    connect(thermSplitterIntGains.portOut[4], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.portOut[4]);
  elseif ATotExt > 0 and ATotWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0 then
    connect(thermSplitterSolRad.portOut[5], roofRC.port_b)
    annotation (Line(
    points={{-122,146},{-122,146},{-38,146},{-38,142},{-11,142},{-11,145}},
    color={191,0,0}));
    connect(thermSplitterIntGains.portOut[5], roofRC.port_b)
    annotation (Line(points={{190,86},{190,86},{190,138},{-11,138},{-11,145}},
    color={191,0,0}));
  end if;
  connect(alphaRoofConst.y, convRoof.Gc)
    annotation (Line(points={{16.5,120},{
    7.25,120},{-2,120}}, color={0,0,127}));
  connect(convRoof.fluid, senTAir.port)
    annotation (Line(points={{-12,110},{-12,110},{-12,96},{66,96},{66,0},{80,0}},
                                                 color={191,0,0}));
  connect(roofRC.port_b, roofIndoorSurface)
    annotation (Line(points={{-11,145},{-11,136},{-112,136},{-112,112},{-216,
          112},{-216,-140},{-40,-140},{-40,-180}},
    color={191,0,0}));
  annotation (defaultComponentName="theZon",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
  -180},{240,180}}), graphics={
  Rectangle(
    extent={{-36,170},{46,104}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{16,168},{46,156}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Roof")}),
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-240,-180},{240,180}}),
  graphics={Rectangle(
  extent={{-40,50},{28,-44}},
  pattern=LinePattern.None,
  fillColor={230,230,230},
  fillPattern=FillPattern.Solid), Text(
  extent={{-60,60},{64,-64}},
  lineColor={0,0,0},
  textString="4")}),
  Documentation(revisions="<html>
  <ul>
  <li>
  September 11, 2015 by Moritz Lauster:<br/>
  First Implementation.
  </li>
  </ul>
  </html>", info="<html>
  <p>
  This model adds another element for the roof. Roofs commonly
  exhibit the same excitations as exterior walls but have different coefficients
  of heat transfer due to their orientation. Adding an extra element for the roof
  might lead to a finer resolution of the dynamic behaviour but increases
  calculation times. The roof is parameterized via the length of the RC-chain
  <code>nRoof</code>,
  the vector of capacities <code>CRoof[nRoof]</code>, the vector of resistances
  <code>RRoof[nRoof]</code> and remaining resistances <code>RRoofRem</code>.
  </p>
  <p>
  The image below shows the RC-network of this model.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/FourElements.png\" alt=\"image\"/>
  </p>
  </html>"));
end FourElements;
