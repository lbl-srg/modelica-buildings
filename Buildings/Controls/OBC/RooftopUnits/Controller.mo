within Buildings.Controls.OBC.RooftopUnits;
block Controller
  "Controller for rooftop unit heat pump systems"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nCoi = 2
    "Total number of DX coils";

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

  parameter Real timPer4(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for disabling DX coil"
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

  parameter Real TLocOut=273.15 - 12.2
    "Minimum outdoor dry-bulb temperature for compressor operation"
    annotation (Dialog(tab="Auxiliary coil"));

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
    annotation(Dialog(tab="Advanced", group="Auxiliary heating parameter"));

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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,140},{-100,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,98},{-100,138}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCoiSeq[nCoi]
    "DX coil available sequence order"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Coolign coil valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCooCoi[nCoi]
    "DX cooling coil signal"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXHeaCoi[nCoi]
    "DX heating coil signal"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeCoo[nCoi](
    final min=0,
    final max=1,
    final unit="1")
    "Compressor commanded speed for DX cooling coils"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,2},{140,42}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpeHea[nCoi](
    final min=0,
    final max=1,
    final unit="1") "Compressor commanded speed for DX heating coils"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-42},{140,-2}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefFra(
    final unit="1")
    "Defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRHea[nCoi](
    final k1=k1,
    final k2=k2,
    final k3=k3)
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiCon[2](
    final nCoi=nCoi,
    final conCoiLow=conCoiLow,
    final conCoiHig=conCoiHig,
    final uThrCoi=uThrCoi,
    final uThrCoi1=uThrCoi1,
    final uThrCoi2=uThrCoi2,
    final uThrCoi3=uThrCoi3,
    final timPer=timPer,
    final timPer1=timPer1,
    final timPer2=timPer2,
    final timPer3=timPer3,
    final minComSpe=minComSpe,
    final maxComSpe=maxComSpe,
    final dUHys=dUHys)
    "DX coil controller"
    annotation (Placement(transformation(extent={{-20,106},{0,126}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDRCoo[nCoi](
    final k1=k1,
    final k2=k2,
    final k3=k3)
    "Compressor speed controller corresponding to DX cooling coil"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi(
    final TLocOut=TLocOut,
    final dTHys=dTHys,
    final k1=k1,
    final k2=k2,
    final uThrHeaCoi=uThrHeaCoi,
    final dUHys=dUHys)
    "Auxiliary coil controller"
    annotation (Placement(transformation(extent={{-30,-48},{-10,-28}})));

  Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations defTimFra(
    final defTri=defTri,
    final tDefRun=tDefRun,
    final TDefLim=TDefLim,
    final dTHys=dTHys1)
    "Defrost time calculation"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCoi)
    "Integer scalar replicator"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=TOutLoc,
    final h=dTHys1)
    "Check if outdoor air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer4)
    "Count time"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{52,-98},{72,-78}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Calculate defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{52,-150},{72,-130}})));

