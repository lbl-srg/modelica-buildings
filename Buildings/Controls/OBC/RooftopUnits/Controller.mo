within Buildings.Controls.OBC.RooftopUnits;
block Controller "Controller for rooftop unit heat pump systems"
  extends Modelica.Blocks.Icons.Block;

  CDL.Interfaces.BooleanInput                        uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  CDL.Interfaces.RealInput                        uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Interfaces.BooleanInput                        uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  CDL.Interfaces.IntegerInput                        uCoiSeq[nCoi]
    "DX coil available sequence order"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.IntegerInput                        uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  CDL.Interfaces.RealInput                        TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not has_TFroSen
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput                        uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        phi(final min=0, final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
      iconTransformation(extent={{-140,-142},{-100,-102}})));
  CDL.Interfaces.RealInput                        TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if has_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
    iconTransformation(extent={{-140,-110},{-100,-70}})));
  CDL.Interfaces.RealOutput                        yComSpe[nCoi](
    final min=0,
    final max=1,
    final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  CDL.Interfaces.BooleanOutput                        yDXCoi[nCoi]
    "DX coil signal"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,20},{140,60}})));
  CDL.Interfaces.RealOutput                        yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  CDL.Interfaces.BooleanOutput                        yDXCoiMod[nCoi]
    "DX coil operation mode"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
      iconTransformation(extent={{100,80},{140,120}})));
  DXCoil.Controller DXCoiCon
    annotation (Placement(transformation(extent={{-86,136},{-66,156}})));
  CompressorDR.CompressorDR ComSpeDR
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  AuxiliaryCoil.AuxiliaryCoil conAuxCoi
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
equation
  connect(DXCoiCon.uDXCoi, uDXCoi) annotation (Line(points={{-88,154},{-194,154},
          {-194,160},{-220,160}}, color={255,0,255}));
  connect(DXCoiCon.uDXCoiAva, uDXCoiAva) annotation (Line(points={{-88,150},{
          -194,150},{-194,120},{-220,120}}, color={255,0,255}));
  connect(DXCoiCon.uCoiSeq, uCoiSeq) annotation (Line(points={{-88,142.2},{-192,
          142.2},{-192,80},{-220,80}}, color={255,127,0}));
  connect(DXCoiCon.uCooCoi, uCooCoi) annotation (Line(points={{-88,138},{-190,
          138},{-190,0},{-220,0}}, color={0,0,127}));
  annotation (defaultComponentName="RTUCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-140},{100,140}}),
        graphics={
          Rectangle(
            extent={{-100,-140},{100,140}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,140},{100,140}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end Controller;