equation
  connect(uDemLimLev, intScaRep.u)
    annotation (Line(points={{-120,40},{-22,40}},  color={255,127,0}));
  connect(intScaRep.y, ComSpeDRCoo.uDemLimLev)
    annotation (Line(points={{2,40},{30,40},{30,46},{38,46}}, color={255,127,0}));
  connect(conAuxCoi.TOut, TOut)
    annotation (Line(points={{-32,-36},{-40,-36},{-40,-80},{-120,-80}},  color={0,0,127}));
  connect(conAuxCoi.uHeaCoi, uHeaCoi)
    annotation (Line(points={{-32,-40},{-120,-40}},color={0,0,127}));
  if not have_TFroSen then
  connect(defTimFra.TOut, TOut)
    annotation (Line(points={{-11,-148},{-58,-148},{-58,-80},{-120,-80}},                     color={0,0,127}));
  end if;
  connect(ComSpeDRCoo.yComSpe, yComSpeCoo)
    annotation (Line(points={{62,40},{120,40}}, color={0,0,127}));
  connect(conAuxCoi.yAuxHea, yAuxHea)
    annotation (Line(points={{-8,-38},{80,-38},{80,-80},{120,-80}},color={0,0,127}));
  connect(yAuxHea, yAuxHea)
    annotation (Line(points={{120,-80},{120,-80}}, color={0,0,127}));
  connect(TFroSen, defTimFra.TOut)
    annotation (Line(points={{-120,-160},{-58,-160},{-58,-148},{-11,-148}}, color={0,0,127}));
  connect(uDXCoi, DXCoiCon[1].uDXCoi)
    annotation (Line(points={{-120,160},{-28,160},{-28,124},{-22,124}}, color={255,0,255}));
  connect(uDXCoiAva, DXCoiCon[1].uDXCoiAva)
    annotation (Line(points={{-120,120},{-22,120}}, color={255,0,255}));
  connect(uCoiSeq, DXCoiCon[1].uCoiSeq)
    annotation (Line(points={{-120,80},{-80,80},{-80,112.2},{-22,112.2}}, color={255,127,0}));
  connect(uCooCoi, DXCoiCon[1].uCoi)
    annotation (Line(points={{-120,0},{-40,0},{-40,108},{-22,108}}, color={0,0,127}));
  connect(uHeaCoi, DXCoiCon[2].uCoi)
    annotation (Line(points={{-120,-40},{-60,-40},{-60,108},{-22,108}}, color={0,0,127}));
  connect(uDXCoi, DXCoiCon[2].uDXCoi)
    annotation (Line(points={{-120,160},{-28,160},{-28,124},{-22,124}}, color={255,0,255}));
  connect(uDXCoiAva, DXCoiCon[2].uDXCoiAva)
    annotation (Line(points={{-120,120},{-22,120}}, color={255,0,255}));
  connect(uCoiSeq, DXCoiCon[2].uCoiSeq)
    annotation (Line(points={{-120,80},{-80,80},{-80,112.2},{-22,112.2}}, color={255,127,0}));
  connect(intScaRep.y, ComSpeDRHea.uDemLimLev)
    annotation (Line(points={{2,40},{30,40},{30,-14},{38,-14}},color={255,127,0}));
  connect(DXCoiCon[1].yComSpe, ComSpeDRCoo.uComSpe)
    annotation (Line(points={{2,112},{20,112},{20,34},{38,34}}, color={0,0,127}));
  connect(DXCoiCon[2].yComSpe, ComSpeDRHea.uComSpe)
    annotation (Line(points={{2,112},{20,112},{20,-26},{38,-26}},color={0,0,127}));
  connect(ComSpeDRHea.yComSpe, yComSpeHea)
    annotation (Line(points={{62,-20},{120,-20}},color={0,0,127}));
  connect(DXCoiCon[1].yDXCoi, yDXCooCoi)
    annotation (Line(points={{2,120},{60,120},{60,140},{120,140}},color={255,0,255}));
  connect(DXCoiCon[2].yDXCoi, yDXHeaCoi)
    annotation (Line(points={{2,120},{60,120},{60,100},{120,100}},color={255,0,255}));
  connect(lesThr.y,tim. u)
    annotation (Line(points={{-8,-80},{8,-80}},  color={255,0,255}));
  connect(tim.passed,booToRea. u)
    annotation (Line(points={{32,-88},{50,-88}},color={255,0,255}));
  connect(TOut, lesThr.u)
    annotation (Line(points={{-120,-80},{-32,-80}}, color={0,0,127}));
  connect(defTimFra.tDefFra, mul1.u2)
    annotation (Line(points={{11,-146},{50,-146}},color={0,0,127}));
  connect(booToRea.y, mul1.u1)
    annotation (Line(points={{74,-88},{80,-88},{80,-120},{40,-120},{40,-134},{50,-134}},color={0,0,127}));
  connect(mul1.y, yDefFra)
    annotation (Line(points={{74,-140},{120,-140}}, color={0,0,127}));

  connect(defTimFra.XOut, XOut) annotation (Line(points={{-11,-152},{-80,-152},{
          -80,-120},{-120,-120}}, color={0,0,127}));
  annotation (defaultComponentName="RTUCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-140},{100,140}}),
        graphics={
          Rectangle(
            extent={{100,180},{-100,-180}},
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
            extent={{-94,168},{-48,154}},
            textColor={255,0,255},
            textString="uDXCoi"),
          Text(
            extent={{-92,124},{-38,108}},
            textColor={255,0,255},
            textString="uDXCoiAva"),
          Text(
            extent={{-92,86},{-46,72}},
            textColor={255,127,0},
            textString="uCoiSeq"),
          Text(
            extent={{-92,52},{-22,28}},
            textColor={255,127,0},
            textString="uDemLimLev"),
          Text(
            extent={{-96,8},{-64,-6}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCoi"),
          Text(
            extent={{-96,-34},{-44,-48}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uHeaCoi"),
          Text(
            extent={{-98,-74},{-62,-88}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TOut"),
          Text(
            extent={{-92,-152},{-46,-172}},
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
            extent={{-98,-114},{-62,-128}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="XOut")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}})),
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
